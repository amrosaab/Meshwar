import 'package:flutter/material.dart';

import '../../../../../../../common/app_colors.dart';
import '../../../../../../../common/ride_visuals.dart';
import '../../../../../../../l10n/app_localizations.dart';

class CancelReasonOption {
  const CancelReasonOption({required this.id, required this.title});
  final String id, title;
}

/// The caller owns the selection and cancellation action. This screen only
/// presents the supplied reasons and never cancels a ride on selection.
class CancelReasonContent extends StatelessWidget {
  const CancelReasonContent(
      {super.key,
      required this.reasons,
      required this.selectedId,
      required this.isCustom,
      required this.otherController,
      required this.onSelect,
      required this.onOtherChanged,
      required this.onBack,
      this.onCancel});

  final List<CancelReasonOption> reasons;
  final String selectedId;
  final bool isCustom;
  final TextEditingController otherController;
  final ValueChanged<CancelReasonOption> onSelect;
  final ValueChanged<String> onOtherChanged;
  final VoidCallback onBack;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
    final muted = dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C);
    final surface = dark ? AppColors.bgAsphaltLight : Colors.white;
    final canvas = RideVisuals.canvas(context);
    final border = dark ? const Color(0xFF382B3B) : const Color(0xFFECE9EE);
    final accent = dark ? AppColors.signalRose : AppColors.meshwarRed;
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14, height: 1.5, color: ink, fontWeight: FontWeight.w500);
    final headline =
        base.copyWith(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3);
    return Scaffold(
      backgroundColor: canvas,
      appBar: AppBar(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 64,
        leading: IconButton(
            tooltip: l10n.back,
            onPressed: onBack,
            icon: Icon(Icons.arrow_back_rounded, color: ink, size: 22)),
        title: Text(l10n.cancelRide,
            style: base.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
            child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                children: [
              const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: RideColorBadge(
                      icon: Icons.event_busy_outlined,
                      gradient: RideVisuals.rose,
                      size: 52,
                      iconSize: 25,
                      radius: 18)),
              const SizedBox(height: 20),
              Text(l10n.cancelRideText, style: headline),
              const SizedBox(height: 8),
              Text(l10n.selectCancelReason, style: base.copyWith(color: muted)),
              const SizedBox(height: 26),
              for (final reason in reasons)
                Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ReasonCard(
                        reason: reason,
                        selected: !isCustom &&
                            selectedId.isNotEmpty &&
                            selectedId == reason.id,
                        surface: surface,
                        border: border,
                        accent: accent,
                        base: base,
                        onTap: () => onSelect(reason))),
              const SizedBox(height: 8),
              TextField(
                controller: otherController,
                minLines: 3,
                maxLines: 5,
                onChanged: onOtherChanged,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                cursorColor: accent,
                style: base.copyWith(fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  labelText: l10n.otherReason,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: RideColorBadge(
                          icon: Icons.edit_note_rounded,
                          gradient: RideVisuals.blue,
                          size: 32,
                          iconSize: 20,
                          radius: 11)),
                  prefixIconConstraints: const BoxConstraints(minWidth: 56),
                  labelStyle: base.copyWith(color: isCustom ? accent : muted),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: surface,
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          BorderSide(color: isCustom ? accent : border)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: accent, width: 1.4)),
                ),
              ),
            ])),
        Container(
            decoration: BoxDecoration(
                color: surface, border: Border(top: BorderSide(color: border))),
            child: SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                      width: double.infinity,
                      child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: otherController,
                          builder: (context, value, _) {
                            final valid = isCustom
                                ? value.text.trim().isNotEmpty
                                : reasons.any((reason) =>
                                    reason.id == selectedId &&
                                    selectedId.isNotEmpty);
                            final enabled = valid && onCancel != null;
                            return Container(
                                decoration: BoxDecoration(
                                    gradient: enabled ? RideVisuals.rose : null,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: enabled
                                        ? RideVisuals.glow(AppColors.meshwarRed,
                                            strength: .2)
                                        : null),
                                child: FilledButton(
                                    onPressed: valid ? onCancel : null,
                                    style: FilledButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: border,
                                        disabledForegroundColor: muted,
                                        minimumSize: const Size.fromHeight(52),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24))),
                                    child: Text(l10n.cancelRide,
                                        textAlign: TextAlign.center,
                                        style: base.copyWith(
                                            color: valid && onCancel != null
                                                ? Colors.white
                                                : muted,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700))));
                          })),
                  const SizedBox(height: 4),
                  TextButton(
                      onPressed: onBack,
                      style: TextButton.styleFrom(
                          foregroundColor: ink,
                          minimumSize: const Size(80, 44)),
                      child: Text(l10n.back, style: base)),
                ]))),
      ]),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard(
      {required this.reason,
      required this.selected,
      required this.surface,
      required this.border,
      required this.accent,
      required this.base,
      required this.onTap});
  final CancelReasonOption reason;
  final bool selected;
  final Color surface, border, accent;
  final TextStyle base;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Semantics(
      label: reason.title,
      checked: selected,
      inMutuallyExclusiveGroup: true,
      onTap: onTap,
      child: ExcludeSemantics(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: radius,
                  boxShadow: RideVisuals.glow(
                      selected ? AppColors.meshwarRed : const Color(0xFFE6862A),
                      strength: selected ? .12 : .06)),
              child: Material(
                  color: selected
                      ? Color.alphaBlend(accent.withValues(alpha: .06), surface)
                      : surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: radius,
                      side: BorderSide(
                          color: selected ? accent : border,
                          width: selected ? 1.4 : 1)),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                      onTap: onTap,
                      child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(children: [
                            const RideColorBadge(
                                icon: Icons.list_alt_rounded,
                                gradient: RideVisuals.amber,
                                size: 34,
                                iconSize: 19),
                            const SizedBox(width: 14),
                            Expanded(
                                child: Text(reason.title,
                                    style: base.copyWith(
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500))),
                            const SizedBox(width: 12),
                            Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: selected
                                    ? accent
                                    : base.color?.withValues(alpha: .45),
                                size: 22),
                          ])))))),
    );
  }
}
