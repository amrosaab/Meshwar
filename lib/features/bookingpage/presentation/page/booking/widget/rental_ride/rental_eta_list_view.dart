// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/utils/custom_loader.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';
import '../bottom/apply_coupons_widget.dart';
import '../bottom/select_payment_widget.dart';
import '../bottom/select_preference_widget.dart';
import '../schedule_ride.dart';

class RentalEtaListViewWidget extends StatelessWidget {
  final BuildContext cont;
  final BookingPageArguments arg;
  final dynamic thisValue;

  const RentalEtaListViewWidget(
      {super.key, required this.cont, required this.arg, this.thisValue});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.width * 0.02),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 4,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: AppLocalizations.of(context)!.selectedPackage,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                          InkWell(
                            onTap: () {
                              context
                                  .read<BookingBloc>()
                                  .add(ShowRentalPackageListEvent());
                            },
                            child: MyText(
                              text: AppLocalizations.of(context)!.edit,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.width * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.025,
                          vertical: size.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary.withAlpha((0.1 * 255).toInt()),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: MyText(
                            text: context
                                .read<BookingBloc>()
                                .rentalPackagesList[context
                                    .read<BookingBloc>()
                                    .selectedPackageIndex]
                                .packageName,
                            textStyle: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.rideDetails,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                    ),
                    if (arg.userData.showRideLaterFeature)
                      _ScheduleRideButton(
                        bookingBloc: context.read<BookingBloc>(),
                        context: context,
                        size: size,
                        arg: arg,
                      ),
                  ],
                ),
                SizedBox(height: size.width * 0.02),
                RawScrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: context.read<BookingBloc>().etaScrollController,
                    padding: EdgeInsets.zero,
                    physics: context.read<BookingBloc>().enableEtaScrolling
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemCount:
                        context.read<BookingBloc>().rentalEtaDetailsList.length,
                    itemBuilder: (context, index) {
                      final eta = context
                          .read<BookingBloc>()
                          .rentalEtaDetailsList
                          .elementAt(index);
                      return _RentalEtaVehicleCard(
                        eta: eta,
                        index: index,
                        bookingBloc: context.read<BookingBloc>(),
                        thisValue: thisValue,
                        size: size,
                        context: context,
                      );
                    },
                  ),
                ),

                // Payment Method
                if (context.read<BookingBloc>().transportType == 'taxi')
                  _PaymentMethodTile(
                    bookingBloc: context.read<BookingBloc>(),
                    context: context,
                    size: size,
                  ),
                // Preferences
                _PreferencesTile(
                  bookingBloc: context.read<BookingBloc>(),
                  context: context,
                  size: size,
                  arg: arg,
                ),
                // Coupon
                if (arg.isOutstationRide == false &&
                    arg.isBiddingRide == false) ...[
                  if (context.read<BookingBloc>().transportType == 'taxi') ...[
                    Builder(builder: (context) {
                      final disableCoupons =
                          context.read<BookingBloc>().showBiddingVehicles;
                      return InkWell(
                        onTap: disableCoupons
                            ? null
                            : () {
                                context.read<BookingBloc>().promoErrorText = '';
                                context.read<BookingBloc>().add(UpdateEvent());
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  barrierColor: Theme.of(context).shadowColor,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0),
                                    ),
                                  ),
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: context.read<BookingBloc>()
                                        ..add(GetPromoCodeListEvent()),
                                      child: ApplyCouponWidget(
                                        arg: arg,
                                        cont: context,
                                      ),
                                    );
                                  },
                                );
                              },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            bottom: size.width * 0.025,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(size.width * 0.04),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .shadowColor
                                      .withAlpha((0.1 * 255).toInt()),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(size.width * 0.025),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellowColor
                                        .withAlpha((0.15 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.asset(
                                    AppImages.ticketImage,
                                    width: size.width * 0.05,
                                    color:
                                        const Color.fromARGB(255, 255, 196, 0),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)!.coupon,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: size.width * 0.04,
                                  color: AppColors.hintColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ]
                ],

                // Instructions
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      controller:
                          context.read<BookingBloc>().instructionsController,
                      borderRadius: 16,
                      filled: true,
                      // fillColor: Theme.of(context).cardColor,
                      hintText:
                          '${AppLocalizations.of(context)!.instructions} (${AppLocalizations.of(context)!.optional})',
                      maxLine: 3,
                      keyboardType: TextInputType.text,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.width * 0.035,
                      ),
                      onChange: (p0) {
                        context.read<BookingBloc>().add(UpdateEvent());
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.05,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScheduleRideButton extends StatelessWidget {
  final BookingBloc bookingBloc;
  final BuildContext context;
  final Size size;
  final BookingPageArguments arg;

  const _ScheduleRideButton({
    required this.bookingBloc,
    required this.context,
    required this.size,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: false,
          enableDrag: false,
          isDismissible: false,
          barrierColor: Theme.of(context).shadowColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          builder: (_) {
            return BlocProvider.value(
              value: context.read<BookingBloc>(),
              child: ScheduleRideWidget(
                arg: arg,
                size: size,
                isReturnTime: false,
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.width * 0.015,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).hintColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              bookingBloc.showDateTime.isEmpty
                  ? Icons.calendar_today_outlined
                  : Icons.access_time,
              color: Theme.of(context).primaryColorDark,
              size: size.width * 0.04,
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              bookingBloc.showDateTime.isEmpty
                  ? AppLocalizations.of(context)!.now
                  : bookingBloc.showDateTime,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RentalEtaVehicleCard extends StatelessWidget {
  final dynamic eta;
  final int index;
  final BookingBloc bookingBloc;
  final dynamic thisValue;
  final Size size;
  final BuildContext context;

  const _RentalEtaVehicleCard({
    required this.eta,
    required this.index,
    required this.bookingBloc,
    required this.thisValue,
    required this.size,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final isRecommended = index == 0;

    return Padding(
      padding: EdgeInsets.only(bottom: size.width * 0.03),
      child: InkWell(
        onTap: () {
          bookingBloc.add(BookingEtaSelectEvent(
            selectedVehicleIndex: index,
            isOutstationRide: bookingBloc.isOutstationRide,
          ));
          final selectedSize = bookingBloc.dropAddressList.length == 1
              ? bookingBloc.currentSize
              : bookingBloc.dropAddressList.length == 2
                  ? bookingBloc.currentSizeTwo
                  : bookingBloc.currentSizeThree;
          bookingBloc.updateScrollHeight(selectedSize);
          bookingBloc.scrollToBottomFunction(
            context.read<BookingBloc>().dropAddressList.length,
          );
          bookingBloc.etaScrollController.jumpTo(selectedSize);
          bookingBloc.checkNearByEta(bookingBloc.nearByDriversData, thisValue);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withAlpha((0.02 * 255).toInt()),
                Theme.of(context).primaryColor.withAlpha((0.04 * 255).toInt())
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: isRecommended
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.035),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// VEHICLE IMAGE
                Container(
                  height: size.width * 0.15,
                  width: size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: eta.icon,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          const Center(child: Loader()),
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
                  ),
                ),

                SizedBox(width: size.width * 0.035),

                /// VEHICLE DETAILS
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME + SAVE BADGE
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              eta.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.width * 0.025),

                      /// CAPACITY + ETA + INFO
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Capacity
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withAlpha((0.2 * 255).toInt()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                (bookingBloc.transportType != 'delivery')
                                    ? Icon(
                                        Icons.people_outline,
                                        size: size.width * 0.035,
                                        color: AppColors.hintColor,
                                      )
                                    : Image.asset(
                                        AppImages.deliveryCapacity,
                                        color: AppColors.hintColor,
                                        height: 12,
                                        width: 12,
                                      ),
                                SizedBox(width: size.width * 0.01),
                                Text(
                                  '${eta.capacity}',
                                  style: const TextStyle(
                                    color: AppColors.hintColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: size.width * 0.03),

                          /// ETA
                          Icon(
                            Icons.access_time,
                            color: Theme.of(context).primaryColor,
                            size: size.width * 0.04,
                          ),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            _getDuration(),
                            style: const TextStyle(
                              color: AppColors.hintColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          /// INFO ICON (Proper Right Alignment)
                          InkWell(
                            onTap: () {
                              bookingBloc.add(
                                ShowEtaInfoEvent(infoIndex: index),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.02),
                              child: Icon(
                                Icons.info_outline,
                                color: AppColors.hintColor,
                                size: size.width * 0.045,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: size.width * 0.03),

                /// PRICE SECTION
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            text:
                                '${eta.currency.toString()} ${eta.fareAmount.toStringAsFixed(2)}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: (eta.hasDiscount &&
                                            !context
                                                .read<BookingBloc>()
                                                .showBiddingVehicles)
                                        ? 14
                                        : 16,
                                    fontWeight: (eta.hasDiscount &&
                                            !context
                                                .read<BookingBloc>()
                                                .showBiddingVehicles)
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    color: (eta.hasDiscount &&
                                            !context
                                                .read<BookingBloc>()
                                                .showBiddingVehicles)
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).primaryColorDark,
                                    decoration: (eta.hasDiscount &&
                                            !context
                                                .read<BookingBloc>()
                                                .showBiddingVehicles)
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor:
                                        Theme.of(context).primaryColorDark,
                                    decorationThickness: 2),
                          ),
                          if (eta.hasDiscount &&
                              !context.read<BookingBloc>().showBiddingVehicles)
                            MyText(
                              text:
                                  '${eta.currency.toString()} ${eta.discountedTotel.toStringAsFixed(2)}',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDuration() {
    if (bookingBloc.nearByEtaVechileList.isNotEmpty) {
      final item = bookingBloc.nearByEtaVechileList
          .where(
            (element) => element.typeId == eta.typeId,
          )
          .toList();
      if (item.isNotEmpty && item.first.duration.isNotEmpty) {
        return item.first.duration;
      }
    }
    return '--';
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final BookingBloc bookingBloc;
  final BuildContext context;
  final Size size;

  const _PaymentMethodTile({
    required this.bookingBloc,
    required this.context,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isInsufficientBalance = bookingBloc.selectedPaymentType == 'wallet' &&
        bookingBloc.userData!.wallet.data.amountBalance <
            bookingBloc.selectedEtaAmount;

    return Padding(
      padding: EdgeInsets.only(
        left: size.width * 0.05,
        right: size.width * 0.05,
        bottom: size.width * 0.025,
        top: size.width * 0.03,
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              barrierColor: Theme.of(context).shadowColor,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              builder: (_) {
                return SelectPaymentMethodWidget(cont: context);
              });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .shadowColor
                    .withAlpha((0.1 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.025),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  bookingBloc.isSavedCardChoose
                      ? Icons.credit_card_rounded
                      : bookingBloc.selectedPaymentType == 'cash'
                          ? Icons.payments_outlined
                          : bookingBloc.selectedPaymentType == 'card'
                              ? Icons.credit_card_rounded
                              : Icons.account_balance_wallet_outlined,
                  size: size.width * 0.05,
                  color:
                      isInsufficientBalance ? AppColors.red : AppColors.primary,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.paymentMethod,
                      style: const TextStyle(
                        color: AppColors.hintColor,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: size.width * 0.005),
                    Text(
                      bookingBloc.isSavedCardChoose
                          ? 'Card'
                          : bookingBloc.selectedPaymentType == 'cash'
                              ? AppLocalizations.of(context)!.cash
                              : bookingBloc.selectedPaymentType == 'wallet'
                                  ? AppLocalizations.of(context)!.wallet
                                  : bookingBloc.selectedPaymentType,
                      style: TextStyle(
                        color: isInsufficientBalance ? AppColors.red : null,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: size.width * 0.04,
                color: AppColors.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferencesTile extends StatelessWidget {
  final BookingBloc bookingBloc;
  final BuildContext context;
  final Size size;
  final BookingPageArguments arg;

  const _PreferencesTile({
    required this.bookingBloc,
    required this.context,
    required this.size,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    final hasPreferences =
        bookingBloc.rentalPreferenceDetailsList?.isNotEmpty ?? false;
    final hasSelectedPreferences =
        bookingBloc.selectedPreferenceDetailsList.isNotEmpty;

    return InkWell(
      onTap: () {
        if (bookingBloc.rentalPreferenceDetailsList?.isNotEmpty ?? false) {
          bookingBloc.add(UpdateEvent());
          showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            enableDrag: false,
            isDismissible: false,
            barrierColor: Theme.of(context).shadowColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            builder: (_) {
              return SelectPreferenceWidget(
                cont: context,
                arg: arg,
              );
            },
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: size.width * 0.025,
        ),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .shadowColor
                    .withAlpha((0.1 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.025),
                decoration: BoxDecoration(
                  color: hasSelectedPreferences
                      ? AppColors.primary.withAlpha((0.1 * 255).toInt())
                      : AppColors.borderColor.withAlpha((0.5 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tune,
                  size: size.width * 0.05,
                  color: hasSelectedPreferences
                      ? AppColors.primary
                      : AppColors.greyHeader,
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.preferences,
                      style: TextStyle(
                        color: hasPreferences ? null : AppColors.greyHeader,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (hasSelectedPreferences && hasPreferences) ...[
                      SizedBox(height: size.width * 0.005),
                      Text(
                        '${bookingBloc.selectedPreferenceDetailsList.length} selected',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: size.width * 0.04,
                color: AppColors.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
