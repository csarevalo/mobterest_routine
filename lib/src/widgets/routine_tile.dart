import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_slidable/flutter_slidable.dart';

import 'custom/custom_slidable.dart';

class RoutineTile extends StatelessWidget {
  final String title;
  final DateTime start;
  final String categoryName;
  final void Function()? onTap;
  final void Function()? onDelete;

  const RoutineTile({
    super.key,
    required this.title,
    required this.start,
    required this.categoryName,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: CustomSlidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                if (onDelete != null) onDelete!();
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
            )
          ],
        ),
        child: _RoutineTile(
          title: title,
          onTap: onTap,
          start: start,
          categoryName: categoryName,
        ),
      ),
    );
  }
}

class _RoutineTile extends StatelessWidget {
  const _RoutineTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.start,
    required this.categoryName,
  });

  final String title;
  final Function()? onTap;
  final DateTime start;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      subtitle: Column(
        children: [
          _RoutineTileRowItem(
            key: const ValueKey(1),
            icon: Icons.schedule_rounded,
            title: DateFormat(
              start.difference(DateUtils.dateOnly(start)).inMinutes > 0
                  ? 'EE, MMM d, y @ h:mm a'
                  : 'EE, MMM d, y',
            ).format(start),
            tooltipMsg: 'Start',
          ),
          const _RoutineTileRowItem(
            key: ValueKey(2),
            icon: Icons.event_repeat_rounded,
            title: 'Mon, Tue',
            tooltipMsg: 'Repeats',
          ),
          _RoutineTileRowItem(
            key: const ValueKey(3),
            icon: Icons.book_outlined,
            title: categoryName,
            tooltipMsg: 'Category',
          ),
        ],
      ),
    );
  }
}

class _RoutineTileRowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String tooltipMsg;
  const _RoutineTileRowItem({
    super.key,
    required this.icon,
    required this.title,
    required this.tooltipMsg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tooltip(
            message: tooltipMsg,
            child: Icon(
              icon,
              size: 18,
            ),
          ),
          const SizedBox(width: 4.0),
          Text(title),
        ],
      ),
      // child :TextSpan(),
    );
  }
}
