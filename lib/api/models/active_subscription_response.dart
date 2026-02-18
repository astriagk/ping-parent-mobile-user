class ActiveSubscriptionResponse {
  final bool success;
  final ActiveSubscriptionData? data;
  final String message;

  ActiveSubscriptionResponse({
    required this.success,
    this.data,
    required this.message,
  });

  factory ActiveSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ActiveSubscriptionData.fromJson(json['data'])
          : null,
      message: json['message'] ?? '',
    );
  }
}

class ActiveSubscriptionData {
  final String subscriptionStatus;

  ActiveSubscriptionData({required this.subscriptionStatus});

  factory ActiveSubscriptionData.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionData(
      subscriptionStatus: json['subscription_status'] ?? '',
    );
  }

  bool get isActive => subscriptionStatus == 'active';
}
