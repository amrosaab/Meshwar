import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/auth_bloc.dart';
import 'login_page.dart';

class UpdatePasswordPage extends StatelessWidget {
  static const String routeName = '/updatePasswordPage';
  final UpdatePasswordPageArguments arg;
  const UpdatePasswordPage({super.key, required this.arg});

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
          if (state is ForgotPasswordUpdateSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Directionality(
                textDirection: context.read<AuthBloc>().textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.updatePassword,
                    automaticallyImplyLeading: true,
                    titleFontSize: 18,
                    textColor: Theme.of(context).primaryColorDark,
                  ),
                  body: CustomBackground(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: context.read<AuthBloc>().formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.beaconGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.meshwarRed
                                              .withOpacity(0.35),
                                          blurRadius: 20,
                                          spreadRadius: -4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.lock_reset_rounded,
                                        color: Colors.white, size: 26),
                                  ),
                                ),
                                SizedBox(height: size.width * 0.05),
                                Center(
                                  child: MyText(
                                    text: AppLocalizations.of(context)!
                                        .enterNewPassword,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                        color:
                                        Theme.of(context).disabledColor,
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(height: size.width * 0.07),
                                MyText(
                                  text: AppLocalizations.of(context)!.password,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    color:
                                    Theme.of(context).primaryColorDark,
                                  ),
                                ),
                                SizedBox(height: size.width * 0.02),
                                buildPasswordField(context, size),
                                SizedBox(height: size.width * 0.02),
                                SizedBox(height: size.width * 0.1),
                                buildButton(context),
                                SizedBox(height: size.width * 0.3),
                              ],
                            ),
                          ),
                        ),
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

  Widget buildButton(BuildContext context) {
    return Center(
      child: CustomButton(
        buttonName: AppLocalizations.of(context)!.change,
        borderRadius: 16,
        textSize: 16,
        width: MediaQuery.sizeOf(context).width,
        isLoader: context.read<AuthBloc>().isLoading,
        onTap: () {
          if (context.read<AuthBloc>().formKey.currentState!.validate()) {
            context.read<AuthBloc>().add(
              UpdatePasswordEvent(
                isLoginByEmail: arg.isLoginByEmail,
                password: context.read<AuthBloc>().rPasswordController.text,
                emailOrMobile: arg.emailOrMobile,
                context: context,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildPasswordField(BuildContext context, Size size) {
    return CustomTextField(
      controller: context.read<AuthBloc>().rPasswordController,
      contentPadding: EdgeInsets.all(size.width * 0.025),
      borderRadius: 14,
      filled: true,
      obscureText: !context.read<AuthBloc>().showPassword,
      hintText: AppLocalizations.of(context)!.enterYourPassword,
      suffixConstraints: BoxConstraints(maxWidth: size.width * 0.2),
      suffixIcon: InkWell(
        onTap: () {
          context.read<AuthBloc>().add(ShowPasswordIconEvent(
              showPassword: context.read<AuthBloc>().showPassword));
        },
        child: !context.read<AuthBloc>().showPassword
            ? const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.visibility_off_outlined,
            color: AppColors.darkGrey,
          ),
        )
            : const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.visibility,
            color: AppColors.darkGrey,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.enterPassword;
        } else if (value.length < 8) {
          return AppLocalizations.of(context)!.minPassRequired;
        } else {
          return null;
        }
      },
    );
  }
}