class ProfileResponse {
  final bool success;
  final ProfileData? data;
  final String message;

  ProfileResponse({required this.success, this.data, required this.message});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class ProfileData {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String createdAt;
  final String updatedAt;
  final UserInfo user;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user.toJson(),
    };
  }
}

class UserInfo {
  final String phoneNumber;
  final String userType;
  final bool isActive;

  UserInfo({
    required this.phoneNumber,
    required this.userType,
    required this.isActive,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      phoneNumber: json['phone_number'] ?? '',
      userType: json['user_type'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'user_type': userType,
      'is_active': isActive,
    };
  }
}
