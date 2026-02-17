class SubscriptionPlansResponse {
  final bool success;
  final List<SubscriptionPlan> data;
  final String? message;
  final String? error;

  SubscriptionPlansResponse({
    required this.success,
    required this.data,
    this.message,
    this.error,
  });

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => SubscriptionPlan.fromJson(e))
              .toList()
          : [],
      message: json['message'],
      error: json['error'],
    );
  }
}

class SubscriptionPlan {
  final String id;
  final String planName;
  final String planType;
  final int price;
  final String currency;
  final String pricingModel;
  final int? perKidPrice;
  final KidsInfo kids;
  final List<Feature> features;
  final bool isActive;
  final bool isRecommended;
  final String planId;
  final String? createdAt;
  final String? updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.planName,
    required this.planType,
    required this.price,
    required this.currency,
    required this.pricingModel,
    this.perKidPrice,
    required this.kids,
    required this.features,
    required this.isActive,
    required this.isRecommended,
    required this.planId,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['_id'] ?? '',
      planName: json['plan_name'] ?? '',
      planType: json['plan_type'] ?? '',
      price: json['price'] ?? 0,
      currency: json['currency'] ?? 'INR',
      pricingModel: json['pricing_model'] ?? 'flat',
      perKidPrice: json['per_kid_price'],
      kids: KidsInfo.fromJson(json['kids'] ?? {}),
      features: json['features'] != null
          ? (json['features'] as List).map((e) => Feature.fromJson(e)).toList()
          : [],
      isActive: json['is_active'] ?? true,
      isRecommended: json['is_recommended'] ?? false,
      planId: json['plan_id'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Convert to Map for widget usage
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'plan_name': planName,
      'plan_type': planType,
      'price': price,
      'currency': currency,
      'pricing_model': pricingModel,
      'per_kid_price': perKidPrice,
      'kids': {'min': kids.min, 'max': kids.max},
      'features': features
          .map((f) => {
                'key': f.key,
                'label': f.label,
                'enabled': f.enabled,
              })
          .toList(),
      'is_active': isActive,
      'is_recommended': isRecommended,
      'plan_id': planId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class KidsInfo {
  final int min;
  final int max;

  KidsInfo({
    required this.min,
    required this.max,
  });

  factory KidsInfo.fromJson(Map<String, dynamic> json) {
    return KidsInfo(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
    );
  }
}

class Feature {
  final String key;
  final String label;
  final bool enabled;

  Feature({
    required this.key,
    required this.label,
    required this.enabled,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      enabled: json['enabled'] ?? false,
    );
  }
}
