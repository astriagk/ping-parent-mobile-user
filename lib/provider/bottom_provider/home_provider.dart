import 'package:skolo/config.dart';
import 'package:skolo/api/api_client.dart';
import 'package:skolo/api/services/trip_tracking_service.dart';
import 'package:skolo/api/models/trip_tracking_response.dart';

class HomeScreenProvider extends ChangeNotifier {
  List cards = [];
  List categories = [];
  List offer = [];
  List<Contact>? contacted;
  bool permissionDenied = false;
  TripTrackingResponse? trackingData;
  bool isLoadingTracking = false;

  // list initialization
  init() {
    categories = appArray.categories;
    offer = appArray.offer;
    notifyListeners();
  }

  Future<void> fetchTrackingData() async {
    try {
      isLoadingTracking = true;
      notifyListeners();

      // Get the trip tracking service from service locator or provider
      // This assumes you have a service locator setup (e.g., GetIt)
      final apiClient = ApiClient();
      final tripTrackingService = TripTrackingService(apiClient);
      trackingData = await tripTrackingService.getActiveTrips();

      isLoadingTracking = false;
      notifyListeners();
    } catch (e) {
      isLoadingTracking = false;
      trackingData = null;
      notifyListeners();
    }
  }
}
