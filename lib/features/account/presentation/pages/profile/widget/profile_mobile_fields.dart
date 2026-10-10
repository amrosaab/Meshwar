import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../common/app_colors.dart';
import '../../../widgets/account_content.dart';

class ProfileMobileFields extends StatelessWidget {
  const ProfileMobileFields(
      {super.key,
      required this.phoneController,
      required this.otpController,
      required this.mobileLabel,
      required this.otpLabel,
      required this.countryLabel,
      required this.dialCode,
      required this.onCountry,
      required this.maxLength,
      this.showOtp = false,
      this.enabled = true});
  final TextEditingController phoneController, otpController;
  final String mobileLabel, otpLabel, countryLabel, dialCode;
  final VoidCallback? onCountry;
  final int maxLength;
  final bool showOtp, enabled;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.surfaceBorder(context)));
    final fill = Theme.of(context).brightness == Brightness.dark
        ? AppColors.bgVoid
        : const Color(0xFFF8F6F9);
    InputDecoration decoration(String hint) => InputDecoration(
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: fill,
        hintStyle: AccountStyle.text(context)
            .copyWith(color: AccountStyle.muted(context)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide:
                const BorderSide(color: AppColors.meshwarRed, width: 1.5)));
    final country = Semantics(
        label: countryLabel,
        child: OutlinedButton(
          onPressed: enabled ? onCountry : null,
          style: OutlinedButton.styleFrom(
              backgroundColor: fill,
              foregroundColor: AccountStyle.ink(context),
              side: BorderSide(color: AppColors.surfaceBorder(context)),
              minimumSize: const Size(90, 58),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.ltr,
              children: [
                Flexible(
                    child: Text(dialCode.isEmpty ? '—' : dialCode,
                        textDirection: TextDirection.ltr,
                        style: AccountStyle.text(context).copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600))),
                const SizedBox(width: 4),
                const ExcludeSemantics(
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 20)),
              ]),
        ));
    final phone = TextField(
      controller: phoneController,
      enabled: enabled,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      maxLength: maxLength,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: AppColors.meshwarRed,
      style: AccountStyle.text(context).copyWith(fontSize: 16),
      decoration: decoration(mobileLabel),
    );
    return AutofillGroup(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      LayoutBuilder(builder: (context, constraints) {
        final stacked = constraints.maxWidth < 260 ||
            MediaQuery.textScalerOf(context).scale(16) > 22;
        return stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [country, const SizedBox(height: 12), phone])
            : Row(children: [
                country,
                const SizedBox(width: 10),
                Expanded(child: phone)
              ]);
      }),
      if (showOtp) ...[
        const SizedBox(height: 24),
        Text(otpLabel,
            style: AccountStyle.text(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        TextField(
          controller: otpController,
          enabled: enabled,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 6,
          autofillHints: const [AutofillHints.oneTimeCode],
          cursorColor: AppColors.meshwarRed,
          style: AccountStyle.text(context).copyWith(
              fontSize: 20, letterSpacing: 5, fontWeight: FontWeight.w600),
          decoration: decoration('••••••'),
        ),
      ],
    ]));
  }
}
