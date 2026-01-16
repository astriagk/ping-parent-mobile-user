import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../api/services/driver_service.dart';
import '../../api/models/driver_response.dart';

class DriverProvider extends ChangeNotifier {
  List<Driver> driverList = [];
  bool isLoading = false;
  String? errorMessage;
  bool _isInitialized = false;

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

  void reset() {
    _isInitialized = false;
    driverList = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }
}
