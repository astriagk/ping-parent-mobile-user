import '../models/subscription_plans_response.dart';
import '../models/subscription_recommendations_response.dart';

abstract class SubscriptionsServiceInterface {
  Future<SubscriptionPlansResponse> getSubscriptionPlans();
  Future<SubscriptionRecommendationsResponse> getRecommendations();
  Future<Map<String, dynamic>> createSubscription(String planId);
  Future<Map<String, dynamic>> upgradeSubscription(String planId);
}
