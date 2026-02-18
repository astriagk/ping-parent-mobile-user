import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../api/services/subscriptions_service.dart';
import '../../api/models/subscription_plans_response.dart';
import '../../api/models/subscription_recommendations_response.dart';

class SubscriptionsProvider extends ChangeNotifier {
  List<SubscriptionPlan> subscriptionPlans = [];
  List<RecommendedPlan> recommendedPlans = [];
  ParentSummary? parentSummary;
  CurrentSubscription? currentSubscription;
  bool isLoading = true; // Start with loading true to prevent empty state flash
  bool isRefreshing = false;
  String? errorMessage;
  bool _isInitialized = false;

  Future<void> onInit() async {
    if (_isInitialized && recommendedPlans.isNotEmpty) return;
    _isInitialized = true;
    await fetchRecommendations();
  }

  Future<void> fetchRecommendations({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing = true;
    } else {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      final subscriptionsService = SubscriptionsService(ApiClient());
      final response = await subscriptionsService.getRecommendations();

      if (response.success && response.data != null) {
        recommendedPlans = response.data!.recommendedPlans;
        parentSummary = response.data!.parentSummary;
        currentSubscription = response.data!.currentSubscription;
        errorMessage = null;
      } else {
        errorMessage = response.error ??
            response.message ??
            'Failed to fetch subscription recommendations';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
    }

    isLoading = false;
    isRefreshing = false;
    notifyListeners();
  }

  Future<void> fetchSubscriptionPlans({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing = true;
    } else {
      isLoading = true;
    }
    errorMessage = null;
    notifyListeners();

    try {
      final subscriptionsService = SubscriptionsService(ApiClient());
      final response = await subscriptionsService.getSubscriptionPlans();

      if (response.success) {
        subscriptionPlans = response.data;
        errorMessage = null;
      } else {
        errorMessage = response.error ??
            response.message ??
            'Failed to fetch subscription plans';
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
    }

    isLoading = false;
    isRefreshing = false;
    notifyListeners();
  }

  Future<bool> createSubscription(String planId) async {
    try {
      final subscriptionsService = SubscriptionsService(ApiClient());
      final response = await subscriptionsService.createSubscription(planId);
      if (response['success'] == true) {
        await fetchRecommendations(isRefresh: true);
        return true;
      }
      errorMessage = response['error'] ?? 'Failed to create subscription';
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Failed to create subscription. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> upgradeSubscription(String planId) async {
    try {
      final subscriptionsService = SubscriptionsService(ApiClient());
      final response = await subscriptionsService.upgradeSubscription(planId);
      if (response['success'] == true) {
        await fetchRecommendations(isRefresh: true);
        return true;
      }
      errorMessage = response['error'] ?? 'Failed to upgrade subscription';
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Failed to upgrade subscription. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkHasActiveSubscription() async {
    try {
      final subscriptionsService = SubscriptionsService(ApiClient());
      final response = await subscriptionsService.getActiveSubscription();
      return response.success &&
          response.data != null &&
          response.data!.isActive;
    } catch (e) {
      return false;
    }
  }

  // Get active subscription plans only
  List<SubscriptionPlan> get activePlans {
    return subscriptionPlans.where((plan) => plan.isActive).toList();
  }

  // Get plans by type (monthly/yearly)
  List<SubscriptionPlan> getPlansByType(String type) {
    return subscriptionPlans
        .where((plan) => plan.planType == type && plan.isActive)
        .toList();
  }

  // Get plan by ID
  SubscriptionPlan? getPlanById(String planId) {
    try {
      return subscriptionPlans.firstWhere((plan) => plan.planId == planId);
    } catch (e) {
      return null;
    }
  }

  void reset() {
    subscriptionPlans = [];
    recommendedPlans = [];
    parentSummary = null;
    currentSubscription = null;
    isLoading = false;
    isRefreshing = false;
    errorMessage = null;
    _isInitialized = false;
    notifyListeners();
  }
}
