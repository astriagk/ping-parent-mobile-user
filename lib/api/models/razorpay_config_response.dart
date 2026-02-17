class RazorpayConfigResponse {
  final bool success;
  final RazorpayConfig? data;
  final String? message;
  final String? error;

  RazorpayConfigResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory RazorpayConfigResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayConfigResponse(
      success: json['success'] ?? false,
      data: json['data'] != null && json['data']['config'] != null
          ? RazorpayConfig.fromJson(json['data']['config'])
          : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class RazorpayConfig {
  final bool isConfigured;
  final String keyId;

  RazorpayConfig({
    required this.isConfigured,
    required this.keyId,
  });

  factory RazorpayConfig.fromJson(Map<String, dynamic> json) {
    return RazorpayConfig(
      isConfigured: json['isConfigured'] ?? false,
      keyId: json['keyId'] ?? '',
    );
  }
}
