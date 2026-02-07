import '../api_client.dart';
import '../endpoints.dart';
import '../models/trip_tracking_response.dart';
import 'dart:convert';

class TripTrackingService {
  final ApiClient _apiClient;

  TripTrackingService(this._apiClient);

  Future<TripTrackingResponse> getActiveTrips() async {
    try {
      final response = await _apiClient.get(Endpoints.activeTrips);
      return TripTrackingResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return TripTrackingResponse(
        success: false,
        data: [],
        count: 0,
        error: e.toString(),
      );
    }
  }
}
