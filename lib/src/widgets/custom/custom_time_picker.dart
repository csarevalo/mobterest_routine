import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Future<void> showCustomTimePicker({
  required BuildContext context,
  final DateTime? initialTime,
  final void Function(DateTime)? onDone,
  final void Function(DateTime)? onCancel,
  final void Function(DateTime)? onDateTimeChanged,
  final Color? backgroundColor,
}) {
  return showModalBottomSheet<DateTime?>(
    context: context,
    builder: (context) {
      return CustomTimePicker(
        initialTime: initialTime,
        backgroundColor: backgroundColor,
        onDone: onDone,
        onCancel: onCancel,
        onDateTimeChanged: onDateTimeChanged,
      );
    },
  );
}

class CustomTimePicker extends StatefulWidget {
  final DateTime? initialTime;
  final void Function(DateTime)? onDone;
  final void Function(DateTime)? onCancel;
  final void Function(DateTime)? onDateTimeChanged;
  final Color? backgroundColor;

  const CustomTimePicker({
    super.key,
    this.initialTime,
    this.onDone,
    this.onCancel,
    this.onDateTimeChanged,
    this.backgroundColor,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late DateTime _time;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime ?? DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlatformTextButton(
                  onPressed: () {
                    if (widget.onCancel != null) widget.onCancel!(_time);
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const Text(
                  'Select Time',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.5,
                  ),
                ),
                PlatformTextButton(
                  onPressed: () {
                    if (widget.onDone != null) widget.onDone!(_time);
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          Container(
            height: 175,
            padding: const EdgeInsets.all(28.0),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              backgroundColor: widget.backgroundColor,
              initialDateTime: widget.initialTime,
              onDateTimeChanged: (newDateTime) {
                _time = newDateTime;
                if (widget.onDateTimeChanged != null) {
                  widget.onDateTimeChanged!(newDateTime);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
