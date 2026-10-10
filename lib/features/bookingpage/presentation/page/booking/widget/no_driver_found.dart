import 'package:flutter/material.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';

class NoDriverFoundWidget extends StatelessWidget {
  const NoDriverFoundWidget({super.key, this.onBackToRide});

  final VoidCallback? onBackToRide;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
    final muted = dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C);
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14, height: 1.5, color: ink, fontWeight: FontWeight.w500);

    return LayoutBuilder(builder: (context, constraints) {
      final available = MediaQuery.sizeOf(context).height * .85;
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: constraints.maxHeight.clamp(0, available)),
        child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: RideVisuals.wash(context, AppColors.meshwarRed),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32))),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const ExcludeSemantics(child: _NoDriversIllustration()),
                    const SizedBox(height: 18),
                    Semantics(
                      header: true,
                      child: Text(l10n.noDriversNearbyTitle,
                          textAlign: TextAlign.center,
                          style: base.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.25)),
                    ),
                    const SizedBox(height: 10),
                    Text(l10n.noDriversNearbyBody,
                        textAlign: TextAlign.center,
                        style: base.copyWith(
                            color: muted, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: AppColors.blue
                              .withValues(alpha: dark ? .13 : .055),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.blue
                                  .withValues(alpha: dark ? .18 : .08))),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ExcludeSemantics(
                              child: RideColorBadge(
                                  icon: Icons.tips_and_updates_outlined,
                                  gradient: RideVisuals.blue,
                                  size: 34,
                                  iconSize: 18,
                                  radius: 12),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(l10n.noDriversNearbyHint,
                                    style: base.copyWith(
                                        fontSize: 13, height: 1.5))),
                          ]),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: RideVisuals.glow(AppColors.meshwarRed,
                              strength: .2)),
                      child: FilledButton(
                        key: const ValueKey('backToRide'),
                        onPressed:
                            onBackToRide ?? () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.meshwarRed,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(58),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(l10n.backToRide.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: base.copyWith(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: .4))),
                              const SizedBox(width: 12),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ]),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _NoDriversIllustration extends StatelessWidget {
  const _NoDriversIllustration();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 240,
      height: 142,
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned(
          left: 20,
          right: 20,
          top: 12,
          bottom: 4,
          child: Transform.rotate(
            angle: -.07,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: dark
                          ? [const Color(0xFF263047), const Color(0xFF2D2038)]
                          : [const Color(0xFFE8F3FF), const Color(0xFFFBEAF0)]),
                  border:
                      Border.all(color: AppColors.blue.withValues(alpha: .1))),
              child: CustomPaint(painter: _MapIllustrationPainter(dark: dark)),
            ),
          ),
        ),
        const Positioned(
            left: 0,
            top: 0,
            child: RideColorBadge(
                icon: Icons.search_rounded,
                gradient: RideVisuals.blue,
                size: 48,
                iconSize: 25,
                radius: 18)),
        const Positioned(
            right: 0,
            top: 20,
            child: RideColorBadge(
                icon: Icons.schedule_rounded,
                gradient: RideVisuals.amber,
                size: 38,
                iconSize: 21,
                radius: 14)),
        Positioned(
            left: 70,
            top: 22,
            child: Image.asset('assets/sedan_sprites/tilt_45_heading_225.png',
                width: 108, height: 108, filterQuality: FilterQuality.medium)),
        const Positioned(
            left: 30,
            bottom: 0,
            child: RideColorBadge(
                icon: Icons.my_location_rounded,
                gradient: RideVisuals.green,
                size: 34,
                iconSize: 18,
                radius: 13)),
      ]),
    );
  }
}

class _MapIllustrationPainter extends CustomPainter {
  const _MapIllustrationPainter({required this.dark});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white.withValues(alpha: dark ? .09 : .8)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * .35),
        Offset(size.width, size.height * .55), road);
    canvas.drawLine(Offset(size.width * .22, 0),
        Offset(size.width * .6, size.height), road);
    canvas.drawLine(Offset(size.width * .82, 0),
        Offset(size.width * .55, size.height), road);
    final route = Path()
      ..moveTo(size.width * .19, size.height * .85)
      ..lineTo(size.width * .39, size.height * .53)
      ..lineTo(size.width * .73, size.height * .57)
      ..lineTo(size.width * .85, size.height * .29);
    canvas.drawPath(
        route,
        Paint()
          ..color = AppColors.meshwarRed.withValues(alpha: .25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_MapIllustrationPainter oldDelegate) =>
      oldDelegate.dark != dark;
}
