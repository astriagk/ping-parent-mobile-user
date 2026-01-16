import '../models/driver_response.dart';

abstract class DriverServiceInterface {
  Future<DriverListResponse> getAllDrivers();
}
