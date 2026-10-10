import 'package:flutter/material.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/ride_visuals.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/widgets/account_content.dart';

class PickupConfirmationPanel extends StatelessWidget {
  const PickupConfirmationPanel(
      {super.key,
      required this.address,
      required this.pickup,
      required this.bookingName,
      required this.onBookingType,
      required this.onConfirm});
  final String address, bookingName;
  final bool pickup;
  final VoidCallback onBookingType, onConfirm;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.bgAsphaltLight
                : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: AppColors.surfaceShadow(context)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height *
                  (MediaQuery.textScalerOf(context).scale(16) > 24 ? .75 : .5)),
          child: SafeArea(
              top: false,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                            child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: AppColors.surfaceBorder(context),
                                    borderRadius: BorderRadius.circular(4)))),
                        const SizedBox(height: 16),
                        Flexible(
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                  if (pickup) ...[
                                    Align(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: TextButton.icon(
                                            onPressed: onBookingType,
                                            icon: const Icon(
                                                Icons.person_outline_rounded,
                                                size: 18),
                                            label: Text(bookingName,
                                                textAlign: TextAlign.center,
                                                style: AccountStyle.text(context)
                                                    .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                            style: TextButton.styleFrom(
                                                foregroundColor:
                                                    AccountStyle.ink(context),
                                                backgroundColor: AppColors.meshwarRed
                                                    .withValues(alpha: .06),
                                                minimumSize: const Size(80, 44),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))))),
                                    const SizedBox(height: 14),
                                  ],
                                  Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: RideVisuals.canvas(context),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(
                                              color: AppColors.surfaceBorder(
                                                  context))),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ExcludeSemantics(
                                                child: RideColorBadge(
                                                    icon: pickup
                                                        ? Icons
                                                            .my_location_rounded
                                                        : Icons
                                                            .location_on_outlined,
                                                    gradient: pickup
                                                        ? RideVisuals.green
                                                        : RideVisuals.rose,
                                                    size: 40,
                                                    iconSize: 22,
                                                    radius: 14)),
                                            const SizedBox(width: 14),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Text(
                                                      pickup
                                                          ? l10n.pickupLocation
                                                          : l10n
                                                              .confirmLocation,
                                                      style: AccountStyle.text(
                                                              context)
                                                          .copyWith(
                                                              fontSize: 12,
                                                              color: AccountStyle
                                                                  .muted(
                                                                      context))),
                                                  const SizedBox(height: 5),
                                                  Text(address,
                                                      style: AccountStyle.text(
                                                              context)
                                                          .copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                ])),
                                          ])),
                                ]))),
                        const SizedBox(height: 18),
                        FilledButton(
                            onPressed:
                                address.trim().isEmpty ? null : onConfirm,
                            style: FilledButton.styleFrom(
                                backgroundColor: AppColors.meshwarRed,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(58),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Text(
                                pickup
                                    ? '${l10n.confirm} ${l10n.pickupLocation}'
                                    : l10n.confirmLocation,
                                textAlign: TextAlign.center,
                                style: AccountStyle.text(context).copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700))),
                      ]))),
        ));
  }
}
