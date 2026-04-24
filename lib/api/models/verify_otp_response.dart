class VerifyOtpResponse {
  final bool success;
  final String? message;
  final String? error;
  final String? token;
  final String? refreshToken;
  final bool? isNewUser;
  final Map<String, dynamic>? user;

  VerifyOtpResponse({
    required this.success,
    this.message,
    this.error,
    this.token,
    this.refreshToken,
    this.isNewUser,
    this.user,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'],
      error: json['error'],
      isNewUser: json['isNewUser'],
      token: data != null ? data['accessToken'] : null,
      refreshToken: data != null ? data['refreshToken'] : null,
      user: data != null ? data['user'] : null,
    );
  }
}
