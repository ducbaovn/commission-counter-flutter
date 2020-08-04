import 'package:casino/logger/app_logger.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class FormatUtil {
  static String formatCurrency(double amount) {
    try {
      FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
          amount: amount,
          settings: MoneyFormatterSettings(
            symbol: 'VND',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 3,
            compactFormatType: CompactFormatType.long,
          ));

      return '${fmf.output.symbolOnRight}';
    } catch (e) {
      AppLogger.e(e);
      return '';
    }
  }
}
