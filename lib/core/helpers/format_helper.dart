import 'package:easy_localization/easy_localization.dart';

class FormatHelper {
  static const String indonesianRupiah = "IDR";

  static String formatCurrency(num value, {String name = indonesianRupiah, int decimalDigits = 0}) {
    final format = NumberFormat.currency(name: name, decimalDigits: decimalDigits);
    final currency = format.format(value.abs());
    final firstNumber = currency.indexOf(RegExp('[0-9]'));

    return currency.replaceFirst(currency[firstNumber], ' ${value < 0 ? '-' : ''}${currency[firstNumber]}');
  }

  static String formatNumber(num value, {String pattern = "#,###.##"}) {
    final formatter = NumberFormat(pattern);
    return formatter.format(value);
  }

  static String formatDateTime(DateTime dateTime, {String pattern = "E, d MMM yyyy - HH:mm"}) {
    if (dateTime == null) {
      return "";
    }
    final dateFormatter = DateFormat(pattern);
    return dateFormatter.format(dateTime);
  }
}
