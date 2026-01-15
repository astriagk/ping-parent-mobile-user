class SchoolListResponse {
  final bool success;
  final List<School> data;
  final String message;

  SchoolListResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SchoolListResponse.fromJson(Map<String, dynamic> json) {
    return SchoolListResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => School.fromJson(e)).toList()
          : [],
      message: json['message'] ?? '',
    );
  }
}

class School {
  final String id;
  final String schoolId;
  final String schoolName;
  final String address;
  final String state;
  final String city;
  final double latitude;
  final double longitude;
  final String contactNumber;
  final String email;
  final String createdAt;
  final String updatedAt;

  School({
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.address,
    required this.state,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['_id'] ?? '',
      schoolId: json['school_id'] ?? '',
      schoolName: json['school_name'] ?? '',
      address: json['address'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String get fullAddress {
    List<String> parts = [];
    if (address.isNotEmpty) {
      parts.add(address);
    }
    if (city.isNotEmpty) {
      parts.add(city);
    }
    if (state.isNotEmpty) {
      parts.add(state);
    }
    return parts.join(', ');
  }
}
