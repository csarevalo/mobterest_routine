import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom/custom_date_time_picker.dart';

class RoutineStartDateTimeButton extends StatefulWidget {
  final DateTime? start;
  final void Function(DateTime?, {required bool hasTime})? onUpdate;
  final void Function(DateTime?, {required bool hasTime})? onClear;

  const RoutineStartDateTimeButton({
    super.key,
    this.start,
    this.onUpdate,
    this.onClear,
  });

  @override
  State<RoutineStartDateTimeButton> createState() =>
      _RoutineStartDateTimeButtonState();
}

class _RoutineStartDateTimeButtonState
    extends State<RoutineStartDateTimeButton> {
  late DateTime? start;
  late String startText;
  late bool hasTime;

  @override
  void initState() {
    start = widget.start;
    updateStartText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Start: ',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            // height: 32,
            child: CupertinoButton(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  const Icon(Icons.edit_calendar_rounded),
                  const SizedBox(width: 8.0),
                  Text(
                    startText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              onPressed: () => showDateTimePicker(
                context: context,
                onDone: updateRoutineStart,
                onClear: clearRoutineStart,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateStartText({bool hasTime = false}) {
    if (start == null) {
      startText = 'None';
    } else {
      // hasTime = start!.isAfter(DateUtils.dateOnly(start!));
      if (!hasTime) {
        startText = DateFormat("MMM d, y").format(start!);
      } else {
        startText = DateFormat("M/d/yy\n h:mma").format(start!);
      }
    }
  }

  void updateRoutineStart(dt, {required hasTime}) {
    setState(() {
      start = dt;
    });
    updateStartText(hasTime: hasTime);
    if (widget.onUpdate != null) {
      widget.onUpdate!(dt, hasTime: hasTime);
    }
  }

  void clearRoutineStart(dt, {required hasTime}) {
    setState(() {
      start = null;
    });
    updateStartText(hasTime: hasTime);
    if (widget.onClear != null) {
      widget.onClear!(dt, hasTime: hasTime);
    }
  }
}
