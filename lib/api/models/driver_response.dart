class DriverListResponse {
  final bool success;
  final List<Driver> data;
  final String? message;
  final String? error;

  DriverListResponse({
    required this.success,
    required this.data,
    this.message,
    this.error,
  });

  factory DriverListResponse.fromJson(Map<String, dynamic> json) {
    return DriverListResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Driver.fromJson(e)).toList()
          : [],
      message: json['message'],
      error: json['error'],
    );
  }
}

class Driver {
  final String? id;
  final String? userId;
  final String? driverUniqueId;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? vehicleType;
  final String? vehicleNumber;
  final int? vehicleCapacity;
  final int? currentStudentCount;
  final String? approvalStatus;
  final bool isAvailable;
  final double? rating;
  final int? totalTrips;
  final String? createdAt;
  final String? updatedAt;
  final String? approvedAt;
  final String? approvedBy;
  final String? rejectionReason;

  Driver({
    this.id,
    this.userId,
    this.driverUniqueId,
    this.name,
    this.email,
    this.photoUrl,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleCapacity,
    this.currentStudentCount,
    this.approvalStatus,
    this.isAvailable = true,
    this.rating,
    this.totalTrips,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.approvedBy,
    this.rejectionReason,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      userId: json['user_id'],
      driverUniqueId: json['driver_unique_id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photo_url'],
      vehicleType: json['vehicle_type'],
      vehicleNumber: json['vehicle_number'],
      vehicleCapacity: json['vehicle_capacity'],
      currentStudentCount: json['current_student_count'],
      approvalStatus: json['approval_status'],
      isAvailable: json['is_available'] ?? true,
      rating: json['rating']?.toDouble(),
      totalTrips: json['total_trips'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      approvedAt: json['approved_at'],
      approvedBy: json['approved_by'],
      rejectionReason: json['rejection_reason'],
    );
  }
}
