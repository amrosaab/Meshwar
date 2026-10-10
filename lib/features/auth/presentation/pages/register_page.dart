import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_arguments.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../application/auth_bloc.dart';
import '../widgets/register_content.dart';
import '../widgets/select_country_widget.dart';
import 'refferal_page.dart';

class RegisterPage extends StatelessWidget {
  static const String routeName = '/registerPage';
  final RegisterPageArguments arg;
  const RegisterPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AuthBloc()
          ..add(GetDirectionEvent())
          ..add(RegisterPageInitEvent(arg: arg)),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              context.read<LoaderBloc>().add(UpdateUserLocationEvent());
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  arg.isRefferalEarnings == 1
                      ? RefferalPage.routeName
                      : HomePage.routeName,
                  (_) => false);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            final bloc = context.read<AuthBloc>();
            return Directionality(
              textDirection: bloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: RegistrationLayout(
                formKey: bloc.formKey,
                nameController: bloc.rUserNameController,
                phoneController: bloc.rMobileController,
                emailController: bloc.rEmailController,
                passwordController: bloc.rPasswordController,
                emailVerified: bloc.isLoginByEmail,
                dialCode: bloc.dialCode,
                flagUrl: bloc.flagImage,
                gender: bloc.selectedGender,
                genders: bloc.genderList,
                showPassword: bloc.showPassword,
                busy: bloc.isLoading || state is LoginLoadingState,
                onBack: () {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) navigator.pop();
                  if (navigator.canPop()) navigator.pop();
                },
                onCountry: arg.countryList.isEmpty
                    ? null
                    : () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (_) => SelectCountryWidget(
                            countries: arg.countryList, cont: context)),
                onGender: (value) => bloc.selectedGender = value,
                onTogglePassword: () => bloc.add(
                    ShowPasswordIconEvent(showPassword: bloc.showPassword)),
                onRegister: () {
                  if (bloc.isLoading ||
                      !(bloc.formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  FocusScope.of(context).unfocus();
                  bloc.add(RegisterUserEvent(
                    userName: bloc.rUserNameController.text,
                    mobileNumber: bloc.rMobileController.text,
                    emailAddress: bloc.rEmailController.text,
                    password: bloc.rPasswordController.text,
                    countryCode: bloc.countryCode,
                    gender: bloc.selectedGender,
                    profileImage: bloc.profileImage,
                    context: context,
                  ));
                },
              ),
            );
          }),
        ),
      );
}
