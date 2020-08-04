import 'package:casino/base/base_viewmodel.dart';
import 'package:casino/base/di/locator.dart';
import 'package:casino/datasource/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreenViewModel extends BaseViewModel {
  UserRepo _userRepo = locator<UserRepo>();

  Future<FirebaseUser> getUser() async {
    return await _userRepo.getCurrentUser();
  }
}
