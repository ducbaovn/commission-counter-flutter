import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseAuthScreen<T extends StatefulWidget> extends BaseScreen<T> {
  AuthViewModel authViewModel = locator<AuthViewModel>();
}
