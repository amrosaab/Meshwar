import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/common.dart';
import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../account/presentation/pages/settings/page/terms_privacy_policy_view_page.dart';

class AuthBottomSheetWidget extends StatefulWidget {
  final TextEditingController emailOrMobile;
  final dynamic continueFunc;
  final bool showLoginBtn;
  final bool isLoginByEmail;
  final Function()? onTapEvent;
  final Function(String)? onChangeEvent;
  final Function(String)? onSubmitEvent;
  final Function()? countrySelectFunc;
  final GlobalKey<FormState> formKey;
  final String dialCode;
  final String flagImage;
  final FocusNode focusNode;
  final bool isShowLoader;
  const AuthBottomSheetWidget(
      {super.key,
        required this.emailOrMobile,
        required this.continueFunc,
        required this.showLoginBtn,
        required this.isLoginByEmail,
        this.onTapEvent,
        this.onChangeEvent,
        this.onSubmitEvent,
        required this.formKey,
        required this.dialCode,
        required this.flagImage,
        this.countrySelectFunc,
        required this.focusNode,
        required this.isShowLoader});

  @override
  State<StatefulWidget> createState() => AuthBottomSheetWidgetState();
}

class AuthBottomSheetWidgetState extends State<AuthBottomSheetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continuePressed() {
    _controller.forward();
  }

  _closeDialog() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height:
              widget.showLoginBtn ? size.height * 0.4 : size.height * 0.27,
              decoration: BoxDecoration(
                color: AppColors.surfaceStrong(context),
                border: Border(
                  top: BorderSide(color: AppColors.surfaceBorder(context)),
                  left: BorderSide(color: AppColors.surfaceBorder(context)),
                  right: BorderSide(color: AppColors.surfaceBorder(context)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.meshwarRed.withOpacity(0.12),
                    blurRadius: 30,
                    spreadRadius: -10,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 40,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBorder(context),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyText(
                          text:
                          '${AppLocalizations.of(context)!.welcome}, ${AppLocalizations.of(context)!.user}',
                          textStyle: AppTextStyle.display(
                              size: 19, weight: FontWeight.w700, color: Theme.of(context).primaryColorDark),
                        ),
                        const SizedBox(width: 10),
                        SvgPicture.asset(AppImages.hi, height: 20, width: 25)
                      ],
                    ),
                    SizedBox(height: size.width * 0.05),
                    MyText(
                      text:
                      '${AppLocalizations.of(context)!.email}/${AppLocalizations.of(context)!.mobile}',
                      textStyle: AppTextStyle.body(
                          size: 12.5, weight: FontWeight.w700, color: AppColors.darkGrey),
                    ),
                    SizedBox(height: size.width * 0.02),
                    Form(
                      key: widget.formKey,
                      child: CustomTextField(
                        controller: widget.emailOrMobile,
                        filled: true,
                        focusNode: widget.focusNode,
                        hintText: AppLocalizations.of(context)!
                            .emailAddressOrMobileNumber,
                        prefixConstraints:
                        BoxConstraints(maxWidth: size.width * 0.2),
                        prefixIcon: !widget.isLoginByEmail
                            ? Center(
                          child: InkWell(
                            onTap: widget.countrySelectFunc,
                            child: Row(
                              children: [
                                Container(
                                  height: 20,
                                  width: 25,
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: AppColors.surfaceStrong(context),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.flagImage,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                    const Center(child: Loader()),
                                    errorWidget: (context, url, error) =>
                                    const Center(child: Text("")),
                                  ),
                                ),
                                MyText(
                                  text: widget.dialCode,
                                  textStyle: AppTextStyle.mono(
                                      size: 14,
                                      weight: FontWeight.w600,
                                      color: Theme.of(context).primaryColorDark),
                                ),
                              ],
                            ),
                          ),
                        )
                            : null,
                        onTap: widget.onTapEvent,
                        onSubmitted: widget.onSubmitEvent,
                        onChange: widget.onChangeEvent,
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              !AppValidation.emailValidate(value) &&
                              !AppValidation.mobileNumberValidate(value)) {
                            return AppLocalizations.of(context)!.validEmailMobile;
                          } else if (value.isEmpty) {
                            return AppLocalizations.of(context)!.enterEmailMobile;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(height: size.width * 0.05),
                    Center(
                      child: CustomButton(
                        buttonName: AppLocalizations.of(context)!.continueN,
                        borderRadius: 16,
                        width: size.width,
                        height: size.width * 0.12,
                        textColor: (widget.emailOrMobile.text.isEmpty)
                            ? Theme.of(context).primaryColorDark
                            : AppColors.white,
                        buttonColor: (widget.emailOrMobile.text.isEmpty)
                            ? AppColors.surfaceStrong(context)
                            : null,
                        onTap: () {
                          if (widget.formKey.currentState!.validate() &&
                              widget.emailOrMobile.text.isNotEmpty) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _continuePressed();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: size.width * 0.02),
                    SizedBox(
                      width: size.width,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          MyText(
                            text: '${AppLocalizations.of(context)!.byContinuing} ',
                            textStyle: AppTextStyle.body(
                                size: 12, weight: FontWeight.w400, color: AppColors.darkGrey),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(
                                  context, TermsPrivacyPolicyViewPage.routeName,
                                  arguments: TermsAndPrivacyPolicyArguments(
                                      isPrivacyPolicy: false));
                            },
                            child: MyText(
                              text: '${AppLocalizations.of(context)!.terms} ',
                              textStyle: AppTextStyle.body(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: AppColors.meshwarRed),
                            ),
                          ),
                          MyText(
                            text: AppLocalizations.of(context)!.and,
                            textStyle: AppTextStyle.body(
                                size: 12, weight: FontWeight.w400, color: AppColors.darkGrey),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(
                                  context, TermsPrivacyPolicyViewPage.routeName,
                                  arguments: TermsAndPrivacyPolicyArguments(
                                      isPrivacyPolicy: true));
                            },
                            child: MyText(
                              text: '${AppLocalizations.of(context)!.privacyPolicy} ',
                              textStyle: AppTextStyle.body(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: AppColors.meshwarRed),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceStrong(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.surfaceBorder(context)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.meshwarRed.withOpacity(0.18),
                              blurRadius: 24,
                              spreadRadius: -6,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  if (!widget.isLoginByEmail)
                                    MyText(
                                      text: widget.dialCode,
                                      textStyle: AppTextStyle.mono(
                                          size: 19, weight: FontWeight.w700, color: AppColors.meshwarRed),
                                    ),
                                  SizedBox(width: size.width * 0.02),
                                  MyText(
                                    text: widget.emailOrMobile.text,
                                    maxLines: 3,
                                    textStyle: AppTextStyle.display(
                                        size: 19, weight: FontWeight.w600, color: Theme.of(context).primaryColorDark),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      style: AppTextStyle.body(
                                          size: 14, weight: FontWeight.w500, color: AppColors.darkGrey),
                                      text: '${AppLocalizations.of(context)!.isThisCorrect} ',
                                    ),
                                    TextSpan(
                                      style: AppTextStyle.boldStyle(
                                        size: 14,
                                        weight: FontWeight.w700,
                                      ).copyWith(
                                          color: AppColors.meshwarRed,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.meshwarRed,
                                          decorationStyle: TextDecorationStyle.solid),
                                      text: AppLocalizations.of(context)!.edit,
                                      recognizer: TapGestureRecognizer()..onTap = _closeDialog,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                buttonName: AppLocalizations.of(context)!.continueN,
                                borderRadius: 16,
                                width: size.width,
                                height: size.width * 0.12,
                                isLoader: widget.isShowLoader,
                                onTap: widget.continueFunc,
                              )
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
      ],
    );
  }
}