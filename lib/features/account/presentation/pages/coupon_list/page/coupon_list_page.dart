import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/app_images.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/coupon_list_widget.dart';
import '../widget/coupon_shimmer.dart';

class CouponsListPage extends StatelessWidget {
  final CouponListPageArguments args;
  static const String routeName = '/couponsListPage';

  const CouponsListPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetPromoCodeListEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is PromoClearLoadingState) {
          } else if (state is PromoClearFailureState) {
          } else if (state is PromoClearSuccessState) {
          } else if (state is PromoApplyLoadingState) {
            CustomLoader.loader(context);
          } else if (state is PromoApplyFailureState) {
            CustomLoader.dismiss(context);
          } else if (state is PromoApplySuccessState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.black54,
              builder: (BuildContext _) {
                return BlocProvider.value(
                  value: BlocProvider.of<AccBloc>(context),
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceStrong(context),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                                color: AppColors.surfaceBorder(context)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.routeGreen.withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: -8,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                margin: const EdgeInsets.only(bottom: 14),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.routeGreen,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 26),
                              ),
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .promoApplied
                                    .replaceAll(
                                    '111',
                                    "'${context.read<AccBloc>().selectedPromoCodeValue}'"),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .primaryColorDark),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              MyText(
                                text: AppLocalizations.of(context)!
                                    .appliedPromoText
                                    .replaceAll('111',
                                    '${args.userData.currencySymbol}${context.read<AccBloc>().selectedPromoPrice.toString()}'),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: AppColors.hintColor),
                                textAlign: TextAlign.center,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 18),
                              CustomButton(
                                buttonName:
                                AppLocalizations.of(context)!.okText,
                                width: double.infinity,
                                onTap: () {
                                  context
                                      .read<AccBloc>()
                                      .add(GetPromoCodeListEvent());
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.coupon,
                  automaticallyImplyLeading: true,
                  titleFontSize: 18,
                ),
                body: Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Column(
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (_) {
                            if (context.read<AccBloc>().isLoading) {
                              return CouponShimmer(size: size);
                            }

                            if (context
                                .read<AccBloc>()
                                .promoCodeDataList
                                .isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: size.height * 0.08),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      LiquidGlassContainer(
                                        circular: true,
                                        width: 148,
                                        height: 148,
                                        blurSigma: 14,
                                        fillOpacity: 0.1,
                                        child: Center(
                                          child: Image.asset(
                                            AppImages.notificationsNoData,
                                            width: 92,
                                            height: 92,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      MyText(
                                        text: AppLocalizations.of(context)!
                                            .noDataAvailable,
                                        textAlign: TextAlign.center,
                                        textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          color: Theme.of(context).primaryColorDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),//
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return CouponsListWidget(
                              cont: context,
                              promoCodeDataList:
                              context.read<AccBloc>().promoCodeDataList,
                              currencySymbol: args.userData.currencySymbol,
                            );
                          },
                        ),
                      ),
                    ],
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