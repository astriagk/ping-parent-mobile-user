import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../endpoints.dart';
import 'storage_service.dart';

class TripWebSocketService {
  IO.Socket? _socket;
  Map<String, dynamic> _currentTripData = {};
  final StorageService _storage = StorageService();
  String? _currentTripId;

  // Callbacks for all parent events as per WEBSOCKET.md
  Function(Map<String, dynamic>)? onPositionUpdate;
  Function(Map<String, dynamic>)? onTripStarted;
  Function(Map<String, dynamic>)? onRouteCalculated;
  Function(Map<String, dynamic>)? onApproaching;
  Function(Map<String, dynamic>)? onStudentPickedUp;
  Function(Map<String, dynamic>)? onStudentDroppedOff;
  Function(Map<String, dynamic>)? onTripCompleted;
  Function(Map<String, dynamic>)? onSocketError;
  Function()? onConnected;
  Function()? onDisconnected;

  Future<void> initializeSocket({String? userId}) async {
    if (_socket != null && _socket!.connected) {
      return;
    }

    // Disconnect existing socket if any
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    // Extract base URL without /api path for WebSocket
    final baseUrl = Endpoints.baseUrl.replaceAll('/api', '');

    // Get authentication token
    final token = await _storage.getAuthToken();
    final storedUserId = userId ?? await _storage.getUserId();

    print('═══════════════════════════════════════════════════════');
    print('🔌 [WEBSOCKET] Initializing connection...');
    print('   URL: $baseUrl');
    print('   User ID: $storedUserId');
    print('   Token: ${token != null ? '${token.substring(0, 20)}...' : 'None'}');
    print('═══════════════════════════════════════════════════════');

    // Connect with proper auth as per WEBSOCKET.md
    // Try polling first (more reliable), then upgrade to websocket
    _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['polling', 'websocket']) // Start with polling, upgrade to websocket
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(30000) // 30 second timeout
            .setPath('/socket.io') // Explicit socket.io path
            .setAuth({
              'token': token ?? '',
              'userId': storedUserId ?? '',
              'role': 'parent',
            })
            .setExtraHeaders({
              'Authorization': 'Bearer ${token ?? ''}',
            })
            .build());

    _socket!.onConnect((_) {
      print('═══════════════════════════════════════════════════════');
      print('✓ [WEBSOCKET] Connected successfully to: $baseUrl');
      print('   Socket ID: ${_socket!.id}');
      print('═══════════════════════════════════════════════════════');
      onConnected?.call();
    });

    _socket!.onDisconnect((reason) {
      print('═══════════════════════════════════════════════════════');
      print('✗ [WEBSOCKET] Disconnected - Reason: $reason');
      print('═══════════════════════════════════════════════════════');
      onDisconnected?.call();
    });

    _socket!.on('error', (error) {
      print('✗ [WEBSOCKET] Error: $error');
    });

    _socket!.onConnectError((error) {
      print('═══════════════════════════════════════════════════════');
      print('✗ [WEBSOCKET] Connection error: $error');
      print('   URL: $baseUrl');
      print('   Check: 1) Server running? 2) Firewall? 3) Socket.IO version?');
      print('═══════════════════════════════════════════════════════');
    });

    _socket!.onReconnect((_) {
      print('🔄 [WEBSOCKET] Reconnected');
    });

    _socket!.onReconnectAttempt((attemptNumber) {
      print('🔄 [WEBSOCKET] Reconnection attempt #$attemptNumber');
    });

    _socket!.onReconnectError((error) {
      print('✗ [WEBSOCKET] Reconnection error: $error');
    });

    _socket!.onReconnectFailed((_) {
      print('✗ [WEBSOCKET] Reconnection failed after all attempts');
    });

    // Listen for socket errors (authorization errors, etc.)
    _socket!.on('socket:error', (data) {
      print('✗ [WEBSOCKET] Socket error: ${data['message']}');
      onSocketError?.call(
          data is Map<String, dynamic> ? data : {'message': data.toString()});
    });
  }

  Future<void> subscribeToTrip(String tripId) async {
    if (_socket == null || !_socket!.connected) {
      print('⚠️ Socket not connected, reconnecting...');
      await initializeSocket();
      // Wait a bit for connection to establish
      await Future.delayed(Duration(milliseconds: 500));
    }
    _subscribeToTripEvents(tripId);
  }

  void _subscribeToTripEvents(String tripId) {
    _currentTripId = tripId;
    print('📍 Subscribing to trip: $tripId');

    // Subscribe using parent:subscribe_trip as per WEBSOCKET.md
    _socket!.emitWithAck('parent:subscribe_trip', {'tripId': tripId},
        ack: (response) {
      if (response == true) {
        print('✓ Successfully subscribed to trip: $tripId');
      } else {
        print('✗ Failed to subscribe to trip: $tripId');
        onSocketError?.call({'message': 'Failed to subscribe to trip'});
      }
    });

    // Remove existing listeners to avoid duplicates
    _socket!.off('trip:position_update');
    _socket!.off('trip:started');
    _socket!.off('trip:route_calculated');
    _socket!.off('trip:approaching');
    _socket!.off('trip:student_picked');
    _socket!.off('trip:student_dropped');
    _socket!.off('trip:completed');

    // Listen to position updates
    _socket!.on('trip:position_update', (data) {
      print('✓ Driver position: ${data['latitude']}, ${data['longitude']}');
      _currentTripData = Map<String, dynamic>.from(data);
      onPositionUpdate?.call(_currentTripData);
    });

    // Listen to trip started event
    _socket!.on('trip:started', (data) {
      print('✓ Trip started');
      onTripStarted
          ?.call(data is Map<String, dynamic> ? data : {'tripId': tripId});
    });

    // Listen to route calculated event
    _socket!.on('trip:route_calculated', (data) {
      print('✓ Route calculated');
      onRouteCalculated?.call(Map<String, dynamic>.from(data));
    });

    // Listen to driver approaching event
    _socket!.on('trip:approaching', (data) {
      final eta = data['eta'];
      print(
          '✓ Driver approaching, ETA: ${eta != null ? (eta / 60).round() : 'unknown'} minutes');
      onApproaching?.call(Map<String, dynamic>.from(data));
    });

    // Listen to student picked up event
    _socket!.on('trip:student_picked', (data) {
      print('✓ Student ${data['studentId']} picked up');
      onStudentPickedUp?.call(Map<String, dynamic>.from(data));
    });

    // Listen to student dropped off event
    _socket!.on('trip:student_dropped', (data) {
      print('✓ Student ${data['studentId']} dropped off');
      onStudentDroppedOff?.call(Map<String, dynamic>.from(data));
    });

    // Listen to trip completion
    _socket!.on('trip:completed', (data) {
      print('✓ Trip completed');
      onTripCompleted
          ?.call(data is Map<String, dynamic> ? data : {'tripId': tripId});
    });
  }

  void unsubscribeFromTrip(String tripId) {
    if (_socket != null) {
      print('📍 Unsubscribing from trip: $tripId');
      _socket!.emit('parent:unsubscribe_trip', {'tripId': tripId});
      _currentTripId = null;
    }
  }

  void disconnect() {
    if (_currentTripId != null) {
      unsubscribeFromTrip(_currentTripId!);
    }
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      print('✗ WebSocket disconnected');
    }
  }

  /// Clears all registered callbacks
  void clearCallbacks() {
    onPositionUpdate = null;
    onTripStarted = null;
    onRouteCalculated = null;
    onApproaching = null;
    onStudentPickedUp = null;
    onStudentDroppedOff = null;
    onTripCompleted = null;
    onSocketError = null;
    onConnected = null;
    onDisconnected = null;
  }

  Map<String, dynamic> getCurrentTripData() {
    return _currentTripData;
  }

  String? get currentTripId => _currentTripId;
  bool get isConnected => _socket != null && _socket!.connected;
}
