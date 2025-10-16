import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'change_month_year_modal.dart';
import 'controller/calender_controller.dart';
import 'day_item_section.dart';
import 'utils/date_helper.dart';
import 'utils/global_configs.dart';
import 'utils/iconsax.dart';
import 'utils/enums/picker_mode.dart';
import 'utils/texts_helper.dart';

class CustomDatePicker extends StatefulWidget {
  //current month to show in the screen
  final DateTime? currentMonth;

  //with setting initialDate your calender would be selectable from the initialDate
  final DateTime? initialDate;

  //with setting lastDate your calender would be selectable until the lastDate
  final DateTime? lastDate;

  //prices to show for each date in the calender if any
  final List<String>? prices;

  //function to call when a month changed and fetch new prices for that month
  final Function(DateTime)? onFetchPrices;

  final PickerType datePickerType;

  ///  Modes can be one of the following
  ///  single -> User can only select one and only one day
  ///  range  -> User can select range of days
  ///  modes can be interchangeable during run time with 'fixedMode = true' or not with 'fixedMode = false'
  final PickerMode datePickerMode;

  ///calender type
  ///simple -> Cupertino style calender
  ///complex -> Material style calender with month and year picker, price showing ability and so on
  final CalenderType calenderType;

  //is mode are interchangeable during run time or not
  final bool fixedMode;

  ///For single mode you have to set rangeDates to (SelectedDate, null)
  ///For range mode you have to set rangeDates to (SelectedStartDate, SelectedEndDate)
  final (DateTime?, DateTime?)? rangeDates;

  ///single mode variables
  final Function(DateTime?) onDateSelected;

  ///range mode variables
  final Function(DateTime?, DateTime?)? onRangeDateSelected;

  ///if modes changes during run time 'onChangePickerMode' function will be called
  final Function(PickerMode)? onChangePickerMode;

  //clear end date
  final Function()? onClearEndDate;

  ///custom day item
  final DayItemSection? currentDayItem;
  final DayItemSection? selectedDayItem;
  final DayItemSection? notSelectedDayItem;
  final DayItemSection? disabledDayItem;

  ///custom theme
  final Color? selectedDayColor;
  final Color? selectedDayBorderColor;

  final Color? defaultDayColor;
  final Color? defaultDayBorderColor;

  final Color? currentDayColor;
  final Color? disabledDytColor;

  final Color? textColor;
  final Color? disabledTextColor;

  final Color? primaryColor;
  final Color? primaryContainerColor;

  final Color? betweenRangeColor;

  ///conditional booleans
  final bool needToShowSelectedDaysBox;
  final bool needToShowChangeCalenderMode;
  final bool needToShowTodayButton;

  const CustomDatePicker({
    super.key,
    this.currentMonth,
    this.onFetchPrices,
    this.initialDate,
    this.lastDate,
    this.prices,
    required this.onDateSelected,
    this.datePickerMode = PickerMode.single,
    this.datePickerType = PickerType.jalali,
    this.fixedMode = true,
    this.rangeDates,
    this.onRangeDateSelected,
    this.onChangePickerMode,
    this.onClearEndDate,
    this.currentDayItem,
    this.selectedDayItem,
    this.notSelectedDayItem,
    this.disabledDayItem,
    this.selectedDayColor,
    this.defaultDayColor,
    this.currentDayColor,
    this.disabledDytColor,
    this.selectedDayBorderColor,
    this.defaultDayBorderColor,
    this.textColor,
    this.disabledTextColor,
    this.primaryColor,
    this.primaryContainerColor,
    this.betweenRangeColor,
    this.needToShowSelectedDaysBox = true,
    this.needToShowChangeCalenderMode = true,
    this.needToShowTodayButton = true,
    this.calenderType = CalenderType.simple,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  CalenderController calenderController = CalenderController();
  bool isInit = true;
  late PickerMode datePickerMode;
  late PickerType pickerType;
  late CalenderType calenderType;

  late DateTime currentMonth;

  late List<dynamic> visibleDates;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  late Color primary;
  late Color primaryContainer;

  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      initVariables();
    }
    super.didChangeDependencies();
  }

  void initVariables() {
    var theme = Theme.of(context);
    //fill colors with input variables or default values
    primary = widget.primaryColor ?? theme.colorScheme.primary;
    primaryContainer =
        widget.primaryContainerColor ?? theme.colorScheme.primaryContainer;

    datePickerMode = widget.datePickerMode;
    pickerType = widget.datePickerType;
    calenderType = widget.calenderType;

    //set current month to now if not provided
    currentMonth = widget.currentMonth ?? DateTime.now().copyWith(day: 1);
    //get visible dates of the current month
    visibleDates = pickerType == PickerType.dateTime
        ? getVisibleDatesGeorgian(currentMonth)
        : getVisibleDatesJalali(currentMonth.toJalali().copy(day: 1));

    //set selected start date and end date
    selectedStartDate = widget.rangeDates?.$1;
    selectedEndDate = widget.rangeDates?.$2;

    // update the UI
    setState(() {});
  }

  List<DateTime> getVisibleDatesGeorgian(DateTime month) {
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int daysBeforeFirst = firstDayOfMonth.weekday == 7
        ? 1
        : firstDayOfMonth.weekday == 6
            ? 0
            : firstDayOfMonth.weekday + 1;

    DateTime startDate =
        firstDayOfMonth.add(Duration(days: daysBeforeFirst * -1));
    List<DateTime> visibleDates = [];
    for (int i = 0;
        i <
            calenderController.getDaysInMonth(
                  pickerType,
                  month.year,
                  month.month,
                ) +
                daysBeforeFirst;
        i++) {
      visibleDates.add(startDate.add(Duration(days: i)));
    }

    return visibleDates;
  }

  List<Jalali> getVisibleDatesJalali(Jalali month) {
    Jalali firstDayOfMonth = Jalali(month.year, month.month, 1);
    int daysBeforeFirst = firstDayOfMonth.weekDay - 1;

    Jalali startDate = firstDayOfMonth.addDays(daysBeforeFirst * -1);
    List<Jalali> visibleDates = [];
    for (int i = 0;
        i <
            calenderController.getDaysInMonth(
                  pickerType,
                  month.year,
                  month.month,
                ) +
                daysBeforeFirst;
        i++) {
      visibleDates.add(startDate.addDays(i));
    }
    return visibleDates;
  }

  void goToNextMonth() {
    widget.prices?.clear();

    var tempMonth = currentMonth;

    setState(() {
      if (tempMonth.month == 12) {
        tempMonth = DateTime(currentMonth.year + 1, 1);
      } else {
        tempMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      }

      //disable next month if lastDate is provided
      if (widget.lastDate != null &&
          calenderController.isAfter(
            tempMonth,
            widget.lastDate!,
            needDayComparison: false,
          )) {
        return;
      }

      currentMonth = tempMonth;
      visibleDates = pickerType == PickerType.dateTime
          ? getVisibleDatesGeorgian(currentMonth.copyWith(day: 1))
          : getVisibleDatesJalali(currentMonth.toJalali().copy(day: 1));
    });
    //call on fetch prices if exists
    if (widget.onFetchPrices != null) widget.onFetchPrices!(currentMonth);
  }

  void goToPreviousMonth() {
    widget.prices?.clear();

    var tempMonth = currentMonth;

    setState(() {
      if (tempMonth.month == 1) {
        tempMonth = DateTime(currentMonth.year - 1, 12, 1);
      } else {
        tempMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      }

      //disable previous month if initialDate is provided
      if (widget.initialDate != null &&
          calenderController.isBefore(
            tempMonth,
            widget.initialDate!,
            needDayComparison: false,
          )) {
        return;
      }

      currentMonth = tempMonth;
      visibleDates = pickerType == PickerType.dateTime
          ? getVisibleDatesGeorgian(currentMonth.copyWith(day: 1))
          : getVisibleDatesJalali(currentMonth.toJalali().copy(day: 1));
    });

    //call on fetch prices if exists
    if (widget.onFetchPrices != null) widget.onFetchPrices!(currentMonth);
  }

  void changeRange(DateTime date) {
    ///if no date selected yet, set the selection as start date
    ///if start day was selected and the new selection is after that set selected dat as the end Date, otherwise set it as start date
    ///if the same day as end or start date was selected, set it as start date and set end date as null
    if (selectedStartDate == null && selectedEndDate == null) {
      selectedStartDate = date;
    } else if (selectedStartDate != null && selectedEndDate == null) {
      if (calenderController.isBefore(date, selectedStartDate!)) {
        selectedStartDate = date;
      } else {
        selectedEndDate = date;
      }
    } else if (selectedStartDate != null && selectedEndDate != null) {
      if (calenderController.isTheSame(selectedStartDate!, date)) {
        selectedEndDate = null;
      } else if (calenderController.isTheSame(selectedEndDate!, date)) {
        selectedStartDate = date;
        selectedEndDate = null;
      } else {
        selectedStartDate = date;
        selectedEndDate = null;
      }
    }

    //call onRangeDateSelected if exists
    if (widget.onRangeDateSelected != null) {
      widget.onRangeDateSelected!(selectedStartDate, selectedEndDate);
    }

    //update the UI
    setState(() {});
  }

  Future<void> openMonthYearSelectionPanel() async {
    await showModalBottomSheet(
      context: context,
      enableDrag: false,
      barrierColor: Colors.black.withValues(alpha: 0.52),
      builder: (context) {
        return ChangeMonthYearModal(
          current: currentMonth,
          startDate: widget.lastDate == null ? widget.currentMonth : null,
          lastDate: widget.lastDate,
          pickerType: pickerType,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          widget.onDateSelected(null);
          //deselect the day if change month or year
          selectedStartDate = null;

          currentMonth = value;
          visibleDates = pickerType == PickerType.dateTime
              ? getVisibleDatesGeorgian(currentMonth)
              : getVisibleDatesJalali(currentMonth.toJalali());
        });
        //call on fetch prices if exists after the current month changes
        if (widget.onFetchPrices != null) widget.onFetchPrices!(currentMonth);
      }
    });
  }

  //change calendar type from gregorian to jalali and vice versa
  //go to today
  Widget _buildCalenderChangeTypeSection() {
    var theme = Theme.of(context);

    //not show this section if both ShowChangeCalenderMode and TodayButton show are false
    if (!widget.needToShowChangeCalenderMode && !widget.needToShowTodayButton) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: globalMargin * 5,
      child: Row(
        children: [
          if (widget.needToShowChangeCalenderMode)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  pickerType = pickerType == PickerType.jalali
                      ? PickerType.dateTime
                      : PickerType.jalali;
                });
                visibleDates = pickerType == PickerType.dateTime
                    ? getVisibleDatesGeorgian(currentMonth.copyWith(day: 1))
                    : getVisibleDatesJalali(
                        currentMonth.toJalali().copy(day: 1));
              },
              icon: Icon(
                Iconsax.repeat_linear,
                size: 24,
                color: widget.primaryColor,
              ),
              label: Text(
                pickerType == PickerType.jalali ? 'تقویم میلادی' : 'تقویم شمسی',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: widget.primaryColor,
                ),
              ),
            ),
          const Spacer(),
          if (widget.needToShowTodayButton)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  currentMonth = DateTime.now();
                  visibleDates = pickerType == PickerType.dateTime
                      ? getVisibleDatesGeorgian(currentMonth)
                      : getVisibleDatesJalali(
                          currentMonth.toJalali().copy(day: 1),
                        );
                });
              },
              icon: Icon(
                Iconsax.calendar_2_linear,
                size: 24,
                color: widget.primaryColor,
              ),
              label: Text(
                'امروز',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: widget.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  //Build the calender selected dates on top
  ///If fixed mode and its Single -> show only one selected day
  ///If Mode is Range -> show start and end dates
  ///enable ability to clear end date only if fixed mode is false
  Widget _buildCalenderSelectedDates() {
    var theme = Theme.of(context);
    if (widget.fixedMode && datePickerMode == PickerMode.single) {
      return Row(
        children: [
          const SizedBox(width: 20),
          const Icon(
            Iconsax.note_1_linear,
            size: 28,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              selectedStartDate == null
                  ? 'انتخاب روز'
                  : pickerType == PickerType.jalali
                      ? selectedStartDate!
                          .toLocal()
                          .toPersianDateStr(showDayStr: false)
                          .removeYearFromPersianDate()
                      : DateFormat.MMMMd().format(selectedStartDate!),
              style: theme.textTheme.labelLarge,
            ),
          ),
          const SizedBox(width: 20),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: [
              const Icon(
                Iconsax.note_1_linear,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تاریخ رفت',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedStartDate == null
                          ? '-'
                          : pickerType == PickerType.jalali
                              ? selectedStartDate!
                                  .toLocal()
                                  .toPersianDateStr(showDayStr: false)
                                  .removeYearFromPersianDate()
                              : DateFormat.MMMMd().format(selectedStartDate!),
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              const Icon(
                Iconsax.note_1_linear,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تاریخ برگشت',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    datePickerMode == PickerMode.single
                        ? InkWell(
                            onTap: () {
                              //change mode to range
                              setState(() {
                                datePickerMode = PickerMode.range;
                              });
                              //call onChangePickerMode if exists
                              if (widget.onChangePickerMode != null) {
                                widget.onChangePickerMode!(datePickerMode);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.add_linear,
                                  size: 20,
                                  color: widget.primaryColor,
                                ),
                                Text(
                                  'افزودن بازگشت',
                                  style: theme.textTheme.labelLarge!.copyWith(
                                    color: widget.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                selectedEndDate == null
                                    ? '-'
                                    : pickerType == PickerType.jalali
                                        ? selectedEndDate!
                                            .toLocal()
                                            .toPersianDateStr(showDayStr: false)
                                            .removeYearFromPersianDate()
                                        : DateFormat.MMMMd()
                                            .format(selectedEndDate!),
                                style: theme.textTheme.labelLarge,
                              ),
                              if (selectedEndDate != null && !widget.fixedMode)
                                InkWell(
                                  borderRadius: globalBorderRadius * 10,
                                  onTap: selectedEndDate == null
                                      ? null
                                      : () {
                                          //set mode to single and make end date null
                                          setState(() {
                                            datePickerMode = PickerMode.single;
                                            selectedEndDate = null;
                                          });
                                          //call onChangePickerMode if exists
                                          if (widget.onChangePickerMode !=
                                              null) {
                                            widget.onChangePickerMode!(
                                                datePickerMode);
                                          }

                                          //call onClearEndDate if exists
                                          if (widget.onClearEndDate != null) {
                                            widget.onClearEndDate!();
                                          }
                                        },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildCalenderHeader() {
    var theme = Theme.of(context);

    return Padding(
      padding: globalMargin * 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Directionality(
            textDirection: TextsHelper().getDirectionByLocale(),
            child: TextButton.icon(
              onPressed: () => pickerType == PickerType.jalali
                  ? goToPreviousMonth()
                  : goToNextMonth(),
              icon: Icon(
                Iconsax.arrow_right_3_linear,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
              label: Text(
                pickerType == PickerType.jalali ? 'ماه قبل' : 'ماه بعد',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
              child: TextButton(
            onPressed: () async => await openMonthYearSelectionPanel(),
            child: Text(
              pickerType == PickerType.jalali
                  ? currentMonth
                      .toLocal()
                      .toPersianDateStr()
                      .removeDayFromPersianDate()
                  : DateFormat.yMMMM().format(currentMonth),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          )),
          Directionality(
            textDirection: TextsHelper().getReverseDirectionByLocale(),
            child: TextButton.icon(
              onPressed: () => pickerType == PickerType.jalali
                  ? goToNextMonth()
                  : goToPreviousMonth(),
              icon: Icon(
                Iconsax.arrow_left_2_linear,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
              label: Text(
                pickerType == PickerType.jalali ? 'ماه بعد' : 'ماه قبل',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysName() {
    var weekDays = pickerType == PickerType.jalali
        ? calenderController.jalaliWeekDays
        : calenderController.georgianWeekDays;

    return Directionality(
      textDirection: TextsHelper().getDirectionByLocale(),
      child: Padding(
        padding: globalMargin * 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays
              .map(
                (e) => Text(
                  e,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return GestureDetector(
      onHorizontalDragEnd: (dragDetail) {
        if (dragDetail.velocity.pixelsPerSecond.dx < 1) {
          pickerType == PickerType.jalali
              ? goToPreviousMonth()
              : goToNextMonth();
        } else {
          pickerType == PickerType.jalali
              ? goToNextMonth()
              : goToPreviousMonth();
        }
      },
      child: Directionality(
        textDirection: pickerType == PickerType.dateTime
            ? TextsHelper().getReverseDirectionByLocale()
            : TextsHelper().getDirectionByLocale(),
        child: Padding(
          padding: globalMargin * 5,
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 7,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: visibleDates.length,
            itemBuilder: (context, index) {
              return datePickerMode == PickerMode.single
                  ? _buildCalenderCell(index)
                  : _buildCalenderRangeCell(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCalenderCell(int index) {
    dynamic currentDate = visibleDates[index];

    int daysBeforeFirst = 0;

    if (pickerType == PickerType.jalali) {
      Jalali currentMonthInJalali = currentMonth.toJalali();
      Jalali firstDayOfMonth =
          Jalali(currentMonthInJalali.year, currentMonthInJalali.month, 1);

      daysBeforeFirst = firstDayOfMonth.weekDay - 1;
    } else {
      DateTime firstDayOfMonth =
          DateTime(currentMonth.year, currentMonth.month, 1);

      daysBeforeFirst = daysBeforeFirst = firstDayOfMonth.weekday == 7
          ? 1
          : firstDayOfMonth.weekday == 6
              ? 0
              : firstDayOfMonth.weekday + 1;
    }

    bool itsLastMonthDay = index < daysBeforeFirst;

    DateTime date =
        currentDate is Jalali ? currentDate.toDateTime() : currentDate;

    if (itsLastMonthDay) {
      return const SizedBox();
    }
    //disable previous days if initialDate is provided
    if (widget.initialDate != null &&
        calenderController.isBefore(date, widget.initialDate!)) {
      if (widget.disabledDayItem != null) {
        return widget.disabledDayItem!;
      } else {
        return DayItemSection(
          date: date,
          isSelected: true,
          isCurrentDate: false,
          isEnabled: false,
          price: null,
          onTap: () {},
          pickerType: pickerType,
          selectedDayColor: widget.selectedDayColor,
          defaultDayColor: widget.defaultDayColor,
          currentDayColor: widget.currentDayColor,
          disabledDytColor: widget.disabledDytColor,
          selectedDayBorderColor: widget.selectedDayBorderColor,
          defaultDayBorderColor: widget.defaultDayBorderColor,
          textColor: widget.textColor,
          disabledTextColor: widget.disabledTextColor,
          betweenRangeColor: widget.betweenRangeColor,
          primaryColor: primary,
          primaryContainerColor: primaryContainer,
        );
      }
    }
    //disable next days if lastDate is provided
    else if (widget.lastDate != null &&
        calenderController.isAfter(date, widget.lastDate!)) {
      if (widget.disabledDayItem != null) {
        return widget.disabledDayItem!;
      } else {
        return DayItemSection(
          date: date,
          isSelected: true,
          isCurrentDate: false,
          isEnabled: false,
          price: null,
          onTap: () {},
          pickerType: pickerType,
          selectedDayColor: widget.selectedDayColor,
          defaultDayColor: widget.defaultDayColor,
          currentDayColor: widget.currentDayColor,
          disabledDytColor: widget.disabledDytColor,
          selectedDayBorderColor: widget.selectedDayBorderColor,
          defaultDayBorderColor: widget.defaultDayBorderColor,
          textColor: widget.textColor,
          disabledTextColor: widget.disabledTextColor,
          betweenRangeColor: widget.betweenRangeColor,
          primaryColor: primary,
          primaryContainerColor: primaryContainer,
        );
      }
    }
    //make current selected date as selected in Single mode
    else if (selectedStartDate != null &&
        calenderController.isTheSame(selectedStartDate!, date)) {
      if (widget.currentDayItem != null) {
        return widget.currentDayItem!;
      } else {
        return DayItemSection(
          date: date,
          isSelected: true,
          isCurrentDate: false,
          price: widget.prices == null || widget.prices!.isEmpty
              ? null
              : widget.prices![index - daysBeforeFirst],
          onTap: () {
            widget.onDateSelected(null);

            //deselect the day if clicked on it
            setState(() {
              selectedStartDate = null;
            });
          },
          pickerType: pickerType,
          selectedDayColor: widget.selectedDayColor,
          defaultDayColor: widget.defaultDayColor,
          currentDayColor: widget.currentDayColor,
          disabledDytColor: widget.disabledDytColor,
          selectedDayBorderColor: widget.selectedDayBorderColor,
          defaultDayBorderColor: widget.defaultDayBorderColor,
          textColor: widget.textColor,
          disabledTextColor: widget.disabledTextColor,
          betweenRangeColor: widget.betweenRangeColor,
          primaryColor: primary,
          primaryContainerColor: primaryContainer,
        );
      }
      //current date in the calender
    } else if (calenderController.isTheSame(DateTime.now(), date)) {
      if (widget.currentDayItem != null) {
        return widget.currentDayItem!;
      } else {
        return DayItemSection(
          date: date,
          isSelected: false,
          isCurrentDate: true,
          price: widget.prices == null || widget.prices!.isEmpty
              ? null
              : widget.prices![index - daysBeforeFirst],
          onTap: () {
            widget.onDateSelected(date);

            setState(() {
              selectedStartDate = date;
            });
          },
          pickerType: pickerType,
          selectedDayColor: widget.selectedDayColor,
          defaultDayColor: widget.defaultDayColor,
          currentDayColor: widget.currentDayColor,
          disabledDytColor: widget.disabledDytColor,
          selectedDayBorderColor: widget.selectedDayBorderColor,
          defaultDayBorderColor: widget.defaultDayBorderColor,
          textColor: widget.textColor,
          disabledTextColor: widget.disabledTextColor,
          betweenRangeColor: widget.betweenRangeColor,
          primaryColor: primary,
          primaryContainerColor: primaryContainer,
        );
      }
      //other days in the calender
    } else {
      if (widget.notSelectedDayItem != null) {
        return widget.notSelectedDayItem!;
      } else {
        return DayItemSection(
          date: date,
          isSelected: false,
          price: widget.prices == null || widget.prices!.isEmpty
              ? null
              : widget.prices![index - daysBeforeFirst],
          onTap: () {
            widget.onDateSelected(date);

            setState(() {
              selectedStartDate = date;
            });
          },
          pickerType: pickerType,
          selectedDayColor: widget.selectedDayColor,
          defaultDayColor: widget.defaultDayColor,
          currentDayColor: widget.currentDayColor,
          disabledDytColor: widget.disabledDytColor,
          selectedDayBorderColor: widget.selectedDayBorderColor,
          defaultDayBorderColor: widget.defaultDayBorderColor,
          textColor: widget.textColor,
          disabledTextColor: widget.disabledTextColor,
          betweenRangeColor: widget.betweenRangeColor,
          primaryColor: primary,
          primaryContainerColor: primaryContainer,
        );
      }
    }
  }

  Widget _buildCalenderRangeCell(int index) {
    dynamic currentDate = visibleDates[index];

    int daysBeforeFirst;

    if (pickerType == PickerType.jalali) {
      Jalali currentMonthInJalali = currentMonth.toJalali();
      Jalali firstDayOfMonth =
          Jalali(currentMonthInJalali.year, currentMonthInJalali.month, 1);

      daysBeforeFirst = firstDayOfMonth.weekDay - 1;
    } else {
      DateTime firstDayOfMonth =
          DateTime(currentMonth.year, currentMonth.month, 1);

      daysBeforeFirst = daysBeforeFirst = firstDayOfMonth.weekday == 7
          ? 1
          : firstDayOfMonth.weekday == 6
              ? 0
              : firstDayOfMonth.weekday + 1;
    }

    bool itsLastMonthDay = index < daysBeforeFirst;

    DateTime date =
        currentDate is Jalali ? currentDate.toDateTime() : currentDate;

    if (itsLastMonthDay) {
      return const SizedBox();
    }
    //disable previous days if initialDate is provided
    if (widget.initialDate != null &&
        calenderController.isBefore(date, widget.initialDate!)) {
      return DayItemSection(
        date: date,
        isSelected: true,
        isCurrentDate: false,
        isEnabled: false,
        price: null,
        onTap: () => {},
        pickerType: pickerType,
        selectedDayColor: widget.selectedDayColor,
        defaultDayColor: widget.defaultDayColor,
        currentDayColor: widget.currentDayColor,
        disabledDytColor: widget.disabledDytColor,
        selectedDayBorderColor: widget.selectedDayBorderColor,
        defaultDayBorderColor: widget.defaultDayBorderColor,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        betweenRangeColor: widget.betweenRangeColor,
        primaryColor: primary,
        primaryContainerColor: primaryContainer,
      );
    }
    //disable next days if lastDate is provided
    else if (widget.lastDate != null &&
        calenderController.isAfter(date, widget.initialDate!)) {
      return DayItemSection(
        date: date,
        isSelected: true,
        isCurrentDate: false,
        isEnabled: false,
        price: null,
        onTap: () => {},
        pickerType: pickerType,
        selectedDayColor: widget.selectedDayColor,
        defaultDayColor: widget.defaultDayColor,
        currentDayColor: widget.currentDayColor,
        disabledDytColor: widget.disabledDytColor,
        selectedDayBorderColor: widget.selectedDayBorderColor,
        defaultDayBorderColor: widget.defaultDayBorderColor,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        betweenRangeColor: widget.betweenRangeColor,
        primaryColor: primary,
        primaryContainerColor: primaryContainer,
      );
    }
    //current selected start date in range mode
    else if (selectedStartDate != null &&
        calenderController.isTheSame(selectedStartDate!, date)) {
      return DayItemSection(
        date: date,
        isSelected: true,
        isCurrentDate: false,
        price: widget.prices == null || widget.prices!.isEmpty
            ? null
            : widget.prices![index - daysBeforeFirst],
        onTap: () => changeRange(date),
        pickerType: pickerType,
        selectedDayColor: widget.selectedDayColor,
        defaultDayColor: widget.defaultDayColor,
        currentDayColor: widget.currentDayColor,
        disabledDytColor: widget.disabledDytColor,
        selectedDayBorderColor: widget.selectedDayBorderColor,
        defaultDayBorderColor: widget.defaultDayBorderColor,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        betweenRangeColor: widget.betweenRangeColor,
        primaryColor: primary,
        primaryContainerColor: primaryContainer,
      );
      //current selected end date in range mode
    } else if (selectedEndDate != null &&
        calenderController.isTheSame(selectedEndDate!, date)) {
      return DayItemSection(
        date: date,
        isSelected: true,
        isCurrentDate: false,
        price: widget.prices == null || widget.prices!.isEmpty
            ? null
            : widget.prices![index - daysBeforeFirst],
        onTap: () => changeRange(date),
        pickerType: pickerType,
        selectedDayColor: widget.selectedDayColor,
        defaultDayColor: widget.defaultDayColor,
        currentDayColor: widget.currentDayColor,
        disabledDytColor: widget.disabledDytColor,
        selectedDayBorderColor: widget.selectedDayBorderColor,
        defaultDayBorderColor: widget.defaultDayBorderColor,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        betweenRangeColor: widget.betweenRangeColor,
        primaryColor: primary,
        primaryContainerColor: primaryContainer,
      );
      //between selected date and end date in range mode
    } else if ((selectedStartDate != null && selectedEndDate != null) &&
        calenderController.isBetween(
            date, selectedStartDate!, selectedEndDate!)) {
      return DayItemSection(
        date: date,
        isSelected: false,
        isBetweenRange: true,
        isCurrentDate: false,
        price: widget.prices == null || widget.prices!.isEmpty
            ? null
            : widget.prices![index - daysBeforeFirst],
        onTap: () => changeRange(date),
        pickerType: pickerType,
        selectedDayColor: widget.selectedDayColor,
        defaultDayColor: widget.defaultDayColor,
        currentDayColor: widget.currentDayColor,
        disabledDytColor: widget.disabledDytColor,
        selectedDayBorderColor: widget.selectedDayBorderColor,
        defaultDayBorderColor: widget.defaultDayBorderColor,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        betweenRangeColor: widget.betweenRangeColor,
        primaryColor: primary,
        primaryContainerColor: primaryContainer,
      );
      //current day
    } else if (calenderController.isTheSame(DateTime.now(), date)) {
      return DayItemSection(
        date: date,
        isSelected: false,
        isCurrentDate: true,
        price: widget.prices == null || widget.prices!.isEmpty
            ? null
            : widget.prices![index - daysBeforeFirst],
        onTap: () => changeRange(date),
        pickerType: pickerType,
        selectedDayColor: widget.selectedDayColor,
        defaultDayColor: widget.defaultDayColor,
        currentDayColor: widget.currentDayColor,
        disabledDytColor: widget.disabledDytColor,
        selectedDayBorderColor: widget.selectedDayBorderColor,
        defaultDayBorderColor: widget.defaultDayBorderColor,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        betweenRangeColor: widget.betweenRangeColor,
        primaryColor: primary,
        primaryContainerColor: primaryContainer,
      );
      //other days
    } else {
      return DayItemSection(
        date: date,
        isSelected: false,
        price: widget.prices == null || widget.prices!.isEmpty
            ? null
            : widget.prices![index - daysBeforeFirst],
        onTap: () => changeRange(date),
        pickerType: pickerType,
        selectedDayColor: widget.selectedDayColor,
        defaultDayColor: widget.defaultDayColor,
        currentDayColor: widget.currentDayColor,
        disabledDytColor: widget.disabledDytColor,
        selectedDayBorderColor: widget.selectedDayBorderColor,
        defaultDayBorderColor: widget.defaultDayBorderColor,
        textColor: widget.textColor,
        disabledTextColor: widget.disabledTextColor,
        betweenRangeColor: widget.betweenRangeColor,
        primaryColor: primary,
        primaryContainerColor: primaryContainer,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildComplexPicker();
  }

  Widget _buildComplexPicker() {
    var theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextsHelper().getDirectionByLocale(),
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 8),
          _buildCalenderChangeTypeSection(),
          const SizedBox(height: 8),
          //if need to show selected days, show _buildCalenderSelectedDates
          if (widget.needToShowSelectedDaysBox) ...[
            Container(
              width: width,
              margin: globalMargin * 5,
              decoration: BoxDecoration(
                borderRadius: globalBorderRadius * 1.5,
                border: Border.all(
                  width: 1,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildCalenderSelectedDates(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          _buildCalenderHeader(),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: width,
            child: _buildDaysName(),
          ),
          _buildCalendar(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
