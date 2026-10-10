import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/application/auth_bloc.dart';
import '../../../../../auth/presentation/widgets/select_country_widget.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../../profile/widget/profile_edit_layout.dart';
import '../../profile/widget/profile_mobile_fields.dart';

class SosAddContactSheet extends StatefulWidget {
  const SosAddContactSheet({super.key, required this.accBloc});
  final AccBloc accBloc;
  @override
  State<SosAddContactSheet> createState() => _SosAddContactSheetState();
}

class _SosAddContactSheetState extends State<SosAddContactSheet> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  final _form = GlobalKey<FormState>();
  String? _phoneError;
  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AuthBloc()
          ..add(GetDirectionEvent())
          ..add(CountryGetEvent())
          ..add(GetCommonModuleEvent()),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          final auth = context.read<AuthBloc>();
          final l10n = AppLocalizations.of(context)!;
          InputDecoration decoration(String label) => InputDecoration(
              labelText: label,
              filled: true,
              fillColor: AppColors.surface(context),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: AppColors.surfaceBorder(context))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: AppColors.surfaceBorder(context))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: AppColors.meshwarRed, width: 1.5)));
          return Directionality(
              textDirection: widget.accBloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: ProfileEditLayout(
                title: l10n.addContact,
                label: l10n.addContact,
                description: l10n.addContactsText,
                icon: Icons.person_add_alt_1_rounded,
                gradient: RideVisuals.green,
                saveLabel: l10n.addContact,
                onBack: () => Navigator.pop(context),
                onSave: () {
                  final valid = _form.currentState!.validate();
                  final phone = _phone.text.trim();
                  setState(() => _phoneError =
                      phone.isEmpty ? l10n.phoneNumberRequired : null);
                  if (!valid || phone.isEmpty) return;
                  if (auth.dialCode.isEmpty) {
                    setState(() => _phoneError = l10n.selectContry);
                    return;
                  }
                  final dial = auth.dialCode.startsWith('+')
                      ? auth.dialCode
                      : '+${auth.dialCode}';
                  widget.accBloc.add(AddContactEvent(
                      name: '${_first.text.trim()} ${_last.text.trim()}'.trim(),
                      number: '$dial$phone'));
                  Navigator.pop(context);
                },
                field: Form(
                    key: _form,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                              controller: _first,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              style: AccountStyle.text(context)
                                  .copyWith(fontSize: 16),
                              decoration: decoration(l10n.firstName),
                              validator: (_) => _first.text.trim().isEmpty &&
                                      _last.text.trim().isEmpty
                                  ? l10n.nameRequired
                                  : null),
                          const SizedBox(height: 16),
                          TextFormField(
                              controller: _last,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              style: AccountStyle.text(context)
                                  .copyWith(fontSize: 16),
                              decoration: decoration(l10n.lastName)),
                          const SizedBox(height: 16),
                          ProfileMobileFields(
                              phoneController: _phone,
                              otpController: auth.otpController.textController,
                              mobileLabel: l10n.phoneNumber,
                              otpLabel: l10n.enterOtp,
                              countryLabel: l10n.selectContry,
                              dialCode: auth.dialCode,
                              maxLength: auth.dialMaxLength,
                              onCountry: auth.countries.isEmpty
                                  ? null
                                  : () => showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (_) => SelectCountryWidget(
                                          cont: context,
                                          countries: auth.countries))),
                          if (_phoneError != null)
                            Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(_phoneError!,
                                    style: AccountStyle.text(context).copyWith(
                                        color: AppColors.meshwarRed,
                                        fontSize: 12))),
                        ])),
              ));
        }),
      );
}
