import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/auth/login/login_screen.dart';
import 'package:commission_counter/feature/counter/counter_item_screen.dart';
import 'package:commission_counter/feature/counter/counter_viewmodel.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/schema/order.dart';
import 'package:commission_counter/widget/app_bar_widget.dart';
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
    _getData();
    super.initState();
  }

  void _getData() async {
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
    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return CounterItemScreen(
          index: index,
          store: counterViewModel.store,
          order: counterViewModel.orders[index],
          onNext: (Order order) {
            counterViewModel.goNextPage(order, index);
          },
          onBack: () {
            counterViewModel.goBackPage();
          },
        );
      },
      controller: counterViewModel.pageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: counterViewModel.orders?.length ?? 0,
    );
  }

  void _logOut() {
    showConfirmDialog(
        content: getStringFromRes(AppLang.log_out_confirm),
        onConfirm: () {
          counterViewModel.logOut();
          LoginScreen.startAndRemove(context);
        });
  }
}
