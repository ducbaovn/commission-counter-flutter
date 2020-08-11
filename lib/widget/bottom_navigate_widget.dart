import 'package:flutter/material.dart';

class BottomNavigateWidget extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onReset;
  final VoidCallback onBack;

  BottomNavigateWidget({
    this.onNext,
    this.onReset,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                if (onBack != null) {
                  onBack();
                }
              },
              child: Container(
                height: 70,
                child: Center(
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (onReset != null) {
                  onReset();
                }
              },
              child: Container(
                height: 70,
                child: Center(
                  child: Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (onNext != null) {
                  onNext();
                }
              },
              child: Container(
                height: 70,
                child: Center(
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
