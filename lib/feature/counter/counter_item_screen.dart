import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/counter/counter_item_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterItemScreen extends StatefulWidget {
  @override
  _CounterItemScreenState createState() => _CounterItemScreenState();
}

class _CounterItemScreenState extends BaseScreen<CounterItemScreen> {
  CounterItemViewModel counterItemViewModel = locator<CounterItemViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => counterItemViewModel,
      child: Consumer<CounterItemViewModel>(
        builder: (context, counterItemViewModel, child) {
          return Container(

          );
        },
      ),
    );
  }
}
