import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/auth_repo.dart';
import 'package:commission_counter/datasource/repo/order_repo.dart';
import 'package:commission_counter/datasource/repo/store_repo.dart';
import 'package:commission_counter/schema/order.dart';
import 'package:commission_counter/schema/store.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:flutter/widgets.dart';

class CounterViewModel extends BaseViewModel {
  AuthRepo _authRepo = locator<AuthRepo>();
  StoreRepo _storeRepo = locator<StoreRepo>();
  OrderRepo _orderRepo = locator<OrderRepo>();

  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  Store store;

  List<Order> orders = [];

  PageController pageController = PageController(initialPage: 0);

  int currentPage;

  void getStoreData() async {
    startLoading();

    User user = await _sharedPreferencesRepo.getUser();

    APIResponse<Store> res = await _storeRepo.getStoreData(user.storeId);
    store = res.data;

    if (res.isSuccess) {
      orders = await _orderRepo.getAllOrderByStoreId(user.storeId);
      addBufferOrder();
    }

    currentPage = orders.length - 1;
    pageController = PageController(initialPage: currentPage);

    handleAPIResult(res);
  }

  void addBufferOrder() {
    /// Buffer one item.
    orders.add(null);
  }

  void goNextPage(Order order, int index) {
    /// Update order, because flutter will re-build item page.
    orders[index] = order;

    ///Update current page
    this.currentPage += 1;

    /// Add buffer item
    addBufferOrder();

    notifyListeners();

    _go2Page(currentPage);
  }

  void goBackPage() {
    if (currentPage > 0) {
      currentPage--;
      _go2Page(currentPage);
    }
  }

  void _go2Page(int index) {
    pageController.jumpToPage(index);
  }

  Future<void> logOut() async {
    return await _authRepo.logOut();
  }
}
