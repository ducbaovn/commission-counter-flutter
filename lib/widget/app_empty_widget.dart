import 'package:flutter/material.dart';
import 'package:casino/localization/app_translations.dart';
import 'package:casino/resources/app_dimen.dart';
import 'package:casino/resources/app_drawable.dart';
import 'package:casino/resources/app_lang.dart';

class AppEmptyWidget extends StatelessWidget {
  final String emptyMessage;
  final VoidCallback onRefresh;
  final String retryLabel;

  AppEmptyWidget({
    this.emptyMessage,
    this.onRefresh,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage(AppDrawable.base_asset),
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: AppDimen.app_margin,
          ),
          Text(
            emptyMessage,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: AppDimen.app_margin,
          ),
          SizedBox(
            width: 150,
            child: OutlineButton(
              child: Text(
                retryLabel ??
                    AppTranslations.of(context).text(AppLang.common_re_try),
              ),
              onPressed: onRefresh,
            ),
          ),
        ],
      ),
    );
  }
}
