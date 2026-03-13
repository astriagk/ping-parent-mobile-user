import '../../config.dart';
import '../../api/api_client.dart';
import '../../api/services/payment_service.dart';

class MyWalletProvider extends ChatProvider {
  bool showEarnings = true;
  bool isLoading = false;
  String? errorMessage;

  final PaymentService _paymentService = PaymentService(ApiClient());

  List<Map<String, dynamic>> payments = [];
  bool _hasFetchedPayments = false;
  bool get hasFetchedPayments => _hasFetchedPayments;
  List<Map<String, dynamic>> get completedPayments =>
      payments.where((p) => p['payment_status'] == 'completed').toList();
  List<Map<String, dynamic>> get pendingPayments =>
      payments.where((p) => p['payment_status'] != 'completed').toList();

  Future<void> fetchPayments() async {
    try {
      isLoading = true;
      errorMessage = null;
      _hasFetchedPayments = true;
      notifyListeners();

      final res = await _paymentService.getPayments();
      if (res.containsKey('data')) {
        final raw = res['data'] as List<dynamic>;
        payments = raw.cast<Map<String, dynamic>>();
        errorMessage = null;
      } else {
        payments = [];
      }
    } catch (e) {
      payments = [];
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setShowEarnings(bool v) {
    showEarnings = v;
    notifyListeners();
  }
}
