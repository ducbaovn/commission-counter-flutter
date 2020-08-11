import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/datasource/repo/auth_repo.dart';
import 'package:commission_counter/schema/seat.dart';

class CounterViewModel extends BaseViewModel {
  AuthRepo _authRepo = locator<AuthRepo>();

  List<Seat> seats = [];

  Future<void> logOut() async {
    return await _authRepo.logOut();
  }

  void generateNewSeats() {
    for (int i = 1; i <= 9; i++) {
      seats.add(Seat(
        index: i,
      ));
    }
    notifyListeners();
  }

  void setUserCodeForSeat(int index, String userCode) {
    seats[index - 1].userCode = userCode;
    resetSelectedSeat();
    seats[index - 1].isSelected = true;
    notifyListeners();
  }

  void resetSelectedSeat() {
    seats.forEach((item) {
      item.isSelected = false;
    });
    notifyListeners();
  }
}
