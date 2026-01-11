import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../api/services/user_service.dart';
import '../api/models/profile_response.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService(ApiClient());

  ProfileData? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ProfileData? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasUserData => _userData != null;

  // Fetch user profile from API
  Future<void> fetchUserProfile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _userService.getParentProfile();

      if (response.success && response.data != null) {
        _userData = response.data;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load profile';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String name,
    required String email,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _userService.updateParentProfile(
        name: name,
        email: email,
      );

      if (response.success && response.data != null) {
        // Refresh user data after successful update
        await fetchUserProfile();
        return true;
      } else {
        _errorMessage = 'Failed to update profile';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Set user data directly (for partial data after login/signup)
  void setUserData(ProfileData data) {
    _userData = data;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear user data (for logout)
  void clearUserData() {
    _userData = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
