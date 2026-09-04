
import 'package:flutter/material.dart';
import '../../common/app_colors.dart';

/// The "punk" signature shape: a panel with two corners cut at 45° instead
/// of rounded — the classic sci-fi HUD panel notch (Cyberpunk 2077, Deus Ex,
/// military targeting displays). Used for hero panels and primary CTAs;
/// smaller chips/pills keep soft rounding so tap targets still read clearly.
class AngularPanel extends StatelessWidget {
  final Widget child;
  final double cut;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final bool glow;

  const AngularPanel({
    super.key,
    required this.child,
    this.cut = 18,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.4,
    this.glow = true,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedBorder = borderColor ?? AppColors.meshwarRed.withOpacity(0.6);
    return Container(
      decoration: glow
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.meshwarRed.withOpacity(0.22),
                  blurRadius: 26,
                  spreadRadius: -6,
                ),
              ],
            )
          : null,
      child: CustomPaint(
        foregroundPainter: _AngularBorderPainter(
          cut: cut,
          color: resolvedBorder,
          width: borderWidth,
        ),
        child: ClipPath(
          clipper: _AngularClipper(cut: cut),
          child: Container(
            decoration: BoxDecoration(color: fillColor ?? AppColors.surface(context)),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _AngularClipper extends CustomClipper<Path> {
  final double cut;
  const _AngularClipper({required this.cut});

  @override
  Path getClip(Size size) {
    final c = cut.clamp(0, size.height / 2).toDouble();
    return Path()
      ..moveTo(c, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - c)
      ..lineTo(size.width - c, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, c)
      ..close();
  }

  @override
  bool shouldReclip(covariant _AngularClipper oldClipper) => oldClipper.cut != cut;
}

class _AngularBorderPainter extends CustomPainter {
  final double cut;
  final Color color;
  final double width;
  const _AngularBorderPainter({required this.cut, required this.color, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final c = cut.clamp(0, size.height / 2).toDouble();
    final path = Path()
      ..moveTo(c, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - c)
      ..lineTo(size.width - c, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, c)
      ..close();
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AngularBorderPainter oldDelegate) =>
      oldDelegate.cut != cut || oldDelegate.color != color || oldDelegate.width != width;
}