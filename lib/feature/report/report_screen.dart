import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/report/report_viewmodel.dart';
import 'package:commission_counter/feature/report/user_filter_screen.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/user_role.dart';
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
    reportViewModel.getPasswordHashing();
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
              mActions: buildAction(reportViewModel, isOpenCounterScreen: true),
            ),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _buildTotalAmount(),
                        _buildDateFilter(),
                        _buildStoreOwnerList(),
                        _buildAgentList(),
                        _buildCustomerList(),
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
              Expanded(
                child: Text(
                  reportViewModel.dateFilter == null
                      ? 'All'
                      : '${DateTimeUtil.getDateFromFormat(reportViewModel.dateFilter?.start)}-'
                          '${DateTimeUtil.getDateFromFormat(reportViewModel.dateFilter?.end)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: AppFont.nunito_regular,
                  ),
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

  Widget _buildStoreOwnerList() {
    return _buildUserFilterView(
      'Select store owner',
      reportViewModel.storeOwnerList,
      reportViewModel.selectedStoreOwnerId,
      UserRole.STORE_OWNER,
      (User user) {
        reportViewModel.setStoreOwnerId(user);
      },
    );
  }

  Widget _buildAgentList() {
    return _buildUserFilterView(
      'Select agent',
      reportViewModel.agentList,
      reportViewModel.selectedAgentId,
      UserRole.AGENT,
      (User user) {
        reportViewModel.setAgentId(user);
      },
    );
  }

  Widget _buildCustomerList() {
    return _buildUserFilterView(
      'Select customer',
      reportViewModel.customerList,
      reportViewModel.selectedCustomerId,
      UserRole.CUSTOMER,
      (User user) {
        reportViewModel.setCustomerId(user);
      },
    );
  }

  Widget _buildUserFilterView(
    String lable,
    List<User> filterUsers,
    User selectedUser,
    UserRole userRole,
    Function(User) onSelectedUser,
  ) {
    if (filterUsers == null) {
      return Container();
    }

    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => UserFilterScreen(
              userRole: userRole,
              adminId: reportViewModel.selectedAdminId?.username,
              storeOwnerId: reportViewModel.selectedStoreOwnerId?.username,
              agentId: reportViewModel.selectedAgentId?.username,
              selectedUsers: [selectedUser],
              onSelectedUser: onSelectedUser,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimen.app_margin),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 10),
              Text(
                lable,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFont.nunito_bold,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  '${selectedUser?.username ?? 'All'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: AppFont.nunito_regular,
                  ),
                ),
              ),
              Visibility(
                visible: selectedUser != null,
                child: IconButton(
                  padding: const EdgeInsets.all(2),
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    onSelectedUser(null);
                  },
                ),
              ),
            ],
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
