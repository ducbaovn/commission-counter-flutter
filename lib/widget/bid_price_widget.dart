import 'package:commission_counter/resources/app_color.dart';
import 'package:commission_counter/resources/app_font.dart';
import 'package:flutter/material.dart';

class BidPriceWidget extends StatefulWidget {
  final List<int> values;
  final int initTotal;
  final Function(int) onItemClick;


  BidPriceWidget({
    @required this.values,
    this.onItemClick,
    this.initTotal = 0,
  }) : assert(values != null);

  @override
  _BidPriceWidgetState createState() => _BidPriceWidgetState();
}

class _BidPriceWidgetState extends State<BidPriceWidget> {
  int initTotal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initTotal = widget.initTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children:
                widget.values.map((value) => _buildPricingItem(value)).toList(),
          ),
          SizedBox(height: 20),
          _buildTotalBidPrice(),
        ],
      ),
    );
  }

  Widget _buildPricingItem(int value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 1),
        height: 60,
        color: AppColor.inputGrayColor,
        child: Material(
          child: InkWell(
            onTap: () {
              if (widget.onItemClick != null) {
                setState(() {
                  initTotal += value;
                });
                widget.onItemClick(initTotal);
              }
            },
            child: Center(
              child: Text(
                value.toString(),
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
        initTotal.toString(),
        style: TextStyle(
          fontSize: 32,
          fontFamily: AppFont.nunito_bold,
        ),
      ),
    );
  }
}
