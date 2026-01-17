import '../models/subscription_plans_response.dart';

abstract class SubscriptionsServiceInterface {
  Future<SubscriptionPlansResponse> getSubscriptionPlans();
}
