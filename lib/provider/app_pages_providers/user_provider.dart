import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skolo/api/api_client.dart';
import 'package:skolo/api/models/profile_response.dart';
import 'package:skolo/api/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService(ApiClient());

  ProfileData? _userData;
  File? _selectedProfileImage;
  String? _originalPhotoUrl;
  bool _isFetching = false; // For initial data fetch from API
  bool _isUpdating = false; // For update operations
  String? _errorMessage;

  // Getters
  ProfileData? get userData => _userData;
  File? get selectedProfileImage => _selectedProfileImage;
  String? get originalPhotoUrl => _originalPhotoUrl;
  bool get isProfileImageChanged => _selectedProfileImage != null;
  bool get isFetching => _isFetching;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  bool get hasUserData => _userData != null;

  bool hasChanges({required String name, required String email}) {
    final currentName = _userData?.name.trim() ?? '';
    final currentEmail = _userData?.email.trim() ?? '';

    return currentName != name.trim() ||
        currentEmail != email.trim() ||
        isProfileImageChanged;
  }

  Future<void> pickProfileImageFromGallery() async {
    await _pickProfileImage(ImageSource.gallery);
  }

  Future<void> pickProfileImageFromCamera() async {
    await _pickProfileImage(ImageSource.camera);
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 85);

      if (pickedFile == null) return;

      _selectedProfileImage = File(pickedFile.path);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to select image';
      notifyListeners();
    }
  }

  // Fetch user profile from API
  Future<void> fetchUserProfile() async {
    try {
      _isFetching = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _userService.getParentProfile();

      if (response.success && response.data != null) {
        _userData = response.data;
        _originalPhotoUrl = response.data!.photoUrl;
        _selectedProfileImage = null;
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

      String? photoUrlForUpdate;

      if (_selectedProfileImage != null) {
        final uploadResult = await _userService.uploadSharedFile(
          file: _selectedProfileImage!,
          folderPath: 'profile/parent',
          oldFileUrl:
              (_originalPhotoUrl != null && _originalPhotoUrl!.isNotEmpty)
                  ? _originalPhotoUrl
                  : null,
        );

        final uploadSuccess = uploadResult['success'] == true;
        if (!uploadSuccess) {
          _errorMessage = uploadResult['message']?.toString() ??
              uploadResult['error']?.toString() ??
              'Failed to upload profile image';
          _isUpdating = false;
          notifyListeners();
          return false;
        }

        photoUrlForUpdate = uploadResult['url']?.toString();
        if (photoUrlForUpdate == null || photoUrlForUpdate.isEmpty) {
          _errorMessage = 'Failed to get uploaded image URL';
          _isUpdating = false;
          notifyListeners();
          return false;
        }
      }

      final response = await _userService.updateParentProfile(
        name: name,
        email: email,
        photoUrl: photoUrlForUpdate,
      );

      if (response.success && response.data != null) {
        // Refresh user data after successful update (silently without showing spinner)
        await _fetchUserProfileSilently();
        _selectedProfileImage = null;
        _originalPhotoUrl = _userData?.photoUrl;
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
        _originalPhotoUrl = response.data!.photoUrl;
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
    _originalPhotoUrl = data.photoUrl;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear user data (for logout)
  void clearUserData() {
    _userData = null;
    _selectedProfileImage = null;
    _originalPhotoUrl = null;
    _errorMessage = null;
    _isFetching = false;
    _isUpdating = false;
    notifyListeners();
  }
}
