import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../api/services/driver_service.dart';
import '../../api/models/driver_response.dart';

class DriverProvider extends ChangeNotifier {
  List<Driver> driverList = [];
  bool isLoading = false;
  bool isAssigning = false;
  String? errorMessage;
  bool _isInitialized = false;
  DriverStudentAssignment? lastAssignment;

  Future<void> onInit() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final driverService = DriverService(ApiClient());
      final response = await driverService.getAllDrivers();

      if (response.success) {
        driverList = response.data;
        errorMessage = null;
      } else {
        errorMessage =
            response.error ?? response.message ?? 'Failed to fetch drivers';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> assignDriverToStudent({
    required String studentId,
    required String driverUniqueId,
  }) async {
    isAssigning = true;
    errorMessage = null;
    notifyListeners();

    try {
      final driverService = DriverService(ApiClient());
      final response = await driverService.createDriverStudentAssignment(
        studentId: studentId,
        driverUniqueId: driverUniqueId,
      );

      if (response.success) {
        lastAssignment = response.data;
        errorMessage = null;
        isAssigning = false;
        notifyListeners();
        return true;
      } else {
        errorMessage =
            response.error ?? response.message ?? 'Assignment failed';
        isAssigning = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
      isAssigning = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _isInitialized = false;
    driverList = [];
    isLoading = false;
    isAssigning = false;
    errorMessage = null;
    lastAssignment = null;
    notifyListeners();
  }
}
