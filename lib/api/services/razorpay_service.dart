import '../api_client.dart';
import '../endpoints.dart';
import '../interfaces/razorpay_service_interface.dart';
import '../models/razorpay_config_response.dart';
import '../models/razorpay_order_response.dart';
import '../models/razorpay_verify_response.dart';
import '../models/record_payment_response.dart';
import 'dart:convert';

class RazorpayService implements RazorpayServiceInterface {
  final ApiClient _apiClient;

  RazorpayService(this._apiClient);

  @override
  Future<RazorpayConfigResponse> getRazorpayConfig() async {
    final response = await _apiClient.get(Endpoints.razorpayConfig);
    return RazorpayConfigResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<RazorpayOrderResponse> createOrder({
    required int amount,
    required String subscriptionId,
    required String description,
    String currency = 'INR',
  }) async {
    final response = await _apiClient.post(
      Endpoints.razorpayOrders,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'subscription_id': subscriptionId,
        'description': description,
      }),
    );
    return RazorpayOrderResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<RazorpayVerifyResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final response = await _apiClient.post(
      Endpoints.razorpayVerify,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      }),
    );
    return RazorpayVerifyResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<RecordPaymentResponse> recordPayment({
    required Map<String, dynamic> paymentData,
  }) async {
    final response = await _apiClient.post(
      Endpoints.payments,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(paymentData),
    );
    return RecordPaymentResponse.fromJson(jsonDecode(response.body));
  }
}
