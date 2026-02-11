import 'dart:convert';
import '../api_client.dart';
import '../endpoints.dart';
import '../interfaces/accept_ride_service_interface.dart';
import '../models/qr_otp_response.dart';

class AcceptRideService implements AcceptRideServiceInterface {
  final ApiClient _apiClient;

  AcceptRideService(this._apiClient);

  @override
  Future<QrOtpResponse> getParentTripQrOtp(String tripId) async {
    final response = await _apiClient.get(
      Endpoints.parentTripQrOtp(tripId),
    );

    if (response.statusCode == 200) {
      return QrOtpResponse.fromJson(jsonDecode(response.body));
    }

    return QrOtpResponse.fromJson({
      'success': false,
      'error': jsonDecode(response.body)['error'] ?? 'Failed to fetch QR/OTP',
    });
  }
}
