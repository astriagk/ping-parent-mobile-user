import 'dart:convert';
import '../api_client.dart';
import '../services/storage_service.dart';
import '../endpoints.dart';

/// Interceptor to handle authentication and token verification
class AuthInterceptor {
  final ApiClient _apiClient;
  final StorageService _storage = StorageService();

  AuthInterceptor(this._apiClient);

  /// Verify token and refresh if needed
  /// Returns true if token is valid or was successfully refreshed
  Future<bool> verifyAndRefreshToken() async {
    try {
      final currentToken = await _storage.getAuthToken();
      if (currentToken == null) {
        return false;
      }

      final response = await _apiClient.get(Endpoints.verifyToken);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final tokenValid = data['data']?['tokenValid'] ?? false;
          final userId = data['data']?['userId'];
          final newToken = data['data']?['newToken'];

          // Save userId if available
          if (userId != null) {
            await _storage.saveUserId(userId.toString());
          }

          // If server provided a new token (token was refreshed), save it
          if (newToken != null) {
            await _storage.saveAuthToken(newToken);
            return true;
          }

          // Token is still valid
          return tokenValid;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if current session is valid
  Future<bool> hasValidSession() async {
    final token = await _storage.getAuthToken();
    if (token == null) return false;

    return await verifyAndRefreshToken();
  }
}
