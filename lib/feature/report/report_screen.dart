import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/report/report_viewmodel.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/type/view_state.dart';
import 'package:commission_counter/util/date_time_util.dart';
import 'package:commission_counter/util/format_uitl.dart';
import 'package:commission_counter/widget/app_bar_widget.dart';
import 'package:commission_counter/widget/app_button_widget.dart';
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
    reportViewModel.getReportForCustomer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => reportViewModel,
      child: Consumer<ReportViewModel>(
        builder: (context, reportViewModel, child) {
          return Scaffold(
            appBar: AppBarWidget(
              mTitle: 'Report',
            ),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _buildDateFilter(),
                        _buildTotalAmount(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateFilter() {
    return Card(
      child: InkWell(
        onTap: () {
          _selectDate();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimen.app_margin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.date_range),
              SizedBox(width: 10),
              Text(
                'Select date:',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFont.nunito_bold,
                ),
              ),
              SizedBox(width: 20),
              Visibility(
                visible: reportViewModel.dateFilter != null,
                child: Expanded(
                  child: Text(
                      '${DateTimeUtil.getDateFromFormat(reportViewModel.dateFilter?.start)}-'
                      '${DateTimeUtil.getDateFromFormat(reportViewModel.dateFilter?.end)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppFont.nunito_regular,
                      )),
                ),
              ),
              SizedBox(width: 10),
              Visibility(
                visible: reportViewModel.dateFilter != null,
                child: IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: Icon(Icons.clear),
                  onPressed: reportViewModel.resetDateFilter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppDimen.app_margin),
        child: Center(
          child: reportViewModel.amountReportLoading == ViewState.Loading
              ? getLoadingView()
              : Text(
                  '${FormatUtil.formatCurrency(
                    reportViewModel.totalAmount,
                    hasUnit: false,
                  )}',
                  style: TextStyle(
                    fontFamily: AppFont.nunito_bold,
                    fontSize: 30,
                    color: AppColor.mainColor,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTimeRange dateTimeRangePicker = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      initialDateRange: reportViewModel.dateFilter ??
          DateTimeRange(
            start: DateTime(2020, DateTime.now().month),
            end: DateTime.now(),
          ),
    );

    if (dateTimeRangePicker != null) {
      reportViewModel.updateDateFiler(DateTimeRange(
        start: dateTimeRangePicker.start,
        end: dateTimeRangePicker.end,
      ));
    }
  }
}
