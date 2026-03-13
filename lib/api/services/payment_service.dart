import 'dart:convert';

import '../api_client.dart';
import '../endpoints.dart';

class PaymentService {
  final ApiClient _apiClient;

  PaymentService(this._apiClient);

  /// GET /parent/payments
  Future<Map<String, dynamic>> getPayments() async {
    final response = await _apiClient.get(Endpoints.payments);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
