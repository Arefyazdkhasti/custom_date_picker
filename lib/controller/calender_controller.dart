import 'package:shamsi_date/shamsi_date.dart';

import '../utils/date_helper.dart';
import '../utils/enums/picker_mode.dart';

class CalenderController {
  final List<String> jalaliWeekDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  final List<String> georgianWeekDays = [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  /// returns true if [first] is before [second]
  bool isBefore(
    DateTime first,
    DateTime second, {
    bool needDayComparison = true,
  }) {
    return first.year < second.year ||
        (first.year == second.year && first.month < second.month) ||
        (needDayComparison &&
            (first.year == second.year &&
                first.month == second.month &&
                first.day < second.day));
  }

  /// returns true if [first] is after [second]
  bool isAfter(
    DateTime first,
    DateTime second, {
    bool needDayComparison = true,
  }) {
    return first.year > second.year ||
        (first.year == second.year && first.month > second.month) ||
        (needDayComparison &&
            (first.year == second.year &&
                first.month == second.month &&
                first.day > second.day));
  }

  /// returns true if [first] and [second] are the same
  bool isTheSame(DateTime first, DateTime second) {
    return first.day == second.day &&
        first.month == second.month &&
        first.year == second.year;
  }

  /// returns true if [date] is between [start] and [end]
  bool isBetween(DateTime date, DateTime start, DateTime end) {
    return date.isBefore(end) && date.isAfter(start);
  }

  /// returns the number of days in a month
  int getDaysInMonth(
    PickerType pickerType,
    int year,
    int month,
  ) {
    if (pickerType == PickerType.jalali) {
      if (month == 12) {
        final bool isLeapYear = Jalali(year).isLeapYear();
        if (isLeapYear) return 30;
        return 29;
      }
      const List<int> daysInMonth = <int>[
        31,
        31,
        31,
        31,
        31,
        31,
        30,
        30,
        30,
        30,
        30,
        -1
      ];
      return daysInMonth[month - 1];
    } else {
      if (month == 2) {
        final bool isLeapYear = DateHelper().isLeapYear(year);
        if (isLeapYear) return 29;
        return 28;
      }
      const List<int> daysInMonth = <int>[
        31,
        -1,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31,
      ];
      return daysInMonth[month - 1];
    }
  }
}
