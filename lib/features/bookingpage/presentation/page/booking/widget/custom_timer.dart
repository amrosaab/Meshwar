import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class CustomTimer extends CustomPainter {
  CustomTimer({
    required this.values,
    required this.backgroundColor,
    required this.color,
    required this.width,
  });
  final dynamic values;
  final Color backgroundColor, color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = width
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - values) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimer oldDelegate) {
    return values != oldDelegate.values ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
