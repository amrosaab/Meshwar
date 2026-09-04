import 'package:flutter/material.dart';
import 'dart:math' as math;

enum FuturisticVehicleType { car, auto, bike, van }

class FuturisticCarWidget extends StatelessWidget {
  final Color primaryColor;
  final double size;
  final FuturisticVehicleType type;
  final double bearing; // Current rotation in degrees

  const FuturisticCarWidget({
    super.key,
    this.primaryColor = Colors.white,
    this.size = 80.0,
    this.type = FuturisticVehicleType.car,
    this.bearing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Fixed World Shadow (Always casts to the same direction regardless of car rotation)
          _buildFixedShadow(),

          // 2. The 3D Body Painter
          CustomPaint(
            size: Size(size, size),
            painter: Vehicle3DProPainter(
              color: primaryColor,
              type: type,
              bearing: bearing,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedShadow() {
    // We want the shadow to stay consistent in "world space" to simulate 3D depth.
    // As the car rotates, the shadow stays offset to the bottom-right of the screen.
    return Container(
      width: size * 0.5,
      height: size * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(4, 6), // Consistent light source from top-left
          ),
        ],
      ),
    );
  }
}

class Vehicle3DProPainter extends CustomPainter {
  final Color color;
  final FuturisticVehicleType type;
  final double bearing;

  Vehicle3DProPainter({
    required this.color,
    required this.type,
    required this.bearing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    canvas.save();
    // Rotate the entire drawing based on bearing
    canvas.translate(center.dx, center.dy);
    canvas.rotate(bearing * math.pi / 180);
    canvas.translate(-center.dx, -center.dy);

    if (type == FuturisticVehicleType.car) {
      _drawHighEndCar(canvas, w, h);
    } else {
      _drawBasic(canvas, w, h);
    }

    canvas.restore();
  }

  void _drawHighEndCar(Canvas canvas, double w, double h) {
    final bodyPaint = Paint()..color = color..style = PaintingStyle.fill;
    final glassPaint = Paint()..color = const Color(0xFF1A1A1A)..style = PaintingStyle.fill;
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.2)..style = PaintingStyle.stroke..strokeWidth = 1;

    // 1. Lower Body Shell (Aerodynamic Silhouette from Image)
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.28, h * 0.12);
    // Front Bumper (Very Rounded)
    bodyPath.quadraticBezierTo(w * 0.5, h * 0.08, w * 0.72, h * 0.12);
    // Sides
    bodyPath.lineTo(w * 0.78, h * 0.85);
    // Rear (Rounded)
    bodyPath.quadraticBezierTo(w * 0.5, h * 0.92, w * 0.22, h * 0.85);
    bodyPath.lineTo(w * 0.28, h * 0.12);
    bodyPath.close();

    // Draw main body with slight depth shading
    canvas.drawPath(bodyPath, Paint()..color = Color.lerp(color, Colors.black, 0.1)!);
    canvas.drawPath(bodyPath, bodyPaint);

    // 2. Hood Details (The "V" shape from image)
    final hoodPath = Path();
    hoodPath.moveTo(w * 0.38, h * 0.15);
    hoodPath.quadraticBezierTo(w * 0.5, h * 0.3, w * 0.62, h * 0.15);
    canvas.drawPath(hoodPath, Paint()..color = Colors.black.withValues(alpha: 0.05)..style = PaintingStyle.stroke..strokeWidth = 2);

    // 3. Side Mirrors
    final mirrorPaint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.18, h * 0.35, w * 0.08, h * 0.04), const Radius.circular(2)), mirrorPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.74, h * 0.35, w * 0.08, h * 0.04), const Radius.circular(2)), mirrorPaint);

    // 4. The Glass Cabin (Cockpit)
    // To simulate 3D, we offset the roof slightly based on the rotation?
    // Actually, let's keep it centered but add high gloss.
    final roofRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.52), width: w * 0.44, height: h * 0.38);
    canvas.drawRRect(RRect.fromRectAndRadius(roofRect, Radius.circular(w * 0.04)), glassPaint);

    // Front Windshield Shine
    final shinePath = Path();
    shinePath.moveTo(w * 0.32, h * 0.38);
    shinePath.lineTo(w * 0.68, h * 0.38);
    canvas.drawPath(shinePath, Paint()..color = Colors.white24..strokeWidth = 3..strokeCap = StrokeCap.round);

    // 5. Wheels & Rims (Visible from top)
    final tirePaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    final rimPaint = Paint()..color = const Color(0xFFE0E0E0)..style = PaintingStyle.fill;

    void drawWheel(double x, double y) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(x, y), width: w * 0.1, height: h * 0.2), const Radius.circular(2)), tirePaint);
      canvas.drawCircle(Offset(x, y), w * 0.03, rimPaint); // Chrome center
    }
    drawWheel(w * 0.25, h * 0.3); // FL
    drawWheel(w * 0.75, h * 0.3); // FR
    drawWheel(w * 0.23, h * 0.75); // RL
    drawWheel(w * 0.77, h * 0.75); // RR

    // 6. Lighting
    // Front LEDs (Sharp Strips)
    final ledPaint = Paint()..color = Colors.white..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.32, h * 0.12, w * 0.1, 2), const Radius.circular(1)), ledPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.58, h * 0.12, w * 0.1, 2), const Radius.circular(1)), ledPaint);

    // Rear Tail Lights (Thin Red)
    final tailPaint = Paint()..color = const Color(0xFFFF1744);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.3, h * 0.88, w * 0.12, 2.5), const Radius.circular(1)), tailPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.58, h * 0.88, w * 0.12, 2.5), const Radius.circular(1)), tailPaint);

    // Final Specular Rim Highlight
    canvas.drawPath(bodyPath, highlightPaint);
  }

  void _drawBasic(Canvas canvas, double w, double h) {
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant Vehicle3DProPainter oldDelegate) {
    return oldDelegate.bearing != bearing || oldDelegate.color != color || oldDelegate.type != type;
  }
}
