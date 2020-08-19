import 'package:commission_counter/localization/app_translations.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtil {
  static Widget buildLine() {
    return Container(
      width: double.infinity,
      height: 0.2,
      color: AppColor.searchBoxTextColor,
    );
  }

  static String getStringFromRes(String key, BuildContext context) =>
      AppTranslations.of(context).text(key);

  static void showToastMsg(String msg, {bool isErrorMsg = false}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isErrorMsg ? Colors.red : AppColor.searchBoxTextColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
