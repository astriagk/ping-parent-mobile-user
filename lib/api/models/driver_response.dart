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

class DriverStudentAssignmentResponse {
  final bool success;
  final DriverStudentAssignment? data;
  final String? message;
  final String? error;

  DriverStudentAssignmentResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory DriverStudentAssignmentResponse.fromJson(Map<String, dynamic> json) {
    return DriverStudentAssignmentResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? DriverStudentAssignment.fromJson(json['data'])
          : null,
      message: json['message'],
      error: json['error'],
    );
  }
}

class DriverStudentAssignment {
  final String? id;
  final String? assignmentId;
  final String? driverId;
  final String? studentId;
  final String? driverUniqueId;
  final String? assignmentStatus;
  final String? assignedDate;
  final String? createdAt;
  final String? updatedAt;

  DriverStudentAssignment({
    this.id,
    this.assignmentId,
    this.driverId,
    this.studentId,
    this.driverUniqueId,
    this.assignmentStatus,
    this.assignedDate,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverStudentAssignment.fromJson(Map<String, dynamic> json) {
    return DriverStudentAssignment(
      id: json['_id'],
      assignmentId: json['assignment_id'],
      driverId: json['driver_id'],
      studentId: json['student_id'],
      driverUniqueId: json['driver_unique_id'],
      assignmentStatus: json['assignment_status'],
      assignedDate: json['assigned_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
