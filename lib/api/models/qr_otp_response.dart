import '../enums/trip_type.dart';

class QrOtpResponse {
  final bool success;
  final QrOtpData? data;
  final String? message;
  final String? error;

  QrOtpResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory QrOtpResponse.fromJson(Map<String, dynamic> json) {
    return QrOtpResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? QrOtpData.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class QrOtpData {
  final String? id;
  final String? qrOtpId;
  final String? parentId;
  final List<String>? studentIds;
  final String? tripId;
  final String? qrCode;
  final String? otpCode;
  final TripType tripType;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final bool isUsed;
  final DateTime? createdAt;

  QrOtpData({
    this.id,
    this.qrOtpId,
    this.parentId,
    this.studentIds,
    this.tripId,
    this.qrCode,
    this.otpCode,
    required this.tripType,
    this.validFrom,
    this.validUntil,
    required this.isUsed,
    this.createdAt,
  });

  factory QrOtpData.fromJson(Map<String, dynamic> json) {
    return QrOtpData(
      id: json['_id'],
      qrOtpId: json['qr_otp_id'],
      parentId: json['parent_id'],
      studentIds: json['student_ids'] != null
          ? List<String>.from(json['student_ids'])
          : null,
      tripId: json['trip_id'],
      qrCode: json['qr_code'],
      otpCode: json['otp_code'],
      tripType: TripType.fromString(json['trip_type']),
      validFrom: json['valid_from'] != null
          ? DateTime.parse(json['valid_from'])
          : null,
      validUntil: json['valid_until'] != null
          ? DateTime.parse(json['valid_until'])
          : null,
      isUsed: json['is_used'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
