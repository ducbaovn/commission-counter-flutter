import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_refreshable_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/order_repo.dart';
import 'package:commission_counter/datasource/repo/user_repo.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/user_role.dart';
import 'package:commission_counter/type/view_state.dart';
import 'package:flutter/material.dart';

class ReportViewModel extends BaseRefreshAbleViewModel {
  OrderRepo _orderRepo = locator<OrderRepo>();
  UserRepo _userRepo = locator<UserRepo>();
  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  ViewState amountReportLoading = ViewState.Idle;
  ViewState customerListLoading = ViewState.Idle;
  ViewState agentListLoading = ViewState.Idle;
  ViewState storeOwnerListLoading = ViewState.Idle;

  List<User> customerList;
  List<User> agentList;
  List<User> storeOwnerList;

  DateTimeRange dateFilter;
  User selectedCustomerId;
  User selectedAgentId;
  User selectedStoreOwnerId;
  User selectedAdminId;

  double totalAmount = 0;

  ReportViewModel() {
    _initData();
    getReportForCustomer();
  }

  void _initData() async {
    User user = await _sharedPreferencesRepo.getUser();

    switch (user.userRoleType) {
      case UserRole.ADMIN:
        storeOwnerList = [];
        break;
      case UserRole.STORE_OWNER:
        agentList = [];
        break;
      case UserRole.AGENT:
        customerList = [];
        break;
      case UserRole.CUSTOMER:
        break;
    }
  }

  void getReportForCustomer() async {
    amountReportLoading = ViewState.Loading;

    User user = await _sharedPreferencesRepo.getUser();

    switch (user.userRoleType) {
      case UserRole.ADMIN:
        selectedAdminId = user;
        break;
      case UserRole.STORE_OWNER:
        selectedStoreOwnerId = user;
        break;
      case UserRole.AGENT:
        selectedAgentId = user;
        break;
      case UserRole.CUSTOMER:
        selectedCustomerId = user;
        break;
    }

    APIResponse<double> res = await _orderRepo.getReport(
      startTime: dateFilter?.start,
      endTime: dateFilter?.end,
      adminId: selectedAdminId?.username,
      storeOwnerId: selectedStoreOwnerId?.username,
      agentId: selectedAgentId?.username,
      customerId: selectedCustomerId?.username,
    );

    totalAmount = res.data;

    amountReportLoading = ViewState.Loaded;

    notifyListeners();
  }

  void updateDateFiler(DateTimeRange dateTimeRange) {
    this.dateFilter = dateTimeRange;
    getReportForCustomer();
    notifyListeners();
  }

  void resetDateFilter() {
    dateFilter = null;
    getReportForCustomer();
    notifyListeners();
  }

  void setCustomerId(User customer) {
    this.selectedCustomerId = customer;
    getReportForCustomer();
  }

  void setAgentId(User agentId) async {
    this.selectedAgentId = agentId;

    customerList = [];
    notifyListeners();

    getReportForCustomer();
  }
}
