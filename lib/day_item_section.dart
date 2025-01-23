import 'package:flutter/material.dart';
import '/../utils/enums/picker_mode.dart';
import '/../utils/texts_helper.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'utils/global_configs.dart';

class DayItemSection extends StatelessWidget {
  const DayItemSection({
    super.key,
    required this.pickerType,
    required this.date,
    required this.isSelected,
    this.isCurrentDate = false,
    this.price,
    required this.onTap,
    this.isEnabled = true,
    this.selectedDayColor,
    this.defaultDayColor,
    this.currentDayColor,
    this.disabledDytColor,
    this.selectedDayBorderColor,
    this.defaultDayBorderColor,
    this.textColor,
    this.disabledTextColor,
    this.priceColor,
    this.betweenRangeColor,
    this.isBetweenRange = false,
    required this.primaryColor,
    required this.primaryContainerColor,
  });

  final PickerType pickerType;
  final DateTime date;
  final bool isSelected;
  final bool isCurrentDate;
  final String? price;
  final VoidCallback onTap;
  final bool isEnabled;

  final Color? selectedDayColor;
  final Color? selectedDayBorderColor;

  final Color? defaultDayColor;
  final Color? defaultDayBorderColor;

  final Color? currentDayColor;
  final Color? disabledDytColor;

  final Color? textColor;
  final Color? disabledTextColor;

  final Color? priceColor;

  final Color? betweenRangeColor;
  final bool isBetweenRange;

  final Color primaryColor;
  final Color primaryContainerColor;
  @override
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    late Color boxColor;
    late Color borderColor;

    if (isEnabled) {
      if (isSelected) {
        boxColor =
            selectedDayColor ?? primaryContainerColor.withValues(alpha: 0.6);
        borderColor = selectedDayBorderColor ?? primaryColor;
      } else if (isBetweenRange) {
        boxColor = betweenRangeColor ??
            selectedDayColor ??
            primaryContainerColor.withValues(alpha: 0.3);
        borderColor = Colors.transparent;
      } else if (isCurrentDate) {
        boxColor = currentDayColor ?? theme.colorScheme.secondaryContainer;
      } else {
        boxColor = defaultDayColor ?? Colors.transparent;
        borderColor = defaultDayBorderColor ??
            theme.colorScheme.outline.withValues(alpha: 0.2);
      }
    } else {
      boxColor =
          disabledDytColor ?? theme.colorScheme.outline.withValues(alpha: 0.04);
    }

    return InkWell(
      borderRadius: globalBorderRadius * 1.5,
      onTap: () => isEnabled ? onTap() : null,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 45,
        height: 45,
        margin: globalMarginAll / 3,
        decoration: BoxDecoration(
          borderRadius: globalBorderRadius * 1.5,
          color: boxColor,
          border: isCurrentDate || !isEnabled
              ? null
              : Border.all(
                  width: 1,
                  color: borderColor,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pickerType == PickerType.dateTime
                  ? date.day.toString()
                  : TextsHelper().convertDigitsByLocale(
                      date.toJalali().day.toString(),
                    ),
              style: theme.textTheme.titleMedium!.copyWith(
                color: isEnabled
                    ? textColor ?? theme.colorScheme.onSurface
                    : disabledTextColor ??
                        theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            if (price != null && price! != nullString && isEnabled)
              if (price != null && price! != nullString && isEnabled)
                FittedBox(
                  child: Text(
                    pickerType == PickerType.dateTime
                        ? price!
                            .toEnglishDigit()
                            .substring(0, price!.length - 4)
                            .seRagham()
                        : TextsHelper()
                            .convertDigitsByLocale(price!)
                            .substring(0, price!.length - 4)
                            .seRagham(),
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: priceColor ?? theme.colorScheme.outline,
                      fontSize: 10,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
