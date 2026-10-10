import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';

/// An inward search field over the map, anchored to the projected pickup.
/// Only the painter ticks; map tiles, camera and booking state stay untouched.
class DriverSearchField extends StatefulWidget {
  const DriverSearchField(
      {super.key,
      required this.center,
      this.mapImage,
      this.mapImageCenter,
      this.mapScale = 1,
      this.mapRotation = 0});
  final Offset center;
  final ui.Image? mapImage;
  final Offset? mapImageCenter;
  final double mapScale, mapRotation;

  @override
  State<DriverSearchField> createState() => _DriverSearchFieldState();
}

class _DriverSearchFieldState extends State<DriverSearchField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _phase = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 3600));
  static final Future<ui.FragmentProgram> _program =
      ui.FragmentProgram.fromAsset('shaders/driver_search_absorb.frag');
  ui.FragmentShader? _shader;
  bool _loadingShader = false;

  @override
  void initState() {
    super.initState();
    if (widget.mapImage != null) _loadShader();
  }

  @override
  void didUpdateWidget(covariant DriverSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mapImage != null && _shader == null) _loadShader();
  }

  Future<void> _loadShader() async {
    if (_loadingShader) return;
    _loadingShader = true;
    try {
      final program = await _program;
      if (mounted) setState(() => _shader = program.fragmentShader());
    } catch (error) {
      debugPrint('Driver search map shader unavailable: $error');
    } finally {
      _loadingShader = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _phase.stop();
      _phase.value = .42;
    } else if (!_phase.isAnimating) {
      _phase.repeat();
    }
  }

  @override
  void dispose() {
    _phase.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: ExcludeSemantics(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 450),
            builder: (context, opacity, child) =>
                Opacity(opacity: opacity, child: child),
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _SearchFieldPainter(
                    phase: _phase,
                    center: widget.center,
                    shader: _shader,
                    mapImage: widget.mapImage,
                    mapImageCenter: widget.mapImageCenter ?? widget.center,
                    mapScale: widget.mapScale,
                    mapRotation: widget.mapRotation,
                    distortMap: !MediaQuery.disableAnimationsOf(context),
                    dark: Theme.of(context).brightness == Brightness.dark),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      );
}

class _SearchFieldPainter extends CustomPainter {
  _SearchFieldPainter(
      {required this.phase,
      required this.center,
      required this.dark,
      required this.shader,
      required this.mapImage,
      required this.mapImageCenter,
      required this.mapScale,
      required this.mapRotation,
      required this.distortMap})
      : super(repaint: phase);
  final Animation<double> phase;
  final Offset center;
  final bool dark;
  final ui.FragmentShader? shader;
  final ui.Image? mapImage;
  final Offset mapImageCenter;
  final double mapScale, mapRotation;
  final bool distortMap;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !center.dx.isFinite || !center.dy.isFinite) return;
    final outer = math.min(size.width * .43, 180.0);
    const inner = 22.0;
    final color = dark ? AppColors.signalRose : AppColors.meshwarRed;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final texture = mapImage;
    final effect = shader;
    if (distortMap && texture != null && effect != null) {
      effect
        ..setFloat(0, size.width)
        ..setFloat(1, size.height)
        ..setFloat(2, center.dx)
        ..setFloat(3, center.dy)
        ..setFloat(4, outer)
        ..setFloat(5, phase.value)
        ..setFloat(6, .98)
        ..setFloat(7, mapImageCenter.dx)
        ..setFloat(8, mapImageCenter.dy)
        ..setFloat(9, mapScale)
        ..setFloat(10, mapRotation)
        ..setImageSampler(0, texture, filterQuality: FilterQuality.medium);
      canvas.drawRect(Offset.zero & size, Paint()..shader = effect);
    }
    canvas.translate(center.dx, center.dy);

    // A local vignette keeps the streets visible beyond the search field.
    final halo = Rect.fromCircle(center: Offset.zero, radius: outer);
    canvas.drawCircle(
        Offset.zero,
        outer,
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFF24102B).withValues(alpha: dark ? .24 : .12),
            color.withValues(alpha: .045),
            color.withValues(alpha: 0),
          ], stops: const [
            0,
            .35,
            1
          ]).createShader(halo));

    // Staggered outlines contract and disappear into the center, instead of
    // accumulating opaque expanding disks.
    for (var index = 0; index < 4; index++) {
      final p = (phase.value + index / 4) % 1;
      final radius = inner + (outer - inner) * math.pow(1 - p, .85);
      final opacity = math.sin(p * math.pi) * (dark ? .26 : .19);
      canvas.drawCircle(
          Offset.zero,
          radius.toDouble(),
          Paint()
            ..color = color.withValues(alpha: opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.25);
    }

    // Small comet trails spiral inward. Their staggered phases hide the reset
    // at the outer edge so the motion remains continuous.
    for (var index = 0; index < 12; index++) {
      final p = (phase.value + index * .137) % 1;
      final angle = index * math.pi * 2 / 12;
      Offset point(double progress) {
        final radius = inner + (outer - inner) * math.pow(1 - progress, .9);
        final theta = angle + progress * math.pi * 1.4;
        return Offset(math.cos(theta) * radius, math.sin(theta) * radius);
      }

      final opacity = math.sin(p * math.pi) * .55;
      for (var trail = 0; trail < 8; trail++) {
        final a = (p - trail * .009).clamp(0.0, 1.0);
        final b = (p - (trail + 1) * .009).clamp(0.0, 1.0);
        canvas.drawLine(
            point(a),
            point(b),
            Paint()
              ..color = color.withValues(alpha: opacity * (1 - trail / 8))
              ..strokeWidth = 1.8
              ..strokeCap = StrokeCap.round);
      }
      canvas.drawCircle(point(p), 2.0 * (1 - p * .55),
          Paint()..color = color.withValues(alpha: opacity));
    }

    // The moving streets fade into a dark core and a rotating accretion rim.
    canvas.drawCircle(
        Offset.zero, 32, Paint()..color = color.withValues(alpha: .12));
    canvas.drawCircle(
        Offset.zero,
        22,
        Paint()
          ..shader = const RadialGradient(
                  colors: [Color(0xFF030207), Color(0xFF17091D)])
              .createShader(Rect.fromCircle(center: Offset.zero, radius: 22)));
    canvas.drawCircle(
        Offset.zero,
        22,
        Paint()
          ..color = color.withValues(alpha: .85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: 24),
        phase.value * math.pi * 2,
        1.1,
        false,
        Paint()
          ..color = const Color(0xFFFFB4CD).withValues(alpha: .8)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SearchFieldPainter oldDelegate) =>
      center != oldDelegate.center ||
      dark != oldDelegate.dark ||
      phase != oldDelegate.phase ||
      shader != oldDelegate.shader ||
      mapImage != oldDelegate.mapImage ||
      mapImageCenter != oldDelegate.mapImageCenter ||
      mapScale != oldDelegate.mapScale ||
      mapRotation != oldDelegate.mapRotation ||
      distortMap != oldDelegate.distortMap;
}
