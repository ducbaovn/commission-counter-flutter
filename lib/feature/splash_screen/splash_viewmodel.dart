import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreenViewModel extends BaseViewModel {
  UserRepo _userRepo = locator<UserRepo>();

  Future<FirebaseUser> getFirebaseUser() async {
    return await _userRepo.getCurrentUser();
  }
}
