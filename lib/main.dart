import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/splash_screen/splash_viewmodel.dart';
import 'package:commission_counter/localization/application.dart';
import 'package:commission_counter/main.route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:route_annotation/route_annotation.dart';

import 'localization/app_translations_delegate.dart';
import 'resources/app_style.dart';

// Init lib here: locator, lang ...
void main() async => {
      setUpInjector(),
      Provider.debugCheckInvalidValueType = null,
      runApp(
        App(),
      ),
    };

@Router()
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppTranslationsDelegate _newLocaleDelegate;
  Key key = UniqueKey();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _newLocaleDelegate =
        AppTranslationsDelegate(newLocale: Locale("en", "English"));
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppStyle.appTheme,
        key: key,
        navigatorKey: application.getNavigatorKey(isGenNewKey: true),
        initialRoute: ROUTE_HOME,
        onGenerateRoute: onGenerateRoute,
        localizationsDelegates: [
          _newLocaleDelegate,
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
          //provides RTL support
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en", ""),
          const Locale("vi", ""),
        ],
      ),
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}
