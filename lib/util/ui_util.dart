import 'package:casino/localization/app_translations.dart';
import 'package:casino/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtil {
  static Widget buildLine() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: AppColor.searchBoxTextColor,
    );
  }

  static String getStringFromRes(String key, BuildContext context) =>
      AppTranslations.of(context).text(key);

  static void showToastMsg(String msg, {bool isErrorMsg = false}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: isErrorMsg ? Colors.red : AppColor.searchBoxTextColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
