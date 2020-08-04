import 'package:casino/resources/app_color.dart';
import 'package:casino/resources/app_dimen.dart';
import 'package:casino/resources/app_font.dart';
import 'package:casino/resources/app_lang.dart';
import 'package:casino/util/ui_util.dart';
import 'package:casino/widget/dialog/base_dialog_widget.dart';
import 'package:flutter/material.dart';

class ConfirmDialogWidget extends BaseDialogWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ConfirmDialogWidget({
    this.title,
    @required this.content,
    this.onConfirm,
    this.onCancel,
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
                Icons.help,
                color: AppColor.confirmColor,
              ),
              SizedBox(width: 8),
              Text(
                title ??
                    UiUtil.getStringFromRes(
                        AppLang.common_confirm_title, context),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppFont.nunito_extra_bold,
                  color: AppColor.confirmColor,
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
                width: 80,
                child: FlatButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCancel != null) {
                      onCancel();
                    }
                  },
                  child: Text(
                    UiUtil.getStringFromRes(
                        AppLang.common_cancel_button, context),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppFont.nunito_bold,
                      color: AppColor.grayButtonColor,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: FlatButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) {
                      onConfirm();
                    }
                  },
                  child: Text(
                    UiUtil.getStringFromRes(
                        AppLang.common_confirm_button, context),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppFont.nunito_bold,
                      color: AppColor.confirmColor,
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
