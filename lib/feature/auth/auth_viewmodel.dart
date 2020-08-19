import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/repo/auth_repo.dart';
import 'package:commission_counter/schema/request/login_request.dart';
import 'package:commission_counter/schema/user.dart';

class AuthViewModel extends BaseViewModel {
  AuthRepo _authRepo = locator<AuthRepo>();

  Future<APIResponse<User>> login(String username, String password) async {
    return await _authRepo.login(LoginRequest(
      username: username,
      password: password,
    ));
  }

  Future<APIResponse> resetPassword(String email) async {
    return await _authRepo.resetPasswordViaEmail(email);
  }
}
