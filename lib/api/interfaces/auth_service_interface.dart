import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';
import '../models/verify_token_response.dart';

abstract class AuthServiceInterface {
  Future<SendOtpResponse> sendOtp({required String phone});
  Future<VerifyOtpResponse> verifyOtp(
      {required String phone, required String otp});
  Future<VerifyTokenResponse> verifyToken();
}
