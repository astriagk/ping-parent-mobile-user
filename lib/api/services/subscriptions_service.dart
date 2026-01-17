import '../api_client.dart';
import '../endpoints.dart';
import '../interfaces/subscriptions_service_interface.dart';
import '../models/subscription_plans_response.dart';
import 'dart:convert';

class SubscriptionsService implements SubscriptionsServiceInterface {
  final ApiClient _apiClient;

  SubscriptionsService(this._apiClient);

  @override
  Future<SubscriptionPlansResponse> getSubscriptionPlans() async {
    final response = await _apiClient.get(Endpoints.subscriptionPlans);
    return SubscriptionPlansResponse.fromJson(jsonDecode(response.body));
  }
}
