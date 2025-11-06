import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TimePickerPainter extends CustomPainter {
  final int selectedHour;
  final int selectedMinute;
  final double hourRotation;
  final double minuteRotation;

  TimePickerPainter({
    required this.selectedHour,
    required this.selectedMinute,
    required this.hourRotation,
    required this.minuteRotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw outer neumorphic circle
    _drawNeumorphicCircle(canvas, center, 159.0);

    // Draw inner neumorphic circle
    _drawNeumorphicCircle(canvas, center, 85.0);

    // Draw rotated outer dial (Hours)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(hourRotation * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);
    _drawOuterDial(canvas, center);
    canvas.restore();

    // Draw rotated inner dial (Minutes)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(minuteRotation * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);
    _drawInnerDial(canvas, center);
    canvas.restore();

    // Draw fixed elements
    _drawPointers(canvas, center);
    _drawCenterDisplay(canvas, center);
  }

  void _drawNeumorphicCircle(Canvas canvas, Offset center, double radius) {
    // Outer dark shadow
    final darkShadowPaint = Paint()
      ..color = const Color(0xFFD1D9E6).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center.translate(6, 6), radius, darkShadowPaint);

    // Inner light shadow
    final lightShadowPaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center.translate(-6, -6), radius, lightShadowPaint);

    // Main circle
    final circlePaint = Paint()
      ..color = const Color(0xFFF5F7FA)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    // Inner shadow effect
    final innerShadowRect = Rect.fromCircle(center: center, radius: radius);
    final innerShadowPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          const Color(0xFFD1D9E6).withOpacity(0.2),
          const Color(0xFFF5F7FA).withOpacity(0),
        ],
        [0.0, 0.6],
      );
    canvas.drawCircle(center, radius - 2, innerShadowPaint);
  }

  void _drawOuterDial(Canvas canvas, Offset center) {
    final outerRadius = 154.0;

    // Draw hour tick marks
    for (int i = 0; i < 24; i++) {
      final angle = (i / 24) * 2 * math.pi - math.pi / 2;
      final tickLength = i % 2 == 0 ? 6.0 : 6.0;
      final startRadius = outerRadius - tickLength;

      final x1 = center.dx + startRadius * math.cos(angle);
      final y1 = center.dy + startRadius * math.sin(angle);
      final x2 = center.dx + outerRadius * math.cos(angle);
      final y2 = center.dy + outerRadius * math.sin(angle);

      final tickPaint = Paint()
        ..shader = ui.Gradient.linear(Offset(x1, y1), Offset(x2, y2), [
          const Color(0xFFFFB366),
          const Color(0xFFFF9933),
        ])
        ..strokeWidth = i % 2 == 0 ? 2.5 : 2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), tickPaint);
    }

    // Draw hour numbers
    for (int i = 0; i < 24; i++) {
      if (i % 2 != 0) continue; // Only draw even hours

      final angle = (i / 24) * 2 * math.pi - math.pi / 2;
      final distance = outerRadius - 25;
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString().padLeft(2, '0'),
          style: TextStyle(
            color: selectedHour == i ? Color(0xFF0C2B4E) : null,
            foreground: selectedHour != i
                ? (Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 0),
                      const Offset(0, 20),
                      [Color(0xFFFFB366), Color(0xFFFF9933)],
                    ))
                : null,
            fontSize: selectedHour == i ? 16 : 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-hourRotation * math.pi / 180);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Draw odd hour numbers (smaller)
    for (int i = 1; i < 24; i += 2) {
      final angle = (i / 24) * 2 * math.pi - math.pi / 2;
      final distance = outerRadius - 25;
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString().padLeft(2, '0'),
          style: TextStyle(
            color: selectedHour == i ? Color(0xFF0C2B4E) : null,
            foreground: selectedHour != i
                ? (Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 0),
                      const Offset(0, 20),
                      [Color(0xFFFFB366), Color(0xFFFF9933)],
                    ))
                : null,
            fontSize: selectedHour == i ? 16 : 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-hourRotation * math.pi / 180);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  void _drawInnerDial(Canvas canvas, Offset center) {
    final innerRadius = 80.0;

    // Draw minute tick marks
    for (int i = 0; i < 60; i++) {
      final angle = (i / 60) * 2 * math.pi - math.pi / 2;
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 12.0 : 6.0;
      final startRadius = innerRadius - tickLength;

      final x1 = center.dx + startRadius * math.cos(angle);
      final y1 = center.dy + startRadius * math.sin(angle);
      final x2 = center.dx + innerRadius * math.cos(angle);
      final y2 = center.dy + innerRadius * math.sin(angle);

      final tickPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(x1, y1),
          Offset(x2, y2),
          isMajor
              ? [const Color(0xFFFFB366), const Color(0xFFFF9933)]
              : [const Color(0xFFFFD4A8), const Color(0xFFFFBD7A)],
        )
        ..strokeWidth = isMajor ? 2 : 1.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), tickPaint);
    }
  }

  void _drawPointers(Canvas canvas, Offset center) {
    // Draw "Hours" indicator at top with gradient

    final hourPointerPath = Path();
    hourPointerPath.moveTo(center.dx, center.dy - 100);
    hourPointerPath.lineTo(center.dx - 10, center.dy - 84);
    hourPointerPath.lineTo(center.dx + 10, center.dy - 84);
    hourPointerPath.close();

    final hourPointerPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.dx, center.dy - 157),
        Offset(center.dx, center.dy - 145),
        [const Color(0xFFFFB366), const Color(0xFFFF9933)],
      )
      ..style = PaintingStyle.fill;
    canvas.drawPath(hourPointerPath, hourPointerPaint);

    // Draw "Hours" label with gradient
    final hoursTextPainter = TextPainter(
      text: TextSpan(
        text: 'Hours',
        style: TextStyle(
          foreground: Paint()
            ..shader = ui.Gradient.linear(
              const Offset(0, 0),
              const Offset(0, 14),
              [Color(0xFF6B7280), Color(0xFF9CA3AF)],
            ),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    hoursTextPainter.layout();
    hoursTextPainter.paint(
      canvas,
      Offset(center.dx - hoursTextPainter.width / 2, center.dy - 120),
    );

    // Draw "Minutes" label on right with gradient
    final minutesTextPainter = TextPainter(
      text: TextSpan(
        text: 'Minutes',
        style: TextStyle(
          foreground: Paint()
            ..shader = ui.Gradient.linear(
              const Offset(0, 0),
              const Offset(0, 14),
              [Color(0xFFFFB366), Color(0xFFFF9933)],
            ),
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    minutesTextPainter.layout();
    minutesTextPainter.paint(
      canvas,
      Offset(center.dx - hoursTextPainter.width / 2, center.dy - 50),
    );
  }

  void _drawCenterDisplay(Canvas canvas, Offset center) {
    final timeTextPainter = TextPainter(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'HH',
            style: TextStyle(
              color: Color(0xFFD4D4D4),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: selectedHour.toString().padLeft(2, '0'),
            style: TextStyle(
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 0),
                  const Offset(0, 40),
                  [const Color(0xFFFFB366), const Color(0xFFFF9933)],
                ),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ':',
            style: TextStyle(
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 0),
                  const Offset(0, 40),
                  [const Color(0xFFFFB366), const Color(0xFFFF9933)],
                ),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: selectedMinute.toString().padLeft(2, '0'),
            style: TextStyle(
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(0, 0),
                  const Offset(0, 40),
                  [const Color(0xFFFFB366), const Color(0xFFFF9933)],
                ),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: 'MM',
            style: TextStyle(
              color: Color(0xFFD4D4D4),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );
    timeTextPainter.layout();
    timeTextPainter.paint(
      canvas,
      Offset(center.dx - timeTextPainter.width / 2, center.dy - 18),
    );
  }

  @override
  bool shouldRepaint(TimePickerPainter oldDelegate) {
    return oldDelegate.selectedHour != selectedHour ||
        oldDelegate.selectedMinute != selectedMinute ||
        oldDelegate.hourRotation != hourRotation ||
        oldDelegate.minuteRotation != minuteRotation;
  }
}
