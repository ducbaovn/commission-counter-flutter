import 'package:intl/intl.dart';

class DateTimeUtil {
  static const String API_REQUEST_FORMAT = 'yyyyMMddHHmmss';
  static const String DDMMYYYY_FORMAT = 'dd/MM/yyyy';
  static const String YYYMMDD_WITHHOUR_FORMAT = 'yyyy-MM-dd hh:mm';

  static String getDateTimeRequest() => getDateFromFormat(
        DateTime.now(),
        format: API_REQUEST_FORMAT,
      );

  static String getDateFromFormat(
    DateTime date, {
    String format = DDMMYYYY_FORMAT,
  }) =>
      DateFormat(format).format(date);
}
