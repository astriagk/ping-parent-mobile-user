import '../api_client.dart';
import '../endpoints.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';
import '../interfaces/auth_service_interface.dart';
import '../models/verify_token_response.dart';
import 'storage_service.dart';
import 'dart:convert';

class AuthService implements AuthServiceInterface {
  final ApiClient _apiClient;
  final StorageService _storage = StorageService();

  AuthService(this._apiClient);

  @override
  Future<SendOtpResponse> sendOtp({required String phone}) async {
    final response = await _apiClient.post(
      Endpoints.sendOtp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200) {
      return SendOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      return SendOtpResponse.fromJson(jsonDecode(response.body));
    }
  }

  @override
  Future<VerifyOtpResponse> verifyOtp(
      {required String phone, required String otp}) async {
    final response = await _apiClient.post(
      Endpoints.verifyOtp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );

    final verifyResponse =
        VerifyOtpResponse.fromJson(jsonDecode(response.body));

    // Save token and user data if verification is successful
    if (response.statusCode == 200 && verifyResponse.success) {
      await _saveUserSession(verifyResponse, phone);
    }

    return verifyResponse;
  }

  Future<SendOtpResponse> registerSendOtp({required String phone}) async {
    final response = await _apiClient.post(
      Endpoints.registerSendOtp,
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200) {
      return SendOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      return SendOtpResponse.fromJson(jsonDecode(response.body));
    }
  }

  Future<VerifyOtpResponse> registerVerifyOtp(
      {required String phone, required String otp}) async {
    final response = await _apiClient.post(
      Endpoints.registerVerifyOtp,
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );
    final verifyResponse =
        VerifyOtpResponse.fromJson(jsonDecode(response.body));

    // Save token and user data if verification is successful
    if (response.statusCode == 200 && verifyResponse.success) {
      await _saveUserSession(verifyResponse, phone);
    }

    return verifyResponse;
  }

  @override
  Future<VerifyTokenResponse> verifyToken() async {
    final response = await _apiClient.get(
      Endpoints.verifyToken,
    );
    if (response.statusCode == 200) {
      return VerifyTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      return VerifyTokenResponse.fromJson(jsonDecode(response.body));
    }
  }

  /// Save user session data after successful authentication
  Future<void> _saveUserSession(
      VerifyOtpResponse response, String phone) async {
    if (response.token != null) {
      await _storage.saveAuthToken(response.token!);
      await _storage.saveUserPhone(phone);
      await _storage.saveLoginStatus(true);
    }

    // Save user data if available
    if (response.user != null) {
      final userData = response.user!;

      if (userData['id'] != null) {
        await _storage.saveUserId(userData['id'].toString());
      }

      if (userData['name'] != null) {
        await _storage.saveUserName(userData['name'].toString());
      }

      if (userData['email'] != null) {
        await _storage.saveUserEmail(userData['email'].toString());
      }
    }
  }

  /// Logout user and clear session data
  Future<void> logout() async {
    await _storage.logout();
  }

  /// Check if user has valid session
  Future<bool> hasValidSession() async {
    return await _storage.hasValidSession();
  }

  /// Get current user ID
  Future<String?> getCurrentUserId() async {
    return await _storage.getUserId();
  }
}
