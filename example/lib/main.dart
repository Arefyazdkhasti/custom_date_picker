import 'package:dual_custom_date_picker/custom_date_picker.dart';
import 'package:dual_custom_date_picker/simple_date_picker.dart';
import 'package:dual_custom_date_picker/utils/enums/picker_mode.dart';
import 'package:dual_custom_date_picker/utils/texts_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalenderType currentCalenderType = CalenderType.simple;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Directionality(
        textDirection: TextsHelper().getReverseDirectionByLocale(),
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Simple Mode:"),
                  CupertinoSwitch(
                    value: currentCalenderType == CalenderType.simple,
                    onChanged: (value) {
                      setState(() {
                        currentCalenderType =
                            value ? CalenderType.simple : CalenderType.complex;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (currentCalenderType == CalenderType.simple) ...[
                SimpleDatePicker(
                  pickerType: PickerType.jalali,
                  onDateSelected: (date) {
                    debugPrint("onDateSelected: ${date.toString()}");
                  },
                  currentMonth: DateTime.now().add(Duration(days: -30)),
                ),
              ] else ...[
                CustomDatePicker(
                  onDateSelected: (date) {
                    debugPrint("onDateSelected: ${date.toString()}");
                  },
                  datePickerMode: PickerMode.range,
                  datePickerType: PickerType.jalali,
                  fixedMode: true,
                  needToShowSelectedDaysBox: true,
                  needToShowChangeCalenderMode: true,
                  needToShowTodayButton: true,
                  currentMonth: DateTime.now(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
