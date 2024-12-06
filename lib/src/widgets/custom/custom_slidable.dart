import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomSlidable extends StatefulWidget {
  final SlidableController? controller;
  final Object? groupTag;
  final bool enabled;
  final bool closeOnScroll;
  final ActionPane? startActionPane;
  final ActionPane? endActionPane;
  final Axis direction;
  final DragStartBehavior dragStartBehavior;
  final bool useTextDirection;
  final Widget child;

  final HitTestBehavior behavior;
  final bool consumeOutsideTaps;

  const CustomSlidable({
    super.key,
    this.controller,
    this.groupTag,
    this.enabled = true,
    this.closeOnScroll = true,
    this.behavior = HitTestBehavior.opaque,
    this.consumeOutsideTaps = false,
    this.startActionPane,
    this.endActionPane,
    this.direction = Axis.horizontal,
    this.dragStartBehavior = DragStartBehavior.down,
    this.useTextDirection = true,
    required this.child,
  });

  @override
  State<CustomSlidable> createState() => _CustomSlidableState();
}

class _CustomSlidableState extends State<CustomSlidable>
    with TickerProviderStateMixin {
  late final SlidableController _controller;
  late bool _isActionPaneOpen;

  @override
  void initState() {
    super.initState();
    _controller = SlidableController(this);
    _isActionPaneOpen = false;
    _controller.actionPaneType.addListener(_actionPaneTypeListener);
  }

  @override
  void dispose() {
    _controller.actionPaneType.removeListener(_actionPaneTypeListener);
    _controller.dispose();
    super.dispose();
  }

  void _actionPaneTypeListener() {
    // debugPrint(_controller.actionPaneType.value.name);
    if (_controller.actionPaneType.value != ActionPaneType.none &&
        !_controller.closing &&
        !_isActionPaneOpen) {
      setState(() {
        _isActionPaneOpen = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      consumeOutsideTaps: widget.consumeOutsideTaps,
      behavior: widget.behavior,
      enabled: _isActionPaneOpen,
      onTapOutside: (_) {
        _controller.close();
        setState(() {
          _isActionPaneOpen = false;
        });
      },
      onTapInside: (_) {
        _controller.close();
        setState(() {
          _isActionPaneOpen = false;
        });
      },
      child: Slidable(
        key: widget.key,
        controller: _controller,
        groupTag: widget.groupTag,
        enabled: widget.enabled,
        closeOnScroll: widget.closeOnScroll,
        startActionPane: widget.startActionPane,
        endActionPane: widget.endActionPane,
        direction: widget.direction,
        dragStartBehavior: widget.dragStartBehavior,
        useTextDirection: widget.useTextDirection,
        child: IgnorePointer(
          ignoring: _isActionPaneOpen,
          child: widget.child,
        ),
      ),
    );
  }
}
