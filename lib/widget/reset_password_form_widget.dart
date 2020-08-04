import 'package:casino/resources/app_dimen.dart';
import 'package:casino/resources/app_lang.dart';
import 'package:casino/util/ui_util.dart';
import 'package:casino/util/validate_util.dart';
import 'package:casino/widget/app_textfield_widget.dart';
import 'package:flutter/material.dart';

class ResetPasswordFormWidget extends StatefulWidget {
  final Function(String) onSubmitData;

  ResetPasswordFormWidget({
    this.onSubmitData,
    Key key,
  }) : super(key: key);

  @override
  ResetPasswordFormWidgetState createState() => ResetPasswordFormWidgetState();
}

class ResetPasswordFormWidgetState extends State<ResetPasswordFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimen.app_margin),
      color: Colors.white,
      child: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: Column(
          children: <Widget>[
            AppTextFieldWidget(
              textHint: UiUtil.getStringFromRes(AppLang.common_email, context),
              inputType: TextInputType.emailAddress,
              onSaved: (email) {
                _email = email;
              },
              validator: _validateEmail,
            ),
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

  void validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (widget.onSubmitData != null) {
        widget.onSubmitData(_email);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
