import 'package:flutter/material.dart';

import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'history_detail_widgets.dart';

class HistoryFareLine {
  const HistoryFareLine(this.label, this.value, {this.color});
  final String label, value;
  final Color? color;
}

class HistoryFareContent extends StatelessWidget {
  const HistoryFareContent({
    super.key,
    required this.lines,
    required this.payment,
    required this.total,
    this.cancelled = false,
  });
  final List<HistoryFareLine> lines;
  final String payment, total;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return HistoryDetailCard(
      title: cancelled ? l10n.cancelled : l10n.fareBreakup,
      icon: cancelled ? Icons.event_busy_rounded : Icons.receipt_long_rounded,
      gradient: cancelled ? RideVisuals.rose : RideVisuals.amber,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final line in lines)
          HistoryDetailRow(
              label: line.label, value: line.value, valueColor: line.color),
        if (total.isNotEmpty) ...[
          if (lines.isNotEmpty)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                    height: 1, color: HistoryDetailStyle.border(context))),
          HistoryDetailRow(label: l10n.payment, value: total, emphasized: true),
          if (payment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: RideVisuals.green.colors.last.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(payment,
                  style: HistoryDetailStyle.text(context)
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ]),
    );
  }
}
