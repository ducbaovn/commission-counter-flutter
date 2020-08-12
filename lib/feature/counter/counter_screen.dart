import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/auth/login/login_screen.dart';
import 'package:commission_counter/feature/counter/counter_viewmodel.dart';
import 'package:commission_counter/feature/counter/input_user_code_screen.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/schema/seat.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/widget/app_bar_widget.dart';
import 'package:commission_counter/widget/bid_price_widget.dart';
import 'package:commission_counter/widget/bottom_navigate_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_annotation/route_annotation.dart';

@RoutePage()
class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();

  static void startAndRemove(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CounterScreen()));
  }
}

class _CounterScreenState extends BaseScreen<CounterScreen> {
  CounterViewModel counterViewModel = locator<CounterViewModel>();

  @override
  void initState() {
    counterViewModel.generateNewSeats();
    _getData();
    super.initState();
  }

  void _getData() {
    counterViewModel.getStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => counterViewModel,
      child: Consumer<CounterViewModel>(
        builder: (context, dealerViewModel, child) {
          return Scaffold(
            appBar: AppBarWidget(
              mTitle: getStringFromRes(AppLang.counter_screen_title),
              mActions: <Widget>[
                IconButton(
                  onPressed: _logOut,
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
            ),
            body: buildContainerViewByStatus(
              counterViewModel,
              _buildMainView(),
              _getData,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainView() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildSeatLayout(),
                SizedBox(height: 10),
                BidPriceWidget(
                  values: counterViewModel.store?.parValues ?? [],
                  totalAmount: counterViewModel.totalAmount ?? 0,
                  onItemClick: (double value) {
                    counterViewModel.setOrderAmount(value);
                  },
                ),
              ],
            ),
          ),
          UiUtil.buildLine(),
          BottomNavigateWidget(
            onReset: () {
              counterViewModel.resetOrderAmount();
            },
            onBack: () {},
            onNext: _submitNewOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLayout() {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: counterViewModel.seats
            .map((seatItem) => Card(
                  color:
                      seatItem.isSelected ? AppColor.mainColor : AppColor.white,
                  child: InkWell(
                    onTap: () {
                      if (seatItem.userCode == null) {
                        _openInputCustomerCodeForm(seatItem);
                      } else {
                        counterViewModel.toggleSelectSeat(seatItem.index);
                      }
                    },
                    onLongPress: () {
                      _resetSeat(seatItem);
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${seatItem.index + 1}',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontFamily: AppFont.nunito_bold,
                                    ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            seatItem.userCode ?? '',
                            style: TextStyle(
                              fontFamily: AppFont.nunito_bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            seatItem.name ?? '',
                            style: TextStyle(
                              fontFamily: AppFont.nunito_regular,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _openInputCustomerCodeForm(Seat seat) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return InputUserCodeScreen(
            userCode: seat.userCode ?? '',
            onSubmitData: (User user) {
              counterViewModel.setUserForSeat(seat.index, user);
              Navigator.pop(context);
            },
          );
        });
  }

  void _resetSeat(Seat seat) {
    if (seat.userCode == null || seat.userCode.isEmpty) {
      return;
    }

    showConfirmDialog(
        content: getStringFromRes(AppLang.reset_seat_confirm),
        onConfirm: () {
          counterViewModel.resetSeat(seat.index);
        });
  }

  void _logOut() {
    showConfirmDialog(
        content: getStringFromRes(AppLang.log_out_confirm),
        onConfirm: () {
          counterViewModel.logOut();
          LoginScreen.startAndRemove(context);
        });
  }

  void _submitNewOrder() async {
    showLoadingDialog();

    APIResponse res = await counterViewModel.submitNewOrder();

    hideLoadingDialog();

    if (!res.isSuccess) {
      showErrorDialog(content: res.message);
    }
  }
}
