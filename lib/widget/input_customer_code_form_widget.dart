import 'package:barcode_scan/barcode_scan.dart';
import 'package:casino/resources/app_dimen.dart';
import 'package:casino/resources/app_font.dart';
import 'package:casino/util/ui_util.dart';
import 'package:casino/util/validate_util.dart';
import 'package:casino/widget/app_textfield_widget.dart';
import 'package:flutter/material.dart';

import 'app_button_widget.dart';

class InputCustomerSeatFormWidget extends StatefulWidget {
  final Function(double) onSubmitData;

  InputCustomerSeatFormWidget({this.onSubmitData});

  @override
  InputCustomerSeatFormWidgetState createState() =>
      InputCustomerSeatFormWidgetState();
}

class InputCustomerSeatFormWidgetState
    extends State<InputCustomerSeatFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _customerCodeController = TextEditingController();
  bool _autoValidate = false;
  String _price;

  @override
  Widget build(BuildContext context) {
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
                  'Customer code',
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
                        textHint: 'Customer code',
                        controller: _customerCodeController,
                        onSaved: (String price) {
                          _price = price;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: _openScanner,
                      icon: Icon(Icons.center_focus_strong),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                AppButtonWidget(
                  label: 'Confirm',
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

  void _openScanner() async {
    ScanResult result = await BarcodeScanner.scan();

    if (result != null) {
      _customerCodeController.text = result.rawContent;
    }
  }

  String _validatePrice(String price) {
    if (ValidateUtil.isNullOrEmpty(price)) {
      return 'Please input customer code';
    }

    return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (widget.onSubmitData != null) {
        widget.onSubmitData(double.parse(_price));
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
