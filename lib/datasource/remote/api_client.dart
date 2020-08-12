import 'dart:io';

import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/remote/order_service.dart';
import 'package:commission_counter/datasource/remote/store_service.dart';
import 'package:commission_counter/datasource/remote/user_service.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:dio/dio.dart';
import 'auth_service.dart';

class ApiClient {
  final dio = Dio();

  SharedPreferencesRepo _sharedPreferencesRepository =
      locator<SharedPreferencesRepo>();

  //Service
  AuthService authService;
  UserService userService;
  OrderService orderService;
  StoreService storeService;

  ApiClient() {
    _setUpDio();
    _setUpService();
  }

  void _setUpDio() {
    dio.options.baseUrl =
        'https://asia-east2-commission-counter.cloudfunctions.net';
    dio.options.connectTimeout = 20000;
    dio.options.receiveTimeout = 20000;
    dio.options.contentType = 'application/json';

    dio.interceptors.addAll([
      /// Log
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
      ),

      /// Error
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
        String token = await _sharedPreferencesRepository.getToken();

        AppLogger.d(token);

        options.headers['Authorization'] = 'Bearer $token';
        options.headers['Platform'] = Platform.isIOS ? 'iOS' : 'Android';
        options.headers['App-Version'] = '1.0';

        return options;
      }, onResponse: (Response response) {
        return response;
      }, onError: (DioError e) async {
        bool isLogin = await _sharedPreferencesRepository.getToken() != null;

//        if (e.response.statusCode == 401 && isLogin) {
//          _sharedPreferencesRepository.clearUserInfo();
////          UiUtil.showToastMsg(
////              UiUtil.getStringFromRes(
////                  AppLang.error_token_expired, application.getCurrentContext()),
////              isErrorMsg: true);
////          LoginScreen.startByNavigatorKey();
//        }
        return e; //continue
      }),
    ]);
  }

  void _setUpService() {
    authService = AuthService(dio, baseUrl: dio.options.baseUrl);
    userService = UserService();
    orderService = OrderService();
    storeService = StoreService();
  }
}
