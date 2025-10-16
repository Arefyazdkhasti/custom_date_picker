import 'package:dual_custom_date_picker/utils/global_configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'controller/calender_controller.dart';
import 'utils/button_style.dart';
import 'utils/enums/picker_mode.dart';
import 'utils/texts_helper.dart';

class SimpleDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? lastDate;
  final DateTime? currentMonth;
  final PickerType pickerType;
  final Function(DateTime?) onDateSelected;
  final Function(DateTime?)? onDateCleared;

  /// Customization related
  final TextStyle? selectedItemStyle;
  final TextStyle? itemStyle;
  final Color? selectedItemBackgroundColor;
  final Color? selectedItemBorderColor;

  /// Select Button Related
  final Widget? selectDateButtonText;
  final ButtonStyle? selectDateButtonStyle;

  /// Clear Button Related
  final Widget? clearDateButton;

  /// Item Height for cupertino picker
  final double? itemHeight;

  const SimpleDatePicker({
    super.key,
    this.initialDate,
    this.lastDate,
    this.currentMonth,
    this.pickerType = PickerType.jalali,
    required this.onDateSelected,
    this.onDateCleared,
    // Customization related
    this.selectedItemStyle,
    this.itemStyle,
    this.selectedItemBackgroundColor,
    this.selectedItemBorderColor,
    this.selectDateButtonText,
    this.selectDateButtonStyle,
    this.clearDateButton,
    this.itemHeight = 200,
  });

  @override
  State<SimpleDatePicker> createState() => _SimpleDatePickerState();
}

class _SimpleDatePickerState extends State<SimpleDatePicker> {
  CalenderController calenderController = CalenderController();

  // 🔸 current selected values
  late int year;
  late int month;
  late int day;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final current = widget.currentMonth ?? now;

    if (widget.pickerType == PickerType.jalali) {
      final j = current.toJalali();
      year = j.year;
      month = j.month;
      day = j.day;
    } else {
      year = current.year;
      month = current.month;
      day = current.day;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final now = DateTime.now();
    final startDate = widget.initialDate ?? DateTime(1900, 1, 1);
    final endDate = widget.lastDate ?? now.add(const Duration(days: 365 * 50));

    // 🔸 recompute constrained lists every build
    late List<int> years;
    late List<int> months;
    late List<int> days;

    if (widget.pickerType == PickerType.jalali) {
      final jStart = startDate.toJalali();
      final jEnd = endDate.toJalali();

      years =
          List.generate(jEnd.year - jStart.year + 1, (i) => jStart.year + i);
      months = List.generate(12, (i) => i + 1).where((m) {
        if (year == jStart.year && m < jStart.month) return false;
        if (year == jEnd.year && m > jEnd.month) return false;
        return true;
      }).toList();

      int totalDays =
          calenderController.getDaysInMonth(widget.pickerType, year, month);
      days = List.generate(totalDays, (i) => i + 1).where((d) {
        if (year == jStart.year && month == jStart.month && d < jStart.day) {
          return false;
        }
        if (year == jEnd.year && month == jEnd.month && d > jEnd.day) {
          return false;
        }
        return true;
      }).toList();
    } else {
      final gStart = startDate;
      final gEnd = endDate;

      years =
          List.generate(gEnd.year - gStart.year + 1, (i) => gStart.year + i);
      months = List.generate(12, (i) => i + 1).where((m) {
        if (year == gStart.year && m < gStart.month) return false;
        if (year == gEnd.year && m > gEnd.month) return false;
        return true;
      }).toList();

      int totalDays =
          calenderController.getDaysInMonth(widget.pickerType, year, month);
      days = List.generate(totalDays, (i) => i + 1).where((d) {
        if (year == gStart.year && month == gStart.month && d < gStart.day) {
          return false;
        }
        if (year == gEnd.year && month == gEnd.month && d > gEnd.day) {
          return false;
        }
        return true;
      }).toList();
    }

    final selectedYearIndex =
        years.indexWhere((y) => y == year).clamp(0, years.length - 1);
    final selectedMonthIndex =
        months.indexWhere((m) => m == month).clamp(0, months.length - 1);
    final selectedDayIndex =
        days.indexWhere((d) => d == day).clamp(0, days.length - 1);

    DateTime getSelectedDate() {
      if (widget.pickerType == PickerType.jalali) {
        return Jalali(year, month, day).toDateTime();
      } else {
        return DateTime(year, month, day);
      }
    }

    return Directionality(
      textDirection: TextsHelper().getReverseDirectionByLocale(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // 🔹 YEAR picker
              Expanded(
                child: _buildPickerWithHighlight(
                  height: widget.itemHeight ?? 200,
                  selectedIndex: selectedYearIndex,
                  initialItem: selectedYearIndex,
                  backgroundColor: widget.selectedItemBackgroundColor ??
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  borderColor: widget.selectedItemBorderColor,
                  onSelectedItemChanged: (i) {
                    setState(() {
                      year = years[i];
                      day = day.clamp(
                        1,
                        calenderController.getDaysInMonth(
                            widget.pickerType, year, month),
                      );
                    });
                  },
                  children: years
                      .map((y) => Center(
                            child: Text(
                              TextsHelper().convertDigitsByLocale(y.toString()),
                              style: y == year
                                  ? widget.selectedItemStyle ??
                                      TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      )
                                  : widget.itemStyle,
                            ),
                          ))
                      .toList(),
                ),
              ),

              // 🔹 MONTH picker
              Expanded(
                child: _buildPickerWithHighlight(
                  height: widget.itemHeight ?? 200,
                  selectedIndex: selectedMonthIndex,
                  initialItem: selectedMonthIndex,
                  backgroundColor: widget.selectedItemBackgroundColor ??
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  borderColor: widget.selectedItemBorderColor,
                  onSelectedItemChanged: (i) {
                    setState(() {
                      month = months[i];
                      day = day.clamp(
                        1,
                        calenderController.getDaysInMonth(
                            widget.pickerType, year, month),
                      );
                    });
                  },
                  children: months
                      .map((m) => Center(
                            child: Text(
                              widget.pickerType == PickerType.jalali
                                  ? TextsHelper().convertDigitsByLocale(
                                      Jalali(year, m, 1).formatter.mN,
                                    )
                                  : DateFormat.MMMM()
                                      .format(DateTime(2000, m, 1)),
                              style: m == month
                                  ? widget.selectedItemStyle ??
                                      TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      )
                                  : widget.itemStyle,
                            ),
                          ))
                      .toList(),
                ),
              ),

              // 🔹 DAY picker
              Expanded(
                child: _buildPickerWithHighlight(
                  height: widget.itemHeight ?? 200,
                  selectedIndex: selectedDayIndex,
                  initialItem: selectedDayIndex,
                  backgroundColor: widget.selectedItemBackgroundColor ??
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  borderColor: widget.selectedItemBorderColor,
                  onSelectedItemChanged: (i) {
                    setState(() => day = days[i]);
                  },
                  children: days
                      .map((d) => Center(
                            child: Text(
                              TextsHelper().convertDigitsByLocale(d.toString()),
                              style: d == day
                                  ? widget.selectedItemStyle ??
                                      TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      )
                                  : widget.itemStyle,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: widget.selectDateButtonStyle ?? buttonStyle,
                  onPressed: () {
                    widget.onDateSelected(getSelectedDate());
                  },
                  child:
                      widget.selectDateButtonText ?? const Text('انتخاب تاریخ'),
                ),
              ),
              if (widget.clearDateButton != null) ...[
                const SizedBox(width: 12),
                Expanded(child: widget.clearDateButton!),
              ],
            ],
          )
        ],
      ),
    );
  }
}

Widget _buildPickerWithHighlight({
  required List<Widget> children,
  required int initialItem,
  required ValueChanged<int> onSelectedItemChanged,
  required int selectedIndex,
  required double height,
  double itemExtent = 44,
  Color? backgroundColor,
  Color? borderColor,
}) {
  return SizedBox(
    height: height,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // 👇 The highlight band for selected item
        IgnorePointer(
          ignoring: true,
          child: Container(
            height: itemExtent,
            width: double.infinity,
            margin: globalMargin * 2.5,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor ?? Colors.transparent,
              ),
              borderRadius: globalBorderRadius * 2,
            ),
          ),
        ),

        CupertinoPicker(
          scrollController:
              FixedExtentScrollController(initialItem: initialItem),
          itemExtent: itemExtent,
          magnification: 1.1,
          useMagnifier: true,
          squeeze: 1.1,
          selectionOverlay: const SizedBox.shrink(),
          onSelectedItemChanged: onSelectedItemChanged,
          children: children,
        ),
      ],
    ),
  );
}
