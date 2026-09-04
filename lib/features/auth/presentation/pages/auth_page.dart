import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../application/auth_bloc.dart';

import '../widgets/auth_body_widget.dart';
import '../widgets/auth_bottom_sheet_widget.dart';
import '../widgets/select_country_widget.dart';
import 'verify_page.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = '/authPage';
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderList(size);
  }

  Widget builderList(Size size) {
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(CountryGetEvent())
        ..add(GetCommonModuleEvent()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is AuthDataSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is VerifySuccessState) {
            Navigator.pushNamed(
              context,
              VerifyPage.routeName,
              arguments: VerifyArguments(
                mobileOrEmail:
                    context.read<AuthBloc>().emailOrMobileController.text,
                dialCode: context.read<AuthBloc>().dialCode,
                countryCode: context.read<AuthBloc>().countryCode,
                countryFlag: context.read<AuthBloc>().flagImage,
                isLoginByEmail: context.read<AuthBloc>().isLoginByEmail,
                userExist: context.read<AuthBloc>().userExist,
                countryList: context.read<AuthBloc>().countries,
                isOtpVerify: context.read<AuthBloc>().userExist ? false : true,
                isDemoLogin: false,
                isRefferalEarnings: context.read<AuthBloc>().isRefferalEarnings,
              ),
            );
          } else if (state is SignInWithDemoState) {
            Navigator.pushNamed(
              context,
              VerifyPage.routeName,
              arguments: VerifyArguments(
                mobileOrEmail:
                    context.read<AuthBloc>().emailOrMobileController.text,
                dialCode: context.read<AuthBloc>().dialCode,
                countryCode: context.read<AuthBloc>().countryCode,
                countryFlag: context.read<AuthBloc>().flagImage,
                isLoginByEmail: context.read<AuthBloc>().isLoginByEmail,
                userExist: false,
                countryList: context.read<AuthBloc>().countries,
                isOtpVerify: true,
                isDemoLogin: true,
                isRefferalEarnings: context.read<AuthBloc>().isRefferalEarnings,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  context.read<AuthBloc>().formKey.currentState!.reset();
                },
                child: Directionality(
                  textDirection: context.read<AuthBloc>().textDirection == 'rtl'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: Scaffold(
                    body: AuthBodyWidget(cont: context),
                    bottomSheet: AuthBottomSheetWidget(
                        formKey: context.read<AuthBloc>().formKey,
                        emailOrMobile:
                            context.read<AuthBloc>().emailOrMobileController,
                        continueFunc: () {},
                        focusNode: context.read<AuthBloc>().textFieldFocus,
                        showLoginBtn: true,
                        isLoginByEmail: context.read<AuthBloc>().isLoginByEmail,
                        countrySelectFunc: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            context: context,
                            builder: (cont) {
                              return SelectCountryWidget(
                                  countries: context.read<AuthBloc>().countries,
                                  cont: context);
                            },
                          );
                        },
                        onTapEvent: () {
                          context
                              .read<AuthBloc>()
                              .add(EmailorMobileOnTapEvent());
                        },
                        onSubmitEvent: (p0) {
                          context
                              .read<AuthBloc>()
                              .add(EmailorMobileOnSubmitEvent());
                        },
                        onChangeEvent: (value) {
                          context
                              .read<AuthBloc>()
                              .add(EmailorMobileOnChangeEvent(value: value));
                        },
                        isShowLoader: context.read<AuthBloc>().isLoading,
                        dialCode: context.read<AuthBloc>().dialCode,
                        flagImage: context.read<AuthBloc>().flagImage),
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
