import 'package:flutter/material.dart';

import 'common.dart';
import '../core/utils/avatar_glow.dart';

/// Pickup marker — a pulsing green dot (AvatarGlow keeps this animated
/// without a bespoke AnimationController).
class PickupIcon extends StatelessWidget {
  const PickupIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: AppColors.routeGreen,
      duration: const Duration(milliseconds: 1800),
      glowRadiusFactor: 0.6,
      glowCount: 2,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.routeGreen.withAlpha((0.3 * 255).toInt()),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.routeGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Drop-off marker — the brand red pin, with the same quiet glow treatment
/// as the rest of the system.
class DropIcon extends StatelessWidget {
  const DropIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: AppColors.meshwarRed,
      duration: const Duration(milliseconds: 1800),
      glowRadiusFactor: 0.5,
      glowCount: 1,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          Icons.location_on_rounded,
          color: AppColors.meshwarRed,
          size: 23,
        ),
      ),
    );
  }
}