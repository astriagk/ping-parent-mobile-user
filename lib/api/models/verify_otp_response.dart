class VerifyOtpResponse {
  final bool success;
  final String? message;
  final String? error;
  final String? token;
  final Map<String, dynamic>? user;

  VerifyOtpResponse({
    required this.success,
    this.message,
    this.error,
    this.token,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
      error: json['error'],
      token: json['data'] != null ? json['data']['token'] : null,
      user: json['data'] != null ? json['data']['user'] : null,
    );
  }
}
