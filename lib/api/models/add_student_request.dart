class AddStudentRequest {
  final String schoolId;
  final String studentName;
  final String? studentClass;
  final String? section;
  final String? rollNumber;
  final String? photoUrl;
  final String? dateOfBirth;
  final String? gender;
  final String pickupAddressId;
  final String? emergencyContact;
  final String? medicalInfo;

  AddStudentRequest({
    required this.schoolId,
    required this.studentName,
    this.studentClass,
    this.section,
    this.rollNumber,
    this.photoUrl,
    this.dateOfBirth,
    this.gender,
    required this.pickupAddressId,
    this.emergencyContact,
    this.medicalInfo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'school_id': schoolId,
      'student_name': studentName,
      'pickup_address_id': pickupAddressId,
    };

    // Add optional fields only if they are not null and not empty
    if (studentClass != null && studentClass!.isNotEmpty) {
      data['class'] = studentClass;
    }
    if (section != null && section!.isNotEmpty) {
      data['section'] = section;
    }
    if (rollNumber != null && rollNumber!.isNotEmpty) {
      data['roll_number'] = rollNumber;
    }
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      data['photo_url'] = photoUrl;
    }
    if (dateOfBirth != null && dateOfBirth!.isNotEmpty) {
      data['date_of_birth'] = dateOfBirth;
    }
    if (gender != null && gender!.isNotEmpty) {
      data['gender'] = gender;
    }
    if (emergencyContact != null && emergencyContact!.isNotEmpty) {
      data['emergency_contact'] = emergencyContact;
    }
    if (medicalInfo != null && medicalInfo!.isNotEmpty) {
      data['medical_info'] = medicalInfo;
    }

    return data;
  }
}
