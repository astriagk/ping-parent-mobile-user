import '../enums/vehicle_type.dart';
import '../enums/trip_type.dart';

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

class DriverUser {
  final String? id;
  final String? userId;
  final String? phoneNumber;
  final String? userType;
  final bool isActive;

  DriverUser({
    this.id,
    this.userId,
    this.phoneNumber,
    this.userType,
    this.isActive = true,
  });

  factory DriverUser.fromJson(Map<String, dynamic> json) {
    return DriverUser(
      id: json['_id'],
      userId: json['user_id'],
      phoneNumber: json['phone_number'],
      userType: json['user_type'],
      isActive: json['is_active'] ?? true,
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
  final VehicleType vehicleType;
  final String? vehicleNumber;
  final int? vehicleCapacity;
  final int? currentStudentCount;
  final String? approvalStatus;
  final bool isAvailable;
  final double? rating;
  final int? totalTrips;
  final TripType? tripType;
  final String? createdAt;
  final String? updatedAt;
  final String? approvedAt;
  final String? approvedBy;
  final String? rejectionReason;
  final DriverUser? user;

  Driver({
    this.id,
    this.userId,
    this.driverUniqueId,
    this.name,
    this.email,
    this.photoUrl,
    this.vehicleType = VehicleType.auto,
    this.vehicleNumber,
    this.vehicleCapacity,
    this.currentStudentCount,
    this.approvalStatus,
    this.isAvailable = true,
    this.rating,
    this.totalTrips,
    this.tripType = TripType.pickup,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.approvedBy,
    this.rejectionReason,
    this.user,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      userId: json['user_id'],
      driverUniqueId: json['driver_unique_id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photo_url'],
      vehicleType: VehicleType.fromString(json['vehicle_type']),
      vehicleNumber: json['vehicle_number'],
      vehicleCapacity: json['vehicle_capacity'],
      currentStudentCount: json['current_student_count'],
      approvalStatus: json['approval_status'],
      isAvailable: json['is_available'] ?? true,
      rating: json['rating']?.toDouble(),
      totalTrips: json['total_trips'],
      tripType: TripType.fromString(json['trip_type']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      approvedAt: json['approved_at'],
      approvedBy: json['approved_by'],
      rejectionReason: json['rejection_reason'],
      user: json['user'] != null ? DriverUser.fromJson(json['user']) : null,
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
