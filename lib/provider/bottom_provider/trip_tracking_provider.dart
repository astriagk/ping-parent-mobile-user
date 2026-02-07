import 'package:flutter/material.dart';
import '../../api/models/trip_tracking_response.dart';
import '../../api/services/trip_tracking_service.dart';
import '../../api/services/trip_websocket_service.dart';

/// Provider for trip tracking with WebSocket support.
/// Uses singleton WebSocket service to maintain persistent connection.
class TripTrackingProvider extends ChangeNotifier with WidgetsBindingObserver {
  final TripTrackingService _tripTrackingService;

  // Use singleton instance
  final TripWebSocketService _webSocketService = TripWebSocketService();

  TripTrackingProvider(this._tripTrackingService);

  // Trip data
  List<Trip> activeTrips = [];
  bool isLoading = false;
  String? error;
  Map<String, dynamic> currentPositionData = {};

  // Connection state
  bool isWebSocketConnected = false;
  String? currentSubscribedTripId;
  bool _initialized = false;

  // Trip status
  bool isTripStarted = false;
  bool isDriverApproaching = false;
  int? driverEtaSeconds;
  String? lastPickedStudentId;
  String? lastDroppedStudentId;
  bool isTripCompleted = false;

  /// Initialize the provider. Safe to call multiple times.
  void init() {
    if (_initialized) return;
    _initialized = true;

    // Register for lifecycle events
    WidgetsBinding.instance.addObserver(this);

    // Set up callbacks
    _setupCallbacks();

    // Fetch trips (this will also connect and subscribe)
    fetchActiveTrips();
  }

  void _setupCallbacks() {
    _webSocketService.onConnected = () {
      isWebSocketConnected = true;
      notifyListeners();
    };

    _webSocketService.onDisconnected = () {
      isWebSocketConnected = false;
      notifyListeners();
    };

    _webSocketService.onPositionUpdate = (data) {
      print("Received position update: $data");
      currentPositionData = data;
      notifyListeners();
    };

    _webSocketService.onTripStarted = (data) {
      isTripStarted = true;
      notifyListeners();
    };

    _webSocketService.onRouteCalculated = (data) {
      notifyListeners();
    };

    _webSocketService.onApproaching = (data) {
      isDriverApproaching = true;
      driverEtaSeconds = data['eta'];
      notifyListeners();
    };

    _webSocketService.onStudentPickedUp = (data) {
      lastPickedStudentId = data['studentId'];
      isDriverApproaching = false;
      notifyListeners();
    };

    _webSocketService.onStudentDroppedOff = (data) {
      lastDroppedStudentId = data['studentId'];
      notifyListeners();
    };

    _webSocketService.onTripCompleted = (data) {
      isTripCompleted = true;
      isTripStarted = false;
      currentSubscribedTripId = null;
      // Refresh the trips list
      fetchActiveTrips();
    };

    _webSocketService.onSocketError = (data) {
      error = data['message'];
      notifyListeners();
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App going to background - socket stays connected
        _webSocketService.pause();
        break;
      case AppLifecycleState.resumed:
        // App coming back - reconnect if needed
        _webSocketService.resume();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Don't disconnect on hidden
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Don't disconnect on dispose - singleton keeps running
    super.dispose();
  }

  /// Fetch active trips and subscribe to the first one
  Future<void> fetchActiveTrips() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _tripTrackingService.getActiveTrips();
      if (response.success) {
        activeTrips = response.data;

        // Subscribe to first active trip (if any)
        if (activeTrips.isNotEmpty && activeTrips.first.tripId != null) {
          await subscribeToTrip(activeTrips.first.tripId!);
        }
      } else {
        error = response.error ?? 'Failed to fetch trips';
        activeTrips = [];
      }
    } catch (e) {
      error = e.toString();
      activeTrips = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Subscribe to a specific trip
  Future<void> subscribeToTrip(String tripId) async {
    // Already subscribed
    if (currentSubscribedTripId == tripId && _webSocketService.isConnected)
      return;

    currentSubscribedTripId = tripId;
    _resetTripStatus();

    final success = await _webSocketService.subscribeToTrip(tripId);
    if (!success) {
      error = 'Failed to subscribe to trip';
      notifyListeners();
    }
  }

  void unsubscribeFromCurrentTrip() {
    if (currentSubscribedTripId != null) {
      _webSocketService.unsubscribeFromTrip(currentSubscribedTripId!);
      currentSubscribedTripId = null;
      _resetTripStatus();
    }
  }

  void _resetTripStatus() {
    isTripStarted = false;
    isDriverApproaching = false;
    driverEtaSeconds = null;
    lastPickedStudentId = null;
    lastDroppedStudentId = null;
    isTripCompleted = false;
    currentPositionData = {};
    notifyListeners();
  }

  // Getters
  TripWebSocketService get webSocketService => _webSocketService;
}
