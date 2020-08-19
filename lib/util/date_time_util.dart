import 'package:intl/intl.dart';

class DateTimeUtil {
  static const String DDMMYYYY_FORMAT = 'dd/MM/yyyy';
  static const String MMDDYYYY_FORMAT = 'MM/dd/yyyy';

  static String getDateFromFormat(
    DateTime date, {
    String format = MMDDYYYY_FORMAT,
  }) {
    if (date == null) {
      return '';
    }
    return DateFormat(format).format(date);
  }
}
