import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../common/liquid_glass_container.dart';
import '../../../../../../../common/pickup_icon.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_divider.dart';
import '../../../../../../../core/utils/custom_loader.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../core/utils/functions.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';
import 'onride_payment_gateway_widget.dart';

class OnRideBottomSheet extends StatelessWidget {
  const OnRideBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final bookingBloc = context.read<BookingBloc>();
        return Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: AppColors.surfaceStrong(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: (bookingBloc.requestData != null &&
                    bookingBloc.driverData != null)
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.width * 0.03),
                    const CustomDivider(),
                    SizedBox(height: size.width * 0.03),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05),
                      width: size.width,
                      child: LiquidGlassContainer(
                        borderRadius: 10,
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: MyText(
                                text: ((bookingBloc.requestData != null &&
                                    bookingBloc
                                        .requestData!.acceptedAt !=
                                        '' &&
                                    bookingBloc
                                        .requestData!.arrivedAt ==
                                        "" &&
                                    bookingBloc
                                        .requestData!.isTripStart ==
                                        0))
                                    ? AppLocalizations.of(context)!.onTheWay
                                    : (bookingBloc
                                    .requestData !=
                                    null &&
                                    bookingBloc
                                        .requestData!.acceptedAt !=
                                        '' &&
                                    bookingBloc.requestData!
                                        .arrivedAt !=
                                        "" &&
                                    bookingBloc.requestData!
                                        .isTripStart ==
                                        0)
                                    ? AppLocalizations.of(context)!
                                    .driverArrived
                                    : AppLocalizations.of(context)!
                                    .reachingDestination,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                    color: Theme.of(context)
                                        .primaryColorDark,
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                              ),
                            ),
                            if ((bookingBloc.requestData != null &&
                                bookingBloc.requestData!.acceptedAt != '' &&
                                bookingBloc.requestData!.arrivedAt != "" &&
                                (bookingBloc.requestData!.isTripStart ==
                                    0 ||
                                    (bookingBloc.requestData!
                                        .transportType ==
                                        'delivery' &&
                                        bookingBloc
                                            .requestData!.isTripStart ==
                                            1)) &&
                                bookingBloc.requestData!.showOtpFeature))
                              Container(
                                padding:
                                const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primary
                                        .withOpacity(0.08)),
                                child: Row(
                                  children: [
                                    MyText(
                                      text: 'OTP ',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    MyText(
                                      text: bookingBloc.requestData!.rideOtp
                                          .toString(),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.03),
                    if (bookingBloc.requestData != null &&
                        bookingBloc.requestData!.isTripStart == 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.65,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    (bookingBloc.requestData!
                                        .acceptedAt !=
                                        '' &&
                                        bookingBloc.requestData!
                                            .arrivedAt ==
                                            '' &&
                                        bookingBloc.requestData!
                                            .isTripStart ==
                                            0)
                                        ? MyText(
                                      text: AppLocalizations.of(
                                          context)!
                                          .driverArriveText
                                          .replaceAll('**',
                                          '${(bookingBloc.duration.isNotEmpty && bookingBloc.duration != '0' && bookingBloc.duration != '0.0') ? double.parse(bookingBloc.duration).toStringAsFixed(0) : 2}'),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    )
                                        : (bookingBloc.requestData!
                                        .acceptedAt !=
                                        '' &&
                                        bookingBloc.requestData!
                                            .arrivedAt !=
                                            '' &&
                                        bookingBloc.requestData!
                                            .isTripStart ==
                                            0)
                                        ? (bookingBloc.requestData!
                                        .isBidRide ==
                                        1 ||
                                        bookingBloc
                                            .requestData!
                                            .isRental)
                                        ? MyText(
                                      text: AppLocalizations
                                          .of(context)!
                                          .driverArrivedLocation,
                                      textStyle:
                                      Theme.of(context)
                                          .textTheme
                                          .bodySmall!,
                                      textAlign:
                                      TextAlign.center,
                                    )
                                        : MyText(
                                      text: (bookingBloc
                                          .requestData!
                                          .freeWaitingTimeInMinsBeforeTripStart ==
                                          0 ||
                                          bookingBloc
                                              .requestData!
                                              .freeWaitingTimeInMinsAfterTripStart ==
                                              0)
                                          ? AppLocalizations.of(context)!
                                          .waitingChargeText
                                          .replaceAll(
                                          '*', '${bookingBloc.requestData!.requestedCurrencySymbol} ${bookingBloc.requestData!.waitingCharge}')
                                          : AppLocalizations.of(context)!
                                          .arrivedMessage
                                          .replaceAll(
                                          '***',
                                          '${bookingBloc.requestData!.requestedCurrencySymbol} ${bookingBloc.requestData!.waitingCharge}')
                                          .replaceAll(
                                          '*',
                                          bookingBloc.requestData!.isTripStart == 0
                                              ? bookingBloc
                                              .requestData!
                                              .freeWaitingTimeInMinsBeforeTripStart
                                              .toString()
                                              : bookingBloc.requestData!.freeWaitingTimeInMinsAfterTripStart.toString()),
                                      textStyle:
                                      Theme.of(context)
                                          .textTheme
                                          .bodySmall!,
                                      maxLines: 2,
                                      textAlign:
                                      TextAlign.center,
                                    )
                                        : MyText(
                                      text: AppLocalizations.of(
                                          context)!
                                          .reachingDestinationInMinutes
                                          .replaceAll('***',
                                          '${(bookingBloc.duration.isNotEmpty && bookingBloc.duration != '0' && bookingBloc.duration != '0.0') ? double.parse(bookingBloc.duration).toStringAsFixed(0) : 2}'),
                                      textStyle:
                                      Theme.of(context)
                                          .textTheme
                                          .bodySmall!,
                                      textAlign:
                                      TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if ((bookingBloc.requestData != null &&
                              bookingBloc.requestData!.acceptedAt !=
                                  '' &&
                              bookingBloc.requestData!.arrivedAt !=
                                  "" &&
                              bookingBloc.requestData!.isTripStart ==
                                  0) &&
                              (bookingBloc.waitingTime / 60)
                                  .toStringAsFixed(0) !=
                                  '0' &&
                              bookingBloc.requestData!.isBidRide == 0 &&
                              !bookingBloc.requestData!.isRental)
                            SizedBox(
                              width: size.width * 0.25,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: Stack(
                                  alignment:
                                  AlignmentDirectional.bottomCenter,
                                  children: [
                                    Image.asset(
                                      AppImages.waitingTime,
                                      color:
                                      Theme.of(context).disabledColor,
                                      width: size.width * 0.098,
                                      fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(5)),
                                            boxShadow:
                                            AppColors.surfaceShadow(
                                                context),
                                            color:
                                            AppColors.surfaceStrong(
                                                context),
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          child: MyText(
                                            text:
                                            '${bookingBloc.formatDuration(bookingBloc.waitingTime).toString()} ${AppLocalizations.of(context)!.mins}',
                                            maxLines: 1,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                    SizedBox(height: size.width * 0.03),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05),
                      width: size.width,
                      child: LiquidGlassContainer(
                        borderRadius: 10,
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const PickupIcon(),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                    child: MyText(
                                        maxLines: 3,
                                        text: bookingBloc
                                            .requestData!.pickAddress)),
                              ],
                            ),
                            if (bookingBloc.requestData!.transportType ==
                                'delivery' &&
                                bookingBloc.requestData!
                                    .pickupPocInstruction.isNotEmpty) ...[
                              Column(
                                children: [
                                  SizedBox(height: size.width * 0.02),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: MyText(
                                      text:
                                      '${AppLocalizations.of(context)!.instructions}: ',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.01),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: MyText(
                                        text: bookingBloc.requestData!
                                            .pickupPocInstruction,
                                        maxLines: 5,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: size.width * 0.03),
                            if (!bookingBloc.requestData!.isRental &&
                                bookingBloc.requestData!.requestStops.data
                                    .isNotEmpty) ...[
                              ListView.separated(
                                itemCount: bookingBloc
                                    .requestData!.requestStops.data.length,
                                shrinkWrap: true,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                          color: AppColors.surfaceBorder(
                                              context)),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const DropIcon(),
                                          SizedBox(
                                              width: size.width * 0.02),
                                          Expanded(
                                            child: MyText(
                                                maxLines: 2,
                                                text: bookingBloc
                                                    .requestData!
                                                    .requestStops
                                                    .data[index]
                                                    .address),
                                          ),
                                          if (bookingBloc.requestData!
                                              .isTripStart ==
                                              1 &&
                                              bookingBloc.requestData!
                                                  .transportType ==
                                                  'taxi') ...[
                                            SizedBox(
                                                width: size.width * 0.01),
                                            InkWell(
                                              onTap: () {
                                                bookingBloc.add(
                                                    EditLocationEvent(
                                                        requestData:
                                                        bookingBloc
                                                            .requestData));
                                              },
                                              child: Icon(
                                                  Icons.edit_outlined,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                            ),
                                          ]
                                        ],
                                      ),
                                      if (bookingBloc.requestData!
                                          .transportType ==
                                          'delivery' &&
                                          bookingBloc
                                              .requestData!
                                              .requestStops
                                              .data[index]
                                              .pocInstruction
                                              .isNotEmpty) ...[
                                        Column(
                                          children: [
                                            SizedBox(
                                                height: size.width * 0.02),
                                            SizedBox(
                                              width: size.width * 0.8,
                                              child: MyText(
                                                text:
                                                '${AppLocalizations.of(context)!.instructions}: ',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.width * 0.01),
                                            SizedBox(
                                              width: size.width * 0.8,
                                              child: MyText(
                                                  text: bookingBloc
                                                      .requestData!
                                                      .requestStops
                                                      .data[index]
                                                      .pocInstruction,
                                                  maxLines: 5,
                                                  textStyle:
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodySmall),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                      height: size.width * 0.02);
                                },
                              ),
                            ],
                            if (!bookingBloc.requestData!.isRental &&
                                bookingBloc.requestData!.requestStops.data
                                    .isEmpty &&
                                bookingBloc.requestData!.dropAddress
                                    .isNotEmpty) ...[
                              Divider(
                                  color:
                                  AppColors.surfaceBorder(context)),
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const DropIcon(),
                                  SizedBox(width: size.width * 0.02),
                                  Expanded(
                                    child: MyText(
                                        maxLines: 3,
                                        text: bookingBloc
                                            .requestData!.dropAddress),
                                  ),
                                  if (bookingBloc
                                      .requestData!.isTripStart ==
                                      1 &&
                                      bookingBloc
                                          .requestData!.transportType ==
                                          'taxi') ...[
                                    SizedBox(width: size.width * 0.01),
                                    InkWell(
                                      onTap: () {
                                        bookingBloc.add(EditLocationEvent(
                                            requestData:
                                            bookingBloc.requestData));
                                      },
                                      child: Icon(Icons.edit_outlined,
                                          size: 20,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                            if (bookingBloc.requestData!.transportType ==
                                'delivery' &&
                                !bookingBloc.requestData!.isRental &&
                                bookingBloc.requestData!.requestStops.data
                                    .isEmpty &&
                                bookingBloc.requestData!.dropPocInstruction
                                    .isNotEmpty) ...[
                              Column(
                                children: [
                                  SizedBox(height: size.width * 0.02),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: MyText(
                                      text:
                                      '${AppLocalizations.of(context)!.instructions}: ',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.01),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: MyText(
                                        text: bookingBloc.requestData!
                                            .dropPocInstruction,
                                        maxLines: 5,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.05),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05),
                      width: size.width,
                      child: LiquidGlassContainer(
                        borderRadius: 10,
                        padding: EdgeInsets.all(size.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: size.width * 0.1,
                                                width: size.width * 0.1,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(20),
                                                    color: Theme.of(context)
                                                        .disabledColor
                                                        .withAlpha(
                                                        (0.2 * 255)
                                                            .toInt())),
                                                alignment: Alignment.center,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: bookingBloc
                                                        .driverData!
                                                        .profilePicture,
                                                    fit: BoxFit.fill,
                                                    placeholder:
                                                        (context, url) =>
                                                    const Center(
                                                      child: Loader(),
                                                    ),
                                                    errorWidget: (context,
                                                        url, error) =>
                                                    const Center(
                                                      child: Text(""),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      MyText(
                                                        text: bookingBloc
                                                            .driverData!
                                                            .name,
                                                        textStyle: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .bodyLarge!,
                                                        maxLines: 5,
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          if (bookingBloc
                                                              .driverData!
                                                              .rating !=
                                                              "0") ...[
                                                            Icon(
                                                              Icons.star,
                                                              size: 15,
                                                              color: Theme.of(
                                                                  context)
                                                                  .primaryColor,
                                                            ),
                                                            MyText(
                                                              text: bookingBloc
                                                                  .driverData!
                                                                  .rating,
                                                              textStyle: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                  fontWeight:
                                                                  FontWeight.w500),
                                                            ),
                                                          ],
                                                          const SizedBox(
                                                              width: 5),
                                                          if (bookingBloc
                                                              .driverData!
                                                              .completedRides !=
                                                              0)
                                                            Container(
                                                              width: 1,
                                                              height: 20,
                                                              color: Theme.of(
                                                                  context)
                                                                  .disabledColor
                                                                  .withAlpha((0.5 *
                                                                  255)
                                                                  .toInt()),
                                                            ),
                                                          const SizedBox(
                                                              width: 5),
                                                          if (bookingBloc
                                                              .driverData!
                                                              .completedRides !=
                                                              0)
                                                            MyText(
                                                              text:
                                                              '${bookingBloc.driverData!.completedRides} trips done',
                                                              textStyle: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: size.width * 0.01),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            height: size.width * 0.15,
                                            width: size.width * 0.15,
                                            child: CachedNetworkImage(
                                              imageUrl: bookingBloc
                                                  .driverData!
                                                  .vehicleTypeImage
                                                  .toString(),
                                              height: size.width * 0.15,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                              const Center(
                                                child: Loader(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                              const Center(
                                                child: Text(""),
                                              ),
                                            ),
                                          ),
                                          MyText(
                                            text: bookingBloc
                                                .driverData!.carColor,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.surface(
                                                    context),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    5),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColorDark)),
                                            child: MyText(
                                                text: bookingBloc
                                                    .driverData!.carNumber,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall),
                                          ),
                                          Wrap(
                                            alignment: WrapAlignment.end,
                                            children: [
                                              MyText(
                                                text:
                                                '${bookingBloc.driverData!.carModelName}|',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!,
                                                maxLines: 1,
                                              ),
                                              MyText(
                                                text: bookingBloc
                                                    .driverData!
                                                    .carMakeName,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if ((bookingBloc.requestData!.transportType ==
                                'taxi' ||
                                bookingBloc.requestData!.isOutStation ==
                                    '1' ||
                                bookingBloc.requestData!.isRental) &&
                                bookingBloc.requestData!
                                    .pickupPocInstruction.isNotEmpty)
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: size.width * 0.02),
                                    SizedBox(
                                      width: size.width * 0.8,
                                      child: MyText(
                                        text:
                                        '${AppLocalizations.of(context)!.instructions}: ',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(height: size.width * 0.01),
                                    SizedBox(
                                      width: size.width * 0.8,
                                      child: MyText(
                                          text: bookingBloc.requestData!
                                              .pickupPocInstruction,
                                          maxLines: 5,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ),
                                  ],
                                ),
                              ),
                            if (bookingBloc.requestData != null &&
                                bookingBloc
                                    .requestData!.requestPreferences !=
                                    null &&
                                bookingBloc.requestData!.requestPreferences
                                    .data.isNotEmpty)
                              Row(
                                children: [
                                  MyText(
                                      text:
                                      '${AppLocalizations.of(context)!.preferences} : ',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  for (int i = 0;
                                  i <
                                      bookingBloc
                                          .requestData!
                                          .requestPreferences
                                          .data
                                          .length;
                                  i++) ...[
                                    Container(
                                      padding: EdgeInsets.all(
                                          size.width * 0.005),
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: bookingBloc
                                            .requestData!
                                            .requestPreferences
                                            .data[i]
                                            .icon,
                                        fit: BoxFit.cover,
                                        errorWidget:
                                            (context, url, error) =>
                                        const Icon(
                                          Icons.error,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    if (i !=
                                        bookingBloc
                                            .requestData!
                                            .requestPreferences
                                            .data
                                            .length -
                                            1) //avoid comma at end
                                      const Text(
                                        ",",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ]
                                ],
                              ),
                            SizedBox(height: size.width * 0.03),
                            if ((bookingBloc.requestData!.isTripStart ==
                                0 &&
                                bookingBloc
                                    .requestData!.transportType ==
                                    'taxi') ||
                                (bookingBloc.requestData!.transportType !=
                                    'taxi')) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          bookingBloc.add(
                                              ChatWithDriverEvent(
                                                  requestId: bookingBloc
                                                      .requestData!.id));
                                        },
                                        child: Container(
                                            width: size.width * 0.1,
                                            height: size.width * 0.1,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.surface(
                                                  context),
                                              border: Border.all(
                                                  color: AppColors
                                                      .surfaceBorder(
                                                      context)),
                                            ),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              AppImages.messages,
                                              width: size.width * 0.05,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            )),
                                      ),
                                      if (bookingBloc
                                          .chatHistoryList.isNotEmpty &&
                                          bookingBloc.chatHistoryList
                                              .where((element) =>
                                          element.fromType == 2 &&
                                              element.seen == 0)
                                              .isNotEmpty)
                                        Positioned(
                                          top: size.width * 0.01,
                                          right: size.width * 0.008,
                                          child: Container(
                                            height: size.width * 0.03,
                                            width: size.width * 0.03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(width: size.width * 0.025),
                                  InkWell(
                                    onTap: () async {
                                      await openUrl(
                                          "tel:${bookingBloc.driverData!.mobile}");
                                    },
                                    child: Container(
                                        width: size.width * 0.1,
                                        height: size.width * 0.1,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.surface(
                                              context),
                                          border: Border.all(
                                              color: AppColors
                                                  .surfaceBorder(context)),
                                        ),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          AppImages.phone,
                                          width: size.width * 0.05,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        )),
                                  ),
                                  SizedBox(width: size.width * 0.025),
                                  InkWell(
                                    onTap: () async {
                                      await Share.share(
                                          'Your Driver is ${bookingBloc.driverData!.name}. ${bookingBloc.driverData!.carColor} ${bookingBloc.driverData!.carMakeName} ${bookingBloc.driverData!.carModelName}, Vehicle Number: ${bookingBloc.driverData!.carNumber}. Track with link: ${AppConstants.baseUrl}track/request/${bookingBloc.requestData!.id}');
                                    },
                                    child: Container(
                                      width: size.width * 0.1,
                                      height: size.width * 0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.surface(context),
                                        border: Border.all(
                                            color: AppColors.surfaceBorder(
                                                context)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.share,
                                        size: size.width * 0.05,
                                        color: Theme.of(context)
                                            .primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.width * 0.05),
                    Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                //Added new
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.5,
                                      child: MyText(
                                          text: bookingBloc
                                              .requestData!.isRental
                                              ? bookingBloc.requestData!
                                              .rentalPackageName
                                              : AppLocalizations.of(
                                              context)!
                                              .rideFare,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              fontWeight:
                                              FontWeight.w600)),
                                    ),
                                    (bookingBloc.requestData!.isBidRide ==
                                        1)
                                        ? MyText(
                                        text:
                                        '${bookingBloc.requestData!.requestedCurrencySymbol} ${bookingBloc.requestData!.acceptedRideFare}',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                            fontWeight:
                                            FontWeight.bold))
                                        : (bookingBloc.requestData!.discountedTotal != null &&
                                        bookingBloc.requestData!.discountedTotal !=
                                            "")
                                        ? MyText(
                                        text:
                                        '${bookingBloc.requestData!.requestedCurrencySymbol} ${bookingBloc.requestData!.discountedTotal}',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                            fontWeight:
                                            FontWeight
                                                .bold))
                                        : MyText(
                                        text:
                                        '${bookingBloc.requestData!.requestedCurrencySymbol} ${bookingBloc.requestData!.requestEtaAmount}',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    bookingBloc.requestData!.paymentOpt ==
                                        '1'
                                        ? Icons.payments_outlined
                                        : bookingBloc.requestData!
                                        .paymentOpt ==
                                        '0'
                                        ? Icons.credit_card_rounded
                                        : Icons
                                        .account_balance_wallet_outlined,
                                    size: size.width * 0.05,
                                    color: Theme.of(context)
                                        .primaryColorDark,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.025,
                                  ),
                                  MyText(
                                      text: bookingBloc.requestData!
                                          .paymentOpt ==
                                          '1'
                                          ? AppLocalizations.of(context)!
                                          .cash
                                          : bookingBloc.requestData!
                                          .paymentOpt ==
                                          '2'
                                          ? AppLocalizations.of(
                                          context)!
                                          .wallet
                                          : AppLocalizations.of(
                                          context)!
                                          .card,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          if (bookingBloc
                              .additionalChargesReason.isNotEmpty &&
                              bookingBloc
                                  .additionalChargesAmount.isNotEmpty)
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: MyText(
                                      text: bookingBloc
                                          .additionalChargesReason,
                                      maxLines: 5,
                                      textAlign: TextAlign.start,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.w600)),
                                ),
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: MyText(
                                      text:
                                      '+ ${bookingBloc.requestData!.requestedCurrencySymbol} ${bookingBloc.additionalChargesAmount}',
                                      maxLines: 2,
                                      textAlign: TextAlign.end,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.bold)),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    if (bookingBloc.requestData!.transportType ==
                        'delivery' &&
                        !bookingBloc.payAtDrop &&
                        bookingBloc.requestData!.paymentOpt == '0' &&
                        bookingBloc.requestData!.isDriverArrived == 1 &&
                        bookingBloc.requestData!.isPaid == 0)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                            vertical: size.width * 0.02),
                        child: CustomButton(
                          buttonName: AppLocalizations.of(context)!.pay,
                          width: size.width * 0.5,
                          height: size.width * 0.11,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor:
                                AppColors.surfaceStrong(context),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (_) {
                                  return BlocProvider.value(
                                    value: bookingBloc,
                                    child: OnridePaymentGatewayWidget(
                                        cont: context,
                                        walletPaymentGatways: bookingBloc
                                            .requestData!
                                            .paymentGateways),
                                  );
                                });
                          },
                        ),
                      ),
                    SizedBox(height: size.width * 0.025),
                    if (bookingBloc.requestData!.isTripStart == 0)
                      InkWell(
                        onTap: () {
                          bookingBloc.selectedCancelReason = '';
                          bookingBloc.add(CancelReasonsEvent(
                              beforeOrAfter: (bookingBloc
                                  .requestData!.isDriverArrived ==
                                  0)
                                  ? 'before'
                                  : 'after'));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .cancelRide,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: size.width * 0.099),
                  ],
                )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}