import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../core/network/extensions.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/profile_edit_layout.dart';

class UpdateDetails extends StatefulWidget {
  static const String routeName = '/UpdateDetails';
  final UpdateDetailsArguments arg;
  const UpdateDetails({super.key, required this.arg});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<AccBloc>();
      bloc.add(AccGetDirectionEvent());
      bloc.add(UpdateControllerWithDetailsEvent(args: widget.arg));
    });
  }

  void _submit(BuildContext context, AccBloc bloc) {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context)!;
    final header = widget.arg.header;
    final user = bloc.userData ?? widget.arg.userData;
    final text = bloc.updateController.text.trim();
    setState(() => _saving = true);
    FocusScope.of(context).unfocus();
    bloc.add(UpdateUserDetailsEvent(
      name: header == l10n.name ? text : '',
      email: header == l10n.email || header == l10n.emailAddress ? text : '',
      gender: header == l10n.gender ? bloc.selectedGender : '',
      profileImage: bloc.profileImage.isEmpty ? '' : bloc.profileImage,
      mobile: header == l10n.mobile ? text : '',
      country: header == l10n.mobile ? user.countryCode : '',
    ));
  }

  @override
  Widget build(BuildContext context) => BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (!_saving || ModalRoute.of(context)?.isCurrent == false) return;
          final l10n = AppLocalizations.of(context)!;
          if (state is UserDetailsUpdatedState) {
            context.showSnackBar(
                color: AppColors.routeGreen, message: l10n.updateSuccess);
            Future.delayed(const Duration(milliseconds: 300), () {
              if (context.mounted) Navigator.pop(context, state);
            });
          } else if (state is UpdateUserDetailsFailureState) {
            setState(() => _saving = false);
            context.showSnackBar(
                color: AppColors.meshwarRed, message: l10n.failedUpdateDetails);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final l10n = AppLocalizations.of(context)!;
          final header = widget.arg.header;
          final isName = header == l10n.name;
          final isGender = header == l10n.gender;
          final isMobile = header == l10n.mobile;
          final isEmail = header == l10n.email || header == l10n.emailAddress;
          final genderLabels = [l10n.male, l10n.female, l10n.preferNotSay];
          final border = OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.surfaceBorder(context)));
          final decoration = InputDecoration(
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.bgVoid
                : const Color(0xFFF8F6F9),
            hintText: isGender
                ? l10n.selectGender
                : isName
                    ? l10n.enterYourName
                    : header,
            hintStyle: AccountStyle.text(context)
                .copyWith(color: AccountStyle.muted(context)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: border,
            enabledBorder: border,
            disabledBorder: border,
            focusedBorder: border.copyWith(
                borderSide:
                    const BorderSide(color: AppColors.meshwarRed, width: 1.5)),
          );
          return Directionality(
            textDirection: bloc.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: ProfileEditLayout(
              title: '${l10n.update} $header',
              label: header,
              description: isName
                  ? l10n.enterNameIdOrPassport
                  : isGender
                      ? l10n.enterYourGender
                      : isMobile
                          ? l10n.mobile
                          : l10n.enterYourEmail,
              icon: isName
                  ? Icons.person_outline_rounded
                  : isGender
                      ? Icons.person_rounded
                      : isMobile
                          ? Icons.phone_outlined
                          : Icons.mail_outline_rounded,
              gradient: isMobile
                  ? RideVisuals.green
                  : isEmail
                      ? RideVisuals.amber
                      : RideVisuals.blue,
              saveLabel: l10n.update,
              saving: _saving,
              onBack: () => Navigator.pop(context),
              onSave: () => _submit(context, bloc),
              field: Form(
                  key: _formKey,
                  child: isGender
                      ? DropdownButtonFormField<String>(
                          initialValue:
                              bloc.genderOptions.contains(bloc.selectedGender)
                                  ? bloc.selectedGender
                                  : null,
                          isExpanded: true,
                          decoration: decoration,
                          dropdownColor: AppColors.surfaceStrong(context),
                          style:
                              AccountStyle.text(context).copyWith(fontSize: 16),
                          items: [
                            for (var i = 0; i < genderLabels.length; i++)
                              DropdownMenuItem(
                                  value: bloc.genderOptions[i],
                                  child: Text(genderLabels[i]))
                          ],
                          onChanged: _saving
                              ? null
                              : (value) {
                                  if (value != null) {
                                    bloc.add(GenderSelectedEvent(
                                        selectedGender: value));
                                  }
                                })
                      : TextFormField(
                          controller: bloc.updateController,
                          enabled: !_saving,
                          decoration: decoration,
                          style:
                              AccountStyle.text(context).copyWith(fontSize: 16),
                          cursorColor: AppColors.meshwarRed,
                          keyboardType: isName
                              ? TextInputType.name
                              : isMobile
                                  ? TextInputType.phone
                                  : isEmail
                                      ? TextInputType.emailAddress
                                      : TextInputType.text,
                          textCapitalization: isName
                              ? TextCapitalization.words
                              : TextCapitalization.none,
                          textDirection:
                              isMobile || isEmail ? TextDirection.ltr : null,
                          textInputAction: TextInputAction.done,
                          autocorrect: isName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: isName
                              ? (value) => (value?.trim().isEmpty ?? true)
                                  ? l10n.nameRequired
                                  : null
                              : null,
                          onFieldSubmitted: (_) => _submit(context, bloc),
                        )),
            ),
          );
        }),
      );
}
