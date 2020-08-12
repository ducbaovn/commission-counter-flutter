import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class FormatUtil {
  static String formatCurrency(double amount, {bool hasUnit = true}) {
    if (amount == null) {
      return 'N/A';
    }
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: amount,
        settings: MoneyFormatterSettings(
          thousandSeparator: ',',
          decimalSeparator: '.',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 3,
          compactFormatType: CompactFormatType.short,
        ));

    return hasUnit
        ? '${fmf.output.withoutFractionDigits} đ'
        : fmf.output.withoutFractionDigits;
  }
}
