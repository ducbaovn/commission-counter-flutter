import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_repo.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo extends BaseRepository {
  Future<FirebaseUser> getCurrentUser() async {
    return await apiClient.userService.getCurrentUser();
  }

  Future<APIResponse<User>> getUserData(String userName) async {
    return await apiClient.userService.getUserInfo(userName);
  }
}
