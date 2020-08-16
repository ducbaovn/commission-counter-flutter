import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_refreshable_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/order_repo.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/view_state.dart';
import 'package:flutter/material.dart';

class ReportViewModel extends BaseRefreshAbleViewModel {
  OrderRepo _orderRepo = locator<OrderRepo>();
  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  DateTimeRange dateFilter;

  double totalAmount = 0;

  ViewState amountReportLoading = ViewState.Idle;

  void updateDateFiler(DateTimeRange dateTimeRange) {
    this.dateFilter = dateTimeRange;
    getReportForCustomer();
    notifyListeners();
  }

  void getReportForCustomer() async {
    amountReportLoading = ViewState.Loading;

    User user = await _sharedPreferencesRepo.getUser();

    APIResponse<double> res = await _orderRepo.getReport(
      customerId: user.username,
      startTime: dateFilter?.start,
      endTime: dateFilter?.end,
    );

    totalAmount = res.data;

    amountReportLoading = ViewState.Loaded;

    notifyListeners();
  }

  void resetDateFilter() {
    dateFilter = null;
    getReportForCustomer();
    notifyListeners();
  }
}
