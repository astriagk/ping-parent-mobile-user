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
      optimizedRouteData: (json['route_geometry'] ?? json['optimized_route_data']) != null
          ? OptimizedRouteData.fromJson(json['route_geometry'] ?? json['optimized_route_data'])
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
      studentId: json['_id'],
      studentName: json['student_name'],
      class_: json['class'],
      section: json['section'],
    );
  }
}

class RouteLeg {
  final List<List<double>> coordinates;

  RouteLeg({required this.coordinates});

  factory RouteLeg.fromJson(Map<String, dynamic> json) {
    return RouteLeg(
      coordinates: json['coordinates'] != null
          ? (json['coordinates'] as List)
              .map((e) => [(e[0] as num).toDouble(), (e[1] as num).toDouble()])
              .toList()
          : [],
    );
  }
}

class OptimizedRouteData {
  final List<Waypoint> waypoints;
  final double totalDistance;
  final int totalDuration;
  final List<List<double>> coordinates;
  final List<RouteLeg> legs;

  OptimizedRouteData({
    required this.waypoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.coordinates,
    required this.legs,
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
      legs: json['legs'] != null
          ? (json['legs'] as List).map((e) => RouteLeg.fromJson(e)).toList()
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
  final String? parentUserId;
  final String? estimatedArrivalTime;
  final double distanceFromPrevious;
  final int durationFromPrevious;
  final WaypointSchool? school;
  final List<String>? schoolIds;
  final Map<String, String>? schoolIdMap;

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
    this.parentUserId,
    this.estimatedArrivalTime,
    required this.distanceFromPrevious,
    required this.durationFromPrevious,
    this.school,
    this.schoolIds,
    this.schoolIdMap,
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
      parentUserId: json['parent_user_id'],
      estimatedArrivalTime: json['estimated_arrival_time'],
      distanceFromPrevious: (json['distance_from_previous'] ?? 0.0).toDouble(),
      durationFromPrevious: json['duration_from_previous'] ?? 0,
      school: json['school'] != null ? WaypointSchool.fromJson(json['school']) : null,
      schoolIds: json['school_ids'] != null
          ? List<String>.from(json['school_ids'])
          : null,
      schoolIdMap: json['school_id_map'] != null
          ? Map<String, String>.from(json['school_id_map'])
          : null,
    );
  }
}

class WaypointSchool {
  final String? schoolId;
  final String? schoolName;
  final String? schoolAddress;
  final String? schoolCity;
  final String? schoolState;
  final double? schoolLatitude;
  final double? schoolLongitude;
  final String? schoolContact;
  final String? schoolEmail;

  WaypointSchool({
    this.schoolId,
    this.schoolName,
    this.schoolAddress,
    this.schoolCity,
    this.schoolState,
    this.schoolLatitude,
    this.schoolLongitude,
    this.schoolContact,
    this.schoolEmail,
  });

  factory WaypointSchool.fromJson(Map<String, dynamic> json) {
    return WaypointSchool(
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      schoolAddress: json['school_address'],
      schoolCity: json['school_city'],
      schoolState: json['school_state'],
      schoolLatitude: (json['school_latitude'] as num?)?.toDouble(),
      schoolLongitude: (json['school_longitude'] as num?)?.toDouble(),
      schoolContact: json['school_contact'],
      schoolEmail: json['school_email'],
    );
  }
}
