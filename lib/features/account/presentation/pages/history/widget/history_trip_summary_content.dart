import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'history_detail_widgets.dart';

class HistoryTripStop {
  const HistoryTripStop(
      {required this.address,
      required this.label,
      this.time = '',
      this.isPickup = false,
      this.isIntermediate = false});
  final String address, label, time;
  final bool isPickup, isIntermediate;
}

class HistoryTripSummaryContent extends StatelessWidget {
  const HistoryTripSummaryContent(
      {super.key,
      required this.stops,
      this.driverName = '',
      this.driverImage = ''});
  final List<HistoryTripStop> stops;
  final String driverName, driverImage;

  @override
  Widget build(BuildContext context) => HistoryDetailCard(
        title: AppLocalizations.of(context)!.tripSummary,
        icon: Icons.route_rounded,
        gradient: RideVisuals.green,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (driverName.isNotEmpty) ...[
            Row(children: [
              ExcludeSemantics(child: _DriverPortrait(url: driverImage)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(driverName,
                      style: HistoryDetailStyle.text(context).copyWith(
                          fontSize: 16, fontWeight: FontWeight.w700))),
            ]),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Divider(
                    height: 1, color: HistoryDetailStyle.border(context))),
          ],
          for (var index = 0; index < stops.length; index++) ...[
            if (index > 0)
              Padding(
                  padding: const EdgeInsetsDirectional.only(start: 15),
                  child: Container(
                      height: 18,
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      color: HistoryDetailStyle.border(context))),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ExcludeSemantics(
                  child: RideColorBadge(
                      icon: stops[index].isPickup
                          ? Icons.my_location_rounded
                          : Icons.location_on_rounded,
                      gradient: stops[index].isPickup
                          ? RideVisuals.green
                          : stops[index].isIntermediate
                              ? RideVisuals.amber
                              : RideVisuals.rose,
                      size: 32,
                      iconSize: 17,
                      radius: 11)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(stops[index].label,
                        style: HistoryDetailStyle.text(context).copyWith(
                            fontSize: 12,
                            color: HistoryDetailStyle.muted(context))),
                    const SizedBox(height: 4),
                    Text(stops[index].address,
                        style: HistoryDetailStyle.text(context)),
                    if (stops[index].time.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(stops[index].time,
                          style: HistoryDetailStyle.text(context).copyWith(
                              fontSize: 12,
                              color: HistoryDetailStyle.muted(context))),
                    ],
                  ])),
            ]),
          ],
        ]),
      );
}

class _DriverPortrait extends StatelessWidget {
  const _DriverPortrait({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    const fallback = RideColorBadge(
        icon: Icons.person_rounded,
        gradient: RideVisuals.blue,
        size: 48,
        iconSize: 25,
        radius: 17);
    if (url.isEmpty) return fallback;
    return ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: CachedNetworkImage(
            imageUrl: url,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            placeholder: (_, __) => fallback,
            errorWidget: (_, __, ___) => fallback));
  }
}
