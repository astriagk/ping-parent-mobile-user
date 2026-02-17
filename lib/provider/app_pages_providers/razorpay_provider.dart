import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../api/api_client.dart';
import '../../api/services/razorpay_service.dart';
import '../../api/services/storage_service.dart';
import '../../api/models/razorpay_config_response.dart';
import '../../api/models/razorpay_order_response.dart';
import '../../api/models/razorpay_verify_response.dart';

class RazorpayProvider extends ChangeNotifier {
  RazorpayConfig? razorpayConfig;
  RazorpayOrder? razorpayOrder;
  RazorpayPayment? verifiedPayment;
  bool isLoading = false;
  bool isPaymentSuccess = false;
  String? errorMessage;

  Razorpay? _razorpay;
  String? _subscriptionId;

  Future<void> initiatePayment({
    required int amount,
    required String subscriptionId,
    required String description,
  }) async {
    isLoading = true;
    errorMessage = null;
    isPaymentSuccess = false;
    _subscriptionId = subscriptionId;
    notifyListeners();

    try {
      final razorpayService = RazorpayService(ApiClient());

      // Step 1: Fetch Razorpay config
      final configResponse = await razorpayService.getRazorpayConfig();

      if (!configResponse.success || configResponse.data == null) {
        errorMessage = configResponse.error ??
            configResponse.message ??
            'Failed to fetch Razorpay configuration';
        isLoading = false;
        notifyListeners();
        return;
      }

      razorpayConfig = configResponse.data;

      // Step 2: Create order
      final orderResponse = await razorpayService.createOrder(
        amount: amount,
        subscriptionId: subscriptionId,
        description: description,
      );

      if (!orderResponse.success || orderResponse.data == null) {
        errorMessage = orderResponse.error ??
            orderResponse.message ??
            'Failed to create payment order';
        isLoading = false;
        notifyListeners();
        return;
      }

      razorpayOrder = orderResponse.data;

      // Step 3: Open Razorpay checkout
      await _openCheckout(
        amount: razorpayOrder!.amount,
        orderId: razorpayOrder!.id,
        description: description,
      );
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _openCheckout({
    required int amount,
    required String orderId,
    required String description,
  }) async {
    _razorpay?.clear();
    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    final storageService = StorageService();
    final email = await storageService.getUserEmail() ?? '';
    final phone = await storageService.getUserPhone() ?? '';

    final options = {
      'key': razorpayConfig!.keyId,
      'amount': amount,
      'currency': 'INR',
      'name': 'Ping Parent',
      'description': description,
      'order_id': orderId,
      'prefill': {
        'email': email,
        'contact': phone,
      },
      'theme': {
        'color': '#3399cc',
      },
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      errorMessage = 'Failed to open checkout';
      isLoading = false;
      notifyListeners();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _verifyPayment(
      razorpayOrderId: response.orderId!,
      razorpayPaymentId: response.paymentId!,
      razorpaySignature: response.signature!,
    );
  }

  Future<void> _verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final razorpayService = RazorpayService(ApiClient());
      final response = await razorpayService.verifyPayment(
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );

      if (response.success && response.data != null) {
        verifiedPayment = response.data;
        errorMessage = null;

        // Step 4: Record payment in database
        await _recordPayment();
      } else {
        errorMessage =
            response.error ?? response.message ?? 'Payment verification failed';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Payment verification failed. Please contact support.';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _recordPayment() async {
    try {
      final razorpayService = RazorpayService(ApiClient());
      final payment = verifiedPayment!;

      final response = await razorpayService.recordPayment(
        paymentData: {
          'payment_type': 'subscription',
          'amount': payment.amount / 100, // Convert from paise to rupees
          'currency': payment.currency,
          'payment_method': payment.method,
          'payment_status': payment.captured ? 'completed' : 'failed',
          'transaction_id': payment.id,
          'gateway_response': {
            'razorpay_payment_id': payment.id,
            'razorpay_order_id': payment.orderId,
            'amount': payment.amount / 100, // Convert from paise to rupees
            'currency': payment.currency,
            'method': payment.method,
            'vpa': payment.vpa,
            'email': payment.email,
            'contact': payment.contact,
            'fee': payment.fee != null ? payment.fee! / 100 : null,
            'tax': payment.tax != null ? payment.tax! / 100 : null,
          },
          'subscription_id': _subscriptionId,
          'payment_date': DateTime.now().toIso8601String(),
        },
      );

      if (response.success) {
        isPaymentSuccess = true;
      } else {
        errorMessage = response.message ?? 'Failed to record payment';
      }
    } catch (e) {
      errorMessage = 'Failed to record payment. Please contact support.';
    }

    isLoading = false;
    notifyListeners();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isLoading = false;
    errorMessage = response.message ?? 'Payment failed';
    notifyListeners();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    isLoading = false;
    notifyListeners();
  }

  void reset() {
    _razorpay?.clear();
    _razorpay = null;
    razorpayConfig = null;
    razorpayOrder = null;
    verifiedPayment = null;
    isLoading = false;
    isPaymentSuccess = false;
    errorMessage = null;
    notifyListeners();
  }
}
