import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/order_repo.dart';
import 'package:commission_counter/datasource/repo/store_repo.dart';
import 'package:commission_counter/schema/order.dart';
import 'package:commission_counter/schema/seat.dart';
import 'package:commission_counter/schema/store.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:flutter/widgets.dart';

class CounterViewModel extends BaseViewModel {
  StoreRepo _storeRepo = locator<StoreRepo>();
  OrderRepo _orderRepo = locator<OrderRepo>();

  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  int _currentPage;

  Store store;

  List<Order> orders = [];

  List<Seat> previousSeats;

  PageController pageController = PageController(initialPage: 0);

  void getStoreData() async {
    startLoading();

    User user = await _sharedPreferencesRepo.getUser();

    APIResponse<Store> res = await _storeRepo.getStoreData(user.storeId);
    store = res.data;

    if (res.isSuccess) {
      orders = await _orderRepo.getAllOrderByStoreId(user.storeId);
      addBufferOrder();
      addBufferOrder();
      _currentPage = orders.length - 2;
      pageController = PageController(initialPage: _currentPage);
    }

    handleAPIResult(res);
  }

  void addBufferOrder() {
    /// Buffer one item.
    orders.add(null);
  }

  void goNextPage(Order order, List<Seat> seats, int index) {
    /// Update order, because flutter will re-build item page.
    orders[index] = order;

    if (seats.isNotEmpty) {
      previousSeats = seats;
    }

    ///Update current page
    this._currentPage += 1;

    /// Add buffer item
    addBufferOrder();

    notifyListeners();

    _go2Page(_currentPage);
  }

  void goBackPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _go2Page(_currentPage);
    }
  }

  void _go2Page(int index) {
    pageController.jumpToPage(index);
  }
}
