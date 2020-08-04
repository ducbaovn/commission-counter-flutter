import 'package:casino/resources/app_font.dart';
import 'package:flutter/material.dart';
import 'package:casino/resources/app_color.dart';

class AppButtonWidget extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  AppButtonWidget({
    @required this.label,
    @required this.onPressed,
  });

  @override
  _AppButtonWidgetState createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        padding: EdgeInsets.all(12),
        child: Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            color: AppColor.white,
            fontSize: 14,
            fontFamily: AppFont.nunito_bold,
          ),
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}

class AppOutlineButtonWidget extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  AppOutlineButtonWidget({
    @required this.label,
    @required this.onPressed,
  });

  @override
  _AppOutlineButtonWidget createState() => _AppOutlineButtonWidget();
}

class _AppOutlineButtonWidget extends State<AppOutlineButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlineButton(
        padding: EdgeInsets.all(12),
        child: Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            color: AppColor.mainColor,
            fontSize: 14,
            fontFamily: AppFont.nunito_bold,
          ),
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}
