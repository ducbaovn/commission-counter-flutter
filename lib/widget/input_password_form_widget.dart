import 'dart:convert';

import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/util/validate_util.dart';
import 'package:commission_counter/widget/app_textfield_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'app_button_widget.dart';

class InputPasswordFormWidget extends StatefulWidget {
  final String passwordHashing;
  final VoidCallback onSubmitData;

  InputPasswordFormWidget({
    this.onSubmitData,
    @required this.passwordHashing,
  });

  @override
  InputPasswordFormWidgetState createState() => InputPasswordFormWidgetState();
}

class InputPasswordFormWidgetState extends State<InputPasswordFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  AppDimen.app_margin,
              left: AppDimen.app_margin,
              right: AppDimen.app_margin,
              top: AppDimen.app_margin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  UiUtil.getStringFromRes(
                      AppLang.switch_screen_password, context),
                  style:
                      TextStyle(fontFamily: AppFont.nunito_bold, fontSize: 16),
                ),
                SizedBox(height: AppDimen.app_margin),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AppTextFieldWidget(
                        inputType: TextInputType.text,
                        obscureText: true,
                        validator: _validatePassword,
                        textHint: UiUtil.getStringFromRes(
                            AppLang.common_password, context),
                        onSaved: (String password) {
                          _password = password;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                AppButtonWidget(
                  label:
                      UiUtil.getStringFromRes(AppLang.common_confirm, context),
                  onPressed: () {
                    _validateInputs();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validatePassword(String password) {
    if (ValidateUtil.isNullOrEmpty(password)) {
      return UiUtil.getStringFromRes(AppLang.error_password_empty, context);
    }

    String passwordHashing = md5.convert(utf8.encode(password)).toString();
    if (passwordHashing != widget.passwordHashing) {
      return UiUtil.getStringFromRes(AppLang.error_password_not_match, context);
    }

    return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (widget.onSubmitData != null) {
        widget.onSubmitData();
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
