import 'package:flutter/material.dart';
import '../../common/app_colors.dart';

/// Frames [child] with four small L-shaped corner brackets, like a
/// targeting reticle or a HUD-highlighted panel. Purely decorative —
/// stack it around a hero element (an avatar, a key stat, a headline) to
/// mark it as "the important thing on screen."
class HudBrackets extends StatelessWidget {
  final Widget child;
  final double inset;
  final double armLength;
  final Color? color;
  final EdgeInsets padding;

  const HudBrackets({
    super.key,
    required this.child,
    this.inset = -10,
    this.armLength = 14,
    this.color,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.meshwarRed;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(padding: padding, child: child),
        Positioned(top: inset, left: inset, child: _corner(c, 0)),
        Positioned(top: inset, right: inset, child: _corner(c, 1)),
        Positioned(bottom: inset, right: inset, child: _corner(c, 2)),
        Positioned(bottom: inset, left: inset, child: _corner(c, 3)),
      ],
    );
  }

  Widget _corner(Color c, int quadrant) {
    // 0=TL 1=TR 2=BR 3=BL
    return Transform.rotate(
      angle: quadrant * 1.5707963267948966, // quadrant * pi/2
      child: CustomPaint(
        size: Size(armLength, armLength),
        painter: _CornerPainter(color: c),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => oldDelegate.color != color;
}