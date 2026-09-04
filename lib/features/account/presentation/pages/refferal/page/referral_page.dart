import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';


import 'package:share_plus/share_plus.dart';
import '../../../../../../common/common.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/network/extensions.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_background.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_container.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/application/auth_bloc.dart';
import '../../../../../home/presentation/pages/home_page.dart';
import '../../../../../userprofile/presentation/pages/driver_profile_pages.dart';
import '../../../../application/acc_bloc.dart';

class ReferralPage extends StatefulWidget {
  final ReferralArguments args;

  static const String routeName = '/ReferralPage';

  const ReferralPage({super.key, required this.args});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool showReferralHistory = false;

  String _formatStatus(String status) {
    if (status.isEmpty) return '';
    final normalized = status.toLowerCase();
    return normalized[0].toUpperCase() + normalized.substring(1);
  }

  Widget _buildEmptyState(BuildContext context, Size size,
      {required IconData icon, required String text}) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: 32, vertical: size.height * 0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiquidGlassContainer(
              circular: true,
              width: 132,
              height: 132,
              blurSigma: 14,
              fillOpacity: 0.1,
              child: Center(
                child: Icon(
                  icon,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: size.width * 0.05),
            MyText(
              text: text,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.greyHintColor,
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) {
        final bloc = AccBloc();
        bloc.add(AccGetDirectionEvent());
        bloc.add(AccGetUserDetailsEvent());
        bloc.add(ReferralResponseEvent());
        return bloc;
      },
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          }
          if (state is ReferralSuccessState) {
            final uploadDoc =
                context.read<AuthBloc>().userData?.enableUserDocument;
            final approve = context.read<AuthBloc>().userData?.approve;

            if (approve == 0 && uploadDoc == "1") {
              Navigator.pushNamedAndRemoveUntil(
                  context, DriverProfilePage.routeName, (route) => false,
                  arguments:
                  const DriverProfilePageArguments(from: 'onboarding'));
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (route) => false);
            }
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: CustomAppBar(
                  title: widget.args.title,
                  automaticallyImplyLeading: true,
                  titleFontSize: 18,
                ),
                body: CustomBackground(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.width * 0.03),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            gradient: AppColors.beaconGradient,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.meshwarRed.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.all(size.width * 0.045),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          String bannerText = widget.args
                                              .userData.referralComissionString;
                                          return MyText(
                                            text: bannerText,
                                            maxLines: 3,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                              fontSize: 24,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Right side - Illustration background
                              // ClipRRect(
                              //   child: Image.asset(AppImages.referralGenius,
                              //       fit: BoxFit.contain),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.05),
                          child: CustomContainer(
                            borderRadius: 14,
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: size.width * 0.1,
                                        width: size.width * 0.4,
                                        decoration: BoxDecoration(
                                          color: AppColors.meshwarRed
                                              .withOpacity(0.06),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.meshwarRed
                                                .withOpacity(0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              MyText(
                                                text: widget.args.userData
                                                    .refferalCode,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  color: Theme.of(
                                                      context)
                                                      .primaryColorDark,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.width * 0.01,
                                      ),
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .yourReferralCode,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                          fontSize: 14,
                                          color: AppColors.hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.width * 0.025,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: widget
                                              .args.userData.refferalCode));
                                      context.showSnackBar(
                                          color:
                                          Theme.of(context).primaryColorDark,
                                          message: AppLocalizations.of(context)!
                                              .referralCodeCopy);
                                    },
                                    child: Container(
                                      width: ((context
                                          .read<AccBloc>()
                                          .languageCode ==
                                          'fr'))
                                          ? size.width * 0.25
                                          : size.width * 0.30,
                                      decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.015)),
                                      padding: EdgeInsets.all(size.width * 0.025),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.copy,
                                            color: AppColors.white,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: ((context
                                                .read<AccBloc>()
                                                .languageCode ==
                                                'fr' ||
                                                context
                                                    .read<AccBloc>()
                                                    .languageCode ==
                                                    'az' ||
                                                (context
                                                    .read<AccBloc>()
                                                    .languageCode ==
                                                    'es') ||
                                                context
                                                    .read<AccBloc>()
                                                    .languageCode ==
                                                    'sq'))
                                                ? size.width * 0.01
                                                : size.width * 0.025,
                                          ),
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .copy,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                              fontSize: ((context
                                                  .read<
                                                  AccBloc>()
                                                  .languageCode ==
                                                  'fr' ||
                                                  context
                                                      .read<
                                                      AccBloc>()
                                                      .languageCode ==
                                                      'az' ||
                                                  (context
                                                      .read<
                                                      AccBloc>()
                                                      .languageCode ==
                                                      'es') ||
                                                  context
                                                      .read<
                                                      AccBloc>()
                                                      .languageCode ==
                                                      'sq'))
                                                  ? 12
                                                  : 14,
                                              color: AppColors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.05, right: size.width * 0.05),
                          child: _ReferralTabToggle(size: size),
                        ),
                        SizedBox(height: size.width * 0.05),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05),
                            child: Builder(
                              builder: (context) {
                                final bloc = context.watch<AccBloc>();
                                if (bloc.showReferralHistory) {
                                  if (state is ReferalHistoryLoadingState) {
                                    return const Center(child: Loader());
                                  }

                                  // Render history whenever data is available
                                  if (state is ReferalHistorySuccessState) {
                                    final historyList = bloc.referralHistory;

                                    if (historyList.isNotEmpty) {
                                      return ListView.separated(
                                        itemCount: historyList.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: size.width * 0.025),
                                        itemBuilder: (context, index) {
                                          final item = historyList[index];
                                          return CustomContainer(
                                            borderRadius: 12,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  size.width * 0.035),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      // Name
                                                      MyText(
                                                        text: item.name,
                                                        textStyle: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Theme.of(
                                                              context)
                                                              .primaryColorDark,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                          size.width * 0.01),
                                                      // Date
                                                      MyText(
                                                        text: item.createdAt
                                                            .split(' ')
                                                            .first,
                                                        textStyle: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                          fontSize: 13,
                                                          color: AppColors
                                                              .hintColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            AppImages.referGift,
                                                            height:
                                                            size.width *
                                                                0.05,
                                                          ),
                                                          SizedBox(
                                                              width: size.width *
                                                                  0.015),
                                                          MyText(
                                                            text:
                                                            '${item.currencySymbol}${item.earning}',
                                                            textStyle: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Theme.of(
                                                                  context)
                                                                  .primaryColorDark,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height:
                                                          size.width * 0.01),
                                                      Container(
                                                        padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                          size.width * 0.02,
                                                          vertical:
                                                          size.width * 0.01,
                                                        ),
                                                        decoration:
                                                        BoxDecoration(
                                                          color: AppColors
                                                              .surfaceStrong(
                                                              context),
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .surfaceBorder(
                                                                  context)),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(20),
                                                        ),
                                                        child: MyText(
                                                          text: _formatStatus(
                                                              item.referralStatus),
                                                          textStyle: Theme.of(
                                                              context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                            color: Theme.of(
                                                                context)
                                                                .primaryColorDark,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }

                                  // Empty state for referral history
                                  return _buildEmptyState(
                                    context,
                                    size,
                                    icon: Icons.card_giftcard_outlined,
                                    text: AppLocalizations.of(context)!
                                        .noReferralHistoryFound,
                                  );
                                }

                                // Show "Refer and Earn" tab content
                                if (state is ReferralResponseLoadingState) {
                                  return const Center(child: Loader());
                                }

                                final referralResponse = bloc.referralResponse;
                                if (referralResponse == null) {
                                  return _buildEmptyState(
                                    context,
                                    size,
                                    icon: Icons.card_giftcard_outlined,
                                    text: AppLocalizations.of(context)!
                                        .referralContentUnavailable,
                                  );
                                }

                                final referralHtml = referralResponse
                                    .data.referralContent.data.description;

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .howItWorks,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      ),
                                      SizedBox(height: size.width * 0.025),
                                      Html(
                                        data: referralHtml,
                                        style: {
                                          "body": Style(
                                            fontSize: FontSize(14),
                                            color: AppColors.greyHintColor,
                                          ),
                                          "strong": Style(
                                            color: AppColors.greyHintColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          "ol": Style(
                                            listStyleType: ListStyleType.none,
                                            padding: HtmlPaddings.zero,
                                          ),
                                          "li": Style(
                                            margin: Margins.only(bottom: 16),
                                            padding: HtmlPaddings.zero,
                                          ),
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.05),
                          child: CustomButton(
                              buttonColor: AppColors.primary,
                              buttonName: AppLocalizations.of(context)!.invite,
                              width: size.width,
                              onTap: () async {
                                String androidUrl =
                                    widget.args.userData.androidApp;
                                String iosUrl = widget.args.userData.iosApp;

                                if (!context.mounted) return;
                                await Share.share(
                                    "${AppLocalizations.of(context)!.referralInviteText.replaceAll('****', widget.args.userData.refferalCode).replaceAll('**', AppConstants.title)}\n$androidUrl \n$iosUrl");
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// "Refer & Earn" / "Referral History" segmented control — same gradient
/// active-pill pattern as the login page's method toggle, so the same
/// control reads consistently wherever it shows up in the app.
class _ReferralTabToggle extends StatelessWidget {
  final Size size;
  const _ReferralTabToggle({required this.size});

  @override
  Widget build(BuildContext context) {
    final showHistory = context.watch<AccBloc>().showReferralHistory;
    final smallFontLocales = ['fr', 'az', 'es', 'sq'];
    final fontSize =
    smallFontLocales.contains(context.read<AccBloc>().languageCode)
        ? 12.0
        : 16.0;

    return Container(
      padding: EdgeInsets.all(size.width * 0.0125),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBorder(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tab(
            context,
            label: AppLocalizations.of(context)!.referAndEarn,
            active: !showHistory,
            fontSize: fontSize,
            onTap: () {
              context
                  .read<AccBloc>()
                  .add(ReferralTabChangeEvent(showReferralHistory: false));
            },
          ),
          _tab(
            context,
            label: AppLocalizations.of(context)!.referralHistory,
            active: showHistory,
            fontSize: fontSize,
            onTap: () {
              context
                  .read<AccBloc>()
                  .add(ReferralTabChangeEvent(showReferralHistory: true));
              context.read<AccBloc>().add(ReferalHistoryEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _tab(
      BuildContext context, {
        required String label,
        required bool active,
        required double fontSize,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size.width * 0.425,
        padding: EdgeInsets.all(size.width * 0.025),
        decoration: BoxDecoration(
          gradient: active ? AppColors.beaconGradient : null,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: MyText(
          text: label,
          textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : AppColors.hintColor,
          ),
        ),
      ),
    );
  }
}