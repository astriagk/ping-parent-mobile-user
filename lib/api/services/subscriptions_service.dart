import '../api_client.dart';
import '../endpoints.dart';
import '../interfaces/subscriptions_service_interface.dart';
import '../models/subscription_plans_response.dart';
import '../models/subscription_recommendations_response.dart';
import 'dart:convert';

class SubscriptionsService implements SubscriptionsServiceInterface {
  final ApiClient _apiClient;

  SubscriptionsService(this._apiClient);

  @override
  Future<SubscriptionPlansResponse> getSubscriptionPlans() async {
    final response = await _apiClient.get(Endpoints.subscriptionPlans);
    return SubscriptionPlansResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Future<SubscriptionRecommendationsResponse> getRecommendations() async {
    final response =
        await _apiClient.get(Endpoints.subscriptionRecommendations);
    return SubscriptionRecommendationsResponse.fromJson(
        jsonDecode(response.body));
  }

  @override
  Future<Map<String, dynamic>> createSubscription(String planId) async {
    final response = await _apiClient.post(
      Endpoints.parentSubscriptions,
      body: {'plan_id': planId},
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> upgradeSubscription(String planId) async {
    final response = await _apiClient.post(
      Endpoints.parentSubscriptionsUpgrade,
      body: {'plan_id': planId},
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
