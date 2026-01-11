import '../api_client.dart';
import '../endpoints.dart';
import '../models/user_model.dart';
import '../models/profile_response.dart';
import '../interfaces/user_service_interface.dart';
import 'dart:convert';

class UserService implements UserServiceInterface {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  @override
  Future<UserModel> fetchUser() async {
    final response = await _apiClient.get(Endpoints.getUser);
    if (response.statusCode == 200) {
      return UserModel.fromJson(
        // ignore: unnecessary_cast
        (response.body as Map<String, dynamic>),
      );
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Future<ProfileResponse> getParentProfile() async {
    final response = await _apiClient.get(Endpoints.parentProfile);
    if (response.statusCode == 200) {
      return ProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = ProfileResponse.fromJson(jsonDecode(response.body));
      throw Exception(errorResponse.data ?? 'Failed to load profile');
    }
  }

  @override
  Future<ProfileResponse> updateParentProfile({
    String? name,
    String? email,
    String? photoUrl,
  }) async {
    final Map<String, dynamic> payload = {};

    if (name != null) payload['name'] = name;
    if (email != null) payload['email'] = email;
    if (photoUrl != null) payload['photo_url'] = photoUrl;

    final response = await _apiClient.put(
      Endpoints.parentProfile,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return ProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Failed to update profile');
    }
  }
}
