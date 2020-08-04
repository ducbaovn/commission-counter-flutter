import 'package:casino/base/base_screen.dart';
import 'package:casino/base/di/locator.dart';
import 'package:casino/feature/auth/login/login_screen.dart';
import 'package:casino/feature/counter/counter_viewmodel.dart';
import 'package:casino/widget/app_bar_widget.dart';
import 'package:casino/widget/input_customer_code_form_widget.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
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
  CounterViewModel dealerViewModel = locator<CounterViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => dealerViewModel,
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
            body: DoubleBackToCloseApp(
              child: Container(
                child: _buildSeatLayout(),
              ),
              snackBar: const SnackBar(
                content: Text('Tap again to close app'),
              ),
            ),
          );
        },
      ),
    );
  }

  void _penInputCustomerCodeForm() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return InputCustomerSeatFormWidget(onSubmitData: (double price) {});
        });
  }

  void _logOut() {
    showConfirmDialog(
        content: 'Are you sure you want to log out?',
        onConfirm: () {
          dealerViewModel.logOut();
          LoginScreen.startAndRemove(context);
        });
  }

  Widget _buildSeatLayout() {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(9, (index) {
        return InkWell(
          onTap: () {
            _penInputCustomerCodeForm();
          },
          child: Container(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        );
      }),
    );
  }
}
