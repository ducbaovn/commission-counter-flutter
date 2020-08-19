import 'package:commission_counter/feature/auth/reset_password/reset_password_screen.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/util/validate_util.dart';
import 'package:commission_counter/widget/app_textfield_widget.dart';
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
  String _username, _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: Column(
          children: <Widget>[
            AppTextFieldWidget(
              textHint:
                  UiUtil.getStringFromRes(AppLang.common_username, context),
              inputType: TextInputType.text,
              prefixIcon: Icon(Icons.person_outline),
              onSaved: (username) {
                _username = username;
              },
              validator: _validateUsername,
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
//            InkWell(
//              onTap: () {
//                ResetPasswordScreen.start(context);
//              },
//              child: Padding(
//                padding: const EdgeInsets.all(20),
//                child: Text(
//                  UiUtil.getStringFromRes(
//                      AppLang.common_forget_password, context),
//                  style: TextStyle(
//                    fontFamily: AppFont.nunito_regular,
//                    fontSize: 14,
//                    color: AppColor.mainColor,
//                  ),
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }

  String _validateUsername(String email) {
    if (ValidateUtil.isNullOrEmpty(email)) {
      return UiUtil.getStringFromRes(AppLang.error_username_empty, context);
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
        widget.onSubmitData(_username, _password);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
