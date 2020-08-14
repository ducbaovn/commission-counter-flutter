import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/counter/counter_item_viewmodel.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/schema/order.dart';
import 'package:commission_counter/schema/seat.dart';
import 'package:commission_counter/schema/store.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/widget/bid_price_widget.dart';
import 'package:commission_counter/widget/bottom_navigate_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_annotation/route_annotation.dart';

import 'input_user_code_screen.dart';

@RoutePage()
class CounterItemScreen extends StatefulWidget {
  final int index;
  final Store store;
  final Order order;
  final Function(Order) onNext;
  final VoidCallback onBack;

  CounterItemScreen({
    this.index,
    this.store,
    this.order,
    this.onNext,
    this.onBack,
  });

  @override
  _CounterItemScreenState createState() => _CounterItemScreenState();
}

class _CounterItemScreenState extends BaseScreen<CounterItemScreen> {
  CounterItemViewModel counterItemViewModel = locator<CounterItemViewModel>();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    counterItemViewModel.initData(widget.store, widget.order);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => counterItemViewModel,
      child: Consumer<CounterItemViewModel>(
        builder: (context, counterItemViewModel, child) {
          return Scaffold(
            body: Container(
              child: buildContainerViewByStatus(
                counterItemViewModel,
                _buildMainView(),
                initData,
              ),
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
                  values: counterItemViewModel.store?.parValues ?? [],
                  totalAmount: counterItemViewModel.totalAmount ?? 0,
                  onItemClick: (double value) {
                    counterItemViewModel.setOrderAmount(value);
                  },
                ),
              ],
            ),
          ),
          UiUtil.buildLine(),
          BottomNavigateWidget(
            currentIndex: widget.index,
            onReset: () {
              counterItemViewModel.resetOrderAmount();
            },
            onBack: widget.onBack,
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
        children: counterItemViewModel.seats
            .map((seatItem) => Card(
                  color:
                      seatItem.isSelected ? AppColor.mainColor : AppColor.white,
                  child: InkWell(
                    onTap: () {
                      if (seatItem.userCode == null) {
                        _openInputCustomerCodeForm(seatItem);
                      } else {
                        counterItemViewModel.toggleSelectSeat(seatItem.index);
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
              counterItemViewModel.setUserForSeat(seat.index, user);
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
          counterItemViewModel.resetSeat(seat.index);
        });
  }

  void _submitNewOrder() async {
    if (widget.order != null && !counterItemViewModel.hasChange) {
      widget.onNext(widget.order);
      return;
    }

    String errorMes = counterItemViewModel.validateData();
    if (errorMes != null) {
      showErrorDialog(content: errorMes);
      return;
    }

    showLoadingDialog();

    APIResponse<Order> res = await counterItemViewModel.submitNewOrder();

    hideLoadingDialog();

    if (!res.isSuccess) {
      showErrorDialog(content: res.message);
    } else {
      UiUtil.showToastMsg('Successfully!');
      widget.onNext(res.data);
    }
  }
}
