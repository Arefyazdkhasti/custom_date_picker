class DateHelper {
  bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
}

extension StringExtension on String {
  String removeYearFromPersianDate() {
    List<String> items = split(' ');
    items.removeLast();
    return items.join(' ');
  }

  String removeDayFromPersianDate() {
    List<String> items = split(' ');
    items.removeAt(0);
    return items.join(' ');
  }
}
