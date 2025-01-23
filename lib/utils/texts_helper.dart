import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class TextsHelper {
  Locale? currentLocale = const Locale('fa');

  String convertDigitsByLocale(String text) {
    if (currentLocale!.languageCode == 'fa' ||
        currentLocale!.languageCode == 'ar') {
      return text.toPersianDigit();
    }
    return text.toEnglishDigit();
  }

  TextDirection getReverseDirectionByLocale() {
    if (currentLocale!.languageCode == 'fa' ||
        currentLocale!.languageCode == 'ar') {
      return TextDirection.ltr;
    }
    return TextDirection.rtl;
  }

  TextDirection getDirectionByLocale() {
    if (currentLocale!.languageCode == 'fa' ||
        currentLocale!.languageCode == 'ar') {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}
