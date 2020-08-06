import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/repo/auth_repo.dart';

class CounterViewModel extends BaseViewModel {
  AuthRepo _authRepo = locator<AuthRepo>();

  Future<void> logOut() async {
    return await _authRepo.logOut();
  }
}
