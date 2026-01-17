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

  @override
  Future<DriverStudentAssignmentResponse> createDriverStudentAssignment({
    required String studentId,
    required String driverUniqueId,
  }) async {
    final body = {
      'student_id': studentId,
      'driver_unique_id': driverUniqueId,
    };

    final response = await _apiClient.post(
      Endpoints.driverStudentAssignments,
      body: body,
    );

    return DriverStudentAssignmentResponse.fromJson(jsonDecode(response.body));
  }
}
