import 'package:commission_counter/feature/auth/login/login_screen.dart';
import 'package:commission_counter/feature/counter/counter_screen.dart';
import 'package:commission_counter/feature/report/report_screen.dart';
import 'package:commission_counter/share_viewmodel/session_viewmodel.dart';
import 'package:commission_counter/type/user_role.dart';
import 'package:commission_counter/widget/dialog/confirm_dialog_widget.dart';
import 'package:commission_counter/widget/dialog/error_dialog_widget.dart';
import 'package:commission_counter/widget/dialog/success_dialog_widget.dart';
import 'package:commission_counter/widget/input_password_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:commission_counter/base/base_viewmodel.dart';
import 'package:commission_counter/localization/app_translations.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/type/view_state.dart';
import 'package:commission_counter/widget/app_empty_widget.dart';
import 'package:commission_counter/widget/app_error_widget.dart';
import 'package:commission_counter/widget/app_loading_widget.dart';
import 'package:commission_counter/widget/progress_dialog.dart';

abstract class BaseScreen<T extends StatefulWidget> extends State<T> {
  ProgressDialog pr;

  String getStringFromRes(String key) => AppTranslations.of(context).text(key);

  SessionViewModel get sessionViewModel =>
      Provider.of<SessionViewModel>(context, listen: false);

  SessionViewModel get sessionViewModelListen =>
      Provider.of<SessionViewModel>(context, listen: true);

  List<Widget> buildAction(
    BaseViewModel baseViewModel, {
    bool isOpenCounterScreen = false,
  }) {
    List<Widget> actions = [];

    if (sessionViewModelListen.user.userRoleType == UserRole.STORE_OWNER &&
        baseViewModel.passwordHashing != null) {
      actions.add(buildSwitchScreenIcon(
        baseViewModel,
        isOpenCounterScreen: isOpenCounterScreen,
      ));
    }

    actions.add(buildLogOutIcon(baseViewModel));

    return actions;
  }

  Widget buildLogOutIcon(BaseViewModel baseViewModel) {
    return IconButton(
      onPressed: () {
        _logOut(baseViewModel);
      },
      icon: Icon(Icons.exit_to_app),
    );
  }

  void _logOut(BaseViewModel baseViewMode) {
    showConfirmDialog(
        content: getStringFromRes(AppLang.log_out_confirm),
        onConfirm: () {
          baseViewMode.logOut();
          LoginScreen.startAndRemove(context);
        });
  }

  Widget buildSwitchScreenIcon(
    BaseViewModel baseViewModel, {
    bool isOpenCounterScreen = false,
  }) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return InputPasswordFormWidget(
                passwordHashing: baseViewModel.passwordHashing,
                onSubmitData: () {
                  Navigator.pop(context);

                  if (isOpenCounterScreen) {
                    CounterScreen.startAndRemove(context);
                  } else {
                    ReportScreen.startAndRemove(context);
                  }
                },
              );
            });
      },
      icon: Icon(Icons.swap_horiz),
    );
  }

  Widget buildLine() {
    return Container(
      width: double.infinity,
      height: 0.2,
      color: AppColor.searchBoxTextColor,
    );
  }

  Widget getLoadingView() => AppLoadingWidget();

  Widget buildEmptyView(String message, VoidCallback onRefresh,
      {String retryLabel}) {
    return AppEmptyWidget(
      emptyMessage: message,
      onRefresh: onRefresh,
      retryLabel: retryLabel,
    );
  }

  Widget buildDataViewWithRefresh(
    Widget child,
    RefreshController refreshController,
    VoidCallback onRefresh, {
    VoidCallback onLoadMore,
  }) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: onLoadMore != null,
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      header: WaterDropMaterialHeader(
        backgroundColor: AppColor.mainColor,
      ),
      footer: ClassicFooter(
        textStyle: TextStyle(
          fontFamily: AppFont.nunito_bold,
          fontSize: 14,
        ),
        idleText: getStringFromRes(AppLang.common_load_more),
        canLoadingText: getStringFromRes(AppLang.common_load_more_confirm),
        loadingIcon: SpinKitThreeBounce(
          color: AppColor.mainColor,
          size: 30,
        ),
        loadingText: '',
      ),
      child: child,
    );
  }

  Widget buildContainerViewByStatus(
    BaseViewModel viewModel,
    Widget contentView,
    VoidCallback onRetry,
  ) {
    Widget mainView = Container();

    switch (viewModel.viewState) {
      case ViewState.Idle:
        mainView = Container();
        break;

      case ViewState.Loading:
        mainView = getLoadingView();
        break;

      case ViewState.Loaded:
      case ViewState.Refreshing:
        mainView = contentView;
        break;

      case ViewState.Error:
        mainView = AppErrorWidget(onRetry: onRetry);
    }

    return mainView;
  }

  void showLoadingDialog() async {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    pr.style(
      message: getStringFromRes(AppLang.common_loading),
      progressWidget: SpinKitThreeBounce(
        color: AppColor.mainColor,
        size: 30,
      ),
    );

    await pr.show();
  }

  void hideLoadingDialog() async {
    await pr.hide();
  }

  void showErrorDialog({
    String title,
    String content,
    VoidCallback onRetry,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ErrorDialogWidget(
        title: title,
        content: content,
        onClose: onRetry,
      ),
    );
  }

  void showSuccessDialog({
    String title,
    String content,
    bool barrierDismissible = true,
    VoidCallback onClose,
  }) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) => SuccessDialogWidget(
        title: title,
        content: content,
        onClose: onClose,
      ),
    );
  }

  void showConfirmDialog({
    String title,
    String content,
    VoidCallback onConfirm,
    VoidCallback onCancel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmDialogWidget(
        title: title,
        content: content,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
