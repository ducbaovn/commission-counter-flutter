import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/local/shared_preferences_repo.dart';
import 'package:commission_counter/datasource/repo/order_repo.dart';
import 'package:commission_counter/schema/commission.dart';
import 'package:commission_counter/schema/order.dart';
import 'package:commission_counter/schema/seat.dart';
import 'package:commission_counter/schema/store.dart';
import 'package:commission_counter/schema/user.dart';

class CounterItemViewModel extends BaseViewModel {
  OrderRepo _orderRepo = locator<OrderRepo>();

  SharedPreferencesRepo _sharedPreferencesRepo =
      locator<SharedPreferencesRepo>();

  List<Seat> seats = [];
  double totalAmount = 0;
  Store store;
  bool hasChange = false;
  Order order;

  void initData(Store store, Order order) async {
    startLoading();

    this.store = store;
    this.order = order;
    generateNewSeats();

    if (order != null) {
      totalAmount = order.amount;

      /// Get commissions for order
      List<Commission> commissions =
          await _orderRepo.getCommissionByOrderId(order.id);

      /// Map commissions to seats
      commissions.forEach((item) {
        seats[item.seat].isSelected = true;
        seats[item.seat].name = item.name;
        seats[item.seat].agentId = item.agentId;
        seats[item.seat].agentId = item.agentId;
        seats[item.seat].userCode = item.customerId;
      });
    }
    stopLoading();
  }

  void generateNewSeats() {
    for (int i = 0; i < 9; i++) {
      seats.add(Seat(index: i));
    }
  }

  void setUserForSeat(int index, User user) {
    ///Set user code
    seats[index].userCode = user.username;
    seats[index].agentId = user.agentId;
    seats[index].name = user.name;
    seats[index].isSelected = false;
    notifyListeners();

    hasChange = true;
  }

  void setOrderAmount(double value) {
    totalAmount += value;
    notifyListeners();

    hasChange = true;
  }

  void resetOrderAmount() {
    totalAmount = 0;
    notifyListeners();
  }

  void resetSeat(int index) {
    seats[index].userCode = null;
    seats[index].name = null;
    seats[index].isSelected = false;
    notifyListeners();

    hasChange = true;
  }

  void toggleSelectSeat(int index) {
    seats[index].isSelected = !seats[index].isSelected;
    notifyListeners();

    hasChange = true;
  }

  String validateData() {
    bool isHasSelected = false;
    seats.forEach((seat) {
      if (seat.isSelected) {
        isHasSelected = true;
        return;
      }
    });

    if (!isHasSelected) {
      return 'Please select customer';
    }

    if (totalAmount == 0) {
      return 'Please select price';
    }

    return null;
  }

  Future<APIResponse<Order>> submitNewOrder() async {
    List<String> listCustomer = [];

    seats.forEach((seat) {
      if (seat.isSelected) {
        listCustomer.add(seat.userCode);
      }
    });

    User user = await _sharedPreferencesRepo.getUser();

    Order order = Order(
      id: this.order?.id ?? null,
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
        commissions.add(
          Commission(
            storeOwnerId: user.username,
            storeId: user.storeId,
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
            adminId: user.adminId,
            amount: totalAmount / listCustomer.length,
            currency: store?.currency,
            agentId: seat.agentId,
            customerId: seat.userCode,
            name: seat.name,
            seat: seat.index,
          ),
        );
      }
    });

    return await _orderRepo.createOrUpdateOrder(
      order: order,
      commissions: commissions,
    );
  }
}
