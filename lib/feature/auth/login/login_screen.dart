import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/feature/auth/auth_viewmodel.dart';
import 'package:commission_counter/feature/auth/base_auth_screen.dart';
import 'package:commission_counter/feature/counter/counter_screen.dart';
import 'package:commission_counter/feature/report/report_screen.dart';
import 'package:commission_counter/localization/application.dart';
import 'package:commission_counter/main.route.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_drawable.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/user_role.dart';
import 'package:commission_counter/widget/keyboard_dismisser_widget.dart';
import 'package:commission_counter/widget/login_form_widget.dart';
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
    Navigator.of(context).pushNamedAndRemoveUntil(
        ROUTE_LOGIN_SCREEN, (Route<dynamic> route) => false);
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

  void _login(String username, String password) async {
    showLoadingDialog();

    APIResponse<User> res = await authViewModel.login(username, password);

    hideLoadingDialog();

    if (res.isSuccess) {
      sessionViewModel.setUser(res.data);

      switch (res.data.userRoleType) {
        case UserRole.ADMIN:
        case UserRole.AGENT:
        case UserRole.CUSTOMER:
          ReportScreen.startAndRemove(context);
          break;

        case UserRole.STORE_OWNER:
          CounterScreen.startAndRemove(context);
          break;
      }
    } else {
      showErrorDialog(content: res.message);
    }
  }
}
