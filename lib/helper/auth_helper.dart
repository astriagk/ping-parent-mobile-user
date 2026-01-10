import 'package:shared_preferences/shared_preferences.dart';
import '../common/session.dart';

class AuthHelper {
  static final Session _session = Session();

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_session.isLogin) ?? false;
  }

  /// Get stored access token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_session.accessToken);
  }

  /// Get stored user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_session.user);
    if (userJson != null) {
      return {'user': userJson}; // Return as map for consistency
    }
    return null;
  }

  /// Save authentication data after successful login
  static Future<void> saveAuthData({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_session.isLogin, true);
    await prefs.setString(_session.accessToken, token);
    // Store user data as individual fields for easy access
    await prefs.setString(_session.id, user['id'] ?? '');
    await prefs.setString(_session.user, user['phone'] ?? '');
  }

  /// Clear authentication data on logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_session.isLogin, false);
    await prefs.remove(_session.accessToken);
    await prefs.remove(_session.id);
    await prefs.remove(_session.user);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_session.id);
  }

  /// Get user phone
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_session.user);
  }
}
