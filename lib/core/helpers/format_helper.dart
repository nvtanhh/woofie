import 'package:easy_localization/easy_localization.dart';

class FormatHelper {
  static String formatNumber(num value, {String pattern = "#,###.##"}) {
    final formatter = NumberFormat(pattern);
    return formatter.format(value);
  }

  static String formatDateTime(DateTime? dateTime, {String pattern = "E, d MMM yyyy - HH:mm"}) {
    if (dateTime == null) {
      return "";
    }
    final dateFormatter = DateFormat(pattern);
    return dateFormatter.format(dateTime);
  }
}
