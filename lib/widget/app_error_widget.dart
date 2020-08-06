
import 'package:flutter/material.dart';
import 'package:commission_counter/localization/app_translations.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_drawable.dart';
import 'package:commission_counter/resources/app_lang.dart';

class AppErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  AppErrorWidget({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
           image: AssetImage(AppDrawable.base_asset),
            width: 250,
            height: 200,
          ),
          SizedBox(
            height: AppDimen.app_margin,
          ),
          Text(
            AppTranslations.of(context).text(AppLang.common_error),
          ),
          SizedBox(
            height: AppDimen.app_margin,
          ),
          SizedBox(
            width: 150,
            child: OutlineButton(
              child: Text(
                AppTranslations.of(context).text(AppLang.common_re_try),
              ),
              onPressed: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}
