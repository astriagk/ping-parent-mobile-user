import '../api_client.dart';
import '../endpoints.dart';
import '../interfaces/driver_service_interface.dart';
import '../models/driver_response.dart';
import 'dart:convert';

class DriverService implements DriverServiceInterface {
  final ApiClient _apiClient;

  DriverService(this._apiClient);

  @override
  Future<DriverListResponse> getAllDrivers() async {
    final response = await _apiClient.get(Endpoints.allDrivers);
    return DriverListResponse.fromJson(jsonDecode(response.body));
  }
}
