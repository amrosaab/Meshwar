import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_arguments.dart';
import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../userprofile/presentation/pages/driver_profile_pages.dart';
import '../../application/auth_bloc.dart';

class RefferalPage extends StatelessWidget {
  static const String routeName = '/refferalPage';
  const RefferalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AuthBloc()..add(GetDirectionEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
          if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          }
          if (state is AuthDataLoadedState) {
            CustomLoader.dismiss(context);
          }
          if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          }
          if (state is LoginLoadingState) {
            CustomLoader.loader(context);
          }
          if (state is LoginFailureState) {
            CustomLoader.dismiss(context);
          }
          if (state is ReferralSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
                context, DriverProfilePage.routeName, (route) => false,
                arguments:
                const DriverProfilePageArguments(from: 'onboarding'));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Directionality(
              textDirection: context.read<AuthBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.applyRefferal,
                  titleFontSize: 16,
                ),
                body: CustomBackground(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.width * 0.05),
                          MyText(
                              text: AppLocalizations.of(context)!.applyRefferal,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: AppColors.hintColor, fontSize: 14)),
                          SizedBox(height: size.width * 0.025),
                          CustomTextField(
                            controller: context
                                .read<AuthBloc>()
                                .rReferralCodeController,
                            contentPadding: EdgeInsets.all(size.width * 0.025),
                            borderRadius: 14,
                            filled: true,
                            hintText:
                            AppLocalizations.of(context)!.enterRefferalCode,
                          ),
                          SizedBox(height: size.width * 0.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                buttonName: AppLocalizations.of(context)!.skip,
                                borderRadius: 16,
                                isBorder: true,
                                buttonColor: Colors.transparent,
                                textColor: Theme.of(context).primaryColorDark,
                                width: size.width * 0.4,
                                onTap: () {
                                  context.read<AuthBloc>().add(ReferralEvent(
                                      referralCode: 'Skip', context: context));
                                },
                              ),
                              CustomButton(
                                buttonName: AppLocalizations.of(context)!.apply,
                                borderRadius: 16,
                                isLoader: context.read<AuthBloc>().isLoading,
                                width: size.width * 0.4,
                                onTap: () {
                                  context.read<AuthBloc>().add(ReferralEvent(
                                      referralCode: context
                                          .read<AuthBloc>()
                                          .rReferralCodeController
                                          .text,
                                      context: context));
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: size.width * 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}