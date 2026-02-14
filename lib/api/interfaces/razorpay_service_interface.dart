import '../models/razorpay_config_response.dart';
import '../models/razorpay_order_response.dart';
import '../models/razorpay_verify_response.dart';
import '../models/record_payment_response.dart';

abstract class RazorpayServiceInterface {
  Future<RazorpayConfigResponse> getRazorpayConfig();
  Future<RazorpayOrderResponse> createOrder({
    required int amount,
    required String subscriptionId,
    required String description,
    String currency,
  });
  Future<RazorpayVerifyResponse> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  });
  Future<RecordPaymentResponse> recordPayment({
    required Map<String, dynamic> paymentData,
  });
}
