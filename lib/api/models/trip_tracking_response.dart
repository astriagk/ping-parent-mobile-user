import '../enums/trip_status.dart';
import '../enums/trip_type.dart';
import 'driver_response.dart';

class TripTrackingResponse {
  final bool success;
  final List<Trip> data;
  final int count;
  final String? message;
  final String? error;

  TripTrackingResponse({
    required this.success,
    required this.data,
    required this.count,
    this.message,
    this.error,
  });

  factory TripTrackingResponse.fromJson(Map<String, dynamic> json) {
    return TripTrackingResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Trip.fromJson(e)).toList()
          : [],
      count: json['count'] ?? 0,
      message: json['message'],
      error: json['error'],
    );
  }
}

class Trip {
  final String? id;
  final String? tripId;
  final TripType tripType;
  final TripStatus tripStatus;
  final String? tripDate;
  final String? startTime;
  final String? driverId;
  final Driver? driver;
  final double totalDistance;
  final List<Student> students;
  final OptimizedRouteData? optimizedRouteData;
  final String? createdAt;
  final String? updatedAt;

  Trip({
    this.id,
    this.tripId,
    required this.tripType,
    required this.tripStatus,
    this.tripDate,
    this.startTime,
    this.driverId,
    this.driver,
    required this.totalDistance,
    required this.students,
    this.optimizedRouteData,
    this.createdAt,
    this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['_id'],
      tripId: json['trip_id'],
      tripType: TripType.fromString(json['trip_type']),
      tripStatus: TripStatus.fromString(json['trip_status']),
      tripDate: json['trip_date'],
      startTime: json['start_time'],
      driverId: json['driver_id'],
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      totalDistance: (json['total_distance'] ?? 0.0).toDouble(),
      students: json['students'] != null
          ? (json['students'] as List).map((e) => Student.fromJson(e)).toList()
          : [],
      optimizedRouteData: json['optimized_route_data'] != null
          ? OptimizedRouteData.fromJson(json['optimized_route_data'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Student {
  final String? studentId;
  final String? studentName;
  final String? class_;
  final String? section;

  Student({
    this.studentId,
    this.studentName,
    this.class_,
    this.section,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      studentName: json['student_name'],
      class_: json['class'],
      section: json['section'],
    );
  }
}

class OptimizedRouteData {
  final List<Waypoint> waypoints;
  final double totalDistance;
  final int totalDuration;
  final List<List<double>> coordinates;

  OptimizedRouteData({
    required this.waypoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.coordinates,
  });

  factory OptimizedRouteData.fromJson(Map<String, dynamic> json) {
    return OptimizedRouteData(
      waypoints: json['waypoints'] != null
          ? (json['waypoints'] as List)
              .map((e) => Waypoint.fromJson(e))
              .toList()
          : [],
      totalDistance: (json['total_distance'] ?? 0.0).toDouble(),
      totalDuration: json['total_duration'] ?? 0,
      coordinates: json['coordinates'] != null
          ? (json['coordinates'] as List)
              .map((e) => [(e[0] as num).toDouble(), (e[1] as num).toDouble()])
              .toList()
          : [],
    );
  }
}

class Waypoint {
  final double latitude;
  final double longitude;
  final String? address;
  final List<String>? studentIds;
  final String? studentParentId;
  final List<String>? studentNames;
  final String? studentPhotoUrl;
  final String? studentGender;
  final String? studentSection;
  final String? studentClass;
  final String? parentName;
  final String? parentEmail;
  final String? parentPhoneNumber;
  final String? estimatedArrivalTime;
  final double distanceFromPrevious;
  final int durationFromPrevious;

  Waypoint({
    required this.latitude,
    required this.longitude,
    this.address,
    this.studentIds,
    this.studentParentId,
    this.studentNames,
    this.studentPhotoUrl,
    this.studentGender,
    this.studentSection,
    this.studentClass,
    this.parentName,
    this.parentEmail,
    this.parentPhoneNumber,
    this.estimatedArrivalTime,
    required this.distanceFromPrevious,
    required this.durationFromPrevious,
  });

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
      studentIds: json['student_id'] != null
          ? List<String>.from(json['student_id'])
          : null,
      studentParentId: json['student_parent_id'],
      studentNames: json['student_names'] != null
          ? List<String>.from(json['student_names'])
          : null,
      studentPhotoUrl: json['student_photo_url'],
      studentGender: json['student_gender'],
      studentSection: json['student_section'],
      studentClass: json['student_class'],
      parentName: json['parent_name'],
      parentEmail: json['parent_email'],
      parentPhoneNumber: json['parent_phone_number'],
      estimatedArrivalTime: json['estimated_arrival_time'],
      distanceFromPrevious: (json['distance_from_previous'] ?? 0.0).toDouble(),
      durationFromPrevious: json['duration_from_previous'] ?? 0,
    );
  }
}
