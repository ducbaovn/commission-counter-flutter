import 'dart:io';

import 'package:casino/base/api_response.dart';
import 'package:casino/base/base_viewmodel.dart';
import 'package:casino/base/di/locator.dart';
import 'package:casino/datasource/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends BaseViewModel {
  AuthRepo _authRepo = locator<AuthRepo>();

  Future<APIResponse<FirebaseUser>> login(String email, String password) async {
    return await _authRepo.login(email, password);
  }

  Future<APIResponse> resetPassword(String email) async {
    return await _authRepo.resetPasswordViaEmail(email);
  }
}
