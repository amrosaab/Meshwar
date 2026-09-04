import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';

class EtaDetailsWidget extends StatelessWidget {
  final BuildContext cont;
  final dynamic etaInfo;
  final bool isReturnTime;
  const EtaDetailsWidget({
    super.key,
    required this.etaInfo,
    required this.cont,
    required this.isReturnTime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              width: size.width,
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: AppColors.surfaceStrong(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                text: etaInfo
                                    .name, //- ${etaInfo.currency.toString()} ${etaInfo.total.toString()}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            MyText(
                              text: etaInfo.description,
                              maxLines: 4,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.hintColor),
                            ),
                          ],
                        ),
                      ),
                      CachedNetworkImage(
                        imageUrl: (context.read<BookingBloc>().isRentalRide)
                            ? etaInfo.icon
                            : etaInfo.vehicleIcon,
                        width: size.width * 0.2,
                        height: size.width * 0.1,
                        fit: BoxFit.contain,
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
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ))
                    ],
                  ),
                  SizedBox(height: size.width * 0.02),
                  Divider(color: AppColors.surfaceBorder(context)),
                  SizedBox(height: size.width * 0.01),
                  if (context.read<BookingBloc>().isRentalRide) ...[
                    Flexible(
                      child: MyText(
                        text: etaInfo.description,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                      ),
                    ),
                  ],
                  if (!context.read<BookingBloc>().isRentalRide &&
                      isReturnTime == false) ...[
                    MyText(
                      text: AppLocalizations.of(context)!.rideFare,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.width * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text:
                          '${AppLocalizations.of(context)!.baseDistancePrice} ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14),
                        ),
                        MyText(
                          text:
                          '${etaInfo.currency}${etaInfo.basePrice.toStringAsFixed(2)}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              fontSize: 14,
                              color: Theme.of(context).primaryColorDark),
                        )
                      ],
                    ),
                    SizedBox(height: size.width * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text:
                          '${AppLocalizations.of(context)!.additional} \n${AppLocalizations.of(context)!.distancePrice} (${etaInfo.calculatedDistance}${etaInfo.unitInWords} x ${etaInfo.currency}${etaInfo.pricePerDistance})',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14),
                        ),
                        MyText(
                          text:
                          '${etaInfo.currency}${etaInfo.distancePrice.toStringAsFixed(2)}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              fontSize: 14,
                              color: Theme.of(context).primaryColorDark),
                        )
                      ],
                    ),
                    SizedBox(height: size.width * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text:
                          '${AppLocalizations.of(context)!.timePrice}(${etaInfo.time} mins x ${etaInfo.currency}${etaInfo.pricePerTime})',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14),
                        ),
                        MyText(
                          text:
                          '${etaInfo.currency}${etaInfo.timePrice.toStringAsFixed(2)}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              fontSize: 14,
                              color: Theme.of(context).primaryColorDark),
                        )
                      ],
                    ),
                    SizedBox(height: size.width * 0.01),
                    if (etaInfo.airportSurgeFee != 0.0 &&
                        etaInfo.airportSurgeFee != 0 &&
                        !context.read<BookingBloc>().isBiddingRideSearching &&
                        !context.read<BookingBloc>().showBiddingVehicles)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: AppLocalizations.of(context)!.airportSurgefee,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 14),
                          ),
                          MyText(
                            text:
                            '${etaInfo.currency}${etaInfo.airportSurgeFee.toStringAsFixed(2)}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark),
                          )
                        ],
                      ),
                    SizedBox(height: size.width * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text:
                          '${AppLocalizations.of(context)!.tax}(${etaInfo.tax}%)', //(${etaInfo.tax})
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14),
                        ),
                        MyText(
                          text:
                          '${etaInfo.currency}${etaInfo.taxAmount.toStringAsFixed(2)}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              fontSize: 14,
                              color: Theme.of(context).primaryColorDark),
                        )
                      ],
                    ),
                    SizedBox(height: size.width * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.adminCommission,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14),
                        ),
                        MyText(
                          text:
                          '${etaInfo.currency}${etaInfo.withoutDiscountAdminCommision.toStringAsFixed(2)}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              fontSize: 14,
                              color: Theme.of(context).primaryColorDark),
                        )
                      ],
                    ),
                    SizedBox(height: size.width * 0.02),
                    if (etaInfo.preferencePriceTotal != 0.0 &&
                        etaInfo.preferencePriceTotal != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: AppLocalizations.of(context)!.preference,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 14),
                          ),
                          MyText(
                            text:
                            '${etaInfo.currency}${etaInfo.preferencePriceTotal.toStringAsFixed(2)}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark),
                          )
                        ],
                      ),
                    Divider(color: AppColors.surfaceBorder(context)),
                    SizedBox(height: size.width * 0.01),
                    // Show grand total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.total,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                              fontSize: 16,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold),
                        ),
                        MyText(
                          text:
                          '${etaInfo.currency}${etaInfo.total.toStringAsFixed(2)}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                              fontSize: 16,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: size.width * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: size.width * 0.015,
                          width: size.width * 0.015,
                          margin: const EdgeInsets.only(top: 7),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        SizedBox(width: size.width * 0.01),
                        Flexible(
                          child: MyText(
                            text: AppLocalizations.of(context)!
                                .infoWaitingPrice
                                .replaceAll('***',
                                '${etaInfo.currency} ${etaInfo.waitingCharge}')
                                .replaceAll('*',
                                '${etaInfo.freeWaitingTimeInMinsBeforeTripStart}'),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                fontSize: 12, color: AppColors.hintColor),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ] else if (isReturnTime == true) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: (etaInfo.unitInWords == 'KM')
                              ? AppLocalizations.of(context)!.pricePerkm
                              : AppLocalizations.of(context)!.pricePerMiles,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 14),
                        ),
                        MyText(
                          text:
                          '${etaInfo.currency}${etaInfo.pricePerDistance.toStringAsFixed(2)}',
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              fontSize: 14,
                              color: Theme.of(context).primaryColorDark),
                        )
                      ],
                    ),
                  ],
                  SizedBox(height: size.width * 0.03),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}