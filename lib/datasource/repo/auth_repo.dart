import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_repo.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/schema/request/login_request.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:dio/dio.dart';

class AuthRepo extends BaseRepository {
  SharedPreferencesRepository _sharedPreferencesRepository =
      locator<SharedPreferencesRepository>();

  Future<APIResponse<User>> login(LoginRequest loginRequest) async {
    try {
      User res = await apiClient.authService.login(loginRequest);

      ///Save token and password to local.
      _sharedPreferencesRepository.setToken(res.token);
      _sharedPreferencesRepository.setPassword(loginRequest.password);

      return APIResponse<User>(data: res);
    } catch (error) {
      if (error is DioError && error.response != null) {
        return APIResponse(
            isSuccess: false, message: error.response.data['message']);
      }

      return APIResponse(isSuccess: false, message: error.message);
    }
  }

  Future<APIResponse> resetPasswordViaEmail(String email) async {
    //return await apiClient.authService.resetPasswordViaEmail(email);
  }

  Future<void> logOut() async {
    return await _sharedPreferencesRepository.clearUserInfo();
  }
}
