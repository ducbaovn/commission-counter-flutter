import 'package:casino/base/base_viewmodel.dart';
import 'package:casino/base/di/locator.dart';
import 'package:casino/datasource/repo/auth_repo.dart';

class CounterViewModel extends BaseViewModel {
  AuthRepo _authRepo = locator<AuthRepo>();

  Future<void> logOut() async {
    return await _authRepo.logOut();
  }
}
