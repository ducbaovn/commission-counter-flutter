import 'dart:convert';

import 'package:commission_counter/schema/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commission_counter/localization/application.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class SharedPreferencesRepo {
  String _TOKEN_KEY = "TOKEN_KEY";
  String _LANG_KEY = "LANG_KEY";
  String _DEVICE_TOKEN = "_DEVICE_TOKEN";
  String _DEVICE_ID = "_DEVICE_ID";
  String _IS_FIRST_TIME = "_IS_FIRST_TIME";
  String _PASSWORD = "_PASSWORD";
  String _USER = "_USER";

  Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_TOKEN_KEY, token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_TOKEN_KEY);
  }

  Future<bool> setLang(String langCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_LANG_KEY, langCode);
  }

  Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_LANG_KEY) ?? VN_CODE;
  }

  Future<bool> setDeviceToken(String deviceToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_DEVICE_TOKEN, deviceToken);
  }

  Future<String> getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_DEVICE_TOKEN);
  }

  Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String deviceId = prefs.getString(_DEVICE_ID);
    if (deviceId == null) {
      deviceId = Uuid().v1();
      await prefs.setString(_DEVICE_ID, deviceId);
    }
    return deviceId;
  }

  Future<bool> setIsFirstTimeLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_IS_FIRST_TIME, value);
  }

  Future<bool> getIsFirstTimeLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(_IS_FIRST_TIME);
  }

  Future<bool> setPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        _PASSWORD, md5.convert(utf8.encode(password)).toString());
  }

  Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PASSWORD);
  }

  Future<bool> setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_USER, jsonEncode(user.toJson()));
  }

  Future<User> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return User.fromJson(jsonDecode(prefs.getString(_USER)));
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUserInfo() async {
    Future.wait([
      setToken(null),
      setDeviceToken(null),
      setPassword(null),
    ]);
  }
}
