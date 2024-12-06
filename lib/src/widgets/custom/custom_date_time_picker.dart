import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'custom_time_picker.dart';

Future<void> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDateTime,
  bool initDeadlineHasTime = false,
  final DateTime? maxDate,
  final DateTime? minDate,
  final void Function(DateTime?, {required bool hasTime})? onDone,
  final void Function(DateTime?, {required bool hasTime})? onCancel,
  final void Function(DateTime?, {required bool hasTime})? onClear,
}) {
  assert(
    initDeadlineHasTime
        ? initDeadlineHasTime == (initialDateTime != null)
        : true,
    'When initDeadlineHasTime is true, initialDateTime cannot be null.',
  );
  return showModalBottomSheet<DateTime?>(
    context: context,
    isScrollControlled: true, //expands content
    builder: (BuildContext context) => CustomDateTimePicker(
      initialDateTime: initialDateTime,
      initDateTimeHasTime: initDeadlineHasTime,
      maxDate: maxDate,
      minDate: minDate,
      onDone: onDone,
      onCancel: onCancel,
      onClear: onClear,
    ),
  );
}

class CustomDateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final bool initDateTimeHasTime;
  final DateTime? maxDate;
  final DateTime? minDate;
  final void Function(DateTime?, {required bool hasTime})? onDone;
  final void Function(DateTime?, {required bool hasTime})? onCancel;
  final void Function(DateTime?, {required bool hasTime})? onClear;

  const CustomDateTimePicker({
    super.key,
    this.initialDateTime,
    this.initDateTimeHasTime = false,
    this.maxDate,
    this.minDate,
    this.onDone,
    this.onCancel,
    this.onClear,
  }) : assert(
          initDateTimeHasTime
              ? initDateTimeHasTime == (initialDateTime != null)
              : true,
          'When initDateTimeHasTime=True, initialDateTime cannot be null.',
        );

  @override
  State<CustomDateTimePicker> createState() => CustomDateTimePickerState();
}

class CustomDateTimePickerState extends State<CustomDateTimePicker> {
  late ThemeData _theme;
  late DateTime? _deadline;
  late bool _hasTime;
  late DateTime? _timeDue;

  @override
  void initState() {
    super.initState();
    _deadline = widget.initialDateTime;
    _hasTime = widget.initDateTimeHasTime;
    _timeDue = _hasTime ? widget.initialDateTime : null;
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    super.didChangeDependencies();
  }

  DateTime? sumDateTime() {
    if (_deadline == null) return null;
    final DateTime dueDate = DateUtils.dateOnly(_deadline!);
    if (!_hasTime || _timeDue == null) return dueDate;
    return dueDate.add(
      Duration(hours: _timeDue!.hour, minutes: _timeDue!.minute),
    );
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
          _DatePickerAppBar(
            onCancel: () {
              if (widget.onCancel != null) {
                widget.onCancel!(sumDateTime(), hasTime: _hasTime);
              }
              Navigator.pop(context);
            },
            onDone: () {
              if (widget.onDone != null) {
                widget.onDone!(sumDateTime(), hasTime: _hasTime);
              }
              Navigator.pop(context);
            },
          ),
          Container(
            height: 380,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            // margin: const EdgeInsets.only(bottom: 16.0),
            child: SfDateRangePicker(
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: _theme.colorScheme.surfaceContainerLow,
              ),
              backgroundColor: _theme.colorScheme.surfaceContainerLow,
              showNavigationArrow: true,
              initialSelectedDate: widget.initialDateTime,
              maxDate: widget.maxDate,
              minDate: widget.minDate,
              onSelectionChanged: (newSelectedDate) {
                if (newSelectedDate.value.runtimeType == DateTime) {
                  setState(() {
                    _deadline = newSelectedDate.value;
                  });
                }
              },
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32.0),
            leading: const Icon(Icons.history_toggle_off_rounded, size: 22),
            title: const Text('Include Time'),
            trailing: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: _hasTime,
                onChanged: _deadline == null
                    ? null
                    : (isEnabled) => setState(() {
                          _hasTime = isEnabled;
                        }),
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32.0),
            leading: const Icon(Icons.schedule_rounded, size: 22),
            title: const Text('Time'),
            trailing: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              onPressed: !_hasTime
                  ? null
                  : () {
                      showCustomTimePicker(
                        context: context,
                        initialTime: _timeDue,
                        onDone: (newTime) => setState(() {
                          _timeDue = newTime;
                        }),
                        // onDateTimeChanged: Do something if needed,
                      );
                    },
              child: Text(
                !_hasTime || _timeDue == null
                    ? 'None'
                    : DateFormat('h:mm aaa').format(_timeDue!),
              ),
            ),
          ),
          const SizedBox(height: 28.0),
          _ClearButton(
            onClear: () {
              if (widget.onClear != null) {
                widget.onClear!(null, hasTime: false);
              }
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 18.0)
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final void Function() onClear;

  const _ClearButton({
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: MaterialButton(
        onPressed: onClear,
        minWidth: double.infinity,
        height: 48,
        child: const Text(
          'Clear',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class _DatePickerAppBar extends StatelessWidget {
  final void Function() onCancel;
  final void Function() onDone;

  const _DatePickerAppBar({
    required this.onCancel,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 15.0),
          PlatformTextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
      title: const Text('Select Date'),
      centerTitle: true,
      actions: [
        PlatformTextButton(
          onPressed: onDone,
          child: const Text('Done'),
        ),
        const SizedBox(width: 12.0)
      ],
      forceMaterialTransparency: true,
    );
  }
}
