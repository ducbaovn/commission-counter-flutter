import 'package:shared_preferences/shared_preferences.dart';
import 'package:casino/localization/application.dart';
import 'package:uuid/uuid.dart';

class SharedPreferencesRepository {
  String _TOKEN_KEY = "TOKEN_KEY";
  String _LANG_KEY = "LANG_KEY";
  String _DEVICE_TOKEN = "_DEVICE_TOKEN";
  String _DEVICE_ID = "_DEVICE_ID";
  String _IS_FIRST_TIME = "_IS_FIRST_TIME";

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

  Future<void> clearUserInfo() async {
    Future.wait([
      setToken(null),
      setDeviceToken(null),
    ]);
  }
}
