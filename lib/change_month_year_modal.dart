import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'utils/button_style.dart';
import 'utils/enums/picker_mode.dart';
import 'utils/global_configs.dart';
import 'utils/texts_helper.dart';

class ChangeMonthYearModal extends StatefulWidget {
  final DateTime? current;
  final DateTime? startDate;
  final DateTime? lastDate;

  final PickerType? pickerType;

  const ChangeMonthYearModal({
    super.key,
    this.current,
    this.startDate,
    this.lastDate,
    this.pickerType = PickerType.jalali,
  });

  @override
  State<ChangeMonthYearModal> createState() => _ChangeMonthYearModalState();
}

class _ChangeMonthYearModalState extends State<ChangeMonthYearModal>
    with SingleTickerProviderStateMixin {
  late DateTime current;
  late Jalali currentJalali;

  late TabController tabController;

  List<int> years = [];

  late int selectedYear;
  late int start;
  late int end;

  @override
  void initState() {
    current = widget.current ?? DateTime.now();
    currentJalali = current.toJalali();

    tabController = TabController(vsync: this, length: 2);
    selectedYear = current.year;

    //fill years from 1300 till 1500
    start = widget.pickerType == PickerType.jalali
        ? widget.startDate?.toJalali().year ?? 1300
        : widget.startDate?.year ?? 1900;
    end = widget.pickerType == PickerType.jalali
        ? widget.lastDate?.toJalali().year ?? 1500
        : widget.lastDate?.year ?? 2500;

    for (var i = start; i <= end; i++) {
      years.add(i);
    }

    super.initState();
  }

  static List<String> persianMonths = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  static List<String> georgianMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          border: null,
          backgroundColor: theme.colorScheme.surface,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;

              Navigator.pop(
                context,
                current,
              );
            },
            child: SafeArea(
                bottom: true,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: globalMargin * 5,
                      height: 50,
                      child: TabBar(
                        controller: tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        tabs: [
                          Center(
                            child: FittedBox(
                              child: Text(
                                'انتخاب ماه',
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          ),
                          Center(
                            child: FittedBox(
                              child: Text(
                                'انتخاب سال',
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 270,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Padding(
                            padding: globalMargin * 5,
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 2,
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: widget.pickerType == PickerType.jalali
                                  ? persianMonths.length
                                  : georgianMonths.length,
                              itemBuilder: (context, index) {
                                bool isSelected;

                                if (widget.pickerType == PickerType.jalali) {
                                  isSelected = currentJalali.month - 1 == index;
                                } else {
                                  isSelected = current.month - 1 == index;
                                }

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (widget.pickerType ==
                                          PickerType.jalali) {
                                        currentJalali = currentJalali.copy(
                                            month: index + 1);
                                      } else {
                                        current =
                                            current.copyWith(month: index + 1);
                                      }
                                    });
                                    tabController.animateTo(1);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.outline
                                                  .withValues(alpha: 0.4),
                                        ),
                                        color: isSelected
                                            ? theme.colorScheme.primaryContainer
                                                .withValues(alpha: 0.4)
                                            : null,
                                        borderRadius: globalBorderRadius * 1.5),
                                    child: Center(
                                      child: Text(
                                        widget.pickerType == PickerType.jalali
                                            ? persianMonths[index]
                                            : georgianMonths[index],
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: globalMargin * 5,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 180,
                                  child: CupertinoPicker(
                                    scrollController:
                                        FixedExtentScrollController(
                                      initialItem:
                                          widget.pickerType == PickerType.jalali
                                              ? currentJalali.year - start
                                              : current.year - start,
                                    ),
                                    itemExtent: 50,
                                    children: years
                                        .map(
                                          (e) => Center(
                                            child: Text(
                                              widget.pickerType ==
                                                      PickerType.jalali
                                                  ? TextsHelper()
                                                      .convertDigitsByLocale(
                                                      e.toString(),
                                                    )
                                                  : e.toString(),
                                              style:
                                                  theme.textTheme.titleMedium,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onSelectedItemChanged: (value) {
                                      selectedYear = value + start;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 56,
                                  width: MediaQuery.of(context).size.width,
                                  child: FilledButton(
                                    style: buttonStyle,
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        widget.pickerType == PickerType.jalali
                                            ? currentJalali
                                                .copy(year: selectedYear)
                                                .toDateTime()
                                            : current.copyWith(
                                                year: selectedYear,
                                              ),
                                      );
                                    },
                                    child: Text('انتخاب کن'),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
