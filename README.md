
# Custom Date Picker

A fully customizable date picker for Flutter that supports both **Jalali** and **Gregorian** calendars. This widget allows users to select a single date or a range of dates, making it ideal for various date-selection needs.

---

## Features

- **Dual Calendar Support**: Switch seamlessly between Jalali (Persian) and Gregorian calendars.
- **Single or Range Selection**:
  - Single Date: Choose one date.
  - Range: Select a start and end date.
- **Customizable Appearance**:
  - Modify colors, borders, day items, and more to match your theme.
- **Dynamic Prices**: Display additional data, like prices, for specific days.
- **Mode Interchangeability**: Toggle between single and range modes dynamically.
- **Today Button**: Quickly jump to the current date.
- **Next/Previous Navigation**: Navigate through months with ease.
- **Custom Day Items**: Define your own day widgets for selected, unselected, disabled, and current days.

---

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  custom_date_picker:
    path: /path_to_your_custom_date_picker
```

Then run:

```bash
flutter pub get
```

---

## Usage

### Basic Example

```dart
import 'package:custom_date_picker/custom_date_picker.dart';

CustomDatePicker(
  onDateSelected: (selectedDate) {
    print('Selected Date: $selectedDate');
  },
  datePickerMode: PickerMode.single,
  datePickerType: PickerType.jalali, // or PickerType.dateTime for Gregorian
)
```

### Range Selection Example

```dart
CustomDatePicker(
  datePickerMode: PickerMode.range,
  rangeDates: (null, null), // Initial range dates
  onRangeDateSelected: (startDate, endDate) {
    print('Start Date: $startDate');
    print('End Date: $endDate');
  },
)
```

### Advanced Example with Customization

```dart
CustomDatePicker(
  currentMonth: DateTime.now(),
  initialDate: DateTime(2023, 1, 1),
  lastDate: DateTime(2024, 12, 31),
  onFetchPrices: (month) {
    print('Fetch prices for: $month');
  },
  prices: ['\$100', '\$120', '\$90'], // Example prices
  datePickerType: PickerType.jalali,
  selectedDayColor: Colors.blue,
  primaryColor: Colors.orange,
  needToShowTodayButton: true,
  needToShowChangeCalenderMode: true,
  onDateSelected: (date) {
    print('Selected Date: $date');
  },
  onRangeDateSelected: (start, end) {
    print('Selected Range: $start to $end');
  },
  onChangePickerMode: (newMode) {
    print('Changed mode to: $newMode');
  },
)
```

---

## Props & Configuration

### Required Parameters

| Name                 | Type                                    | Description                           |
|----------------------|-----------------------------------------|---------------------------------------|
| `onDateSelected`     | `Function(DateTime?)`                  | Callback for a single date selection.|
| `datePickerMode`     | `PickerMode`                           | Selection mode: `single` or `range`. |
| `datePickerType`     | `PickerType`                           | Calendar type: `jalali` or `dateTime`.|

### Optional Parameters

| Name                     | Type                                       | Description                            |
|--------------------------|--------------------------------------------|----------------------------------------|
| `currentMonth`           | `DateTime?`                               | Initial month to display.              |
| `initialDate`            | `DateTime?`                               | Minimum selectable date.               |
| `lastDate`               | `DateTime?`                               | Maximum selectable date.               |
| `rangeDates`             | `(DateTime?, DateTime?)?`                 | Initial start and end dates for range. |
| `onRangeDateSelected`    | `Function(DateTime?, DateTime?)?`         | Callback for range date selection.     |
| `onChangePickerMode`     | `Function(PickerMode)?`                   | Callback when the selection mode changes. |
| `prices`                 | `List<String>?`                          | Additional data for days (e.g., prices). |
| `onFetchPrices`          | `Function(DateTime)?`                    | Fetch prices when the month changes.   |

### Appearance Customization

| Name                     | Type              | Description                            |
|--------------------------|-------------------|----------------------------------------|
| `selectedDayColor`       | `Color?`          | Background color for the selected day. |
| `currentDayColor`        | `Color?`          | Background color for the current day.  |
| `defaultDayColor`        | `Color?`          | Default day background color.          |
| `primaryColor`           | `Color?`          | Primary color for buttons and icons.   |
| `textColor`              | `Color?`          | Default text color.                    |

---

## Additional Features

- **Custom Day Widgets**: Override default day widgets with `DayItemSection`.
- **Multi-language Support**: Adjusts text direction for RTL (e.g., Persian) or LTR (e.g., English).

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
