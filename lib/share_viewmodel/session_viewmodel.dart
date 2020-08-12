import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/schema/user.dart';

class SessionViewModel extends BaseViewModel {
  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  User user;

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> getUser() async {
    user = await _sharedPreferencesRepo.getUser();
    notifyListeners();
  }
}
