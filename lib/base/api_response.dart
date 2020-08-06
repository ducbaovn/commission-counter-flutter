////import 'package:dio/dio.dart';
////
////
//import 'package:dio/dio.dart';
//import 'package:commission_counter/logger/app_logger.dart';
//
class APIResponse<T> {
//  // From API
  String message;
  bool isSuccess;
  T data;

  APIResponse({
    this.message,
    this.isSuccess = true,
    this.data,
  }); //
}
