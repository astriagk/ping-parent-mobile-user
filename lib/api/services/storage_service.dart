import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing both secure and non-secure storage
/// - Uses FlutterSecureStorage for sensitive data (tokens, user ID, etc.)
/// - Uses SharedPreferences for non-sensitive data (theme, language, etc.)
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Storage Keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyTokenExpiry = 'token_expiry';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyThemeMode = 'is_dark_mode';
  static const String _keyLanguage = 'language';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  // ============================================================
  // SECURE STORAGE METHODS (For sensitive data)
  // ============================================================

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: _keyAuthToken, value: token);
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _keyAuthToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _keyUserId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _keyUserId);
  }

  /// Save user phone number
  Future<void> saveUserPhone(String phone) async {
    await _secureStorage.write(key: _keyUserPhone, value: phone);
  }

  /// Get user phone number
  Future<String?> getUserPhone() async {
    return await _secureStorage.read(key: _keyUserPhone);
  }

  /// Save token with expiry time
  Future<void> saveTokenWithExpiry(String token, int expiresInSeconds) async {
    final expiryTime =
        DateTime.now().add(Duration(seconds: expiresInSeconds));
    await _secureStorage.write(key: _keyAuthToken, value: token);
    await _secureStorage.write(
      key: _keyTokenExpiry,
      value: expiryTime.toIso8601String(),
    );
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    final expiryString = await _secureStorage.read(key: _keyTokenExpiry);
    if (expiryString == null) return true;

    try {
      final expiry = DateTime.parse(expiryString);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }

  /// Clear all secure storage data
  Future<void> clearSecureData() async {
    await _secureStorage.deleteAll();
  }

  // ============================================================
  // SHARED PREFERENCES METHODS (For non-sensitive data)
  // ============================================================

  /// Save user name
  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  /// Get user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  /// Save theme mode
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyThemeMode, isDark);
  }

  /// Get theme mode
  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyThemeMode) ?? false;
  }

  /// Save language preference
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  /// Get language preference
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage);
  }

  /// Save login status
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = await getAuthToken();
    final isLoggedInPref = prefs.getBool(_keyIsLoggedIn) ?? false;
    return isLoggedInPref && hasToken != null;
  }

  /// Save onboarding completion status
  Future<void> saveOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // ============================================================
  // UTILITY METHODS
  // ============================================================

  /// Clear all stored data (both secure and non-secure)
  Future<void> clearAllData() async {
    await clearSecureData();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Logout user - clear auth data but keep app preferences
  Future<void> logout() async {
    await _secureStorage.delete(key: _keyAuthToken);
    await _secureStorage.delete(key: _keyRefreshToken);
    await _secureStorage.delete(key: _keyUserId);
    await _secureStorage.delete(key: _keyUserPhone);
    await _secureStorage.delete(key: _keyTokenExpiry);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  /// Check if user has valid session
  Future<bool> hasValidSession() async {
    final token = await getAuthToken();
    if (token == null) return false;

    // Check if login status is set
    final isLoggedIn = await this.isLoggedIn();
    return isLoggedIn;
  }
}
