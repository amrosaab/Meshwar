import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Color roles shared by the ride sheet, chat and cancellation screen.
abstract final class RideVisuals {
  static const rose = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    // Deep enough for white button labels across the entire gradient.
    colors: [AppColors.meshwarRed, Color(0xFFE71353)],
  );
  static const green = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34C77E), AppColors.routeGreen],
  );
  static const blue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6BA7F5), Color(0xFF3A72D4)],
  );
  static const amber = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB84D), Color(0xFFE6862A)],
  );

  static List<BoxShadow> glow(Color color, {double strength = .14}) => [
        BoxShadow(
            color: color.withValues(alpha: strength),
            blurRadius: 16,
            offset: const Offset(0, 5),
            spreadRadius: -3),
      ];

  static LinearGradient wash(BuildContext context, Color color) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.bgAsphaltLight : Colors.white;
    return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          surface,
          Color.alphaBlend(color.withValues(alpha: dark ? .08 : .035), surface)
        ]);
  }

  static Color canvas(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.bgVoid
          : AppColors.lightBg;
}

class RideColorBadge extends StatelessWidget {
  const RideColorBadge(
      {super.key,
      required this.icon,
      required this.gradient,
      this.size = 36,
      this.iconSize = 19,
      this.radius = 12});
  final IconData icon;
  final LinearGradient gradient;
  final double size, iconSize, radius;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: RideVisuals.glow(gradient.colors.last)),
        child: Icon(icon, size: iconSize, color: Colors.white),
      );
}
