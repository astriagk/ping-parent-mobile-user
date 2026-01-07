import '../enums/user_status.dart';

class UserModel {
  final String id;
  final String name;
  final UserStatus status;

  UserModel({required this.id, required this.name, required this.status});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      status: UserStatus.values
          .firstWhere((e) => e.toString() == 'UserStatus.' + json['status']),
    );
  }
}
