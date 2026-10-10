import 'dart:math' as math;

/// A rendered 3D view, selected from the vehicle and map camera orientation.
class SedanPose {
  static const headingStep = 3;
  static const tiltStep = 5;
  static const maxTilt = 75;
  final int heading;
  final int tilt;

  const SedanPose(this.heading, this.tilt);

  factory SedanPose.forCamera(double bearing,
      {double cameraBearing = 0, double cameraTilt = 0}) {
    final relative = normalize(bearing) - normalize(cameraBearing);
    return SedanPose(
      ((normalize(relative) / headingStep).round() * headingStep) % 360,
      tiltFrame(cameraTilt),
    );
  }

  static int tiltFrame(double tilt) =>
      (((tilt.isFinite ? tilt : 0).clamp(0, maxTilt) / tiltStep).round() *
          tiltStep);

  static double normalize(double angle) =>
      angle.isFinite ? (angle % 360 + 360) % 360 : 0;

  static double turnDelta(double from, double to) =>
      (normalize(to) - normalize(from) + 540) % 360 - 180;

  static double interpolateBearing(double from, double to, double progress) =>
      normalize(normalize(from) + turnDelta(from, to) * progress.clamp(0, 1));

  String get assetPath =>
      'assets/sedan_sprites/tilt_${tilt.toString().padLeft(2, '0')}_heading_${heading.toString().padLeft(3, '0')}.png';

  /// Sub-frame correction keeps turning continuous between rendered headings.
  double rotationCorrection(double bearing, double cameraBearing) {
    final actual = normalize(bearing - normalize(cameraBearing));
    double projected(double heading) {
      final radians = heading * math.pi / 180;
      return math.atan2(math.sin(radians),
              math.cos(radians) * math.cos(tilt * math.pi / 180)) *
          180 /
          math.pi;
    }

    return turnDelta(projected(heading.toDouble()), projected(actual));
  }

  @override
  bool operator ==(Object other) =>
      other is SedanPose && heading == other.heading && tilt == other.tilt;

  @override
  int get hashCode => Object.hash(heading, tilt);
}
