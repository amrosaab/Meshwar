// ignore_for_file: deprecated_member_use

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:shimmer/shimmer.dart";
import "../../../../../../common/common.dart";
import "../../../../../../core/utils/custom_appbar.dart";
import "../../../../../../core/utils/custom_button.dart";
import "../../../../../../core/utils/custom_container.dart";
import "../../../../../../core/utils/custom_loader.dart";
import "../../../../../../core/utils/custom_text.dart";
import "../../../../../../l10n/app_localizations.dart";
import "../../../../application/acc_bloc.dart";

class OutStationOfferedPage extends StatelessWidget {
  static const String routeName = '/outStationOfferedPage';
  final OutStationOfferedPageArguments args;

  const OutStationOfferedPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(OutstationGetEvent(id: args.requestId)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is RequestCancelState) {
            Navigator.pop(context);
          } else if (state is OutstationAcceptState) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.offeredRide,
                automaticallyImplyLeading: true,
                onBackTap: () {
                  Navigator.of(context).pop();
                  context.read<AccBloc>().scrollController.dispose();
                },
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: context.read<AccBloc>().scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 36,
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildOfferedFareCard(context),
                        const SizedBox(height: 16),
                        if (context.read<AccBloc>().outstation.isEmpty &&
                            context.read<AccBloc>().outStationBidStream != null)
                          _buildLoadingShimmer(context, size),
                        if (context.read<AccBloc>().outstation.isNotEmpty)
                          _buildChooseDriverHeader(context),
                        const SizedBox(height: 12),
                        if (context.read<AccBloc>().outstation.isEmpty)
                          _buildEmptyState(context, size),
                        const SizedBox(height: 20),
                        if (context.read<AccBloc>().outstation.isNotEmpty)
                          _buildDriverList(context, size),
                        const SizedBox(height: 20),
                        _buildCancelButton(context, size),
                        const SizedBox(height: 20),
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

  // === Offered Fare Card ===
  Widget _buildOfferedFareCard(BuildContext context) {
    return CustomContainer(
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.myOfferedFare,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            MyText(
              text: '${args.currencySymbol} ${args.offeredFare}',
              textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColorDark,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Loading Shimmer ===
  // The two bars grow from center outward — a "searching both sides" read
  // for a bid negotiation in progress. Kept that structure exactly; only
  // the base shimmer tone now follows the active theme, and each bar gets
  // a soft glow so it reads as an active signal rather than flat grey.
  Widget _buildLoadingShimmer(BuildContext context, Size size) {
    final baseColor = AppColors.shimmerBase(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: Theme.of(context).primaryColor,
              direction: ShimmerDirection.rtl,
              child: Container(
                width: size.width * 0.45,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.meshwarRed.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: -1,
                    ),
                  ],
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: Theme.of(context).primaryColor,
              direction: ShimmerDirection.ltr,
              child: Container(
                width: size.width * 0.45,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // === Choose Driver Header ===
  Widget _buildChooseDriverHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MyText(
          text: AppLocalizations.of(context)!.chooseAdriver,
          textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // === Empty State ===
  Widget _buildEmptyState(BuildContext context, Size size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.noOutstation,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            MyText(
              text: AppLocalizations.of(context)!.noBidRideContent,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).disabledColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Driver List ===
  Widget _buildDriverList(BuildContext context, Size size) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: context.read<AccBloc>().outstation.length,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final driver = context.read<AccBloc>().outstation.elementAt(index);
        return _buildDriverCard(context, size, driver, index);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
    );
  }

  // === Driver Card ===
  Widget _buildDriverCard(
      BuildContext context, Size size, Map driver, int index) {
    return CustomContainer(
      width: size.width,
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Price Badge ===
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MyText(
                text: "${args.currencySymbol} ${driver['price']}",
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === Driver Info Row ===
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Driver Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surfaceBorder(context),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: driver['driver_img'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: Loader(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.person, size: 32),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Driver Details
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Rating
                      Row(
                        children: [
                          Flexible(
                            child: MyText(
                              text: driver['driver_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            color: AppColors.amberOnSurface(context),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          MyText(
                            text: driver['rating'],
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Vehicle & Distance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: MyText(
                              text: '${driver['vehicle_make']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                color: AppColors.greyHintColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: AppColors.greyHintColor,
                              ),
                              const SizedBox(width: 4),
                              MyText(
                                text:
                                '${context.read<AccBloc>().outStationDriver.elementAt(index)} km',
                                maxLines: 1,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                  color: AppColors.greyHintColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // === Action Buttons ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Decline Button — outline style, keeps it visually
                // secondary next to the solid-filled Accept button.
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      context.read<AccBloc>().add(
                        OutstationAcceptOrDeclineEvent(
                          id: args.requestId,
                          offeredRideFare: args.offeredFare,
                          isAccept: false,
                          driver: driver,
                        ),
                      );
                    },
                    buttonName: AppLocalizations.of(context)!.decline,
                    isBorder: true,
                    buttonColor: Colors.transparent,
                    textColor: Theme.of(context).primaryColorDark,
                  ),
                ),

                const SizedBox(width: 12),

                // Accept Button
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      context.read<AccBloc>().add(
                        OutstationAcceptOrDeclineEvent(
                          id: args.requestId,
                          offeredRideFare: args.offeredFare,
                          isAccept: true,
                          driver: driver,
                        ),
                      );
                    },
                    buttonName: AppLocalizations.of(context)!.accept,
                    buttonColor: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // === Cancel Button ===
  Widget _buildCancelButton(BuildContext context, Size size) {
    return CustomButton(
      onTap: () {
        context.read<AccBloc>().add(
          RideLaterCancelRequestEvent(requestId: args.requestId),
        );
      },
      borderRadius: 30,
      buttonName: AppLocalizations.of(context)!.cancelRide,
      width: size.width * 0.8,
      buttonColor: AppColors.red,
      textColor: AppColors.white,
    );
  }

  // Keeping the original cancelRide method (even though it's not used)
  Widget cancelRide(BuildContext context, Size size) {
    return StatefulBuilder(builder: (_, add) {
      return Container(
        padding: MediaQuery.of(context).viewInsets,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.05),
            topRight: Radius.circular(size.width * 0.05),
          ),
        ),
        width: size.width,
        child: Container(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                width: size.width * 0.5,
                buttonName: AppLocalizations.of(context)!.cancel,
                onTap: () {
                  context.read<AccBloc>().add(
                    RideLaterCancelRequestEvent(requestId: args.requestId),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}