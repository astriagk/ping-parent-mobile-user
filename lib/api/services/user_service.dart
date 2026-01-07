import '../api_client.dart';
import '../endpoints.dart';
import '../models/user_model.dart';
import '../interfaces/user_service_interface.dart';

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
}
