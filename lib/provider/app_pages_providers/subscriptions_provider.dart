import 'package:flutter/material.dart';
import '../../api/api_client.dart';
import '../../api/services/subscriptions_service.dart';
import '../../api/models/subscription_plans_response.dart';
import '../../api/models/subscription_recommendations_response.dart';

class SubscriptionsProvider extends ChangeNotifier {
  List<SubscriptionPlan> subscriptionPlans = [];
  List<RecommendedPlan> recommendedPlans = [];
  ParentSummary? parentSummary;
  List<CurrentSubscription> currentSubscriptions = [];
  bool coveredBySchool = false;
  bool isLoading = true; // Start with loading true to prevent empty state flash
  bool isRefreshing = false;
  String? errorMessage;
  bool _isInitialized = false;

  /// Returns the first self-pay subscription, if any.
  CurrentSubscription? get firstSelfPaySubscription {
    try {
      return currentSubscriptions
          .firstWhere((s) => s.subscriptionSource == 'self_pay');
    } catch (_) {
      return null;
    }
  }

  /// True when not all students are covered by school but at least one is.
  bool get hasPartialSchoolCoverage =>
      !coveredBySchool &&
      currentSubscriptions.any((s) => s.isSchoolRedemption);

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
        currentSubscriptions = response.data!.currentSubscriptions;
        coveredBySchool = response.data!.coveredBySchool;
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

  Future<bool> createSubscription(String planId,
      {List<String>? studentIds}) async {
    try {
      final subscriptionsService = SubscriptionsService(ApiClient());
      final response = await subscriptionsService.createSubscription(
        planId,
        studentIds: studentIds,
      );
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
      return response.success && response.data.any((s) => s.isActive);
    } catch (e) {
      return false;
    }
  }

  Future<bool> redeemSubscriptionCode(String code) async {
    try {
      final subscriptionsService = SubscriptionsService(ApiClient());
      final response = await subscriptionsService.redeemCode(code);
      if (response.success) {
        await fetchRecommendations(isRefresh: true);
        errorMessage = null;
        notifyListeners();
        return true;
      }
      errorMessage = response.error ?? 'Failed to redeem code';
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Failed to redeem code. Please try again.';
      notifyListeners();
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
      return subscriptionPlans.firstWhere((plan) => plan.id == planId);
    } catch (e) {
      return null;
    }
  }

  void reset() {
    subscriptionPlans = [];
    recommendedPlans = [];
    parentSummary = null;
    currentSubscriptions = [];
    coveredBySchool = false;
    isLoading = false;
    isRefreshing = false;
    errorMessage = null;
    _isInitialized = false;
    notifyListeners();
  }
}
