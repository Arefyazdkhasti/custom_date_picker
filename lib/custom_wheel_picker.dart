import 'package:dual_custom_date_picker/utils/texts_helper.dart';
import 'package:material_ui/material_ui.dart';

import 'utils/global_configs.dart';

class CustomWheelPicker extends StatefulWidget {
  const CustomWheelPicker({
    this.values,
    this.initialValue,
    this.onValueChanged,
    this.children,
    this.initialItem = 0,
    this.onSelectedItemChanged,
    this.highlightColor,
    this.borderRadius,
    this.itemExtent = 50,
    this.height = 200,
    this.textStyle,
    this.formatValue,
    this.needConvertionByLocale = false,
    this.selectedItemStyle,
    this.itemStyle,
    this.showSelectionHighlight = true,
    this.magnification = 1.0,
    this.useMagnifier = false,
    this.squeeze = 1.1,
    super.key,
  }) : assert(
         (values != null && initialValue != null) || children != null,
         'Either values and initialValue or children must be provided.',
       ),
       assert(
         values == null || children == null,
         'Use either values or children, not both.',
       );

  // Values mode: Day, Month, Year, etc.
  final List<int>? values;
  final int? initialValue;
  final ValueChanged<int>? onValueChanged;

  // Custom children mode: Equivalent to CupertinoPicker children.
  final List<Widget>? children;
  final int initialItem;
  final ValueChanged<int>? onSelectedItemChanged;

  // Appearance
  final Color? highlightColor;
  final BorderRadiusGeometry? borderRadius;
  final double itemExtent;
  final double height;

  final TextStyle? textStyle;
  final TextStyle? selectedItemStyle;
  final TextStyle? itemStyle;

  // Formatting
  final String Function(int value)? formatValue;
  final bool needConvertionByLocale;

  // Wheel configuration
  final bool showSelectionHighlight;
  final double magnification;
  final bool useMagnifier;
  final double squeeze;

  @override
  State<CustomWheelPicker> createState() => _CustomWheelPickerState();
}

class _CustomWheelPickerState extends State<CustomWheelPicker> {
  late FixedExtentScrollController _scrollController;

  int? _selectedValue;

  bool get _isValuesMode => widget.values != null;

  int get _initialIndex {
    if (!_isValuesMode) {
      return widget.initialItem;
    }

    final index = widget.values!.indexOf(widget.initialValue!);

    return index < 0 ? 0 : index;
  }

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.initialValue;

    _scrollController = FixedExtentScrollController(initialItem: _initialIndex);
  }

  @override
  void didUpdateWidget(covariant CustomWheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    final initialValueChanged = oldWidget.initialValue != widget.initialValue;

    final initialItemChanged = oldWidget.initialItem != widget.initialItem;

    final valuesChanged = oldWidget.values != widget.values;

    if (initialValueChanged || initialItemChanged || valuesChanged) {
      _selectedValue = widget.initialValue;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpToItem(_initialIndex);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  TextStyle? _getItemStyle(int index) {
    if (!_isValuesMode) {
      return widget.textStyle;
    }

    final isSelected = widget.values![index] == _selectedValue;

    if (isSelected) {
      return widget.selectedItemStyle ??
          widget.textStyle ??
          TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          );
    }

    return widget.itemStyle ??
        widget.textStyle ??
        Theme.of(context).textTheme.titleMedium;
  }

  String _formatValue(int value) {
    final formattedValue = widget.formatValue?.call(value) ?? value.toString();

    // convert digits by locale if jalali picker
    if (widget.needConvertionByLocale) {
      return TextsHelper().convertDigitsByLocale(formattedValue);
    }

    return formattedValue;
  }

  Widget _buildValueItem(int index) {
    final value = widget.values![index];

    return Center(
      child: Text(_formatValue(value), style: _getItemStyle(index)),
    );
  }

  void _onItemChanged(int index) {
    if (_isValuesMode) {
      final value = widget.values![index];

      setState(() {
        _selectedValue = value;
      });

      widget.onValueChanged?.call(value);
    } else {
      widget.onSelectedItemChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.showSelectionHighlight)
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color:
                      widget.highlightColor ??
                      Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: widget.borderRadius ?? globalBorderRadius * 1.5,
                ),
              ),
            ),

          ListWheelScrollView.useDelegate(
            controller: _scrollController,
            itemExtent: widget.itemExtent,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.003,
            diameterRatio: 1.5,
            magnification: widget.magnification,
            useMagnifier: widget.useMagnifier,
            squeeze: widget.squeeze,
            onSelectedItemChanged: _onItemChanged,
            childDelegate: _isValuesMode
                ? ListWheelChildBuilderDelegate(
                    childCount: widget.values!.length,
                    builder: (context, index) {
                      return _buildValueItem(index);
                    },
                  )
                : ListWheelChildListDelegate(children: widget.children!),
          ),
        ],
      ),
    );
  }
}
