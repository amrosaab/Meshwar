import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_validators.dart';
import '../../../../common/ride_visuals.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/widgets/account_content.dart';

class RegistrationLayout extends StatelessWidget {
  const RegistrationLayout({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.emailVerified,
    required this.dialCode,
    required this.flagUrl,
    required this.gender,
    required this.genders,
    required this.showPassword,
    required this.busy,
    required this.onBack,
    required this.onCountry,
    required this.onGender,
    required this.onTogglePassword,
    required this.onRegister,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController,
      phoneController,
      emailController,
      passwordController;
  final bool emailVerified, showPassword, busy;
  final String dialCode, flagUrl, gender;
  final List<String> genders;
  final VoidCallback onBack, onTogglePassword, onRegister;
  final VoidCallback? onCountry;
  final ValueChanged<String> onGender;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? const Color(0xFFFF82A6) : AppColors.meshwarRed;
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.surfaceBorder(context)));
    InputDecoration decoration(String label, {Widget? suffix}) =>
        InputDecoration(
            labelText: label,
            labelStyle: AccountStyle.text(context)
                .copyWith(color: AccountStyle.muted(context)),
            counterText: '',
            suffixIcon: suffix,
            filled: true,
            fillColor: dark ? AppColors.bgVoid : const Color(0xFFF8F6F9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: border,
            enabledBorder: border,
            disabledBorder: border,
            focusedBorder: border.copyWith(
                borderSide: BorderSide(color: accent, width: 1.5)),
            errorMaxLines: 4);
    const verifiedIcon = ExcludeSemantics(
        child: Icon(Icons.check_circle_rounded,
            color: AppColors.routeGreen, size: 20));
    final mobile = TextFormField(
      controller: phoneController,
      enabled: !busy && emailVerified,
      textDirection: TextDirection.ltr,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: AccountStyle.text(context).copyWith(fontSize: 16),
      decoration: decoration(l10n.mobileNumber,
          suffix: emailVerified ? null : verifiedIcon),
      validator: (value) {
        if (value == null || value.isEmpty) return l10n.enterMobile;
        if (!AppValidation.mobileNumberValidate(value)) return l10n.validMobile;
        return null;
      },
    );
    final country = OutlinedButton(
      onPressed: !busy && emailVerified ? onCountry : null,
      style: OutlinedButton.styleFrom(
          foregroundColor: AccountStyle.ink(context),
          disabledForegroundColor: AccountStyle.ink(context),
          backgroundColor: dark ? AppColors.bgVoid : const Color(0xFFF8F6F9),
          minimumSize: const Size(90, 58),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          side: BorderSide(color: AppColors.surfaceBorder(context)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
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
                              const Icon(Icons.public_rounded, size: 20)))),
              const SizedBox(width: 8),
            ],
            Flexible(
                child: Text(dialCode.isEmpty ? '—' : dialCode,
                    style: AccountStyle.text(context)
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
            if (emailVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            ],
          ]),
    );
    final genderLabels = [l10n.male, l10n.female, l10n.preferNotSay];
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
        leading: IconButton(
            onPressed: busy ? null : onBack,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(Icons.arrow_back_rounded)),
        title: Text(l10n.register,
            maxLines: 2,
            style: AccountStyle.text(context).copyWith(
                fontSize: 22, height: 1.2, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: formKey,
          child: AutofillGroup(
              child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                      gradient:
                          RideVisuals.wash(context, const Color(0xFF3A72D4)),
                      borderRadius: BorderRadius.circular(28),
                      border:
                          Border.all(color: AppColors.surfaceBorder(context))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ExcludeSemantics(
                            child: RideColorBadge(
                                icon: Icons.person_add_alt_1_rounded,
                                gradient: RideVisuals.blue,
                                size: 56,
                                iconSize: 28,
                                radius: 18)),
                        const SizedBox(height: 18),
                        Text(l10n.signUp,
                            style: AccountStyle.text(context).copyWith(
                                fontSize: 24,
                                height: 1.25,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Text(l10n.getStarted,
                            style: AccountStyle.text(context)
                                .copyWith(color: AccountStyle.muted(context))),
                      ]),
                ),
                const SizedBox(height: 18),
                _RegistrationCard(
                    title: l10n.personalInformation,
                    icon: Icons.badge_outlined,
                    gradient: RideVisuals.green,
                    children: [
                      TextFormField(
                          controller: nameController,
                          enabled: !busy,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          style:
                              AccountStyle.text(context).copyWith(fontSize: 16),
                          decoration: decoration(l10n.fullName),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? l10n.enterUserName
                                  : null),
                      const SizedBox(height: 18),
                      LayoutBuilder(
                          builder: (context, constraints) => constraints
                                          .maxWidth <
                                      280 ||
                                  MediaQuery.textScalerOf(context).scale(16) >
                                      22
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                      country,
                                      const SizedBox(height: 12),
                                      mobile
                                    ])
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      country,
                                      const SizedBox(width: 10),
                                      Expanded(child: mobile)
                                    ])),
                      const SizedBox(height: 18),
                      TextFormField(
                          controller: emailController,
                          enabled: !busy && !emailVerified,
                          textDirection: TextDirection.ltr,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          autocorrect: false,
                          style:
                              AccountStyle.text(context).copyWith(fontSize: 16),
                          decoration: decoration(
                              emailVerified
                                  ? l10n.emailAddress
                                  : '${l10n.emailAddress} (${l10n.optional})',
                              suffix: emailVerified ? verifiedIcon : null),
                          validator: (value) => value != null &&
                                  value.isNotEmpty &&
                                  !AppValidation.emailValidate(value)
                              ? l10n.validEmail
                              : null),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<String>(
                          initialValue:
                              genders.contains(gender) ? gender : null,
                          isExpanded: true,
                          isDense: false,
                          itemHeight: null,
                          selectedItemBuilder: (context) => [
                                for (final label
                                    in genderLabels.take(genders.length))
                                  Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(label,
                                          style: AccountStyle.text(context)
                                              .copyWith(fontSize: 16))),
                              ],
                          style:
                              AccountStyle.text(context).copyWith(fontSize: 16),
                          dropdownColor: AppColors.surface(context),
                          decoration: decoration(l10n.gender),
                          items: [
                            for (var i = 0;
                                i < genders.length && i < genderLabels.length;
                                i++)
                              DropdownMenuItem(
                                  value: genders[i],
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(genderLabels[i])))
                          ],
                          onChanged: busy
                              ? null
                              : (value) {
                                  if (value != null) onGender(value);
                                },
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.requiredField
                              : null),
                    ]),
                const SizedBox(height: 18),
                _RegistrationCard(
                    title: l10n.password,
                    icon: Icons.lock_outline_rounded,
                    gradient: RideVisuals.amber,
                    children: [
                      TextFormField(
                          controller: passwordController,
                          enabled: !busy,
                          obscureText: !showPassword,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                          autocorrect: false,
                          enableSuggestions: false,
                          style:
                              AccountStyle.text(context).copyWith(fontSize: 16),
                          decoration: decoration(l10n.password,
                              suffix: Semantics(
                                  toggled: showPassword,
                                  label: l10n.password,
                                  child: IconButton(
                                      onPressed: busy ? null : onTogglePassword,
                                      icon: Icon(showPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                      color: AccountStyle.muted(context)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.enterPassword;
                            }
                            if (value.length < 8) return l10n.minPassRequired;
                            return null;
                          }),
                    ]),
              ],
            ),
          )),
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
          child: FilledButton(
            onPressed: busy ? null : onRegister,
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.meshwarRed,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.meshwarRed,
                disabledForegroundColor: Colors.white,
                minimumSize: const Size.fromHeight(58),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (busy) ...[
                const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)),
                const SizedBox(width: 10)
              ],
              Flexible(
                  child: Text(l10n.register,
                      textAlign: TextAlign.center,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700))),
            ]),
          ),
        ),
      ),
    );
  }
}

class _RegistrationCard extends StatelessWidget {
  const _RegistrationCard(
      {required this.title,
      required this.icon,
      required this.gradient,
      required this.children});
  final String title;
  final IconData icon;
  final LinearGradient gradient;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.surfaceBorder(context))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ExcludeSemantics(
                child: RideColorBadge(icon: icon, gradient: gradient)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(title,
                    style: AccountStyle.text(context).copyWith(
                        fontSize: 18,
                        height: 1.25,
                        fontWeight: FontWeight.w700)))
          ]),
          const SizedBox(height: 22),
          ...children,
        ]),
      );
}
