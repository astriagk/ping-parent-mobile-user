import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../endpoints.dart';
import '../enums/socket_events.dart';
import 'storage_service.dart';

/// Singleton WebSocket service for trip tracking.
/// Maintains a single persistent connection throughout the app lifecycle.
class TripWebSocketService {
  // Singleton instance
  static final TripWebSocketService _instance =
      TripWebSocketService._internal();
  factory TripWebSocketService() => _instance;
  TripWebSocketService._internal();

  IO.Socket? _socket;
  String? _currentTripId;
  final StorageService _storage = StorageService();
  bool _isConnecting = false;
  Completer<bool>? _connectionCompleter;

  // Callbacks
  Function(Map<String, dynamic>)? onPositionUpdate;
  Function(Map<String, dynamic>)? onTripStarted;
  Function(Map<String, dynamic>)? onTripStatusUpdate;
  Function(Map<String, dynamic>)? onRouteCalculated;
  Function(Map<String, dynamic>)? onApproaching;
  Function(Map<String, dynamic>)? onStudentPickedUp;
  Function(Map<String, dynamic>)? onStudentDroppedOff;
  Function(Map<String, dynamic>)? onTripCompleted;
  Function(Map<String, dynamic>)? onSocketError;
  Function()? onConnected;
  Function()? onDisconnected;

  // Parent-specific notification callbacks (only for YOUR child)
  Function(Map<String, dynamic>)? onMyStudentPicked;
  Function(Map<String, dynamic>)? onMyStudentDropped;
  Function(Map<String, dynamic>)? onMyStudentApproaching;
  Function(Map<String, dynamic>)? onMyStudentAbsent;

  bool get isConnected => _socket?.connected ?? false;
  String? get currentTripId => _currentTripId;

  /// Initialize socket connection. Safe to call multiple times.
  Future<bool> connect() async {
    // Already connected
    if (_socket != null && _socket!.connected) {
      return true;
    }

    // Connection in progress - wait for it
    if (_isConnecting && _connectionCompleter != null) {
      return _connectionCompleter!.future;
    }

    _isConnecting = true;
    _connectionCompleter = Completer<bool>();

    try {
      // Clean up old socket
      _disposeSocket();

      final baseUrl = Endpoints.baseUrl.replaceAll('/api', '');
      final token = await _storage.getAuthToken();
      final userId = await _storage.getUserId();

      if (token == null || userId == null) {
        _completeConnection(false);
        return false;
      }

      _socket = IO.io(baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'forceNew': false, // Reuse existing connection
        'reconnection': true,
        'reconnectionAttempts': 999, // Keep trying to reconnect
        'reconnectionDelay': 500, // Start with 500ms delay
        'reconnectionDelayMax': 3000, // Max 3 seconds between attempts
        'timeout': 10000, // Faster timeout for quicker retry
        'auth': {
          'token': token,
          'userId': userId,
          'role': 'parent',
        },
      });

      _setupEventHandlers();
      _socket!.connect();

      // Wait for connection with timeout
      final connected = await _waitForConnection(Duration(seconds: 15));
      _completeConnection(connected);
      return connected;
    } catch (e) {
      _completeConnection(false);
      return false;
    }
  }

  void _completeConnection(bool success) {
    _isConnecting = false;
    if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
      _connectionCompleter!.complete(success);
    }
    _connectionCompleter = null;
  }

  Future<bool> _waitForConnection(Duration timeout) async {
    if (_socket == null) return false;

    final completer = Completer<bool>();
    Timer? timer;

    void onConnect(_) {
      timer?.cancel();
      if (!completer.isCompleted) completer.complete(true);
    }

    void onError(error) {
      timer?.cancel();
      if (!completer.isCompleted) completer.complete(false);
    }

    _socket!.once('connect', onConnect);
    _socket!.once('connect_error', onError);

    timer = Timer(timeout, () {
      _socket!.off('connect', onConnect);
      _socket!.off('connect_error', onError);
      if (!completer.isCompleted) completer.complete(false);
    });

    // Already connected
    if (_socket!.connected) {
      timer.cancel();
      return true;
    }

    return completer.future;
  }

  void _setupEventHandlers() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      print('[P] Connected');
      onConnected?.call();
      if (_currentTripId != null) _emitSubscription(_currentTripId!);
    });

    _socket!.onDisconnect((reason) {
      print('[P] Disconnected: $reason');
      onDisconnected?.call();
    });

    _socket!.onConnectError((error) {
      print('[P] Error: $error');
    });

    _socket!.onReconnect((_) {
      print('[P] Reconnected');
      if (_currentTripId != null) _emitSubscription(_currentTripId!);
    });

    _socket!.onReconnectAttempt((attempt) => null);

    _socket!.on(BroadcastSocketEvent.error.value, (data) {
      onSocketError
          ?.call(data is Map<String, dynamic> ? data : {'message': '$data'});
    });

    // Set up trip event listeners (permanent, not per-subscription)
    _setupTripListeners();
  }

  void _setupTripListeners() {
    if (_socket == null) return;

    _socket!.on(BroadcastSocketEvent.positionUpdate.value, (data) {
      onPositionUpdate?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(BroadcastSocketEvent.tripStarted.value, (data) {
      onTripStarted?.call(data is Map<String, dynamic> ? data : {});
    });

    _socket!.on(BroadcastSocketEvent.tripStatusUpdate.value, (data) {
      onTripStatusUpdate?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(BroadcastSocketEvent.routeCalculated.value, (data) {
      onRouteCalculated?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(BroadcastSocketEvent.approaching.value, (data) {
      onApproaching?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(BroadcastSocketEvent.studentPicked.value, (data) {
      onStudentPickedUp?.call(Map<String, dynamic>.from(data));
    });

    // Also listen for driver's direct event (server may forward it)
    _socket!.on('driver:student_picked', (data) {
      onStudentPickedUp?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(BroadcastSocketEvent.studentDropped.value, (data) {
      onStudentDroppedOff?.call(Map<String, dynamic>.from(data));
    });

    // Also listen for driver's direct drop event
    _socket!.on('driver:student_dropped', (data) {
      onStudentDroppedOff?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(BroadcastSocketEvent.tripCompleted.value, (data) {
      _currentTripId = null;
      onTripCompleted?.call(data is Map<String, dynamic> ? data : {});
    });

    // Parent-specific notification events (only YOUR child - auto-triggered by REST API)
    _socket!.on(ParentNotificationEvent.myStudentPicked.value, (data) {
      onMyStudentPicked?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(ParentNotificationEvent.myStudentDropped.value, (data) {
      onMyStudentDropped?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(ParentNotificationEvent.myStudentApproaching.value, (data) {
      onMyStudentApproaching?.call(Map<String, dynamic>.from(data));
    });

    _socket!.on(ParentNotificationEvent.myStudentAbsent.value, (data) {
      onMyStudentAbsent?.call(Map<String, dynamic>.from(data));
    });
  }

  /// Subscribe to a trip. Connects if not already connected.
  Future<bool> subscribeToTrip(String tripId) async {
    // Unsubscribe from previous trip if different
    if (_currentTripId != null && _currentTripId != tripId) {
      unsubscribeFromTrip(_currentTripId!);
    }

    // Ensure connected
    if (!isConnected) {
      final connected = await connect();
      if (!connected) return false;
    }

    _currentTripId = tripId;

    // Always emit subscription (re-join room if needed)
    return _emitSubscription(tripId);
  }

  bool _emitSubscription(String tripId) {
    if (_socket == null || !_socket!.connected) return false;

    _socket!.emitWithAck(ParentSocketEvent.subscribeTrip.value, tripId,
        ack: (response) {
      if (response == true) {
        print('[P] Subscribed to trip:$tripId');
      } else {
        onSocketError?.call({'message': 'Failed to subscribe'});
      }
    });

    return true;
  }

  void unsubscribeFromTrip(String tripId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(ParentSocketEvent.unsubscribeTrip.value, tripId);
    }
    if (_currentTripId == tripId) {
      _currentTripId = null;
    }
  }

  void _disposeSocket() {
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }

  /// Disconnect and cleanup. Call when done with tracking.
  void disconnect() {
    if (_currentTripId != null) unsubscribeFromTrip(_currentTripId!);
    _disposeSocket();
  }

  /// Pause connection (e.g., when app goes to background).
  void pause() {
    // Socket.IO will handle reconnection automatically
  }

  /// Resume connection (e.g., when app comes to foreground).
  Future<void> resume() async {
    final tripId = _currentTripId;

    if (isConnected) {
      // Re-subscribe to ensure we're in the room
      if (tripId != null) _emitSubscription(tripId);
      return;
    }

    // Force a fresh connection
    _disposeSocket();

    final connected = await connect();
    if (connected && tripId != null) {
      _currentTripId = tripId;
      _emitSubscription(tripId);
    }
  }

  void clearCallbacks() {
    onPositionUpdate = null;
    onTripStarted = null;
    onTripStatusUpdate = null;
    onRouteCalculated = null;
    onApproaching = null;
    onStudentPickedUp = null;
    onStudentDroppedOff = null;
    onTripCompleted = null;
    onSocketError = null;
    onConnected = null;
    onDisconnected = null;
    // Parent-specific notification callbacks
    onMyStudentPicked = null;
    onMyStudentDropped = null;
    onMyStudentApproaching = null;
    onMyStudentAbsent = null;
  }
}
