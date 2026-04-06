import 'subscription_plans_response.dart';

class ActiveSubscriptionResponse {
  final bool success;
  final List<ActiveSubscription> data;
  final String message;

  ActiveSubscriptionResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ActiveSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => ActiveSubscription.fromJson(e))
              .toList()
          : [],
      message: json['message'] ?? '',
    );
  }
}

class ActiveSubscription {
  final String id;
  final String parentId;
  final String planId;
  final List<String> studentIds;
  final int numberOfKids;
  final int originalPrice;
  final int calculatedPrice;
  final String currency;
  final String startDate;
  final String endDate;
  final String subscriptionStatus;
  final bool autoRenew;
  final String? subscriptionSource;
  final ActiveSubscriptionPlan plan;
  final List<ActiveSubscriptionStudent> students;

  ActiveSubscription({
    required this.id,
    required this.parentId,
    required this.planId,
    required this.studentIds,
    required this.numberOfKids,
    required this.originalPrice,
    required this.calculatedPrice,
    required this.currency,
    required this.startDate,
    required this.endDate,
    required this.subscriptionStatus,
    required this.autoRenew,
    this.subscriptionSource,
    required this.plan,
    required this.students,
  });

  bool get isActive => subscriptionStatus == 'active';

  factory ActiveSubscription.fromJson(Map<String, dynamic> json) {
    return ActiveSubscription(
      id: json['_id'] ?? '',
      parentId: json['parent_id'] ?? '',
      planId: json['plan_id'] ?? '',
      studentIds: json['student_ids'] != null
          ? (json['student_ids'] as List).map((e) => e.toString()).toList()
          : [],
      numberOfKids: json['number_of_kids'] ?? 0,
      originalPrice: json['original_price'] ?? 0,
      calculatedPrice: json['calculated_price'] ?? 0,
      currency: json['currency'] ?? 'INR',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      subscriptionStatus: json['subscription_status'] ?? '',
      autoRenew: json['auto_renew'] ?? false,
      subscriptionSource: json['subscription_source'],
      plan: json['plan'] != null
          ? ActiveSubscriptionPlan.fromJson(json['plan'])
          : ActiveSubscriptionPlan(
              id: '',
              planName: '',
              planType: '',
              pricingModel: 'flat',
              price: 0,
              features: [],
            ),
      students: json['students'] != null
          ? (json['students'] as List)
              .map((e) => ActiveSubscriptionStudent.fromJson(e))
              .toList()
          : [],
    );
  }
}

class ActiveSubscriptionPlan {
  final String id;
  final String planName;
  final String planType;
  final String pricingModel;
  final int price;
  final List<Feature> features;

  ActiveSubscriptionPlan({
    required this.id,
    required this.planName,
    required this.planType,
    required this.pricingModel,
    required this.price,
    required this.features,
  });

  factory ActiveSubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionPlan(
      id: json['_id'] ?? '',
      planName: json['plan_name'] ?? '',
      planType: json['plan_type'] ?? '',
      pricingModel: json['pricing_model'] ?? 'flat',
      price: json['price'] ?? 0,
      features: json['features'] != null
          ? (json['features'] as List).map((e) => Feature.fromJson(e)).toList()
          : [],
    );
  }
}

class ActiveSubscriptionStudent {
  final String id;
  final String studentName;
  final String studentClass;
  final String? section;

  ActiveSubscriptionStudent({
    required this.id,
    required this.studentName,
    required this.studentClass,
    this.section,
  });

  factory ActiveSubscriptionStudent.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionStudent(
      id: json['_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['class'] ?? '',
      section: json['section'],
    );
  }
}
