import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/repo/user_repo.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/user_role.dart';

class UserFilterViewModel extends BaseViewModel {
  UserRepo _userRepo = locator<UserRepo>();
  List<User> users = [];

  void getUsers(String hostId, UserRole userRole) async {
    startLoading();

    APIResponse<List<User>> res = await _userRepo.getUsers(hostId, userRole);
    users = res.data;

    handleAPIResult(res);
  }
}
