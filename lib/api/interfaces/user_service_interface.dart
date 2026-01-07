import '../models/user_model.dart';

abstract class UserServiceInterface {
  Future<UserModel> fetchUser();
}
