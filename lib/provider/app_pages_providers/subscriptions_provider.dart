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
  String? redeemErrorMessage;
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

  /// True when at least one student is already covered (school or self-pay)
  /// but not all students are covered.
  bool get hasPartialCoverage =>
      !coveredBySchool &&
      (parentSummary?.coveredStudents.isNotEmpty ?? false);

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

      final errorCode = response['error'] as String?;
      if (errorCode == 'STUDENT_ALREADY_SUBSCRIBED') {
        errorMessage = 'All your kids already have active subscriptions.';
      } else if (errorCode == 'STUDENT_COUNT_ABOVE_MAX') {
        final max = response['data']?['max'] ?? response['max'];
        errorMessage = max != null
            ? 'This plan supports max $max kid(s). Please select fewer students.'
            : 'Too many students selected for this plan.';
      } else {
        errorMessage = errorCode ?? 'Failed to create subscription';
      }
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
        redeemErrorMessage = null;
        await fetchRecommendations(isRefresh: true);
        notifyListeners();
        return true;
      }
      redeemErrorMessage =
          response.error ?? response.message ?? 'Failed to redeem code';
      notifyListeners();
      return false;
    } catch (e) {
      redeemErrorMessage = 'Failed to redeem code. Please try again.';
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

  void clearError() {
    errorMessage = null;
    redeemErrorMessage = null;
    notifyListeners();
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
    redeemErrorMessage = null;
    _isInitialized = false;
    notifyListeners();
  }
}
