import 'dart:io';

import 'package:casino/base/di/locator.dart';
import 'package:casino/datasource/local/shared_preferences_repo.dart';
import 'package:casino/datasource/remote/user_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'auth_service.dart';

class ApiClient {
  SharedPreferencesRepository _sharedPreferencesRepository =
      locator<SharedPreferencesRepository>();

  //Service
  AuthService authService;
  UserService userService;

  ApiClient() {
    _setUpService();
  }

  void _setUpService() {
    authService = AuthService();
    userService = UserService();
  }
}
