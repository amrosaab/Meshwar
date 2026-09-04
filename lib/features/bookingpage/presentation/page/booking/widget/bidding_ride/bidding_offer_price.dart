import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../common/pickup_icon.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';

class BiddingOfferingPriceWidget extends StatelessWidget {
  final BuildContext cont;
  final BookingPageArguments arg;
  const BiddingOfferingPriceWidget(
      {super.key, required this.cont, required this.arg});

  bool _isDecreaseDisabled(BuildContext context) {
    final bloc = context.read<BookingBloc>();
    final double totalValue = bloc.isMultiTypeVechiles
        ? (bloc.isOutstationRide && bloc.isRoundTrip)
            ? (bloc.sortedEtaDetailsList[bloc.selectedVehicleIndex].total * 2)
            : bloc.sortedEtaDetailsList[bloc.selectedVehicleIndex].total
        : (bloc.isOutstationRide && bloc.isRoundTrip)
            ? (bloc.etaDetailsList[bloc.selectedVehicleIndex].total * 2)
            : bloc.etaDetailsList[bloc.selectedVehicleIndex].total;
    final String bidLowPercentage = bloc.isMultiTypeVechiles
        ? bloc.sortedEtaDetailsList[bloc.selectedVehicleIndex]
            .biddingLowPercentage
        : bloc.etaDetailsList[bloc.selectedVehicleIndex].biddingLowPercentage;
    final double minAllowedPrice = (bidLowPercentage == '0')
        ? 0.0
        : totalValue - ((double.parse(bidLowPercentage) / 100) * totalValue);
    final double currentFare =
        double.tryParse(bloc.farePriceController.text) ?? totalValue;
    return currentFare <= minAllowedPrice;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 4,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 12,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern drag handle indicator
                  Center(
                    child: Container(
                      width: size.width * 0.1,
                      height: size.width * 0.01,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .disabledColor
                            .withAlpha((0.3 * 255).toInt()),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: size.width * 0.04),

                  // Vehicle name with icon
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 4,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.directions_car_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MyText(
                            text:
                                context.read<BookingBloc>().isMultiTypeVechiles
                                    ? context
                                        .read<BookingBloc>()
                                        .sortedEtaDetailsList[context
                                            .read<BookingBloc>()
                                            .selectedVehicleIndex]
                                        .name
                                    : context
                                        .read<BookingBloc>()
                                        .etaDetailsList[context
                                            .read<BookingBloc>()
                                            .selectedVehicleIndex]
                                        .name,
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.width * 0.08),

                  // Location cards with modern styling
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup Location
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.025,
                            height: size.width * 0.025,
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          MyText(
                            text: AppLocalizations.of(context)!.pickupLocation,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.015),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 4,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                            itemCount: context
                                .read<BookingBloc>()
                                .pickUpAddressList
                                .length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final address = context
                                  .read<BookingBloc>()
                                  .pickUpAddressList
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.green
                                            .withAlpha((0.1 * 255).toInt()),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const PickupIcon(),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MyText(
                                        text: address.address,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: size.width * 0.025,
                      ),
                      // Drop Location
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.025,
                            height: size.width * 0.025,
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          MyText(
                            text: AppLocalizations.of(context)!.dropLocation,
                            textStyle:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).disabledColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.015),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 4,
                              spreadRadius: 0.5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                            itemCount: context
                                .read<BookingBloc>()
                                .dropAddressList
                                .length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final address = context
                                  .read<BookingBloc>()
                                  .dropAddressList
                                  .elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.red
                                            .withAlpha((0.1 * 255).toInt()),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const DropIcon(),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MyText(
                                        text: address.address,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),

                  SizedBox(height: size.width * 0.05),

                  // Offer your fare section
                  Center(
                    child: Column(
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.offerYourFare,
                          textStyle:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withAlpha((0.1 * 255).toInt()),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 6),
                              MyText(
                                text:
                                    '${AppLocalizations.of(context)!.minimumRecommendedFare.replaceAll('***', '')} ${context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency} ${context.read<BookingBloc>().isMultiTypeVechiles ? (context.read<BookingBloc>().isOutstationRide && context.read<BookingBloc>().isRoundTrip) ? (context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount * 2).toStringAsFixed(2) : context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount.toStringAsFixed(2) : (context.read<BookingBloc>().isOutstationRide && context.read<BookingBloc>().isRoundTrip) ? (context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount * 2).toStringAsFixed(2) : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].minAmount.toStringAsFixed(2)}',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.width * 0.04),

                  // Price adjustment buttons with modern styling
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 4,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Decrease button
                        _buildPriceButton(
                          context: context,
                          size: size,
                          icon: Icons.remove_rounded,
                          label:
                              '-${double.parse(context.read<BookingBloc>().userData!.biddingAmountIncreaseOrDecrease.toString())}',
                          isDisabled: _isDecreaseDisabled(context),
                          isDecrease: true,
                          onTap: () {
                            final bool isDisabled =
                                _isDecreaseDisabled(context);
                            if (!isDisabled) {
                              context.read<BookingBloc>().add(
                                  BiddingIncreaseOrDecreaseEvent(
                                      isIncrease: false,
                                      isOutStation: context
                                          .read<BookingBloc>()
                                          .isOutstationRide));
                            }
                          },
                        ),

                        // Price input field
                        Container(
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 4,
                                spreadRadius: 0.5,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: TextField(
                            enabled: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller:
                                context.read<BookingBloc>().farePriceController,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 15),
                              prefixText:
                                  '${context.read<BookingBloc>().isMultiTypeVechiles ? context.read<BookingBloc>().sortedEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency : context.read<BookingBloc>().etaDetailsList[context.read<BookingBloc>().selectedVehicleIndex].currency} ',
                              prefixStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ),

                        // Increase button
                        _buildPriceButton(
                          context: context,
                          size: size,
                          icon: Icons.add_rounded,
                          label:
                              '+${double.parse(context.read<BookingBloc>().userData!.biddingAmountIncreaseOrDecrease.toString())}',
                          isDisabled: context
                              .read<BookingBloc>()
                              .isBiddingIncreaseLimitReach,
                          isDecrease: false,
                          onTap: () {
                            if (!context
                                .read<BookingBloc>()
                                .isBiddingIncreaseLimitReach) {
                              context.read<BookingBloc>().add(
                                  BiddingIncreaseOrDecreaseEvent(
                                      isIncrease: true,
                                      isOutStation: context
                                          .read<BookingBloc>()
                                          .isOutstationRide));
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.width * 0.05),

                  // Create Request Button with gradient
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColor
                              .withAlpha((0.3 * 255).toInt()),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: context.read<BookingBloc>().isLoading
                          ? null
                          : () {
                              final currencySymbol = context
                                      .read<BookingBloc>()
                                      .isMultiTypeVechiles
                                  ? context
                                      .read<BookingBloc>()
                                      .sortedEtaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .currency
                                  : context
                                      .read<BookingBloc>()
                                      .etaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .currency;

                              final total = double.parse(context
                                      .read<BookingBloc>()
                                      .isMultiTypeVechiles
                                  ? context
                                      .read<BookingBloc>()
                                      .sortedEtaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .total
                                      .toString()
                                  : context
                                      .read<BookingBloc>()
                                      .etaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .total
                                      .toString());

                              final lowPercentage = double.parse(context
                                      .read<BookingBloc>()
                                      .isMultiTypeVechiles
                                  ? context
                                      .read<BookingBloc>()
                                      .sortedEtaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .biddingLowPercentage
                                  : context
                                      .read<BookingBloc>()
                                      .etaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .biddingLowPercentage);

                              final highPercentage = double.parse(context
                                      .read<BookingBloc>()
                                      .isMultiTypeVechiles
                                  ? context
                                      .read<BookingBloc>()
                                      .sortedEtaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .biddingHighPercentage
                                  : context
                                      .read<BookingBloc>()
                                      .etaDetailsList[context
                                          .read<BookingBloc>()
                                          .selectedVehicleIndex]
                                      .biddingHighPercentage);

                              double roundToTwoDecimals(double number) {
                                return double.parse(number.toStringAsFixed(2));
                              }

                              final value = (context
                                          .read<BookingBloc>()
                                          .isOutstationRide &&
                                      context.read<BookingBloc>().isRoundTrip)
                                  ? ((total * 2) -
                                      ((lowPercentage / 100) * (total * 2)))
                                  : (total - ((lowPercentage / 100) * total));
                              final highValue = (context
                                          .read<BookingBloc>()
                                          .isOutstationRide &&
                                      context.read<BookingBloc>().isRoundTrip)
                                  ? ((total * 2) +
                                      (highPercentage / 100) * (total * 2))
                                  : (total + (highPercentage / 100) * total);

                              final roundedValue = roundToTwoDecimals(value);
                              final roundedHighValue =
                                  roundToTwoDecimals(highValue);
                              final enteredFare = double.parse(context
                                  .read<BookingBloc>()
                                  .farePriceController
                                  .text
                                  .trim());
                              if (enteredFare >= roundedValue &&
                                  enteredFare <= roundedHighValue) {
                                Navigator.pop(context);
                                if (context.read<BookingBloc>().transportType ==
                                        'taxi' ||
                                    context.read<BookingBloc>().transportType ==
                                        'delivery') {
                                  context.read<BookingBloc>().add(BiddingCreateRequestEvent(
                                      userData:
                                          context.read<BookingBloc>().userData!,
                                      vehicleData: context.read<BookingBloc>().isMultiTypeVechiles
                                          ? context.read<BookingBloc>().sortedEtaDetailsList[context
                                              .read<BookingBloc>()
                                              .selectedVehicleIndex]
                                          : context.read<BookingBloc>().etaDetailsList[context
                                              .read<BookingBloc>()
                                              .selectedVehicleIndex],
                                      pickupAddressList: arg.pickupAddressList,
                                      dropAddressList: arg.stopAddressList,
                                      selectedTransportType: context
                                          .read<BookingBloc>()
                                          .transportType,
                                      paidAt: context.read<BookingBloc>().payAtDrop
                                          ? 'Receiver'
                                          : 'Sender',
                                      selectedPaymentType: context
                                          .read<BookingBloc>()
                                          .selectedPaymentType,
                                      scheduleDateTime: context
                                          .read<BookingBloc>()
                                          .scheduleDateTime,
                                      goodsTypeId:
                                          context.read<BookingBloc>().selectedGoodsTypeId == 0
                                              ? null
                                              : context
                                                  .read<BookingBloc>()
                                                  .selectedGoodsTypeId
                                                  .toString(),
                                      goodsQuantity: context.read<BookingBloc>().goodsQtyController.text.isEmpty ? null : context.read<BookingBloc>().goodsQtyController.text,
                                      offeredRideFare: context.read<BookingBloc>().farePriceController.text,
                                      polyLine: context.read<BookingBloc>().polyLine,
                                      isOutstationRide: context.read<BookingBloc>().isOutstationRide,
                                      isRoundTrip: context.read<BookingBloc>().isRoundTrip,
                                      scheduleDateTimeForReturn: context.read<BookingBloc>().scheduleDateTimeForReturn,
                                      cardToken: context.read<BookingBloc>().selectedCardToken,
                                      parcelType: arg.title,
                                      preferences: context.read<BookingBloc>().selectedPreferenceDetailsList,
                                      preferencesIcons: context.read<BookingBloc>().selectedPreferenceIconsList,
                                      bookOthers: (context.read<BookingBloc>().isMyself == true) ? 0 : 1,
                                      contactNumber: (context.read<BookingBloc>().isMyself == true) ? '' : context.read<BookingBloc>().selectedContact.number,
                                      myself: (context.read<BookingBloc>().isMyself == true) ? 1 : 0,
                                      contactBookName: (context.read<BookingBloc>().isMyself == true) ? '' : context.read<BookingBloc>().selectedContact.name));
                                }
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  enableDrag: false,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: context.read<BookingBloc>(),
                                      child: SafeArea(
                                        child: Container(
                                          width: size.width,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                    height: size.width * 0.1),
                                                MyText(
                                                  text: ((double.parse(context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .farePriceController
                                                                  .text) >=
                                                              value) ==
                                                          false)
                                                      ? '${AppLocalizations.of(context)!.minimumRideFareError} ($currencySymbol ${value.toStringAsFixed(2)})'
                                                      : '${AppLocalizations.of(context)!.maximumRideFareError} ($currencySymbol ${highValue.toStringAsFixed(2)})',
                                                  maxLines: 3,
                                                  textAlign: TextAlign.center,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error),
                                                ),
                                                SizedBox(
                                                    height: size.width * 0.1),
                                                CustomButton(
                                                  width: size.width,
                                                  buttonName:
                                                      AppLocalizations.of(
                                                              context)!
                                                          .okText,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: context.read<BookingBloc>().isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.createRequest,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: size.width * 0.15),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPriceButton({
    required BuildContext context,
    required Size size,
    required IconData icon,
    required String label,
    required bool isDisabled,
    required bool isDecrease,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isDisabled
        ? Theme.of(context).disabledColor.withAlpha((0.15 * 255).toInt())
        : isDecrease
            ? AppColors.red
            : AppColors.green;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size.width * 0.14,
        // height: size.width * 0.15,
        padding: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled
              ? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200)
              : buttonColor.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDisabled
                ? Colors.transparent
                : buttonColor.withAlpha((0.3 * 255).toInt()),
            width: 1.2,
          ),
        ),
        //   padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDisabled
                  ? (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400)
                  : buttonColor,
              size: 16,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isDisabled
                        ? (isDarkMode
                            ? Colors.grey.shade600
                            : Colors.grey.shade400)
                        : buttonColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
