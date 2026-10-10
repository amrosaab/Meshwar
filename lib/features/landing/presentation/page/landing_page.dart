import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_colors.dart';
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
            final bloc = context.read<OnBoardingBloc>();
            return PopScope(
              canPop: false,
              child: Directionality(
                textDirection: bloc.textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: bloc.onBoardingData.isNotEmpty
                      ? Column(
                          children: [
                            // Full-bleed hero — extends under the status bar
                            // rather than sitting in an inset card, with the
                            // Skip link floating on top of it (standard
                            // modern onboarding pattern) instead of
                            // competing for space with the primary action
                            // below.
                            Expanded(
                              flex: 58,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  buildLandingImageContainer(size, context),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.center,
                                          colors: [
                                            Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            Theme.of(context)
                                                .scaffoldBackgroundColor
                                                .withValues(alpha: 0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: MediaQuery.paddingOf(context).top +
                                        12,
                                    right: 16,
                                    child: buildSkipLink(context),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 42,
                              child: SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      24, 20, 24, 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: buildLandingContentWidget(
                                            size, context),
                                      ),
                                      buildPrimaryButton(context, size),
                                    ],
                                  ),
                                ),
                              ),
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
    final bloc = context.read<OnBoardingBloc>();
    return bloc.onBoardingData.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  bloc.onBoardingData.length,
                  (index) {
                    final isSelected = bloc.onBoardChangeIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: isSelected ? 24 : 8,
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.beaconGradient : null,
                        color: isSelected ? null : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  controller: bloc.contentPageController,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: bloc.onBoardingData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyText(
                          text: bloc.onBoardingData[index].title,
                          textAlign: TextAlign.center,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 12),
                        MyText(
                          text: bloc.onBoardingData[index].description,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontSize: 15,
                                height: 1.5,
                                color: AppColors.hintColor,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        ),
                      ],
                    );
                  },
                  onPageChanged: (value) {
                    bloc.imagePageController.jumpToPage(value);
                    bloc.add(OnBoardingDataChangeEvent(currentIndex: value));
                  },
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget buildLandingImageContainer(Size size, BuildContext context) {
    final bloc = context.read<OnBoardingBloc>();
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: PageView.builder(
        controller: bloc.imagePageController,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: bloc.onBoardingData.length,
        itemBuilder: (context, index) {
          return bloc.onBoardingData.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: bloc.onBoardingData[bloc.onBoardChangeIndex]
                      .onboardingImage,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.surface(context),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                  // Was an empty Text("") — a failed image load looked
                  // identical to the fixed-size bug above (nothing visible),
                  // making the two indistinguishable from the UI alone.
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.surface(context),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 40,
                    ),
                  ),
                )
              : null;
        },
        onPageChanged: (value) {
          bloc.contentPageController.jumpToPage(value);
          bloc.add(OnBoardingDataChangeEvent(currentIndex: value));
        },
      ),
    );
  }

  Widget buildSkipLink(BuildContext context) {
    final bloc = context.read<OnBoardingBloc>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => bloc.add(SkipEvent()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: MyText(
            text: AppLocalizations.of(context)!.skip,
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPrimaryButton(BuildContext context, Size size) {
    final bloc = context.read<OnBoardingBloc>();
    if (bloc.onBoardingData.isEmpty) return const SizedBox();
    final isLastPage =
        bloc.onBoardChangeIndex == bloc.onBoardingData.length - 1;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.beaconGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (isLastPage) {
                bloc.add(SkipEvent());
              } else {
                bloc.contentPageController.nextPage(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: isLastPage
                      ? AppLocalizations.of(context)!.continueN
                      : AppLocalizations.of(context)!.next,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
