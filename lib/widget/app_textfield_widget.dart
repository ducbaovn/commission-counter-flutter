import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';

class AppTextFieldWidget extends StatefulWidget {
  final String textHint;
  final String initialValue;
  final TextInputType inputType;
  final bool readOnly;
  final Widget suffixIcon;
  final Widget prefix;
  final Widget prefixIcon;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final GestureTapCallback onTap;
  final TextEditingController controller;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;

  AppTextFieldWidget({
    this.textHint,
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.suffixIcon,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.onTap,
    this.controller,
    this.obscureText = false,
    this.prefix,
    this.prefixIcon,
    this.inputFormatters,
  });

  @override
  _AppTextFieldWidgetState createState() => _AppTextFieldWidgetState();
}

class _AppTextFieldWidgetState extends State<AppTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onSaved: widget.onSaved,
        readOnly: widget.readOnly,
        keyboardType: widget.inputType,
        validator: widget.validator,
        initialValue: widget.initialValue,
        onTap: widget.onTap,
        style: TextStyle(color: AppColor.searchBoxTextColor),
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          prefix: widget.prefix,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintText: widget.textHint,
          filled: true,
          fillColor: AppColor.inputGrayColor,
          hintStyle: TextStyle(
            color: AppColor.searchBoxTextColor,
            fontFamily: AppFont.nunito_regular,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: AppColor.inputGrayColor,
              )),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.inputGrayColor, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: AppColor.inputGrayColor,
            ),
          ),
        ),
      ),
    );
  }
}
