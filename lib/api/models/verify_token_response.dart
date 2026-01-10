class VerifyTokenResponse {
  final bool success;
  final String? userId;
  final String? role;
  final bool? tokenValid;
  final String? error;

  VerifyTokenResponse({
    required this.success,
    this.userId,
    this.role,
    this.tokenValid,
    this.error,
  });

  factory VerifyTokenResponse.fromJson(Map<String, dynamic> json) {
    return VerifyTokenResponse(
      success: json['success'] ?? false,
      userId: json['data'] != null ? json['data']['userId'] : null,
      role: json['data'] != null ? json['data']['role'] : null,
      tokenValid: json['data'] != null ? json['data']['tokenValid'] : null,
      error: json['error'],
    );
  }
}
