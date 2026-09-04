import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../common/common.dart';

/// The app's signature backdrop — "punk beacon" cyberpunk revision.
///
/// In dark mode: two glow "beacons" (Meshwar red + rose) drift behind a
/// faint circuit-trace grid, with a subtle scanline sweep over the top for
/// a CRT/HUD read. In light mode it backs off to a warm off-white with a
/// single quiet glow — same signature, daylight version — so this widget
/// is safe regardless of which theme is active.
/// Respects reduced-motion settings.
class CustomBackground extends StatefulWidget {
  final Widget? child;
  /// Overrides the default meshwarRed/signalRose beacon glow with a
  /// different color pair — e.g. the app's glassBlue* accent, for screens
  /// whose AppBar or panels are blue-glass rather than red-branded, so
  /// the ambient glow doesn't clash with what's floating on top of it.
  /// Null (the default) keeps the original red/rose brand glow.
  final Color? primaryGlowColor;
  final Color? secondaryGlowColor;

  const CustomBackground({
    super.key,
    this.child,
    this.primaryGlowColor,
    this.secondaryGlowColor,
  });

  @override
  State<CustomBackground> createState() => _CustomBackgroundState();
}

class _CustomBackgroundState extends State<CustomBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.backdropGradient : AppColors.lightBackdropGradient,
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = reduceMotion ? 0.0 : _controller.value * 2 * math.pi;
              return CustomPaint(
                painter: _BeaconPainter(
                  t,
                  isDark: isDark,
                  primaryColor: widget.primaryGlowColor,
                  secondaryColor: widget.secondaryGlowColor,
                ),
                size: Size.infinite,
              );
            },
          ),
          if (isDark) CustomPaint(painter: _CircuitGridPainter(), size: Size.infinite),
          if (isDark && !reduceMotion)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, _) =>
                  CustomPaint(painter: _ScanlinePainter(_scanController.value), size: Size.infinite),
            ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _BeaconPainter extends CustomPainter {
  final double t;
  final bool isDark;
  final Color? primaryColor;
  final Color? secondaryColor;
  _BeaconPainter(this.t, {required this.isDark, this.primaryColor, this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final redCenter = Offset(
      size.width * 0.2 + math.sin(t) * 24,
      size.height * 0.18 + math.cos(t) * 18,
    );
    final primary = primaryColor ?? AppColors.glassBlueStrong;
    // 3-stop gradient instead of 2 — a straight [color, transparent] radial
    // at this scale (0.55 * width) has a fast-falling midsection that reads
    // as a visible ring/arc rather than a soft ambient glow, especially
    // once something else (e.g. a glass panel) sits on top of it. Adding
    // a half-strength stop partway out spreads the falloff over more of
    // the radius, so the edge stops being perceptible as a band.
    final redGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          primary.withOpacity(isDark ? 0.22 : 0.08),
          primary.withOpacity(isDark ? 0.08 : 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: redCenter, radius: size.width * 0.55));

    canvas.drawRect(Offset.zero & size, redGlow);

    // The second glow (rose) is a dark-mode-only flourish — in light mode
    // one quiet glow reads as intentional; two would look busy on a bright
    // background.
    if (isDark) {
      final secondary = secondaryColor ?? AppColors.glassBlue;
      final roseCenter = Offset(
        size.width * 0.85 - math.cos(t) * 20,
        size.height * 0.75 - math.sin(t) * 26,
      );
      final roseGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            secondary.withOpacity(0.18),
            secondary.withOpacity(0.06),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: roseCenter, radius: size.width * 0.6));
      canvas.drawRect(Offset.zero & size, roseGlow);
    }
  }

  @override
  bool shouldRepaint(covariant _BeaconPainter oldDelegate) =>
      oldDelegate.t != t ||
          oldDelegate.isDark != isDark ||
          oldDelegate.primaryColor != primaryColor ||
          oldDelegate.secondaryColor != secondaryColor;
}

/// Sparse circuit-board trace lines with the occasional glowing junction —
/// reads as a PCB/schematic rather than plain dots, harder-edged and more
/// "technical" than the previous soft dot-grid.
class _CircuitGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;
    final node = Paint()..color = AppColors.meshwarRed.withOpacity(0.5);

    const step = 64.0;
    final rand = math.Random(7); // fixed seed: stable pattern across rebuilds

    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        if (rand.nextDouble() < 0.35) {
          // short horizontal or vertical trace
          if (rand.nextBool()) {
            canvas.drawLine(Offset(x, y), Offset(x + step * 0.6, y), line);
          } else {
            canvas.drawLine(Offset(x, y), Offset(x, y + step * 0.6), line);
          }
        }
        if (rand.nextDouble() < 0.06) {
          canvas.drawCircle(Offset(x, y), 1.6, node);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CircuitGridPainter oldDelegate) => false;
}

/// A faint horizontal band that sweeps down the screen on a slow loop — the
/// classic CRT/terminal scanline read. Deliberately subtle: this is texture,
/// not a distraction.
class _ScanlinePainter extends CustomPainter {
  final double progress;
  const _ScanlinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, y - 40, size.width, 80));
    canvas.drawRect(Rect.fromLTWH(0, y - 40, size.width, 80), paint);
  }
//
  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) => oldDelegate.progress != progress;
}