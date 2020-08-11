import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/auth/login/login_screen.dart';
import 'package:commission_counter/feature/counter/counter_viewmodel.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/schema/seat.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/widget/app_bar_widget.dart';
import 'package:commission_counter/widget/bid_price_widget.dart';
import 'package:commission_counter/widget/bottom_navigate_widget.dart';
import 'package:commission_counter/widget/input_customer_code_form_widget.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => counterViewModel,
      child: Consumer<CounterViewModel>(
        builder: (context, dealerViewModel, child) {
          return Scaffold(
            appBar: AppBarWidget(
              mTitle: 'Dealer',
              mActions: <Widget>[
                IconButton(
                  onPressed: _logOut,
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          child: _buildSeatLayout(),
                        ),
                        SizedBox(height: 20),
                        BidPriceWidget(
                          values: [25, 50, 100],
                          onItemClick: (int value) {},
                        ),
                      ],
                    ),
                  ),
                  UiUtil.buildLine(),
                  BottomNavigateWidget(
                    onReset: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openInputCustomerCodeForm(Seat seat) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return InputCustomerSeatFormWidget(
            userCode: seat.userCode ?? '',
            onSubmitData: (String userCode) {
              counterViewModel.setUserCodeForSeat(seat.index, userCode);
              Navigator.pop(context);
            },
          );
        });
  }

  void _logOut() {
    showConfirmDialog(
        content: 'Are you sure you want to log out?',
        onConfirm: () {
          counterViewModel.logOut();
          LoginScreen.startAndRemove(context);
        });
  }

  Widget _buildSeatLayout() {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: counterViewModel.seats
            .map((seatItem) => Card(
                  color:
                      seatItem.isSelected ? AppColor.mainColor : AppColor.white,
                  child: InkWell(
                    onTap: () {
                      _openInputCustomerCodeForm(seatItem);
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${seatItem.index}',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontFamily: AppFont.nunito_bold,
                                    ),
                          ),
                          SizedBox(height: 5),
                          Text(seatItem.userCode ?? '',
                              style: TextStyle(
                                fontFamily: AppFont.nunito_regular,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
