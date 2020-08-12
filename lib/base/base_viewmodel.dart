import 'package:flutter/widgets.dart';
import 'package:commission_counter/logger/app_logger.dart';
import 'package:commission_counter/type/view_state.dart';

import 'api_response.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;
  String _errorMsg;

  ViewState get viewState => _viewState;

  String get errorMsg => _errorMsg;

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
}
