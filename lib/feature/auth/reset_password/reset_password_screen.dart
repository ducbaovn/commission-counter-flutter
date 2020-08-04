import 'package:casino/base/api_response.dart';
import 'package:casino/main.route.dart';
import 'package:casino/feature/auth/auth_viewmodel.dart';
import 'package:casino/feature/auth/base_auth_screen.dart';
import 'package:casino/resources/app_dimen.dart';
import 'package:casino/resources/app_lang.dart';
import 'package:casino/util/ui_util.dart';
import 'package:casino/widget/app_bar_widget.dart';
import 'package:casino/widget/app_button_widget.dart';
import 'package:casino/widget/keyboard_dismisser_widget.dart';
import 'package:casino/widget/reset_password_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_annotation/route_annotation.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  static void start(BuildContext context) {
    Navigator.of(context).pushNamed(ROUTE_RESET_PASSWORD_SCREEN);
  }

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends BaseAuthScreen<ResetPasswordScreen> {
  GlobalKey<ResetPasswordFormWidgetState> _resetPasswordFormKey =
      GlobalKey<ResetPasswordFormWidgetState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => authViewModel,
      child: Consumer<AuthViewModel>(
        builder: (context, resetPasswordViewModel, child) {
          return KeyboardDismisserWidget(
            child: Scaffold(
              appBar: AppBarWidget(
                mTitle: UiUtil.getStringFromRes(
                    AppLang.reset_password_title, context),
              ),
              body: _buildMainView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainView() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                ResetPasswordFormWidget(
                    key: _resetPasswordFormKey,
                    onSubmitData: _sendResetPassword),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimen.app_margin),
            child: AppButtonWidget(
              label: UiUtil.getStringFromRes(
                  AppLang.reset_password_button, context),
              onPressed: () {
                _resetPasswordFormKey.currentState.validateInputs();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendResetPassword(String email) async {
    showLoadingDialog();

    APIResponse apiResponse = await authViewModel.resetPassword(email);

    hideLoadingDialog();

    if (apiResponse.isSuccess) {
      showSuccessDialog(
          content: UiUtil.getStringFromRes(
              AppLang.reset_password_success, context));
    } else {
      showErrorDialog(content: apiResponse.message);
    }
  }
}
