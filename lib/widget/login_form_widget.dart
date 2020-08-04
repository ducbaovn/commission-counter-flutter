import 'package:casino/feature/auth/reset_password/reset_password_screen.dart';
import 'package:casino/resources/app_color.dart';
import 'package:casino/resources/app_dimen.dart';
import 'package:casino/resources/app_font.dart';
import 'package:casino/resources/app_lang.dart';
import 'package:casino/util/ui_util.dart';
import 'package:casino/util/validate_util.dart';
import 'package:casino/widget/app_textfield_widget.dart';
import 'package:flutter/material.dart';

import 'app_button_widget.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String, String) onSubmitData;

  LoginFormWidget({this.onSubmitData});

  @override
  LoginFormWidgetState createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: Column(
          children: <Widget>[
            AppTextFieldWidget(
              textHint: UiUtil.getStringFromRes(AppLang.common_email, context),
              inputType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email),
              onSaved: (email) {
                _email = email;
              },
              validator: _validateEmail,
            ),
            SizedBox(height: AppDimen.app_margin),
            AppTextFieldWidget(
              obscureText: true,
              textHint:
                  UiUtil.getStringFromRes(AppLang.common_password, context),
              inputType: TextInputType.text,
              prefixIcon: Icon(Icons.lock),
              onSaved: (password) {
                _password = password;
              },
              validator: _validatePassword,
            ),
            SizedBox(height: 50),
            AppButtonWidget(
              label:
                  UiUtil.getStringFromRes(AppLang.common_login_button, context),
              onPressed: _validateInputs,
            ),
            InkWell(
              onTap: () {
                ResetPasswordScreen.start(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  UiUtil.getStringFromRes(
                      AppLang.common_forget_password, context),
                  style: TextStyle(
                    fontFamily: AppFont.nunito_regular,
                    fontSize: 14,
                    color: AppColor.mainColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _validateEmail(String email) {
    if (ValidateUtil.isNullOrEmpty(email)) {
      return UiUtil.getStringFromRes(AppLang.error_email_empty, context);
    }

    if (!ValidateUtil.isValidEmail(email)) {
      return UiUtil.getStringFromRes(AppLang.error_email_invalid, context);
    }
    return null;
  }

  String _validatePassword(String password) {
    if (ValidateUtil.isNullOrEmpty(password)) {
      return UiUtil.getStringFromRes(AppLang.error_password_empty, context);
    }

    return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (widget.onSubmitData != null) {
        widget.onSubmitData(_email, _password);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
