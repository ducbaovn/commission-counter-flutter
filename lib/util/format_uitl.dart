import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class FormatUtil {
  static String formatCurrency(double amount) {
    if (amount == null) {
      return 'N/A';
    }
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: amount,
        settings: MoneyFormatterSettings(
          thousandSeparator: ',',
          decimalSeparator: '.',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 2,
          compactFormatType: CompactFormatType.short,
        ));

    return fmf.output.nonSymbol.replaceAll('.00', '');
  }
}
