import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/ride_visuals.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/widgets/account_content.dart';

class OtpVerificationLayout extends StatelessWidget {
  const OtpVerificationLayout({
    super.key,
    required this.email,
    required this.destination,
    required this.controller,
    required this.remaining,
    required this.busy,
    required this.onChanged,
    required this.onChange,
    required this.onResend,
    required this.onVerify,
  });

  final bool email, busy;
  final String destination;
  final TextEditingController controller;
  final int remaining;
  final ValueChanged<String> onChanged;
  final VoidCallback onChange, onResend, onVerify;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? const Color(0xFFFF82A6) : AppColors.meshwarRed;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: AppColors.surfaceBorder(context)),
    );
    final countdown = '${(remaining ~/ 60).toString().padLeft(2, '0')}:'
        '${(remaining % 60).toString().padLeft(2, '0')}';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RideVisuals.canvas(context),
      appBar: AppBar(
        backgroundColor: dark ? AppColors.bgAsphaltLight : Colors.white,
        foregroundColor: AccountStyle.ink(context),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarHeight:
            MediaQuery.textScalerOf(context).scale(22) > 32 ? 120 : 64,
        title: Text(l10n.verifyYourAccount,
            maxLines: 2,
            style: AccountStyle.text(context).copyWith(
                fontSize: 22, height: 1.2, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: RideVisuals.wash(context, const Color(0xFF3A72D4)),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.surfaceBorder(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(
                    child: SizedBox(
                      width: 110,
                      height: 88,
                      child: Stack(children: [
                        RideColorBadge(
                            icon: Icons.password_rounded,
                            gradient: RideVisuals.blue,
                            size: 72,
                            iconSize: 34,
                            radius: 24),
                        Positioned(
                            right: 10,
                            bottom: 0,
                            child: RideColorBadge(
                                icon: Icons.shield_outlined,
                                gradient: RideVisuals.green,
                                size: 32,
                                iconSize: 18,
                                radius: 11)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(l10n.enterOtp,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 24,
                          height: 1.25,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(l10n.sendCode,
                      style: AccountStyle.text(context)
                          .copyWith(color: AccountStyle.muted(context))),
                  const SizedBox(height: 10),
                  Text(destination,
                      textDirection: TextDirection.ltr,
                      style: AccountStyle.text(context)
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                  TextButton.icon(
                      onPressed: busy ? null : onChange,
                      style: TextButton.styleFrom(
                          foregroundColor: accent,
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(email ? l10n.changeEmail : l10n.changeNumber,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 14),
                  AutofillGroup(
                    child: LayoutBuilder(builder: (context, constraints) {
                      final compact = constraints.maxWidth < 260 ||
                          MediaQuery.textScalerOf(context).scale(24) > 36;
                      return TextField(
                        controller: controller,
                        enabled: !busy,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        cursorColor: accent,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 24,
                            letterSpacing: compact ? 2 : 10,
                            fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          labelText: l10n.enterOtp,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: AccountStyle.text(context)
                              .copyWith(color: AccountStyle.muted(context)),
                          hintText: '000000',
                          hintStyle: TextStyle(
                              color: AccountStyle.muted(context)
                                  .withValues(alpha: .45)),
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.surface(context),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 22),
                          border: border,
                          enabledBorder: border,
                          disabledBorder: border,
                          focusedBorder: border.copyWith(
                              borderSide:
                                  BorderSide(color: accent, width: 1.5)),
                        ),
                        onChanged: onChanged,
                        onSubmitted: (_) {
                          if (!busy && controller.text.length == 6) onVerify();
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (remaining > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE6862A)
                                  .withValues(alpha: dark ? .15 : .09),
                              borderRadius: BorderRadius.circular(14)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const ExcludeSemantics(
                                child: Icon(Icons.hourglass_bottom_rounded,
                                    size: 18, color: Color(0xFFE6862A))),
                            const SizedBox(width: 8),
                            Text(countdown,
                                textDirection: TextDirection.ltr,
                                style: AccountStyle.text(context).copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures()
                                    ])),
                          ]),
                        ),
                      TextButton.icon(
                        onPressed: remaining == 0 && !busy ? onResend : null,
                        style: TextButton.styleFrom(foregroundColor: accent),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(l10n.resendOtp,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 180),
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => FilledButton(
              onPressed: !busy && value.text.length == 6 ? onVerify : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.meshwarRed,
                foregroundColor: Colors.white,
                disabledBackgroundColor: busy
                    ? AppColors.meshwarRed
                    : AppColors.meshwarRed.withValues(alpha: .4),
                disabledForegroundColor: Colors.white,
                minimumSize: const Size.fromHeight(58),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (busy) ...[
                  const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)),
                  const SizedBox(width: 10),
                ],
                Flexible(
                    child: Text(l10n.verifyOtp,
                        textAlign: TextAlign.center,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
