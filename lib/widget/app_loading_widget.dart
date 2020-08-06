import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:commission_counter/resources/app_color.dart';

class AppLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SpinKitThreeBounce(
          color: AppColor.mainColor,
          size: 30,
        ),
      ),
    );
  }
}
