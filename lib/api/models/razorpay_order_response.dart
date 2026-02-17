class RazorpayOrderResponse {
  final bool success;
  final RazorpayOrder? data;
  final String? message;
  final String? error;

  RazorpayOrderResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory RazorpayOrderResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? RazorpayOrder.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class RazorpayOrder {
  final int amount;
  final int amountDue;
  final int amountPaid;
  final int attempts;
  final int createdAt;
  final String currency;
  final String entity;
  final String id;
  final Map<String, dynamic>? notes;
  final String? offerId;
  final String receipt;
  final String status;

  RazorpayOrder({
    required this.amount,
    required this.amountDue,
    required this.amountPaid,
    required this.attempts,
    required this.createdAt,
    required this.currency,
    required this.entity,
    required this.id,
    this.notes,
    this.offerId,
    required this.receipt,
    required this.status,
  });

  factory RazorpayOrder.fromJson(Map<String, dynamic> json) {
    return RazorpayOrder(
      amount: json['amount'] ?? 0,
      amountDue: json['amount_due'] ?? 0,
      amountPaid: json['amount_paid'] ?? 0,
      attempts: json['attempts'] ?? 0,
      createdAt: json['created_at'] ?? 0,
      currency: json['currency'] ?? 'INR',
      entity: json['entity'] ?? '',
      id: json['id'] ?? '',
      notes: json['notes'],
      offerId: json['offer_id'],
      receipt: json['receipt'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
