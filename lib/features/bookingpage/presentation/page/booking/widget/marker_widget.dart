import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';

/// Wrapper kept for API compatibility with `booking_bloc.dart`, which rasterises
/// this widget to a [BitmapDescriptor] via `toBitmapDescriptor()` at a fixed
/// 30x30 logical size.
///
/// The pins are now vector-drawn ([PickupPin] / [DropPin]) instead of PNG
/// assets — crisper at any density, theme-aware, and no async image decode
/// during rasterisation.
class MarkerWidget extends StatelessWidget {
  const MarkerWidget({
    super.key,
    required this.text,
    this.count,
    required this.isPickup,
  });

  final String text;
  final String? count;
  final bool isPickup;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CustomPaint(
          painter:
              isPickup ? PinPainter.pickup() : PinPainter.drop(label: count),
        ),
      ),
    );
  }
}

/// Live-widget origin marker for `flutter_map` (not rasterised).
class PickupPin extends StatelessWidget {
  const PickupPin({super.key, this.size = 34});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: PinPainter.pickup()),
      );
}

/// Live-widget destination marker for `flutter_map` (not rasterised).
class DropPin extends StatelessWidget {
  const DropPin({super.key, this.size = 34, this.label});

  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: PinPainter.drop(label: label)),
      );
}

/// Shared painter for both markers. Everything is drawn inside a square box;
/// the destination pin's tip sits on the bottom-centre so it lines up with the
/// Google Maps default marker anchor (0.5, 1.0).
class PinPainter extends CustomPainter {
  PinPainter._({required this.isPickup, this.label});

  factory PinPainter.pickup() => PinPainter._(isPickup: true);
  factory PinPainter.drop({String? label}) =>
      PinPainter._(isPickup: false, label: label);

  final bool isPickup;
  final String? label;

  @override
  void paint(Canvas canvas, Size size) {
    isPickup ? _paintPickup(canvas, size) : _paintDrop(canvas, size);
  }

  void _paintPickup(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.30;

    // Brand halo.
    canvas.drawCircle(c, size.width * 0.5,
        Paint()..color = AppColors.meshwarRed.withValues(alpha: 0.10));
    canvas.drawCircle(c, size.width * 0.4,
        Paint()..color = AppColors.meshwarRed.withValues(alpha: 0.14));

    // Contact shadow.
    canvas.drawCircle(
      c.translate(0, r * 0.3),
      r * 1.02,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );

    // White disc + brand ring + inner dot.
    canvas.drawCircle(c, r, Paint()..color = Colors.white);
    canvas.drawCircle(
      c,
      r * 0.64,
      Paint()
        ..color = AppColors.meshwarRed
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.44,
    );
    canvas.drawCircle(c, r * 0.22, Paint()..color = AppColors.meshwarRed);
  }

  /// Destination = a rounded-square "tag" on a short stem (distinct from the
  /// pickup ring). Anchor point is the bottom-centre tip.
  void _paintDrop(Canvas canvas, Size size) {
    final w = size.width;
    final tagW = w * 0.66;
    final tagH = w * 0.62;
    final left = (w - tagW) / 2;
    final top = w * 0.04;
    final tag = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, tagW, tagH),
      Radius.circular(w * 0.2),
    );
    final tipY = size.height - w * 0.02;
    final stem = Path()
      ..moveTo(w / 2 - w * 0.13, top + tagH - 1)
      ..lineTo(w / 2, tipY)
      ..lineTo(w / 2 + w * 0.13, top + tagH - 1)
      ..close();

    // Shadow.
    canvas.drawPath(
      stem.shift(const Offset(0, 1.4)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );
    canvas.drawRRect(
      tag.shift(const Offset(0, 1.6)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.8),
    );

    final fill = Paint()..color = AppColors.meshwarRed;
    canvas.drawPath(stem, fill);
    canvas.drawRRect(tag, fill);

    final tagC = Offset(w / 2, top + tagH / 2);
    if (label != null && label!.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.white,
            fontSize: tagH * 0.5,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, tagC - Offset(tp.width / 2, tp.height / 2));
    } else {
      // White rounded-square "destination" glyph.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: tagC, width: tagW * 0.42, height: tagW * 0.42),
          Radius.circular(w * 0.07),
        ),
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PinPainter oldDelegate) =>
      oldDelegate.isPickup != isPickup || oldDelegate.label != label;
}
