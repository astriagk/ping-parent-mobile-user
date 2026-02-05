import 'package:taxify_user_ui/config.dart';
import '../../api/models/trip_tracking_response.dart';
import '../../api/services/trip_tracking_service.dart';
import '../../api/services/trip_websocket_service.dart';

class TripTrackingProvider extends ChangeNotifier {
  final TripTrackingService _tripTrackingService;
  final TripWebSocketService _webSocketService = TripWebSocketService();

  TripTrackingProvider(this._tripTrackingService);

  List<Trip> activeTrips = [];
  bool isLoading = false;
  String? error;
  Map<String, dynamic> currentPositionData = {};
  Map<String, String> tripPositionMap = {}; // tripId -> current position

  // WebSocket connection state
  bool isWebSocketConnected = false;
  String? currentSubscribedTripId;

  // Trip status tracking
  bool isTripStarted = false;
  bool isDriverApproaching = false;
  int? driverEtaSeconds;
  String? lastPickedStudentId;
  String? lastDroppedStudentId;
  bool isTripCompleted = false;

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  Future<void> fetchActiveTrips() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _tripTrackingService.getActiveTrips();
      if (response.success) {
        activeTrips = response.data;

        // Subscribe to WebSocket updates for each active trip
        for (var trip in activeTrips) {
          if (trip.tripId != null) {
            _subscribeToTripUpdates(trip.tripId!);
          }
        }
      } else {
        error = response.error ?? 'Failed to fetch active trips';
        activeTrips = [];
      }
    } catch (e) {
      error = e.toString();
      activeTrips = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _subscribeToTripUpdates(String tripId) async {
    currentSubscribedTripId = tripId;

    // Connection callbacks
    _webSocketService.onConnected = () {
      print('═══════════════════════════════════════════════════════');
      print('🔌 [WEBSOCKET] CONNECTED');
      print('═══════════════════════════════════════════════════════');
      isWebSocketConnected = true;
      notifyListeners();
    };

    _webSocketService.onDisconnected = () {
      print('═══════════════════════════════════════════════════════');
      print('❌ [WEBSOCKET] DISCONNECTED');
      print('═══════════════════════════════════════════════════════');
      isWebSocketConnected = false;
      notifyListeners();
    };

    // Position update callback
    _webSocketService.onPositionUpdate = (data) {
      print('═══════════════════════════════════════════════════════');
      print('📍 [POSITION UPDATE]');
      print('   Latitude: ${data['latitude']}');
      print('   Longitude: ${data['longitude']}');
      print('   Speed: ${data['speed'] ?? 'N/A'}');
      print('   Heading: ${data['heading'] ?? 'N/A'}');
      print('   Accuracy: ${data['accuracy'] ?? 'N/A'}');
      print('═══════════════════════════════════════════════════════');
      currentPositionData = data;
      tripPositionMap[tripId] =
          '${data['latitude']?.toStringAsFixed(4) ?? 'N/A'}, ${data['longitude']?.toStringAsFixed(4) ?? 'N/A'}';
      notifyListeners();
    };

    // Trip started callback
    _webSocketService.onTripStarted = (data) {
      print('═══════════════════════════════════════════════════════');
      print('🚗 [TRIP STARTED]');
      print('   Trip ID: ${data['tripId'] ?? tripId}');
      print('   Data: $data');
      print('═══════════════════════════════════════════════════════');
      isTripStarted = true;
      notifyListeners();
    };

    // Route calculated callback
    _webSocketService.onRouteCalculated = (data) {
      print('═══════════════════════════════════════════════════════');
      print('🗺️ [ROUTE CALCULATED]');
      print('   Route Data: $data');
      print('═══════════════════════════════════════════════════════');
      notifyListeners();
    };

    // Driver approaching callback
    _webSocketService.onApproaching = (data) {
      final eta = data['eta'];
      final etaMinutes = eta != null ? (eta / 60).round() : null;
      print('═══════════════════════════════════════════════════════');
      print('🚙 [DRIVER APPROACHING]');
      print('   Student ID: ${data['studentId']}');
      print('   ETA: $etaMinutes minutes ($eta seconds)');
      print('═══════════════════════════════════════════════════════');
      isDriverApproaching = true;
      driverEtaSeconds = eta;
      notifyListeners();
    };

    // Student picked up callback
    _webSocketService.onStudentPickedUp = (data) {
      print('═══════════════════════════════════════════════════════');
      print('✅ [STUDENT PICKED UP]');
      print('   Student ID: ${data['studentId']}');
      print('   Trip ID: ${data['tripId'] ?? tripId}');
      print('   Data: $data');
      print('═══════════════════════════════════════════════════════');
      lastPickedStudentId = data['studentId'];
      isDriverApproaching = false;
      notifyListeners();
    };

    // Student dropped off callback
    _webSocketService.onStudentDroppedOff = (data) {
      print('═══════════════════════════════════════════════════════');
      print('🏠 [STUDENT DROPPED OFF]');
      print('   Student ID: ${data['studentId']}');
      print('   Trip ID: ${data['tripId'] ?? tripId}');
      print('   Data: $data');
      print('═══════════════════════════════════════════════════════');
      lastDroppedStudentId = data['studentId'];
      notifyListeners();
    };

    // Trip completed callback
    _webSocketService.onTripCompleted = (data) {
      print('═══════════════════════════════════════════════════════');
      print('🏁 [TRIP COMPLETED]');
      print('   Trip ID: ${data['tripId'] ?? tripId}');
      print('   Data: $data');
      print('═══════════════════════════════════════════════════════');
      isTripCompleted = true;
      isTripStarted = false;
      // Refresh trips after completion
      fetchActiveTrips();
    };

    // Socket error callback
    _webSocketService.onSocketError = (data) {
      print('═══════════════════════════════════════════════════════');
      print('⚠️ [SOCKET ERROR]');
      print('   Message: ${data['message']}');
      print('   Data: $data');
      print('═══════════════════════════════════════════════════════');
      error = data['message'];
      notifyListeners();
    };

    await _webSocketService.subscribeToTrip(tripId);
  }

  /// Subscribe to a specific trip for real-time updates
  Future<void> subscribeToTrip(String tripId) async {
    print('═══════════════════════════════════════════════════════');
    print('📡 [SUBSCRIBING TO TRIP]');
    print('   Trip ID: $tripId');
    print('═══════════════════════════════════════════════════════');
    await _subscribeToTripUpdates(tripId);
  }

  /// Unsubscribe from current trip
  void unsubscribeFromCurrentTrip() {
    if (currentSubscribedTripId != null) {
      print('═══════════════════════════════════════════════════════');
      print('📡 [UNSUBSCRIBING FROM TRIP]');
      print('   Trip ID: $currentSubscribedTripId');
      print('═══════════════════════════════════════════════════════');
      _webSocketService.unsubscribeFromTrip(currentSubscribedTripId!);
      currentSubscribedTripId = null;
      _resetTripState();
    }
  }

  void _resetTripState() {
    isTripStarted = false;
    isDriverApproaching = false;
    driverEtaSeconds = null;
    lastPickedStudentId = null;
    lastDroppedStudentId = null;
    isTripCompleted = false;
    currentPositionData = {};
    notifyListeners();
  }

  void init() {
    print('═══════════════════════════════════════════════════════');
    print('🚀 [TRIP TRACKING PROVIDER] INITIALIZING...');
    print('═══════════════════════════════════════════════════════');
    _webSocketService.initializeSocket();
    fetchActiveTrips();
  }

  String? getTripPosition(String tripId) {
    return tripPositionMap[tripId];
  }

  TripWebSocketService get webSocketService => _webSocketService;
}
