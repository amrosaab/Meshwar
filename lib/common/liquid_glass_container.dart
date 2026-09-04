import 'dart:ui';
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// A glass surface that actually looks like glass — a translucent blurred
/// fill PLUS a painted specular highlight streak, matching the curved
/// light-reflection look of a soap bubble / Apple Liquid Glass, not just
/// a flat tinted rectangle. The highlight is what a plain
/// BackdropFilter+gradient combo can't produce on its own; this adds it
/// as a real painted layer on top.
///
/// Use [borderRadius] as a full pill (height / 2) for bars, or a fixed
/// value for chips/badges. Use [circular]: true for round icon badges.
class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final bool circular;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;
  final double fillOpacity;
  final double? width;
  final double? height;
  /// Overrides the default glassBlue* gradient with a single flat color
  /// (still blurred, still gets the highlight). Needed for callers that
  /// must control their own tint — e.g. CustomAppBar, whose existing
  /// callers pass Colors.transparent and rely on that staying transparent
  /// rather than being forced blue.
  final Color? tintColor;
  /// Overrides with a full custom Gradient instead of a single flat tint
  /// — for callers that want to keep a genuine multi-stop brand gradient
  /// (e.g. the red/rose beaconGradient on a hero card) while still gaining
  /// the blur and specular highlight, rather than being flattened to one
  /// color at a low, washed-out opacity. Takes priority over [tintColor]
  /// if both are somehow provided.
  final Gradient? gradientOverride;
  /// Whether to paint the rim border. Off for bars that want their own
  /// border treatment (e.g. a bottom-only hairline) instead of a full rim.
  final bool showBorder;
  /// Whether to paint the specular highlight streaks on top. Defaults to true.
  final bool showHighlight;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.circular = false,
    this.padding,
    this.blurSigma = 18,
    this.fillOpacity = 0.14,
    this.width,
    this.height,
    this.tintColor,
    this.gradientOverride,
    this.showBorder = true,
    this.showHighlight = false,
  }) : assert(
  !circular || (width != null && height != null),
  'circular LiquidGlassContainer requires explicit width and height',
  );

  @override
  Widget build(BuildContext context) {
    final shapeClip = circular
        ? ClipOval(child: _buildInner(context))
        : ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 24),
      child: _buildInner(context),
    );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: shapeClip);
    }
    return shapeClip;
  }

  Widget _buildInner(BuildContext context) {
    final radius = circular ? null : BorderRadius.circular(borderRadius ?? 24);
    final Gradient gradient;
    if (gradientOverride != null) {
      gradient = gradientOverride!;
    } else if (tintColor != null && tintColor!.opacity == 0) {
      // Caller explicitly wants no visible fill (e.g. Colors.transparent) —
      // stay fully transparent rather than forcing any tint through.
      gradient = const LinearGradient(
        colors: [Colors.transparent, Colors.transparent],
      );
    } else if (tintColor != null) {
      gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          tintColor!.withOpacity(fillOpacity + 0.06),
          tintColor!.withOpacity(fillOpacity),
        ],
      );
    } else {
      gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.glassBlueStrong.withOpacity(fillOpacity + 0.06),
          AppColors.glassBlue.withOpacity(fillOpacity),
        ],
      );
    }
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: circular ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: radius,
                gradient: gradient,
                border: showBorder
                    ? Border.all(color: Colors.white.withOpacity(0.4))
                    : null,
              ),
            ),
          ),
          // The actual specular highlight — a soft curved streak near the
          // top, painted directly rather than faked with a gradient
          // rectangle. This is what reads as "glass" vs. "tinted plastic".
          // Positioned.fill here now reliably matches the visible clipped
          // shape, since the Stack itself is size-locked by the SizedBox
          // above rather than inferring its size implicitly.
          if (showHighlight)
            Positioned.fill(
              child: CustomPaint(
                painter: _SpecularHighlightPainter(circular: circular),
              ),
            ),
          Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SpecularHighlightPainter extends CustomPainter {
  final bool circular;
  _SpecularHighlightPainter({required this.circular});

  @override
  void paint(Canvas canvas, Size size) {
    // Primary highlight: a wide, soft arc hugging the top edge — the
    // main "light glancing off the curve" streak.
    final primaryPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Colors.white.withOpacity(0.55),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final topArc = Path();
    if (circular) {
      topArc.addOval(Rect.fromLTWH(
          size.width * 0.08, -size.height * 0.15, size.width * 0.84, size.height * 0.6));
    } else {
      topArc.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.04, -size.height * 0.3, size.width * 0.92,
            size.height * 0.55),
        Radius.circular(size.height),
      ));
    }
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(topArc, primaryPaint);
    canvas.restore();

    // Secondary highlight: a small bright glint, upper-left — the
    // "hotspot" a bubble surface always has, not just an even wash.
    final glintPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.08, size.width * 0.22,
          size.height * 0.14),
      glintPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpecularHighlightPainter oldDelegate) => false;
}