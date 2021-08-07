import 'package:age_calculator/age_calculator.dart';
import 'package:easy_localization/easy_localization.dart';

class DateTimeHelper {
  static List<DateTime> daysInMonth(DateTime month) {
    final first = firstDayOfMonth(month);
    final daysBefore = first.weekday;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = DateTimeHelper.lastDayOfMonth(month);

    var daysAfter = 7 - last.weekday;

    // If the last day is sunday (7) the entire week must be rendered
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    final lastToDisplay = last.add(Duration(days: daysAfter));
    return daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  static DateTime firstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month);
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    final beginningNextMonth = (month.month < 12)
        ? DateTime(month.year, month.month + 1)
        : DateTime(month.year + 1);
    return beginningNextMonth.subtract(const Duration(days: 1));
  }

  /// Returns a [DateTime] for each day the given range.
  ///
  /// [start] inclusive
  /// [end] exclusive
  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.add(const Duration(days: 1));
      final timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  static List<String> generateListOfMonths() {
    final List<String> result = [];
    for (int i = 1; i <= 12; i++) {
      // increment the month value
      result.add(DateFormat.MMMM().format(DateTime(DateTime.now().year, i)));
    }
    return result;
  }

  static bool equalsDate(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month && a.year == b.year;
  }

  static String calcAge(DateTime? dob) {
    if (dob == null) return "Unknown";
    final age = AgeCalculator.age(dob);
    if (age.years == 0) {
      return "${age.months.toString()} M";
    } else {
      return "${age.years}Y/${age.months}M";
    }
  }
}
