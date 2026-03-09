import 'dart:io';

// import '../models/user_model.dart';
import '../models/profile_response.dart';

abstract class UserServiceInterface {
  // Future<UserModel> fetchUser();
  Future<ProfileResponse> getParentProfile();
  Future<ProfileResponse> updateParentProfile({
    String? name,
    String? email,
    String? photoUrl,
  });

  Future<Map<String, dynamic>> uploadSharedFile({
    required File file,
    required String folderPath,
    String? oldFileUrl,
  });
}
