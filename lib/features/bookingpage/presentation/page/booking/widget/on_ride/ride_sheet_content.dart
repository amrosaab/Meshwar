import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/app_colors.dart';
import '../../../../../../../common/ride_visuals.dart';
import '../../../../../../../l10n/app_localizations.dart';

class RideSheetStop {
  const RideSheetStop({
    required this.label,
    required this.address,
    this.isPickup = false,
    this.instruction = '',
    this.onEdit,
  });

  final String label;
  final String address;
  final bool isPickup;
  final String instruction;
  final VoidCallback? onEdit;
}

/// Presentation only: the booking sheet owns ride state and all action handlers.
class RideSheetContent extends StatelessWidget {
  const RideSheetContent({
    super.key,
    required this.status,
    required this.statusIcon,
    required this.stops,
    required this.driverName,
    required this.avatarUrl,
    required this.rating,
    required this.completedRides,
    required this.vehicleName,
    required this.vehicleColor,
    required this.vehiclePlate,
    required this.fareLabel,
    required this.fare,
    required this.paymentLabel,
    required this.paymentIcon,
    this.subtitle,
    this.eta,
    this.otp,
    this.waiting,
    this.driverInstruction = '',
    this.preferenceIcons = const [],
    this.hasUnreadMessages = false,
    this.extraChargeLabel = '',
    this.extraCharge = '',
    this.onMessage,
    this.onCall,
    this.onShare,
    this.onPay,
    this.onCancel,
  });

  final String status;
  final IconData statusIcon;
  final String? subtitle, eta, otp, waiting;
  final List<RideSheetStop> stops;
  final String driverName, avatarUrl, rating;
  final int completedRides;
  final String vehicleName, vehicleColor, vehiclePlate, driverInstruction;
  final List<String> preferenceIcons;
  final bool hasUnreadMessages;
  final String fareLabel, fare, paymentLabel, extraChargeLabel, extraCharge;
  final IconData paymentIcon;
  final VoidCallback? onMessage, onCall, onShare, onPay, onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
    final muted = dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C);
    final soft = dark ? AppColors.bgAsphaltLight : const Color(0xFFF6F5F7);
    final border = dark ? const Color(0xFF382B3B) : const Color(0xFFECE9EE);
    final accent = dark ? AppColors.signalRose : AppColors.primary;
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(color: ink);
    Text text(String value,
            {double size = _RideType.body,
            FontWeight weight = FontWeight.w500,
            Color? color,
            int? lines}) =>
        Text(
          value,
          maxLines: lines,
          overflow: lines != null ? TextOverflow.ellipsis : null,
          style: base.copyWith(
              fontSize: size, fontWeight: weight, color: color, height: 1.45),
        );
    Widget badge(String value,
            {IconData? icon, Color? color, LinearGradient? gradient}) =>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
              color: soft, borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[
              if (gradient != null)
                RideColorBadge(
                    icon: icon,
                    gradient: gradient,
                    size: 28,
                    iconSize: 16,
                    radius: 10)
              else
                Icon(icon, size: 16, color: color ?? ink),
              const SizedBox(width: 6)
            ],
            Flexible(
                child: text(value,
                    size: _RideType.body,
                    weight: FontWeight.w600,
                    color: color)),
          ]),
        );
    Widget instruction(String value) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: text('${l10n.instructions}: $value',
              size: _RideType.label, color: muted),
        );

    return Material(
      color: dark ? AppColors.bgAsphalt : AppColors.lightBg,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                            color: border,
                            borderRadius: BorderRadius.circular(8)))),
                const SizedBox(height: 22),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: [
                          Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                  color: accent, shape: BoxShape.circle)),
                          const SizedBox(width: 7),
                          Flexible(
                              child: text(l10n.rideDetails,
                                  size: _RideType.label,
                                  weight: FontWeight.w600,
                                  color: muted)),
                        ]),
                        const SizedBox(height: 5),
                        text(status,
                            size: _RideType.title, weight: FontWeight.w800),
                      ])),
                  const SizedBox(width: 14),
                  Container(
                    constraints: const BoxConstraints(minWidth: 64),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                        gradient: RideVisuals.rose,
                        boxShadow: RideVisuals.glow(AppColors.meshwarRed),
                        borderRadius: BorderRadius.circular(18)),
                    child: eta != null
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            text(eta!,
                                size: _RideType.amount,
                                weight: FontWeight.w800,
                                color: Colors.white),
                            text(l10n.mins,
                                size: _RideType.label,
                                weight: FontWeight.w600,
                                color: Colors.white),
                          ])
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Icon(statusIcon,
                                color: Colors.white, size: 28)),
                  ),
                ]),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  text(subtitle!, size: _RideType.body, color: muted),
                ],
                if (otp != null || waiting != null) ...[
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    if (otp != null)
                      Semantics(
                          label: 'OTP $otp',
                          child: badge('OTP  $otp',
                              icon: Icons.lock_outline_rounded, color: accent)),
                    if (waiting != null)
                      badge('$waiting ${l10n.mins}',
                          icon: Icons.timer_outlined),
                  ]),
                ],
                const SizedBox(height: 20),
                _RideCard(
                    border: border,
                    child: Column(children: [
                      for (var i = 0; i < stops.length; i++) ...[
                        if (i > 0)
                          Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 32),
                              child: Divider(height: 22, color: border)),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: RideColorBadge(
                                  icon: stops[i].isPickup
                                      ? Icons.my_location_rounded
                                      : Icons.location_on_rounded,
                                  gradient: stops[i].isPickup
                                      ? RideVisuals.green
                                      : RideVisuals.rose,
                                  size: 28,
                                  iconSize: 16,
                                  radius: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    text(stops[i].label,
                                        size: _RideType.label,
                                        weight: FontWeight.w700,
                                        color: stops[i].isPickup
                                            ? (dark
                                                ? const Color(0xFF67D4A5)
                                                : AppColors.routeGreen)
                                            : accent),
                                    const SizedBox(height: 3),
                                    text(stops[i].address,
                                        size: _RideType.body,
                                        weight: FontWeight.w600,
                                        lines: 2),
                                    if (stops[i].instruction.isNotEmpty)
                                      instruction(stops[i].instruction),
                                  ])),
                              if (stops[i].onEdit != null)
                                IconButton(
                                  tooltip: l10n.edit,
                                  onPressed: stops[i].onEdit,
                                  icon: Icon(Icons.edit_outlined,
                                      size: 19, color: accent),
                                ),
                            ]),
                      ],
                    ])),
                const SizedBox(height: 14),
                _RideCard(
                    border: border,
                    tone: const Color(0xFF3A72D4),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  width: 54,
                                  height: 54,
                                  color: soft,
                                  child: avatarUrl.isEmpty
                                      ? Icon(Icons.person_rounded,
                                          color: muted, size: 30)
                                      : CachedNetworkImage(
                                          imageUrl: avatarUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (_, url) => Icon(
                                              Icons.person_rounded,
                                              color: muted,
                                              size: 30),
                                          errorWidget: (_, url, error) => Icon(
                                              Icons.person_rounded,
                                              color: muted,
                                              size: 30),
                                        ),
                                )),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  text(driverName,
                                      size: _RideType.name,
                                      weight: FontWeight.w700,
                                      lines: 2),
                                  const SizedBox(height: 4),
                                  Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        if (rating != '0' && rating.isNotEmpty)
                                          Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.star_rounded,
                                                    size: 16,
                                                    color: AppColors
                                                        .amberOnSurface(
                                                            context)),
                                                const SizedBox(width: 3),
                                                text(rating,
                                                    size: _RideType.label,
                                                    weight: FontWeight.w700),
                                              ]),
                                        if (completedRides > 0)
                                          text(
                                              '${l10n.totalRides}: $completedRides',
                                              size: _RideType.label,
                                              color: muted),
                                      ]),
                                ])),
                          ]),
                          Divider(height: 26, color: border),
                          LayoutBuilder(builder: (context, constraints) {
                            final vehicle = Row(children: [
                              const RideColorBadge(
                                  icon: Icons.directions_car_outlined,
                                  gradient: RideVisuals.blue,
                                  size: 38,
                                  iconSize: 21),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    text(vehicleName,
                                        size: _RideType.body,
                                        weight: FontWeight.w700,
                                        lines: 2),
                                    if (vehicleColor.isNotEmpty)
                                      text(vehicleColor,
                                          size: _RideType.label, color: muted),
                                  ])),
                            ]);
                            final plate = Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                  color: soft,
                                  border: Border.all(color: border),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: text(vehiclePlate,
                                      size: _RideType.body,
                                      weight: FontWeight.w800)),
                            );
                            // Stack details at small widths or large accessibility sizes.
                            if (constraints.maxWidth < 270 ||
                                MediaQuery.textScalerOf(context).scale(14) >
                                    20 ||
                                vehiclePlate.length > 12) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    vehicle,
                                    const SizedBox(height: 10),
                                    plate
                                  ]);
                            }
                            return Row(children: [
                              Expanded(child: vehicle),
                              const SizedBox(width: 12),
                              Flexible(child: plate)
                            ]);
                          }),
                          if (driverInstruction.isNotEmpty)
                            instruction(driverInstruction),
                          if (preferenceIcons.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  text(l10n.preferences,
                                      size: _RideType.label, color: muted),
                                  for (final url in preferenceIcons)
                                    CachedNetworkImage(
                                        imageUrl: url,
                                        width: 22,
                                        height: 22,
                                        errorWidget: (_, url, error) => Icon(
                                            Icons.check_circle_outline,
                                            size: 20,
                                            color: muted)),
                                ]),
                          ],
                          if (onMessage != null ||
                              onCall != null ||
                              onShare != null) ...[
                            const SizedBox(height: 16),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (onMessage != null)
                                    Expanded(
                                        child: _ContactAction(
                                            label: l10n.messageText,
                                            icon: Icons
                                                .chat_bubble_outline_rounded,
                                            onTap: onMessage!,
                                            gradient: RideVisuals.rose,
                                            foreground: ink,
                                            primary: true,
                                            unread: hasUnreadMessages)),
                                  if (onCall != null) ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: _ContactAction(
                                      label: l10n.rideCall,
                                      icon: Icons.call_outlined,
                                      onTap: onCall!,
                                      gradient: RideVisuals.green,
                                      foreground: ink,
                                    )),
                                  ],
                                  if (onShare != null) ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: _ContactAction(
                                      label: l10n.shareRide,
                                      icon: Icons.ios_share_rounded,
                                      onTap: onShare!,
                                      gradient: RideVisuals.blue,
                                      foreground: ink,
                                    )),
                                  ],
                                ]),
                          ],
                        ])),
                const SizedBox(height: 14),
                _RideCard(
                    border: border,
                    tone: const Color(0xFFE6862A),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  text(fareLabel,
                                      size: _RideType.label, color: muted),
                                  const SizedBox(height: 2),
                                  text(fare,
                                      size: _RideType.amount,
                                      weight: FontWeight.w800),
                                ])),
                            const SizedBox(width: 12),
                            Flexible(
                                child: badge(paymentLabel,
                                    icon: paymentIcon,
                                    gradient: RideVisuals.amber)),
                          ]),
                          if (extraChargeLabel.isNotEmpty &&
                              extraCharge.isNotEmpty) ...[
                            Divider(height: 22, color: border),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: text(extraChargeLabel,
                                          size: _RideType.label, color: muted)),
                                  const SizedBox(width: 12),
                                  Flexible(
                                      child: text(extraCharge,
                                          size: _RideType.body,
                                          weight: FontWeight.w700)),
                                ]),
                          ],
                        ])),
                if (onPay != null) ...[
                  const SizedBox(height: 14),
                  FilledButton(
                      onPressed: onPay,
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: Text(l10n.pay,
                          style: base.copyWith(
                              fontSize: _RideType.action,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                              color: Colors.white))),
                ],
                if (onCancel != null) ...[
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: onCancel,
                      style: TextButton.styleFrom(
                          foregroundColor: accent,
                          minimumSize: const Size.fromHeight(48)),
                      child: Text(l10n.cancelRide,
                          style: base.copyWith(
                              fontSize: _RideType.action,
                              fontWeight: FontWeight.w600,
                              color: accent))),
                ],
              ]),
        ),
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard(
      {required this.border,
      required this.child,
      this.tone = AppColors.meshwarRed});
  final Color border, tone;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: RideVisuals.wash(context, tone),
            boxShadow: RideVisuals.glow(tone, strength: .07),
            border: Border.all(color: border.withValues(alpha: .65)),
            borderRadius: BorderRadius.circular(20)),
        child: child,
      );
}

class _ContactAction extends StatelessWidget {
  const _ContactAction(
      {required this.label,
      required this.icon,
      required this.onTap,
      required this.gradient,
      required this.foreground,
      this.primary = false,
      this.unread = false});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final LinearGradient gradient;
  final Color foreground;
  final bool primary, unread;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: label,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
                gradient: primary
                    ? RideVisuals.rose
                    : RideVisuals.wash(context, gradient.colors.last),
                borderRadius: BorderRadius.circular(14)),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Stack(clipBehavior: Clip.none, children: [
                    if (primary)
                      SizedBox(
                          height: 32,
                          width: 32,
                          child: Icon(icon, size: 21, color: Colors.white))
                    else
                      RideColorBadge(
                          icon: icon,
                          gradient: gradient,
                          size: 32,
                          iconSize: 18,
                          radius: 11),
                    if (unread)
                      PositionedDirectional(
                          top: -3,
                          end: -4,
                          child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: AppColors.emberGold,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primary, width: 1.5)))),
                  ]),
                  const SizedBox(height: 5),
                  Text(label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: _RideType.action,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                          color: primary ? Colors.white : foreground)),
                ]),
              ),
            ),
          ),
        ),
      );
}

/// Shared sizes keep labels, details and actions consistent across cards.
abstract final class _RideType {
  static const double label = 12;
  static const double action = 13;
  static const double body = 14;
  static const double name = 16;
  static const double title = 20;
  static const double amount = 26;
}
