class RedeemCodeResponse {
  final bool success;
  final RedeemedSubscription? data;
  final String? message;
  final String? error;

  RedeemCodeResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory RedeemCodeResponse.fromJson(Map<String, dynamic> json) {
    return RedeemCodeResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? RedeemedSubscription.fromJson(json['data'])
          : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class RedeemedSubscription {
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
  final String subscriptionSource;
  final String? schoolSubscriptionId;
  final String createdAt;
  final String updatedAt;
  final String id;

  RedeemedSubscription({
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
    required this.subscriptionSource,
    this.schoolSubscriptionId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory RedeemedSubscription.fromJson(Map<String, dynamic> json) {
    return RedeemedSubscription(
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
      subscriptionSource: json['subscription_source'] ?? '',
      schoolSubscriptionId: json['school_subscription_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
