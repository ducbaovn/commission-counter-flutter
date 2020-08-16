import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/report/user_filter_viewmodel.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/user_role.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/widget/app_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFilterScreen extends StatefulWidget {
  final String hostId;
  final UserRole userRole;
  final List<User> selectedUsers;
  final Function(User) onSelectedUser;

  UserFilterScreen({
    this.hostId,
    this.userRole,
    this.selectedUsers = const [],
    this.onSelectedUser,
  });

  @override
  _UserFilterScreenState createState() => _UserFilterScreenState();
}

class _UserFilterScreenState extends BaseScreen<UserFilterScreen> {
  UserFilterViewModel userFilterViewModel = locator<UserFilterViewModel>();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    userFilterViewModel.getUsers(widget.hostId, widget.userRole);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => userFilterViewModel,
      child: Consumer<UserFilterViewModel>(
        builder: (context, userFilterViewModel, child) {
          return Container(
            child: buildContainerViewByStatus(
              userFilterViewModel,
              _buildMainView(),
              _getData,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainView() {
    if (userFilterViewModel.users.isEmpty) {
      return AppEmptyWidget(
        emptyMessage: 'Data is empty',
        onRefresh: _getData,
      );
    }

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: _buildUserItemView(userFilterViewModel.users[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return UiUtil.buildLine();
      },
      itemCount: userFilterViewModel.users.length,
    );
  }

  Widget _buildUserItemView(User user) {
    return InkWell(
      onTap: () {
        if (widget.onSelectedUser != null) {
          widget.onSelectedUser(user);
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimen.app_margin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                user?.username ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFont.nunito_semi_bold,
                ),
              ),
            ),
            Visibility(
              visible: widget.selectedUsers.any((selectedUserItem) =>
                  selectedUserItem?.username == user.username),
              child: Icon(
                Icons.check_circle,
                color: AppColor.mainColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
