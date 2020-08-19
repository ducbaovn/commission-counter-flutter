import 'package:barcode_scan/barcode_scan.dart';
import 'package:commission_counter/base/api_response.dart';
import 'package:commission_counter/base/base_screen.dart';
import 'package:commission_counter/base/di/locator.dart';
import 'package:commission_counter/feature/counter/input_user_code_viewmodel.dart';
import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_dimen.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/resources/app_lang.dart';
import 'package:commission_counter/schema/user.dart';
import 'package:commission_counter/type/view_state.dart';
import 'package:commission_counter/util/ui_util.dart';
import 'package:commission_counter/util/validate_util.dart';
import 'package:commission_counter/widget/app_button_widget.dart';
import 'package:commission_counter/widget/app_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputUserCodeScreen extends StatefulWidget {
  final String userCode;
  final Function(User) onSubmitData;

  InputUserCodeScreen({
    this.userCode,
    this.onSubmitData,
  });

  @override
  _InputUserCodeScreenState createState() => _InputUserCodeScreenState();
}

class _InputUserCodeScreenState extends BaseScreen<InputUserCodeScreen> {
  InputUserCodeViewModel inputUserCodeViewModel =
      locator<InputUserCodeViewModel>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _customerCodeController = TextEditingController();
  bool _autoValidate = false;
  String _userCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userCode = widget.userCode;
    _customerCodeController.text = widget.userCode;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => inputUserCodeViewModel,
      child: Consumer<InputUserCodeViewModel>(
        builder: (context, inputUserCodeViewModel, child) {
          return Container(
            child: _buildMainView(),
          );
        },
      ),
    );
  }

  Widget _buildMainView() {
    return Container(
      child: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  AppDimen.app_margin,
              left: AppDimen.app_margin,
              right: AppDimen.app_margin,
              top: AppDimen.app_margin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  UiUtil.getStringFromRes(AppLang.custom_code, context),
                  style:
                      TextStyle(fontFamily: AppFont.nunito_bold, fontSize: 16),
                ),
                SizedBox(height: AppDimen.app_margin),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AppTextFieldWidget(
                        inputType: TextInputType.text,
                        validator: _validatePrice,
                        textHint: UiUtil.getStringFromRes(
                            AppLang.custom_code, context),
                        controller: _customerCodeController,
                        onSaved: (String price) {
                          _userCode = price;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: _openScanner,
                      icon: Icon(Icons.center_focus_strong),
                    ),
                  ],
                ),
                Visibility(
                  visible: inputUserCodeViewModel.viewState == ViewState.Error,
                  child: Text(
                    inputUserCodeViewModel.errorMsg ?? '',
                    style: TextStyle(
                      color: AppColor.errorColor,
                      fontSize: 12,
                      fontFamily: AppFont.nunito_regular,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                inputUserCodeViewModel.viewState == ViewState.Loading
                    ? Container(
                        child: getLoadingView(),
                      )
                    : AppButtonWidget(
                        label: UiUtil.getStringFromRes(
                            AppLang.common_confirm, context),
                        onPressed: () {
                          _validateInputs();
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkUserInfo(String userName) async {
    APIResponse<User> res =
        await inputUserCodeViewModel.checkUserInfo(userName);

    if (res.isSuccess && widget.onSubmitData != null) {
      widget.onSubmitData(res.data);
    }
  }

  void _openScanner() async {
    ScanResult result = await BarcodeScanner.scan();

    if (result != null) {
      _customerCodeController.text = result.rawContent;
    }
  }

  String _validatePrice(String price) {
    if (ValidateUtil.isNullOrEmpty(price)) {
      return UiUtil.getStringFromRes(AppLang.error_user_code_empty, context);
    }

    return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (widget.onSubmitData != null) {
        _checkUserInfo(_userCode);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
