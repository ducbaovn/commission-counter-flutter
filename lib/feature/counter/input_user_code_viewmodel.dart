import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/repo/user_repo.dart';
import 'package:commission_counter/schema/user.dart';

class InputUserCodeViewModel extends BaseViewModel {
  UserRepo _userRepo = locator<UserRepo>();
  User user;

  Future<APIResponse<User>> checkUserInfo(String userName) async {
    startLoading();

    APIResponse<User> res = await _userRepo.getUserData(userName);

    user = res.data;

    handleAPIResult(res);

    return res;
  }
}
