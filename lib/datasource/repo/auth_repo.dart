import 'package:casino/base/api_response.dart';
import 'package:casino/base/base_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo extends BaseRepository {
  Future<APIResponse<FirebaseUser>> login(String email, String password) async {
    return await apiClient.authService.login(email, password);
  }

  Future<APIResponse> resetPasswordViaEmail(String email) async {
    return await apiClient.authService.resetPasswordViaEmail(email);
  }

  Future<void> logOut() async {
    return await apiClient.authService.logOut();
  }
}
