import 'dart:async';

import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/auth/login/login_screen.dart';
import 'package:commission_counter/feature/counter/counter_screen.dart';
import 'package:commission_counter/feature/report/report_screen.dart';
import 'package:commission_counter/feature/splash_screen/splash_viewmodel.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/type/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:route_annotation/route_annotation.dart';

@RoutePage(isInitialRoute: true)
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseScreen<SplashScreen> {
  SplashScreenViewModel splashViewModel = locator<SplashScreenViewModel>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => loadData());
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => splashViewModel,
      child: Consumer<SplashScreenViewModel>(
        builder: (context, splashViewModel, child) {
          return Scaffold(
            body: Container(
              color: AppColor.white,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: AppDimen.app_margin,
                          right: AppDimen.app_margin,
                          bottom: 100,
                        ),
                        height: 400,
                      )
                    ],
                  ),
                  Container(
                    child: SpinKitDoubleBounce(
                      color: AppColor.mainColor,
                      size: 50,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 1), onDoneLoading);
  }

  void onDoneLoading() async {
    FirebaseUser firebaseUser = await splashViewModel.getFirebaseUser();

    if (firebaseUser != null) {
      await sessionViewModel.getUser();
      switch (sessionViewModel.user.userRoleType) {
        case UserRole.ADMIN:
        case UserRole.AGENT:
        case UserRole.CUSTOMER:
          ReportScreen.startAndRemove(context);
          break;

        case UserRole.STORE_OWNER:
          CounterScreen.startAndRemove(context);
          break;
      }
    } else {
      LoginScreen.startAndRemove(context);
    }
  }
}
