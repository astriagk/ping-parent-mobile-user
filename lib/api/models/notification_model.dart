class NotificationModel {
  final String id;
  final String? title;
  final String? message;
  final String? notificationType;
  final bool isRead;
  final DateTime? createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    this.title,
    this.message,
    this.notificationType,
    this.isRead = false,
    this.createdAt,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'],
      message: json['message'],
      notificationType: json['notification_type'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      data: json['data'] is Map<String, dynamic> ? json['data'] : null,
    );
  }
}
