import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../application/onboarding_bloc.dart';

class LandingPage extends StatefulWidget {
  static const String routeName = '/landingPage';
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderList(size);
  }

  Widget builderList(Size size) {
    return BlocProvider(
      create: (context) => OnBoardingBloc()..add(GetOnBoardingDataEvent()),
      child: BlocListener<OnBoardingBloc, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingInitialState) {
            CustomLoader.loader(context);
          }
          if (state is OnBoardingLoadingState) {
            CustomLoader.loader(context);
          }
          if (state is OnBoardingSuccessState) {
            CustomLoader.dismiss(context);
          }
          if (state is OnBoardingFailureState) {
            CustomLoader.dismiss(context);
          }
          if (state is SkipState) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
          }
        },
        child: BlocBuilder<OnBoardingBloc, OnBoardingState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              child: Directionality(
                textDirection:
                    context.read<OnBoardingBloc>().textDirection == 'rtl'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: Scaffold(
                  body: (context
                          .read<OnBoardingBloc>()
                          .onBoardingData
                          .isNotEmpty)
                      ? Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: size.height * 0.1),
                                  Container(
                                    height: size.height * 0.35,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.16),
                                  buildLandingContentWidget(size, context),
                                  SizedBox(height: size.height * 0.02),
                                  buildSkipButton(context, size),
                                ],
                              ),
                            ),
                            Positioned(
                              top: size.height * 0.1,
                              left: size.width * 0.09,
                              child: buildLandingImageContainer(size, context),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLandingContentWidget(Size size, BuildContext context) {
    return context.read<OnBoardingBloc>().onBoardingData.isNotEmpty
        ? Column(
            children: [
              SizedBox(
                height: size.height * 0.20,
                width: size.width,
                child: PageView.builder(
                  controller:
                      context.read<OnBoardingBloc>().contentPageController,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount:
                      context.read<OnBoardingBloc>().onBoardingData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyText(
                          text: context
                              .read<OnBoardingBloc>()
                              .onBoardingData[index]
                              .title,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 26),
                        ),
                        SizedBox(height: size.height * 0.02),
                        MyText(
                          text: context
                              .read<OnBoardingBloc>()
                              .onBoardingData[index]
                              .description,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 14, color: AppColors.hintColor),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        ),
                      ],
                    );
                  },
                  onPageChanged: (value) {
                    context
                        .read<OnBoardingBloc>()
                        .imagePageController
                        .jumpToPage(value);
                    context
                        .read<OnBoardingBloc>()
                        .add(OnBoardingDataChangeEvent(currentIndex: value));
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  context.read<OnBoardingBloc>().onBoardingData.length,
                  (index) {
                    bool isSelected =
                        context.read<OnBoardingBloc>().onBoardChangeIndex ==
                            index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width:
                          isSelected ? 20 : 8, //  Active indicator = long pill
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor // Active color
                            : Colors.grey.shade400, // Inactive dot
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        : const SizedBox();
  }

  Widget buildLandingImageContainer(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.5,
      width: size.width * 0.83,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: PageView.builder(
        controller: context.read<OnBoardingBloc>().imagePageController,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: context.read<OnBoardingBloc>().onBoardingData.length,
        itemBuilder: (context, index) {
          return context.read<OnBoardingBloc>().onBoardingData.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: context
                      .read<OnBoardingBloc>()
                      .onBoardingData[
                          context.read<OnBoardingBloc>().onBoardChangeIndex]
                      .onboardingImage,
                  width: 30,
                  height: 20,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Text(
                      "",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : null;
        },
        onPageChanged: (value) {
          context
              .read<OnBoardingBloc>()
              .contentPageController
              .jumpToPage(value);
          context
              .read<OnBoardingBloc>()
              .add(OnBoardingDataChangeEvent(currentIndex: value));
        },
      ),
    );
  }

  Widget buildSkipButton(BuildContext context, Size size) {
    if (context.read<OnBoardingBloc>().onBoardingData.isNotEmpty) {
      return CustomButton(
        buttonName: (context.read<OnBoardingBloc>().onBoardChangeIndex ==
                context.read<OnBoardingBloc>().onBoardingData.length - 1)
            ? '${AppLocalizations.of(context)!.continueN} '
            : '${AppLocalizations.of(context)!.skip} ',
        onTap: () => context.read<OnBoardingBloc>().add(SkipEvent()),
        textSize: 12,
        width: size.width,
        borderRadius: 10,
      );
    } else {
      return const SizedBox();
    }
  }
}
