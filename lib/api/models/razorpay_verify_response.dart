class RazorpayVerifyResponse {
  final bool success;
  final RazorpayPayment? data;
  final String? message;
  final String? error;

  RazorpayVerifyResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory RazorpayVerifyResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayVerifyResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? RazorpayPayment.fromJson(json['data'])
          : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class RazorpayPayment {
  final String id;
  final String entity;
  final int amount;
  final String currency;
  final String status;
  final String orderId;
  final bool international;
  final String method;
  final int amountRefunded;
  final bool captured;
  final String? description;
  final String? vpa;
  final String? email;
  final String? contact;
  final Map<String, dynamic>? notes;
  final int? fee;
  final int? tax;
  final int createdAt;

  RazorpayPayment({
    required this.id,
    required this.entity,
    required this.amount,
    required this.currency,
    required this.status,
    required this.orderId,
    required this.international,
    required this.method,
    required this.amountRefunded,
    required this.captured,
    this.description,
    this.vpa,
    this.email,
    this.contact,
    this.notes,
    this.fee,
    this.tax,
    required this.createdAt,
  });

  factory RazorpayPayment.fromJson(Map<String, dynamic> json) {
    return RazorpayPayment(
      id: json['id'] ?? '',
      entity: json['entity'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'INR',
      status: json['status'] ?? '',
      orderId: json['order_id'] ?? '',
      international: json['international'] ?? false,
      method: json['method'] ?? '',
      amountRefunded: json['amount_refunded'] ?? 0,
      captured: json['captured'] ?? false,
      description: json['description'],
      vpa: json['vpa'],
      email: json['email'],
      contact: json['contact'],
      notes: json['notes'],
      fee: json['fee'],
      tax: json['tax'],
      createdAt: json['created_at'] ?? 0,
    );
  }
}
