import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
    this.backgroundColor = Colors.white24,
  });

  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color backgroundColor;

  @override

  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint =
    Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Create gradient paint
    final gradientPaint =
    Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    gradientPaint.shader = SweepGradient(
      colors: gradientColors,
      tileMode: TileMode.clamp,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    ).createShader(rect);

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}