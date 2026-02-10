import '../models/qr_otp_response.dart';

abstract class AcceptRideServiceInterface {
  /// Fetches QR code and OTP for a parent's trip
  Future<QrOtpResponse> getParentTripQrOtp(String tripId);
}
