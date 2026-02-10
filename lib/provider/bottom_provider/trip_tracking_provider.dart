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

  // Parent-specific notifications (only YOUR child)
  Map<String, dynamic>? myStudentPickedData;
  Map<String, dynamic>? myStudentDroppedData;
  Map<String, dynamic>? myStudentApproachingData;

  /// Initialize the provider. Safe to call multiple times.
  void init() {
    // Always set up callbacks (they may have been cleared)
    _setupCallbacks();

    if (_initialized) return;

    _initialized = true;

    // Register for lifecycle events
    WidgetsBinding.instance.addObserver(this);

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
      currentPositionData = data;
      notifyListeners();
    };

    // If already connected, update state immediately
    if (_webSocketService.isConnected) {
      isWebSocketConnected = true;
    }

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

    // Parent-specific notification callbacks (only YOUR child)
    _webSocketService.onMyStudentPicked = (data) {
      myStudentPickedData = data;
      notifyListeners();
    };

    _webSocketService.onMyStudentDropped = (data) {
      myStudentDroppedData = data;
      notifyListeners();
    };

    _webSocketService.onMyStudentApproaching = (data) {
      myStudentApproachingData = data;
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
    currentSubscribedTripId = tripId;

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
