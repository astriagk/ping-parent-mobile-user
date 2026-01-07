import '../models/send_otp_response.dart';

abstract class AuthServiceInterface {
  Future<SendOtpResponse> sendOtp({required String phone});
}
