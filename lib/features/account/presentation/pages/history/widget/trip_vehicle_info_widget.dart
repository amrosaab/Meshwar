// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_container.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class TripVehicleInfoWidget extends StatelessWidget {
  final BuildContext cont;
  final TripHistoryPageArguments arg;

  const TripVehicleInfoWidget({
    super.key,
    required this.cont,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocProvider.value(
      value: cont.read<AccBloc>(),
      child: BlocBuilder<AccBloc, AccState>(
        builder: (context, state) {
          return CustomContainer(
            borderRadius: 14,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Top Row: Vehicle Image + Ride Type Info ===
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Vehicle Image + Name
                        SizedBox(
                          width: size.width * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surface(context),
                                  border: Border.all(
                                    color: AppColors.surfaceBorder(context),
                                    width: 1.5,
                                  ),
                                  image: arg.historyData.vehicleTypeImage
                                      .isNotEmpty
                                      ? DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      arg.historyData.vehicleTypeImage,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                      : const DecorationImage(
                                    image: AssetImage(AppImages.noImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: arg.historyData.vehicleTypeImage.isEmpty
                                    ? const Icon(Icons.directions_car, size: 28)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              MyText(
                                text: arg.historyData.vehicleTypeName,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.greyHintColor,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),

                        // Right: Type of Ride Details
                        SizedBox(
                          width: size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MyText(
                                text: AppLocalizations.of(context)!.typeofRide,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  color: AppColors.greyHintColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              MyText(
                                text: (arg.historyData.isOutStation == 0 &&
                                    arg.historyData.isRental == false &&
                                    arg.historyData.goodsType == '-')
                                    ? AppLocalizations.of(context)!.regular
                                    : (arg.historyData.isOutStation == 0 &&
                                    arg.historyData.isRental ==
                                        false &&
                                    arg.historyData.goodsType != '-')
                                    ? AppLocalizations.of(context)!
                                    .delivery
                                    : (arg.historyData.isOutStation ==
                                    0 &&
                                    arg.historyData.isRental ==
                                        true &&
                                    arg.historyData.goodsType ==
                                        '-')
                                    ? '${AppLocalizations.of(context)!.rental} - ${arg.historyData.rentalPackageName}'
                                    : (arg.historyData.isOutStation ==
                                    0 &&
                                    arg.historyData.isRental ==
                                        true &&
                                    arg.historyData
                                        .goodsType !=
                                        '-')
                                    ? '${AppLocalizations.of(context)!.deliveryRental} - ${arg.historyData.rentalPackageName}'
                                    : (arg.historyData
                                    .isOutStation ==
                                    1 &&
                                    arg.historyData
                                        .isRental ==
                                        false &&
                                    arg.historyData
                                        .goodsType ==
                                        '-')
                                    ? AppLocalizations.of(
                                    context)!
                                    .outStation
                                    : (arg.historyData
                                    .isOutStation ==
                                    1 &&
                                    arg.historyData
                                        .isRental ==
                                        false &&
                                    arg.historyData
                                        .goodsType !=
                                        '-')
                                    ? AppLocalizations.of(
                                    context)!
                                    .deliveryOutStation
                                    : '',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (context
                                        .read<AccBloc>()
                                        .languageCode ==
                                        'fr' ||
                                        (context
                                            .read<AccBloc>()
                                            .languageCode ==
                                            'az') ||
                                        (context
                                            .read<AccBloc>()
                                            .languageCode ==
                                            'es') ||
                                        context
                                            .read<AccBloc>()
                                            .languageCode ==
                                            'sq')
                                        ? 12
                                        : 14,
                                    color: Theme.of(context)
                                        .primaryColorDark),
                              ),
                              const SizedBox(height: 6),

                              // Outstation Round Trip / One Way Badge
                              if (arg.historyData.isOutStation == 1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellowColor
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.yellowColor
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MyText(
                                        text: (arg.historyData.isOutStation ==
                                            1 &&
                                            arg.historyData.isRoundTrip !=
                                                '')
                                            ? AppLocalizations.of(context)!
                                            .roundTrip
                                            : AppLocalizations.of(context)!
                                            .oneWayTrip,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                          color: AppColors.yellowColor,
                                        ),
                                      ),
                                      if (arg.historyData.isOutStation == 1 &&
                                          arg.historyData.isRoundTrip != '')
                                        const Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.import_export,
                                            size: 14,
                                            color: AppColors.yellowColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 8),

                              // Date / Time
                              MyText(
                                text: (arg.historyData.laterRide == true &&
                                    arg.historyData.isOutStation == 1)
                                    ? arg.historyData.tripStartTime
                                    : (arg.historyData.laterRide == true &&
                                    arg.historyData.isOutStation != 1)
                                    ? arg
                                    .historyData.tripStartTimeWithDate
                                    : arg.historyData.isCompleted == 1
                                    ? arg.historyData
                                    .convertedCompletedAt
                                    : arg.historyData.isCancelled == 1
                                    ? arg.historyData
                                    .convertedCancelledAt
                                    : arg.historyData
                                    .convertedCreatedAt,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                  color: AppColors.hintColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // === Bottom Section: Duration, Distance, Color (Only if completed) ===
                    if (arg.historyData.isCompleted == 1) ...[
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Theme.of(context).dividerColor.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Duration
                          _buildInfoItem(
                            context,
                            icon: Icons.access_time_outlined,
                            label: AppLocalizations.of(context)!.duration,
                            value:
                            '${arg.historyData.totalTime} ${AppLocalizations.of(context)!.mins}',
                          ),

                          // Distance
                          _buildInfoItem(
                            context,
                            image: AppImages.routes,
                            label: AppLocalizations.of(context)!.distance,
                            value:
                            '${arg.historyData.totalDistance} ${arg.historyData.unit}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Car Color
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppImages.vehicleColorImage,
                                height: 20,
                                width: 20,
                                color: AppColors.hintColor,
                              ),
                              const SizedBox(width: 8),
                              MyText(
                                text: AppLocalizations.of(context)!.colorText,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                  color: AppColors.greyHintColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          MyText(
                            text: arg.historyData.carColor,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.greyHintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, {
        IconData? icon,
        String? image,
        required String label,
        required String value,
      }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.meshwarRed.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: icon != null
                  ? Icon(icon, size: 16, color: AppColors.meshwarRed)
                  : Image.asset(image!,
                  height: 16, width: 16, color: AppColors.meshwarRed),
            ),
            const SizedBox(width: 8),
            MyText(
              text: label,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.hintColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        MyText(
          text: value,
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.greyHintColor,
          ),
        ),
      ],
    );
  }
}