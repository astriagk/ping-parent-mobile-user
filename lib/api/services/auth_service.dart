import '../api_client.dart';
import '../endpoints.dart';
import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';
import '../models/verify_token_response.dart';
import '../interfaces/auth_service_interface.dart';
import 'dart:convert';

class AuthService implements AuthServiceInterface {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  @override
  Future<SendOtpResponse> sendOtp({required String phone}) async {
    final response = await _apiClient.post(
      Endpoints.sendOtp,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
      requiresAuth: false,
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
      requiresAuth: false,
    );
    if (response.statusCode == 200) {
      return VerifyOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      return VerifyOtpResponse.fromJson(jsonDecode(response.body));
    }
  }

  @override
  Future<VerifyTokenResponse> verifyToken() async {
    final response = await _apiClient.get(
      Endpoints.verifyToken,
      requiresAuth: true,
    );
    if (response.statusCode == 200) {
      return VerifyTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      return VerifyTokenResponse.fromJson(jsonDecode(response.body));
    }
  }
}
