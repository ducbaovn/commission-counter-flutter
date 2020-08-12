import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/auth_repo.dart';
import 'package:commission_counter/datasource/repo/order_repo.dart';
import 'package:commission_counter/datasource/repo/store_repo.dart';
import 'package:commission_counter/schema/commission.dart';
import 'package:commission_counter/schema/order.dart';
import 'package:commission_counter/schema/seat.dart';
import 'package:commission_counter/schema/store.dart';
import 'package:commission_counter/schema/user.dart';

class CounterViewModel extends BaseViewModel {
  AuthRepo _authRepo = locator<AuthRepo>();
  OrderRepo _orderRepo = locator<OrderRepo>();
  StoreRepo _storeRepo = locator<StoreRepo>();

  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  List<Seat> seats = [];
  double totalAmount = 0;
  Store store;

  Future<void> logOut() async {
    return await _authRepo.logOut();
  }

  void generateNewSeats() {
    for (int i = 0; i < 9; i++) {
      seats.add(Seat(index: i));
    }
    notifyListeners();
  }

  void getStoreData() async {
    startLoading();

    User user = await _sharedPreferencesRepo.getUser();

    APIResponse<Store> res = await _storeRepo.getStoreData(user.storeId);

    store = res.data;

    handleAPIResult(res);
  }

  void setUserForSeat(int index, User user) {
    ///Set user code
    seats[index].userCode = user.username;
    seats[index].agentId = user.agentId;
    seats[index].name = user.name;
    seats[index].isSelected = true;
    notifyListeners();
  }

  void setOrderAmount(double value) {
    totalAmount += value;
    notifyListeners();
  }

  void resetOrderAmount() {
    totalAmount = 0;
    notifyListeners();
  }

  void resetSeat(int index) {
    seats[index].userCode = null;
    seats[index].isSelected = false;
    notifyListeners();
  }

  void toggleSelectSeat(int index) {
    seats[index].isSelected = !seats[index].isSelected;
    notifyListeners();
  }

  Future<APIResponse> submitNewOrder() async {
    if (totalAmount == 0) {
      return APIResponse(
        isSuccess: false,
        message: 'Please select price',
      );
    }

    List<String> listCustomer = [];

    seats.forEach((seat) {
      if (seat.isSelected) {
        listCustomer.add(seat.userCode);
      }
    });

    if (listCustomer.isEmpty) {
      return APIResponse(
        isSuccess: false,
        message: 'Please select customer',
      );
    }

    User user = await _sharedPreferencesRepo.getUser();

    Order order = Order(
      storeOwnerId: user.username,
      storeId: user.storeId,
      adminId: user.adminId,
      currency: store?.currency,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      amount: totalAmount,
      listCustomer: listCustomer,
    );

    List<Commission> commissions = [];
    seats.forEach((seat) {
      if (seat.isSelected) {
        commissions.add(Commission(
          storeOwnerId: user.username,
          storeId: user.storeId,
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
          adminId: user.adminId,
          amount: totalAmount / listCustomer.length,
          currency: store?.currency,
          agentId: seat.agentId ?? 'Aa000',
          customerId: seat.userCode,
        ));
      }
    });

    return await _orderRepo.submitOrder(
      order: order,
      commissions: commissions,
    );
  }
}
