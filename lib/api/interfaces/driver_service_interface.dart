import '../models/driver_response.dart';

abstract class DriverServiceInterface {
  Future<DriverListResponse> getAllDrivers();
  Future<DriverStudentAssignmentResponse> createDriverStudentAssignment({
    required String studentId,
    required String driverUniqueId,
  });
}
