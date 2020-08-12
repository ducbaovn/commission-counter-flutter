import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:commission_counter/util/format_uitl.dart';
import 'package:flutter/material.dart';

class BidPriceWidget extends StatelessWidget {
  final List<double> values;
  final double totalAmount;
  final Function(double) onItemClick;

  BidPriceWidget({
    @required this.values,
    this.onItemClick,
    this.totalAmount = 0,
  }) : assert(values != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildTotalBidPrice(),
          SizedBox(height: 10),
          Row(
            children: values.map((value) => _buildPricingItem(value)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingItem(double value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 1),
        height: 60,
        color: AppColor.inputGrayColor,
        child: Material(
          child: InkWell(
            onTap: () {
              if (onItemClick != null) {
                onItemClick(value);
              }
            },
            child: Center(
              child: Text(
                FormatUtil.formatCurrency(
                  value ?? 0,
                  hasUnit: false,
                ),
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: AppFont.nunito_bold,
                  color: AppColor.mainColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBidPrice() {
    return Center(
      child: Text(
        FormatUtil.formatCurrency(
          totalAmount?.toDouble() ?? 0,
          hasUnit: false,
        ),
        style: TextStyle(
          fontSize: 32,
          fontFamily: AppFont.nunito_bold,
        ),
      ),
    );
  }
}
