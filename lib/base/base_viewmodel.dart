import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/auth_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:commission_counter/type/view_state.dart';

import 'api_response.dart';

class BaseViewModel extends ChangeNotifier {
  AuthRepo _authRepo = locator<AuthRepo>();
  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  ViewState _viewState = ViewState.Idle;
  String _errorMsg;

  ViewState get viewState => _viewState;

  String get errorMsg => _errorMsg;

  String passwordHashing;

  void setViewState(ViewState newState) {
    _viewState = newState;
    notifyListeners();
  }

  void setErrorMsg(String errorMsg) {
    AppLogger.e(errorMsg);
    _errorMsg = errorMsg;
  }

  void startLoading() {
    setViewState(ViewState.Loading);
  }

  void startRefreshing() {
    setViewState(ViewState.Refreshing);
  }

  void stopLoading() {
    setViewState(ViewState.Loaded);
  }

  void notifyError() {
    setViewState(ViewState.Error);
  }

  void handleAPIResult(APIResponse response) {
    if (response.isSuccess) {
      stopLoading();
    } else {
      setErrorMsg(response.message);
      notifyError();
    }
  }

  Future<void> getPasswordHashing() async {
    passwordHashing = await _sharedPreferencesRepo.getPassword();
    notifyListeners();
  }

  Future<void> logOut() async {
    return await _authRepo.logOut();
  }
}
