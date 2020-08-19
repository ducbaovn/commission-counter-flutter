import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/widget/dialog/base_dialog_widget.dart';
import 'package:flutter/material.dart';

class SuccessDialogWidget extends BaseDialogWidget {
  final String title;
  final String content;
  final VoidCallback onClose;

  SuccessDialogWidget({
    this.title,
    @required this.content,
    this.onClose,
  }) : assert(content != null);

  @override
  Widget buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimen.app_margin),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(0.0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        // To make the card compact
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: AppColor.successColor,
              ),
              SizedBox(width: 8),
              Text(
                title ??
                    UiUtil.getStringFromRes(
                        AppLang.common_success_title, context),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppFont.nunito_extra_bold,
                  color: AppColor.successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimen.app_margin),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppFont.nunito_semi_bold,
            ),
          ),
          SizedBox(height: AppDimen.app_margin),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 100,
                child: FlatButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onClose != null) {
                      onClose();
                    }
                  },
                  child: Text(
                    UiUtil.getStringFromRes(
                        AppLang.common_close_button, context),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppFont.nunito_bold,
                      color: AppColor.successColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
