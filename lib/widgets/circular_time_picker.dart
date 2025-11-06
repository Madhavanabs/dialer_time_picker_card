import 'dart:math' as math;

import 'package:custom_card/widgets/time_picker_painter.dart';
import 'package:flutter/material.dart';

class CircularTimePicker extends StatefulWidget {
  final int selectedHour;
  final int selectedMinute;
  final Function(int hour, int minute) onTimeChanged;

  const CircularTimePicker({
    super.key,
    required this.selectedHour,
    required this.selectedMinute,
    required this.onTimeChanged,
  });

  @override
  State<CircularTimePicker> createState() => _CircularTimePickerState();
}

class _CircularTimePickerState extends State<CircularTimePicker> {
  double _hourRotation = 0;
  double _minuteRotation = 0;
  double _lastAngle = 0;
  bool _isDraggingHour = false;
  bool _isDraggingMinute = false;

  @override
  void didUpdateWidget(CircularTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedHour != widget.selectedHour) {
      _hourRotation = -(widget.selectedHour / 24) * 360;
    }
    if (oldWidget.selectedMinute != widget.selectedMinute) {
      _minuteRotation = -(widget.selectedMinute / 60) * 360;
    }
  }

  void _handlePanStart(DragStartDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final center = Offset(box.size.width / 2, box.size.height / 2);
    final position = box.globalToLocal(details.globalPosition);

    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    _lastAngle = math.atan2(dy, dx);

    if (distance > 115 && distance < 165) {
      _isDraggingHour = true;
      _isDraggingMinute = false;
    } else if (distance > 45 && distance < 105) {
      _isDraggingMinute = true;
      _isDraggingHour = false;
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDraggingHour && !_isDraggingMinute) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final center = Offset(box.size.width / 2, box.size.height / 2);
    final position = box.globalToLocal(details.globalPosition);

    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final currentAngle = math.atan2(dy, dx);

    double angleDiff = currentAngle - _lastAngle;

    if (angleDiff > math.pi) {
      angleDiff -= 2 * math.pi;
    } else if (angleDiff < -math.pi) {
      angleDiff += 2 * math.pi;
    }

    _lastAngle = currentAngle;

    setState(() {
      if (_isDraggingHour) {
        _hourRotation += angleDiff * 180 / math.pi;
        _hourRotation = _hourRotation % 360;

        int hour = ((-_hourRotation / 360 * 24).round()) % 24;
        if (hour < 0) hour += 24;

        if (hour != widget.selectedHour) {
          widget.onTimeChanged(hour, widget.selectedMinute);
        }
      } else if (_isDraggingMinute) {
        _minuteRotation += angleDiff * 180 / math.pi;
        _minuteRotation = _minuteRotation % 360;

        int minute = ((-_minuteRotation / 360 * 60).round()) % 60;
        if (minute < 0) minute += 60;

        if (minute != widget.selectedMinute) {
          widget.onTimeChanged(widget.selectedHour, minute);
        }
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _isDraggingHour = false;
      _isDraggingMinute = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 360,
      child: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: TimePickerPainter(
              selectedHour: widget.selectedHour,
              selectedMinute: widget.selectedMinute,
              hourRotation: _hourRotation,
              minuteRotation: _minuteRotation,
            ),
          ),
        ),
      ),
    );
  }
}
