import 'package:commission_counter/base/base_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo extends BaseRepository {
  Future<FirebaseUser> getCurrentUser() async {
    return await apiClient.userService.getCurrentUser();
  }
}
