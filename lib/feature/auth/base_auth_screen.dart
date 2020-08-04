import 'package:casino/base/base_screen.dart';
import 'package:casino/base/di/locator.dart';
import 'package:casino/feature/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseAuthScreen<T extends StatefulWidget> extends BaseScreen<T> {
  AuthViewModel authViewModel = locator<AuthViewModel>();
}
