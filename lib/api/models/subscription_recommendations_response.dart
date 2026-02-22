import 'subscription_plans_response.dart';

class SubscriptionRecommendationsResponse {
  final bool success;
  final RecommendationsData? data;
  final String? message;
  final String? error;

  SubscriptionRecommendationsResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory SubscriptionRecommendationsResponse.fromJson(
      Map<String, dynamic> json) {
    return SubscriptionRecommendationsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? RecommendationsData.fromJson(json['data'])
          : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class RecommendationsData {
  final ParentSummary parentSummary;
  final List<RecommendedPlan> recommendedPlans;
  final List<ExcludedPlan> excludedPlans;
  final CurrentSubscription? currentSubscription;

  RecommendationsData({
    required this.parentSummary,
    required this.recommendedPlans,
    required this.excludedPlans,
    this.currentSubscription,
  });

  factory RecommendationsData.fromJson(Map<String, dynamic> json) {
    return RecommendationsData(
      parentSummary: ParentSummary.fromJson(json['parent_summary'] ?? {}),
      recommendedPlans: json['recommended_plans'] != null
          ? (json['recommended_plans'] as List)
              .map((e) => RecommendedPlan.fromJson(e))
              .toList()
          : [],
      excludedPlans: json['excluded_plans'] != null
          ? (json['excluded_plans'] as List)
              .map((e) => ExcludedPlan.fromJson(e))
              .toList()
          : [],
      currentSubscription: json['current_subscription'] != null
          ? CurrentSubscription.fromJson(json['current_subscription'])
          : null,
    );
  }
}

class ParentSummary {
  final int totalKids;
  final List<KidSummary> kids;
  final List<SameTripGroup> sameTripGroups;

  ParentSummary({
    required this.totalKids,
    required this.kids,
    required this.sameTripGroups,
  });

  factory ParentSummary.fromJson(Map<String, dynamic> json) {
    return ParentSummary(
      totalKids: json['total_kids'] ?? 0,
      kids: json['kids'] != null
          ? (json['kids'] as List).map((e) => KidSummary.fromJson(e)).toList()
          : [],
      sameTripGroups: json['same_trip_groups'] != null
          ? (json['same_trip_groups'] as List)
              .map((e) => SameTripGroup.fromJson(e))
              .toList()
          : [],
    );
  }
}

class KidSummary {
  final String studentId;
  final String studentName;
  final String studentClass;
  final String? section;
  final String? schoolId;
  final String? driverUniqueId;
  final bool hasDriver;

  KidSummary({
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    this.section,
    this.schoolId,
    this.driverUniqueId,
    required this.hasDriver,
  });

  factory KidSummary.fromJson(Map<String, dynamic> json) {
    return KidSummary(
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['class'] ?? '',
      section: json['section'],
      schoolId: json['school_id'],
      driverUniqueId: json['driver_unique_id'],
      hasDriver: json['has_driver'] ?? false,
    );
  }
}

class SameTripGroup {
  final String driverUniqueId;
  final List<String> kids;
  final int count;

  SameTripGroup({
    required this.driverUniqueId,
    required this.kids,
    required this.count,
  });

  factory SameTripGroup.fromJson(Map<String, dynamic> json) {
    return SameTripGroup(
      driverUniqueId: json['driver_unique_id'] ?? '',
      kids: json['kids'] != null
          ? (json['kids'] as List).map((e) => e.toString()).toList()
          : [],
      count: json['count'] ?? 0,
    );
  }
}

class RecommendedPlan {
  final String planId;
  final String planName;
  final String planType;
  final String pricingModel;
  final int price;
  final int? perKidPrice;
  final int originalPrice;
  final int calculatedPrice;
  final PlanDiscount? discount;
  final bool coversAllKids;
  final int kidsCovered;
  final List<Feature> features;
  final bool isRecommended;
  final String reason;
  final bool isCurrentPlan;
  final bool isUpgrade;
  final Proration? proration;
  final int? upgradePrice;

  RecommendedPlan({
    required this.planId,
    required this.planName,
    required this.planType,
    required this.pricingModel,
    required this.price,
    this.perKidPrice,
    required this.originalPrice,
    required this.calculatedPrice,
    this.discount,
    required this.coversAllKids,
    required this.kidsCovered,
    required this.features,
    required this.isRecommended,
    required this.reason,
    this.isCurrentPlan = false,
    this.isUpgrade = false,
    this.proration,
    this.upgradePrice,
  });

  factory RecommendedPlan.fromJson(Map<String, dynamic> json) {
    return RecommendedPlan(
      planId: json['plan_id'] ?? '',
      planName: json['plan_name'] ?? '',
      planType: json['plan_type'] ?? '',
      pricingModel: json['pricing_model'] ?? 'flat',
      price: json['price'] ?? 0,
      perKidPrice: json['per_kid_price'],
      originalPrice: json['original_price'] ?? 0,
      calculatedPrice: json['calculated_price'] ?? 0,
      discount: json['discount'] != null
          ? PlanDiscount.fromJson(json['discount'])
          : null,
      coversAllKids: json['covers_all_kids'] ?? false,
      kidsCovered: json['kids_covered'] ?? 0,
      features: json['features'] != null
          ? (json['features'] as List).map((e) => Feature.fromJson(e)).toList()
          : [],
      isRecommended: json['is_recommended'] ?? false,
      reason: json['reason'] ?? '',
      isCurrentPlan: json['is_current_plan'] ?? false,
      isUpgrade: json['is_upgrade'] ?? false,
      proration: json['proration'] != null
          ? Proration.fromJson(json['proration'])
          : null,
      upgradePrice: json['upgrade_price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plan_id': planId,
      'plan_name': planName,
      'plan_type': planType,
      'pricing_model': pricingModel,
      'price': price,
      'per_kid_price': perKidPrice,
      'original_price': originalPrice,
      'calculated_price': calculatedPrice,
      'discount': discount != null
          ? {
              'type': discount!.type,
              'percentage': discount!.percentage,
              'amount': discount!.amount,
              'label': discount!.label,
            }
          : null,
      'covers_all_kids': coversAllKids,
      'kids_covered': kidsCovered,
      'features': features
          .map((f) => {
                'key': f.key,
                'label': f.label,
                'enabled': f.enabled,
              })
          .toList(),
      'is_recommended': isRecommended,
      'reason': reason,
      'is_current_plan': isCurrentPlan,
      'is_upgrade': isUpgrade,
      'proration': proration != null
          ? {
              'current_plan_total_days': proration!.currentPlanTotalDays,
              'current_plan_remaining_days':
                  proration!.currentPlanRemainingDays,
              'current_daily_rate': proration!.currentDailyRate,
              'current_remaining_value': proration!.currentRemainingValue,
              'new_plan_full_price': proration!.newPlanFullPrice,
              'prorated_upgrade_price': proration!.proratedUpgradePrice,
            }
          : null,
      'upgrade_price': upgradePrice,
    };
  }
}

class PlanDiscount {
  final String type;
  final int percentage;
  final int amount;
  final String label;

  PlanDiscount({
    required this.type,
    required this.percentage,
    required this.amount,
    required this.label,
  });

  factory PlanDiscount.fromJson(Map<String, dynamic> json) {
    return PlanDiscount(
      type: json['type'] ?? '',
      percentage: json['percentage'] ?? 0,
      amount: json['amount'] ?? 0,
      label: json['label'] ?? '',
    );
  }
}

class ExcludedPlan {
  final String planId;
  final String planName;
  final String reason;

  ExcludedPlan({
    required this.planId,
    required this.planName,
    required this.reason,
  });

  factory ExcludedPlan.fromJson(Map<String, dynamic> json) {
    return ExcludedPlan(
      planId: json['plan_id'] ?? '',
      planName: json['plan_name'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}

class CurrentSubscription {
  final String id;
  final String planId;
  final int calculatedPrice;
  final String startDate;
  final String endDate;
  final int remainingDays;
  final int remainingValue;

  CurrentSubscription({
    required this.id,
    required this.planId,
    required this.calculatedPrice,
    required this.startDate,
    required this.endDate,
    required this.remainingDays,
    required this.remainingValue,
  });

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) {
    return CurrentSubscription(
      id: json['_id'] ?? '',
      planId: json['plan_id'] ?? '',
      calculatedPrice: json['calculated_price'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      remainingDays: json['remaining_days'] ?? 0,
      remainingValue: json['remaining_value'] ?? 0,
    );
  }
}

class Proration {
  final int currentPlanTotalDays;
  final int currentPlanRemainingDays;
  final double currentDailyRate;
  final int currentRemainingValue;
  final int newPlanFullPrice;
  final int proratedUpgradePrice;

  Proration({
    required this.currentPlanTotalDays,
    required this.currentPlanRemainingDays,
    required this.currentDailyRate,
    required this.currentRemainingValue,
    required this.newPlanFullPrice,
    required this.proratedUpgradePrice,
  });

  factory Proration.fromJson(Map<String, dynamic> json) {
    return Proration(
      currentPlanTotalDays: json['current_plan_total_days'] ?? 0,
      currentPlanRemainingDays: json['current_plan_remaining_days'] ?? 0,
      currentDailyRate: (json['current_daily_rate'] ?? 0).toDouble(),
      currentRemainingValue: json['current_remaining_value'] ?? 0,
      newPlanFullPrice: json['new_plan_full_price'] ?? 0,
      proratedUpgradePrice: json['prorated_upgrade_price'] ?? 0,
    );
  }
}
