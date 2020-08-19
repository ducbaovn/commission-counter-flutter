import 'dart:math';

extension NumberFormat on double {
  double roundDouble(int places) {
    double mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}
