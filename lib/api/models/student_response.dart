class StudentListResponse {
  final bool success;
  final List<Student> data;
  final String? message;
  final String? error;

  StudentListResponse({
    required this.success,
    required this.data,
    this.message,
    this.error,
  });

  factory StudentListResponse.fromJson(Map<String, dynamic> json) {
    return StudentListResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Student.fromJson(e)).toList()
          : [],
      message: json['message'],
      error: json['error'],
    );
  }
}

class Student {
  final String? id;
  final String? studentId;
  final String? parentId;
  final String? schoolId;
  final String? studentName;
  final String? studentClass;
  final String? section;
  final String? rollNumber;
  final String? photoUrl;
  final String? dateOfBirth;
  final String? gender;
  final String? pickupAddressId;
  final String? emergencyContact;
  final String? medicalInfo;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final School? school;
  final PickupAddress? pickupAddress;

  Student({
    this.id,
    this.studentId,
    this.parentId,
    this.schoolId,
    this.studentName,
    this.studentClass,
    this.section,
    this.rollNumber,
    this.photoUrl,
    this.dateOfBirth,
    this.gender,
    this.pickupAddressId,
    this.emergencyContact,
    this.medicalInfo,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.school,
    this.pickupAddress,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      studentId: json['student_id'],
      parentId: json['parent_id'],
      schoolId: json['school_id'],
      studentName: json['student_name'],
      studentClass: json['class'],
      section: json['section'],
      rollNumber: json['roll_number'],
      photoUrl: json['photo_url'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      pickupAddressId: json['pickup_address_id'],
      emergencyContact: json['emergency_contact'],
      medicalInfo: json['medical_info'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      pickupAddress: json['pickup_address'] != null
          ? PickupAddress.fromJson(json['pickup_address'])
          : null,
    );
  }
}

class School {
  final String? id;
  final String? schoolId;
  final String? schoolName;
  final String? address;
  final String? state;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? contactNumber;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  School({
    this.id,
    this.schoolId,
    this.schoolName,
    this.address,
    this.state,
    this.city,
    this.latitude,
    this.longitude,
    this.contactNumber,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['_id'],
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      address: json['address'],
      state: json['state'],
      city: json['city'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      contactNumber: json['contact_number'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String get fullAddress {
    List<String> parts = [];
    if (address != null && address!.isNotEmpty) {
      parts.add(address!);
    }
    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }
    if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }
    return parts.join(', ');
  }
}

class PickupAddress {
  final String? id;
  final String? parentId;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final bool isPrimary;
  final String? createdAt;
  final String? updatedAt;

  PickupAddress({
    this.id,
    this.parentId,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.isPrimary = false,
    this.createdAt,
    this.updatedAt,
  });

  factory PickupAddress.fromJson(Map<String, dynamic> json) {
    return PickupAddress(
      id: json['_id'],
      parentId: json['parent_id'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isPrimary: json['is_primary'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String get fullAddress {
    List<String> parts = [];
    if (addressLine1 != null && addressLine1!.isNotEmpty) {
      parts.add(addressLine1!);
    }
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }
    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }
    if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }
    return parts.join(', ');
  }
}
