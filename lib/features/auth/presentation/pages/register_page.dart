import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_container.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../core/utils/staggered_reveal.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../loading/application/loader_bloc.dart';
import '../../../userprofile/presentation/pages/driver_profile_pages.dart';
import '../../application/auth_bloc.dart';
import '../widgets/select_country_widget.dart';
import 'refferal_page.dart';

class RegisterPage extends StatelessWidget {
  static const String routeName = '/registerPage';
  final RegisterPageArguments arg;
  const RegisterPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AuthBloc()
        ..add(GetDirectionEvent())
        ..add(RegisterPageInitEvent(arg: arg)),
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
          if (state is LoginSuccessState) {
            context.read<LoaderBloc>().add(UpdateUserLocationEvent());
            if (arg.isRefferalEarnings == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RefferalPage.routeName, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
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
                child: SafeArea(
                  child: Scaffold(
                    appBar: CustomAppBar(
                      title: AppLocalizations.of(context)!.register,
                      titleFontSize: 18,
                      automaticallyImplyLeading: true,
                      onBackTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    body: CustomBackground(
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.05),
                          child: Column(
                            children: [
                              Expanded(
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: context.read<AuthBloc>().formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: size.width * 0.05),
                                          StaggeredReveal(
                                            index: 0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  text: AppLocalizations.of(context)!.signUp,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColorDark,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 24),
                                                ),
                                                SizedBox(height: size.width * 0.025),
                                                MyText(
                                                  text: AppLocalizations.of(context)!
                                                      .getStarted,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                      color: AppColors.darkGrey,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.width * 0.05,
                                          ),
                                          StaggeredReveal(
                                            index: 1,
                                            child: CustomContainer(
                                              borderRadius: 18,
                                              padding: EdgeInsets.all(size.width * 0.04),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  MyText(
                                                    text: AppLocalizations.of(context)!
                                                        .personalInformation,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 18),
                                                  ),
                                                  SizedBox(height: size.width * 0.05),
                                                  MyText(
                                                    text: AppLocalizations.of(context)!
                                                        .fullName,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color: AppColors.darkGrey,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(height: size.width * 0.025),
                                                  buildUserNameField(context, size),
                                                  SizedBox(height: size.width * 0.05),
                                                  MyText(
                                                    text: AppLocalizations.of(context)!
                                                        .mobileNumber,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color: AppColors.darkGrey,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(height: size.width * 0.025),
                                                  buildMobileField(context, size),
                                                  SizedBox(height: size.width * 0.05),
                                                  MyText(
                                                    text: AppLocalizations.of(context)!
                                                        .emailAddress,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color: AppColors.darkGrey,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(height: size.width * 0.025),
                                                  buildEmailField(context, size),
                                                  SizedBox(height: size.width * 0.05),
                                                  MyText(
                                                    text: AppLocalizations.of(context)!
                                                        .gender,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color: AppColors.darkGrey,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(height: size.width * 0.025),
                                                  buildDropDownGenderField(context),
                                                  SizedBox(height: size.width * 0.05),
                                                  MyText(
                                                    text: AppLocalizations.of(context)!
                                                        .password,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        color: AppColors.darkGrey,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(height: size.width * 0.025),
                                                  buildPasswordField(context, size),
                                                  SizedBox(height: size.width * 0.025),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.width * 0.05,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(height: size.width * 0.05),
                              StaggeredReveal(index: 2, child: buildButton(context)),
                              SizedBox(height: size.width * 0.05),
                            ],
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

  // NOTE: not currently called from build() — profile-picture upload isn't
  // wired into the registration form as it stands. Restyled in case you
  // want to add it back in, but I didn't insert a call to it since that
  // would change the page's actual layout/behavior beyond a visual pass.
  Widget buildProfilePick(Size size, BuildContext context) {
    return SafeArea(
      child: Center(
        child: CircleAvatar(
          radius: size.width * 0.15,
          backgroundColor: AppColors.surfaceStrong(context),
          backgroundImage: context.read<AuthBloc>().profileImage.isNotEmpty
              ? FileImage(File(context.read<AuthBloc>().profileImage))
              : const AssetImage(AppImages.defaultProfile),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _showImageSourceSheet(context);
                    },
                    child: Container(
                      height: size.width * 0.1,
                      width: size.width * 0.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.beaconGradient,
                      ),
                      child: const Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          )),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Center(
      child: CustomButton(
        buttonName: AppLocalizations.of(context)!.register,
        borderRadius: 16,
        textSize: 16,
        width: MediaQuery.of(context).size.width,
        isLoader: context.read<AuthBloc>().isLoading,
        onTap: () {
          if (context.read<AuthBloc>().formKey.currentState!.validate() &&
              !context.read<AuthBloc>().isLoading) {
            context.read<AuthBloc>().add(RegisterUserEvent(
                userName: context.read<AuthBloc>().rUserNameController.text,
                mobileNumber: context.read<AuthBloc>().rMobileController.text,
                emailAddress: context.read<AuthBloc>().rEmailController.text,
                password: context.read<AuthBloc>().rPasswordController.text,
                countryCode: context.read<AuthBloc>().countryCode,
                gender: context.read<AuthBloc>().selectedGender,
                profileImage: context.read<AuthBloc>().profileImage,
                context: context));
          }
        },
      ),
    );
  }

  Widget buildPasswordField(BuildContext context, Size size) {
    return CustomTextField(
      controller: context.read<AuthBloc>().rPasswordController,
      filled: true,
      borderRadius: 14,
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

  Widget buildEmailField(BuildContext context, Size size) {
    return CustomTextField(
      controller: context.read<AuthBloc>().rEmailController,
      enabled: !context.read<AuthBloc>().isLoginByEmail,
      filled: true,
      borderRadius: 14,
      fillColor: context.read<AuthBloc>().isLoginByEmail
          ? AppColors.surfaceStrong(context)
          : null,
      hintText:
      '${AppLocalizations.of(context)!.enterYourEmail} (${AppLocalizations.of(context)!.optional})',
      validator: (value) {
        if (value!.isNotEmpty && !AppValidation.emailValidate(value)) {
          return AppLocalizations.of(context)!.validEmail;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildMobileField(BuildContext context, Size size) {
    return CustomTextField(
      controller: context.read<AuthBloc>().rMobileController,
      filled: true,
      borderRadius: 14,
      fillColor: !context.read<AuthBloc>().isLoginByEmail
          ? AppColors.surfaceStrong(context)
          : null,
      enabled: context.read<AuthBloc>().isLoginByEmail,
      hintText: AppLocalizations.of(context)!.enterYourMobile,
      keyboardType: TextInputType.number,
      prefixConstraints: BoxConstraints(maxWidth: size.width * 0.2),
      prefixIcon: Center(
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (cont) {
                return SelectCountryWidget(
                    countries: arg.countryList, cont: context);
              },
            );
          },
          child: Row(
            children: [
              Container(
                height: 20,
                width: 25,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors.surfaceStrong(context),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      context.read<AuthBloc>().flagImage,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: (context.read<AuthBloc>().flagImage.isEmpty)
                    ? const Center(
                  child: Loader(),
                )
                    : null,
              ),
              MyText(
                text: context.read<AuthBloc>().dialCode,
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      validator: (value) {
        if (value!.isNotEmpty && !AppValidation.mobileNumberValidate(value)) {
          return AppLocalizations.of(context)!.validMobile;
        } else if (value.isEmpty) {
          return AppLocalizations.of(context)!.enterMobile;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildUserNameField(BuildContext context, Size size) {
    return CustomTextField(
      controller: context.read<AuthBloc>().rUserNameController,
      filled: true,
      borderRadius: 14,
      hintText: AppLocalizations.of(context)!.enterYourName,
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.enterUserName;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildDropDownGenderField(BuildContext context) {
    List<String> showGenderList = [
      AppLocalizations.of(context)!.male,
      AppLocalizations.of(context)!.female,
      AppLocalizations.of(context)!.preferNotSay,
    ];
    return Builder(builder: (context) {
      final border = OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.surfaceBorder(context), width: 1),
        borderRadius: BorderRadius.circular(14),
      );
      final focusedBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.meshwarRed, width: 1.4),
        borderRadius: BorderRadius.circular(14),
      );
      return DropdownButtonFormField(
        isExpanded: true,
        style: Theme.of(context).textTheme.bodyMedium!,
        dropdownColor: AppColors.surfaceStrong(context),
        icon: const Icon(Icons.arrow_drop_down_circle),
        iconSize: 20,
        elevation: 10,
        onChanged: (newValue) {
          int index = showGenderList.indexOf(newValue.toString());
          if (index != -1) {
            String codedValue = context.read<AuthBloc>().genderList[index];
            context.read<AuthBloc>().selectedGender = codedValue;
          }
        },
        items: showGenderList.map<DropdownMenuItem>((value) {
          return DropdownMenuItem(
            value: value,
            alignment: AlignmentDirectional.centerStart,
            child: MyText(text: value),
          );
        }).toList(),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          hintText: AppLocalizations.of(context)!.selectGender,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGrey),
          filled: true,
          fillColor: AppColors.surface(context),
          errorStyle: TextStyle(
            color: AppColors.red.withAlpha((0.8 * 255).toInt()),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.errorLight.withAlpha((0.8 * 255).toInt()),
                width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.errorLight.withAlpha((0.5 * 255).toInt()),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: focusedBorder,
          enabledBorder: border,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (context.read<AuthBloc>().selectedGender.isEmpty) {
            return AppLocalizations.of(context)!.requiredField;
          } else {
            return null;
          }
        },
      );
    });
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black54,
      builder: (_) => Container(
        decoration: BoxDecoration(
            color: AppColors.surfaceStrong(context),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            border: Border(
              top: BorderSide(color: AppColors.surfaceBorder(context)),
            )),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: MyText(
                  text: AppLocalizations.of(context)!.cameraText,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<AuthBloc>()
                      .add(ImageUpdateEvent(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  size: 20,
                  color: Theme.of(context).primaryColorDark,
                ),
                title: MyText(
                  text: AppLocalizations.of(context)!.galleryText,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<AuthBloc>()
                      .add(ImageUpdateEvent(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}