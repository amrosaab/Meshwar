import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/ride_visuals.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/widgets/account_content.dart';

class VerifyContactLayout extends StatelessWidget {
  const VerifyContactLayout(
      {super.key,
      required this.email,
      required this.field,
      required this.busy,
      required this.onSend,
      required this.onSignIn,
      required this.onTerms,
      required this.onPrivacy});
  final bool email, busy;
  final Widget field;
  final VoidCallback onSend, onSignIn, onTerms, onPrivacy;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = email ? l10n.verifyEmailText : l10n.verifyPhone;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: RideVisuals.canvas(context),
      appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.bgAsphaltLight
              : Colors.white,
          foregroundColor: AccountStyle.ink(context),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          toolbarHeight:
              MediaQuery.textScalerOf(context).scale(22) > 32 ? 120 : 64,
          title: Text(title,
              maxLines: 2,
              style: AccountStyle.text(context).copyWith(
                  fontSize: 22, height: 1.2, fontWeight: FontWeight.w700))),
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
                        gradient:
                            RideVisuals.wash(context, const Color(0xFF3A72D4)),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                            color: AppColors.surfaceBorder(context))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          ExcludeSemantics(
                              child: SizedBox(
                                  width: 110,
                                  height: 88,
                                  child: Stack(children: [
                                    RideColorBadge(
                                        icon: email
                                            ? Icons.mail_outline_rounded
                                            : Icons.phone_iphone_rounded,
                                        gradient: RideVisuals.blue,
                                        size: 72,
                                        iconSize: 34,
                                        radius: 24),
                                    const Positioned(
                                        right: 10,
                                        bottom: 0,
                                        child: RideColorBadge(
                                            icon: Icons.shield_outlined,
                                            gradient: RideVisuals.green,
                                            size: 32,
                                            iconSize: 18,
                                            radius: 11)),
                                  ]))),
                          const SizedBox(height: 22),
                          Text(
                              email
                                  ? l10n.verifyEmailId
                                  : l10n.verifyMobileNumber,
                              style: AccountStyle.text(context).copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25)),
                          const SizedBox(height: 12),
                          Text(l10n.confirmOtpNumber,
                              style: AccountStyle.text(context).copyWith(
                                  color: AccountStyle.muted(context))),
                          const SizedBox(height: 26),
                          field,
                        ])),
                const SizedBox(height: 20),
                Text(l10n.signupAgree,
                    textAlign: TextAlign.center,
                    style: AccountStyle.text(context).copyWith(
                        fontSize: 12, color: AccountStyle.muted(context))),
                Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TextButton(
                          onPressed: onTerms,
                          style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFFFF82A6)
                                  : AppColors.meshwarRed),
                          child: Text(l10n.termsOfService,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700))),
                      Text(l10n.and,
                          style: AccountStyle.text(context).copyWith(
                              fontSize: 12,
                              color: AccountStyle.muted(context))),
                      TextButton(
                          onPressed: onPrivacy,
                          style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFFFF82A6)
                                  : AppColors.meshwarRed),
                          child: Text(l10n.privacyPolicyText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700))),
                    ]),
                const SizedBox(height: 14),
                Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(l10n.alreadyHaveAccount,
                          textAlign: TextAlign.center,
                          style: AccountStyle.text(context)
                              .copyWith(color: AccountStyle.muted(context))),
                      TextButton(
                          onPressed: busy ? null : onSignIn,
                          style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFFFF82A6)
                                  : AppColors.meshwarRed),
                          child: Text(l10n.signIn,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700))),
                    ]),
              ])),
      bottomNavigationBar: AnimatedPadding(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          padding:
              EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: FilledButton(
                  onPressed: busy ? null : onSend,
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.meshwarRed,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.meshwarRed,
                      disabledForegroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(58),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (busy) ...[
                          const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)),
                          const SizedBox(width: 10)
                        ],
                        Flexible(
                            child: Text(l10n.sendOtp,
                                textAlign: TextAlign.center,
                                style: AccountStyle.text(context).copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700))),
                      ])))),
    );
  }
}

class VerifyContactField extends StatelessWidget {
  const VerifyContactField(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.email,
      required this.dialCode,
      required this.maxLength,
      required this.onCountry,
      this.flagUrl = '',
      this.enabled = true});
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool email, enabled;
  final String dialCode, flagUrl;
  final int maxLength;
  final VoidCallback? onCountry;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.surfaceBorder(context)));
    final field = TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        textDirection: TextDirection.ltr,
        keyboardType: email ? TextInputType.emailAddress : TextInputType.phone,
        textInputAction: TextInputAction.done,
        autofillHints: [
          email ? AutofillHints.email : AutofillHints.telephoneNumberNational
        ],
        maxLength: email
            ? null
            : maxLength > 0
                ? maxLength
                : 15,
        inputFormatters:
            email ? null : [FilteringTextInputFormatter.digitsOnly],
        cursorColor: AppColors.meshwarRed,
        style: AccountStyle.text(context).copyWith(fontSize: 16),
        decoration: InputDecoration(
            labelText: email ? l10n.email : l10n.mobile,
            counterText: '',
            filled: true,
            fillColor: AppColors.surface(context),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: border,
            enabledBorder: border,
            disabledBorder: border,
            focusedBorder: border.copyWith(
                borderSide:
                    const BorderSide(color: AppColors.meshwarRed, width: 1.5)),
            suffixIcon: IconButton(
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                onPressed: enabled ? controller.clear : null,
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AccountStyle.muted(context))));
    if (email) return AutofillGroup(child: field);
    final country = Semantics(
        label: l10n.selectContry,
        child: OutlinedButton(
            onPressed: enabled ? onCountry : null,
            style: OutlinedButton.styleFrom(
                foregroundColor: AccountStyle.ink(context),
                backgroundColor: AppColors.surface(context),
                minimumSize: const Size(90, 58),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                side: BorderSide(color: AppColors.surfaceBorder(context)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.ltr,
                children: [
                  if (flagUrl.isNotEmpty) ...[
                    ExcludeSemantics(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(flagUrl,
                                width: 24,
                                height: 18,
                                fit: BoxFit.cover,
                                errorBuilder: (_, error, stackTrace) =>
                                    const Icon(Icons.public_rounded,
                                        size: 20)))),
                    const SizedBox(width: 8)
                  ],
                  Flexible(
                      child: Text(dialCode.isEmpty ? '—' : dialCode,
                          textDirection: TextDirection.ltr,
                          style: AccountStyle.text(context).copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600))),
                  const SizedBox(width: 4),
                  const ExcludeSemantics(
                      child: Icon(Icons.keyboard_arrow_down_rounded, size: 18)),
                ])));
    return AutofillGroup(
        child: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth < 280 ||
                    MediaQuery.textScalerOf(context).scale(16) > 22
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [country, const SizedBox(height: 12), field])
                : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    country,
                    const SizedBox(width: 10),
                    Expanded(child: field)
                  ])));
  }
}
