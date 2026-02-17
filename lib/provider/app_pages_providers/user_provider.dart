import 'package:flutter/foundation.dart';
import 'package:taxify_user_ui/api/api_client.dart';
import 'package:taxify_user_ui/api/models/profile_response.dart';
import 'package:taxify_user_ui/api/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService(ApiClient());

  ProfileData? _userData;
  bool _isFetching = false; // For initial data fetch from API
  bool _isUpdating = false; // For update operations
  String? _errorMessage;

  // Getters
  ProfileData? get userData => _userData;
  bool get isFetching => _isFetching;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  bool get hasUserData => _userData != null;

  // Fetch user profile from API
  Future<void> fetchUserProfile() async {
    try {
      _isFetching = true;
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
      _isFetching = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String name,
    required String email,
  }) async {
    try {
      _isUpdating = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _userService.updateParentProfile(
        name: name,
        email: email,
      );

      if (response.success && response.data != null) {
        // Refresh user data after successful update (silently without showing spinner)
        await _fetchUserProfileSilently();
        _isUpdating = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to update profile';
        _isUpdating = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // Internal method to fetch profile without showing skeleton
  Future<void> _fetchUserProfileSilently() async {
    try {
      final response = await _userService.getParentProfile();

      if (response.success && response.data != null) {
        _userData = response.data;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load profile';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
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
    _isFetching = false;
    _isUpdating = false;
    notifyListeners();
  }
}
