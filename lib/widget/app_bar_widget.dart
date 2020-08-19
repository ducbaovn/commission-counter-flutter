import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends AppBar {
  final String mTitle;
  final bool hideBackButton;
  final List<Widget> mActions;
  final PreferredSizeWidget bottomWidget;

  AppBarWidget({
    Key key,
    this.mTitle,
    this.hideBackButton = false,
    this.mActions,
    this.bottomWidget,
  }) : super(key: key);

  @override
  bool get automaticallyImplyLeading => !hideBackButton;

  @override
  bool get centerTitle => true;

  @override
  Color get backgroundColor => AppColor.mainColor;

  @override
  List<Widget> get actions => mActions;

  @override
  IconThemeData get iconTheme => IconThemeData(
        color: AppColor.white,
        size: 18,
      );

  @override
  Widget get title => Text(
        mTitle,
        style: TextStyle(
          color: AppColor.white,
          fontSize: 18,
          fontFamily: AppFont.nunito_bold,
        ),
      );

  @override
  PreferredSizeWidget get bottom => bottomWidget;
}
