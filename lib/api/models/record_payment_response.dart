class RecordPaymentResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;
  final List<dynamic>? errors;

  RecordPaymentResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory RecordPaymentResponse.fromJson(Map<String, dynamic> json) {
    return RecordPaymentResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'],
      errors: json['errors'],
    );
  }
}
