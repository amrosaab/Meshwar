import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/common.dart';
import '../../../../common/app_colors.dart';
import '../../../../core/utils/custom_background.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../language/presentation/page/choose_language_page.dart';
import '../../application/auth_bloc.dart';

class AuthBodyWidget extends StatelessWidget {
  final BuildContext cont;
  const AuthBodyWidget({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<AuthBloc>(),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return CustomBackground(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _LanguagePill(
                            code: context.read<AuthBloc>().languageCode.toUpperCase(),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ChooseLanguagePage.routeName,
                                arguments: ChangeLanguageArguments(from: 1),
                              ).then(
                                    (value) {
                                  if (!context.mounted) return;
                                  context.read<AuthBloc>().add(GetDirectionEvent());
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.06),
                  const _BeaconMark(),
                  SizedBox(height: size.width * 0.08),
                  SizedBox(
                    height: size.height * 0.56,
                    child: _BeaconCarousel(items: context.read<AuthBloc>().splashImages),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small language switcher rendered as a glass pill.
class _LanguagePill extends StatelessWidget {
  final String code;
  final VoidCallback onTap;
  const _LanguagePill({required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceBorder(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: code,
              textStyle: AppTextStyle.mono(
                  size: 12, weight: FontWeight.w700, color: AppColors.meshwarRed, letterSpacing: 1),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.language_outlined, size: 16, color: AppColors.meshwarRed),
            const Icon(Icons.expand_more_rounded, size: 16, color: AppColors.darkGrey),
          ],
        ),
      ),
    );
  }
}

/// A single pulsing beacon ring — the brand's signature mark. A quiet
/// nod to a live GPS ping, since this is a ride app's front door.
class _BeaconMark extends StatefulWidget {
  const _BeaconMark();

  @override
  State<_BeaconMark> createState() => _BeaconMarkState();
}

class _BeaconMarkState extends State<_BeaconMark> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: 54,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final v = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - v).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 1 + v * 1.4,
                  child: Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.meshwarRed.withOpacity(0.6), width: 1.4),
                    ),
                  ),
                ),
              ),
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.beaconGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.meshwarRed.withOpacity(0.6),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Carousel wrapped in a glass frame with animated dot indicators.
class _BeaconCarousel extends StatefulWidget {
  final List<Widget> items;
  const _BeaconCarousel({required this.items});

  @override
  State<_BeaconCarousel> createState() => _BeaconCarouselState();
}

class _BeaconCarouselState extends State<_BeaconCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CarouselSlider(
                items: widget.items,
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  autoPlayCurve: Curves.easeInOutCubic,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.22,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (i, reason) =>
                      setState(() => _index = i % widget.items.length),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: active ? 22 : 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: active ? AppColors.beaconGradient : null,
                color: active ? null : AppColors.surfaceBorder(context),
              ),
            );
          }),
        ),
      ],
    );
  }
}