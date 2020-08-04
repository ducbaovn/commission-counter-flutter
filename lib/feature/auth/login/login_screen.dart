import 'package:casino/base/api_response.dart';
import 'package:casino/feature/auth/auth_viewmodel.dart';
import 'package:casino/feature/auth/base_auth_screen.dart';
import 'package:casino/feature/counter/counter_screen.dart';
import 'package:casino/localization/application.dart';
import 'package:casino/main.route.dart';
import 'package:casino/resources/app_dimen.dart';
import 'package:casino/resources/app_drawable.dart';
import 'package:casino/widget/keyboard_dismisser_widget.dart';
import 'package:casino/widget/login_form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:route_annotation/route_annotation.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  static void start(BuildContext context) {
    Navigator.of(context).pushNamed(ROUTE_LOGIN_SCREEN);
  }

  static void startAndRemove(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  static void startByNavigatorKey() {
    application.getNavigatorKey().currentState.pushNamedAndRemoveUntil(
        ROUTE_LOGIN_SCREEN, (Route<dynamic> route) => false);
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseAuthScreen<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => authViewModel,
      child: Consumer<AuthViewModel>(
        builder: (context, loginViewModel, child) {
          return KeyboardDismisserWidget(
            child: Scaffold(
              body: Container(
                padding: const EdgeInsets.all(AppDimen.app_margin),
                child: _buildMainView(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainView() {
    return ListView(
      children: <Widget>[
        SizedBox(height: AppDimen.app_margin),
        SvgPicture.asset(
          AppDrawable.icon_logo,
          width: 130,
          height: 130,
        ),
        SizedBox(height: 30),
        LoginFormWidget(
          onSubmitData: _login,
        ),
        SizedBox(height: AppDimen.app_margin),
      ],
    );
  }

  void _login(String email, String password) async {
    showLoadingDialog();

    APIResponse<FirebaseUser> res = await authViewModel.login(email, password);

    hideLoadingDialog();

    if (res.isSuccess) {
      CounterScreen.startAndRemove(context);
    } else {
      showErrorDialog(content: res.message);
    }
  }
}
