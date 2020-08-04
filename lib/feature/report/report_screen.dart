import 'package:casino/base/base_screen.dart';
import 'package:casino/base/di/locator.dart';
import 'package:casino/feature/report/report_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_annotation/route_annotation.dart';

@RoutePage()
class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();

  static void startAndRemove(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ReportScreen()));
  }
}

class _ReportScreenState extends BaseScreen<ReportScreen> {
  ReportViewModel reportViewModel = locator<ReportViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => reportViewModel,
      child: Consumer<ReportViewModel>(
        builder: (context, reportViewModel, child) {
          return Container();
        },
      ),
    );
  }
}
