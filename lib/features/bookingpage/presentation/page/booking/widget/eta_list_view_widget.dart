// ignore_for_file: unused_element, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';
import 'bottom/apply_coupons_widget.dart';
import 'bottom/select_payment_widget.dart';
import 'bottom/select_preference_widget.dart';
import 'schedule_ride.dart';

class EtaListViewWidget extends StatelessWidget {
  final BuildContext cont;
  final BookingPageArguments arg;
  final dynamic thisValue;

  const EtaListViewWidget({
    super.key,
    required this.cont,
    required this.arg,
    this.thisValue,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: cont.read<BookingBloc>(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (arg.isWithoutDestinationRide != null &&
                  arg.isWithoutDestinationRide!)
                SizedBox(height: size.width * 0.04),
              // Outstation Trip Type Selection
              if (bookingBloc.isOutstationRide) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: size.width * 0.025),
                      Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withAlpha((0.05 * 255).toInt()),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(size.width * 0.0125),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _TripTypeCard(
                                title: AppLocalizations.of(context)!.oneWayTrip,
                                subtitle:
                                    AppLocalizations.of(context)!.getDropOff,
                                isSelected: !bookingBloc.isRoundTrip,
                                onTap: () {
                                  bookingBloc.isRoundTrip = false;
                                  bookingBloc.showReturnDateTime = '';
                                  bookingBloc.scheduleDateTimeForReturn = '';
                                  bookingBloc.add(UpdateEvent());
                                },
                                showCheck: !bookingBloc.isRoundTrip &&
                                    arg.userData
                                            .enableOutstationRoundTripFeature ==
                                        '1',
                                size: size,
                                context: context,
                              ),
                            ),
                            if (arg.userData.enableOutstationRoundTripFeature ==
                                '1') ...[
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: _TripTypeCard(
                                  title:
                                      AppLocalizations.of(context)!.roundTrip,
                                  subtitle: AppLocalizations.of(context)!
                                      .keepTheCarTillReturn,
                                  isSelected: bookingBloc.isRoundTrip,
                                  onTap: () {
                                    bookingBloc.isRoundTrip = true;
                                    bookingBloc.add(UpdateEvent());
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: false,
                                      enableDrag: false,
                                      isDismissible: false,
                                      barrierColor:
                                          Theme.of(context).shadowColor,
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      builder: (_) {
                                        return BlocProvider.value(
                                          value: context.read<BookingBloc>(),
                                          child: ScheduleRideWidget(
                                            arg: arg,
                                            size: size,
                                            isReturnTime: true,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  showCheck: bookingBloc.isRoundTrip,
                                  size: size,
                                  context: context,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(size.width * 0.035),
                        child: Column(
                          children: [
                            _DateTimeRow(
                              label:
                                  '${AppLocalizations.of(context)!.leaveOn} : ',
                              value: bookingBloc.showDateTime,
                              icon: Icons.calendar_today_outlined,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: false,
                                  enableDrag: false,
                                  isDismissible: true,
                                  barrierColor: Theme.of(context).shadowColor,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                              size: size,
                              context: context,
                            ),
                            if (bookingBloc.isRoundTrip) ...[
                              SizedBox(height: size.width * 0.025),
                              const Divider(),
                              SizedBox(height: size.width * 0.025),
                              _DateTimeRow(
                                label:
                                    '${AppLocalizations.of(context)!.returnBy} : ',
                                value: bookingBloc.showReturnDateTime,
                                icon: Icons.calendar_today_outlined,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: false,
                                    enableDrag: false,
                                    isDismissible: false,
                                    barrierColor: Theme.of(context).shadowColor,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.read<BookingBloc>(),
                                        child: ScheduleRideWidget(
                                          arg: arg,
                                          size: size,
                                          isReturnTime: true,
                                        ),
                                      );
                                    },
                                  );
                                },
                                size: size,
                                context: context,
                                showSelectDate:
                                    bookingBloc.showReturnDateTime.isEmpty,
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: size.width * 0.0),
                    ],
                  ),
                ),
              ],
              SizedBox(height: size.width * 0.03),
              // Ride Details Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.rideDetails,
                      textStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                    ),
                    if (bookingBloc.showSharedRide)
                      _SeatSelector(
                        bookingBloc: bookingBloc,
                        arg: arg,
                        context: context,
                        size: size,
                      ),
                    if ((!bookingBloc.showBiddingVehicles ||
                            !bookingBloc.isMultiTypeVechiles) &&
                        !bookingBloc.showSharedRide &&
                        arg.userData.showRideLaterFeature)
                      _ScheduleRideButton(
                        bookingBloc: bookingBloc,
                        context: context,
                        size: size,
                        arg: arg,
                      ),
                  ],
                ),
              ),
              SizedBox(height: size.width * 0.02),
              // ETA List
              ((bookingBloc.isEtaFilter && !bookingBloc.filterSuccess) ||
                      ((bookingBloc.isMultiTypeVechiles &&
                              bookingBloc.sortedEtaDetailsList.isEmpty) ||
                          bookingBloc.etaDetailsList.isEmpty))
                  ? SizedBox(
                      height: size.height * 0.49,
                      child: Center(child: Image.asset(AppImages.noDataFound)),
                    )
                  : RawScrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: bookingBloc.etaScrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: () {
                          final baseList = bookingBloc.isMultiTypeVechiles
                              ? bookingBloc.sortedEtaDetailsList
                              : bookingBloc.etaDetailsList;
                          return baseList.length;
                        }(),
                        itemBuilder: (context, index) {
                          final baseList = bookingBloc.isMultiTypeVechiles
                              ? bookingBloc.sortedEtaDetailsList
                              : bookingBloc.etaDetailsList;
                          final eta = baseList.elementAt(index);
                          final originalIndex = baseList.indexOf(eta);
                          return _EtaVehicleCard(
                            eta: eta,
                            index: index,
                            bookingBloc: bookingBloc,
                            originalIndex: originalIndex,
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
                  bookingBloc: bookingBloc,
                  context: context,
                  size: size,
                ),
              // Preferences
              _PreferencesTile(
                bookingBloc: bookingBloc,
                context: context,
                size: size,
                arg: arg,
              ),
              // Coupon
              if (arg.isOutstationRide == false &&
                  arg.isBiddingRide == false) ...[
                if (context.read<BookingBloc>().transportType == 'taxi') ...[
                  Builder(builder: (context) {
                    final disableCoupons = bookingBloc.showBiddingVehicles;
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
                          padding: EdgeInsets.all(size.width * 0.035),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.105,
                                height: size.width * 0.105,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFFD76A),
                                      Color(0xFFF0A93A),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(13),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFF0A93A)
                                          .withValues(alpha: 0.32),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  AppImages.ticketImage,
                                  width: size.width * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.coupon,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: size.width * 0.035,
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
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CustomTextField(
                    controller:
                        context.read<BookingBloc>().instructionsController,
                    borderRadius: 14,
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
          );
        },
      ),
    );
  }
}

// Helper Widgets for UI Enhancements

class _RideTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String languageCode;
  final Size size;

  const _RideTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.languageCode,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isLongLanguage = languageCode == 'fr' ||
        languageCode == 'az' ||
        languageCode == 'es' ||
        languageCode == 'sq';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.width * 0.018,
          horizontal: size.width * 0.01,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isLongLanguage ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _TripTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showCheck;
  final Size size;
  final BuildContext context;

  const _TripTypeCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.showCheck,
    required this.size,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(size.width * 0.025),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showCheck)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.white,
                    size: size.width * 0.05,
                  ),
              ],
            ),
            SizedBox(height: size.width * 0.01),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected
                    ? AppColors.white.withAlpha((0.8 * 255).toInt())
                    : AppColors.hintColor,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final Size size;
  final BuildContext context;
  final bool showSelectDate;

  const _DateTimeRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    required this.size,
    required this.context,
    this.showSelectDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: size.width * 0.05),
              SizedBox(width: size.width * 0.02),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.hintColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (value.isNotEmpty)
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                Icon(
                  Icons.edit,
                  size: size.width * 0.05,
                  color: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
          if (value.isEmpty || showSelectDate)
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.selectDate,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                Icon(
                  Icons.arrow_forward_ios,
                  size: size.width * 0.04,
                  color: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SeatSelector extends StatelessWidget {
  final BookingBloc bookingBloc;
  final BookingPageArguments arg;
  final BuildContext context;
  final Size size;

  const _SeatSelector({
    required this.bookingBloc,
    required this.arg,
    required this.context,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: false,
          enableDrag: true,
          isDismissible: true,
          barrierColor: Theme.of(context).shadowColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          builder: (ctx) {
            return BlocProvider.value(
              value: context.read<BookingBloc>(),
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  final b = context.read<BookingBloc>();
                  int tempSelectedSeats = b.selectedSharedSeats;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.borderColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.width * 0.04),
                              MyText(
                                text: AppLocalizations.of(context)!.selectSeats,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: size.width * 0.04),
                              Builder(
                                builder: (context) {
                                  final selectedVehicle = b.isMultiTypeVechiles
                                      ? (b.sortedEtaDetailsList.isNotEmpty
                                          ? b.sortedEtaDetailsList[
                                              b.selectedVehicleIndex]
                                          : null)
                                      : (b.etaDetailsList.isNotEmpty
                                          ? b.etaDetailsList[
                                              b.selectedVehicleIndex]
                                          : null);

                                  final maxCapacity =
                                      (selectedVehicle?.capacity ?? 10)
                                          .toDouble();
                                  final divisions = (maxCapacity - 1).toInt();

                                  tempSelectedSeats =
                                      tempSelectedSeats > maxCapacity.toInt()
                                          ? maxCapacity.toInt()
                                          : tempSelectedSeats;

                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: List.generate(
                                          maxCapacity.toInt(),
                                          (index) => Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Slider(
                                        value: tempSelectedSeats.toDouble(),
                                        min: 1.0,
                                        max: maxCapacity,
                                        divisions:
                                            divisions > 0 ? divisions : 1,
                                        label: '$tempSelectedSeats',
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        onChanged: (val) {
                                          setState(() {
                                            tempSelectedSeats = val.round();
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: size.width * 0.04),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    b.add(SelectSharedSeatsEvent(
                                        seats: tempSelectedSeats));
                                    final baseBloc =
                                        context.read<BookingBloc>();
                                    baseBloc.add(BookingEtaRequestEvent(
                                      picklat: arg.picklat,
                                      picklng: arg.picklng,
                                      droplat: arg.droplat,
                                      droplng: arg.droplng,
                                      ridetype: 1,
                                      transporttype: arg.transportType,
                                      distance: baseBloc.distance,
                                      duration: baseBloc.duration,
                                      polyLine: baseBloc.polyLine,
                                      pickupAddressList: arg.pickupAddressList,
                                      dropAddressList: arg.stopAddressList,
                                      isOutstationRide: arg.isOutstationRide,
                                      isWithoutDestinationRide:
                                          arg.isWithoutDestinationRide ?? false,
                                      preferenceId: baseBloc
                                              .selectedPreferenceDetailsList
                                              .isNotEmpty
                                          ? baseBloc
                                              .selectedPreferenceDetailsList
                                          : null,
                                      sharedRide: 1,
                                      seatsTaken: tempSelectedSeats,
                                    ));
                                    Navigator.pop(ctx);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.width * 0.04),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.confirm,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
          color: AppColors.primary.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.airline_seat_recline_normal,
              color: AppColors.primary,
              size: size.width * 0.04,
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              '${AppLocalizations.of(context)!.selectSeats}: ${bookingBloc.selectedSharedSeats}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
          horizontal: size.width * 0.032,
          vertical: size.width * 0.017,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppColors.beaconGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.meshwarRed.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              bookingBloc.showDateTime.isEmpty
                  ? Icons.calendar_today_outlined
                  : Icons.access_time,
              color: Colors.white,
              size: size.width * 0.04,
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              bookingBloc.showDateTime.isEmpty
                  ? AppLocalizations.of(context)!.now
                  : bookingBloc.showDateTime,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtaVehicleCard extends StatelessWidget {
  final dynamic eta;
  final int index;
  final BookingBloc bookingBloc;
  final int originalIndex;
  final dynamic thisValue;
  final Size size;
  final BuildContext context;

  const _EtaVehicleCard({
    required this.eta,
    required this.index,
    required this.bookingBloc,
    required this.originalIndex,
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
            selectedTypeEta: bookingBloc.showSharedRide ? 'Shared' : '',
            selectedVehicleIndex: originalIndex,
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
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: isRecommended
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: isRecommended ? 22 : 16,
                spreadRadius: isRecommended ? -2 : 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.035),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// VEHICLE IMAGE — a gradient badge with a tinted car-icon
                /// placeholder instead of a blank/black box while loading
                /// or if the vehicle icon URL fails.
                Container(
                  height: size.width * 0.14,
                  width: size.width * 0.14,
                  decoration: BoxDecoration(
                    gradient: AppColors.beaconGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.meshwarRed.withValues(alpha: 0.32),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    // CachedNetworkImage's errorWidget doesn't reliably
                    // fire for an empty/null URL (a common state before
                    // the vehicle icon has loaded from the backend), so
                    // that case is handled explicitly here instead of
                    // relying on errorWidget alone.
                    child: (eta.vehicleIcon == null ||
                            (eta.vehicleIcon as String).isEmpty)
                        ? Center(
                            child: Icon(
                              Icons.directions_car_filled_rounded,
                              color: Colors.white,
                              size: size.width * 0.065,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: eta.vehicleIcon,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(
                              child: Icon(
                                Icons.directions_car_filled_rounded,
                                color: Colors.white.withValues(alpha: 0.6),
                                size: size.width * 0.065,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.directions_car_filled_rounded,
                                color: Colors.white,
                                size: size.width * 0.065,
                              ),
                            ),
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
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
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
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.015),
                            child: const Text(
                              '·',
                              style: TextStyle(
                                color: AppColors.hintColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          /// ETA
                          Icon(
                            Icons.access_time,
                            color: Theme.of(context).primaryColor,
                            size: size.width * 0.035,
                          ),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            _getDuration(),
                            style: const TextStyle(
                              color: AppColors.hintColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Spacer(),

                          /// INFO ICON (Proper Right Alignment)
                          InkWell(
                            onTap: () {
                              bookingBloc.add(
                                ShowEtaInfoEvent(infoIndex: originalIndex),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.02),
                              child: Icon(
                                Icons.info_outline,
                                color: AppColors.hintColor,
                                size: size.width * 0.04,
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
                    if (eta.hasDiscount &&
                        !bookingBloc.showBiddingVehicles) ...[
                      Text(
                        '${eta.currency}${eta.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).hintColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(height: size.width * 0.01),
                    ],
                    Text(
                      bookingBloc.isRoundTrip
                          ? '${eta.currency}${eta.pricePerDistance.toStringAsFixed(2)}'
                          : '${eta.currency}${(eta.hasDiscount && !bookingBloc.showBiddingVehicles) ? eta.discountTotal.toStringAsFixed(2) : eta.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: (eta.hasDiscount &&
                                !bookingBloc.showBiddingVehicles)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorDark,
                      ),
                    ),
                    if (bookingBloc.isRoundTrip)
                      Padding(
                        padding: EdgeInsets.only(top: size.width * 0.005),
                        child: Text(
                          '/${eta.unitInWords}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.hintColor,
                          ),
                        ),
                      ),
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(size.width * 0.035),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: size.width * 0.105,
                height: size.width * 0.105,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isInsufficientBalance
                        ? [
                            const Color(0xFFF0546F),
                            AppColors.meshwarRed,
                          ]
                        : const [
                            Color(0xFFFFB84D),
                            Color(0xFFE6862A),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: (isInsufficientBalance
                              ? AppColors.meshwarRed
                              : const Color(0xFFE6862A))
                          .withValues(alpha: 0.32),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  bookingBloc.isSavedCardChoose
                      ? Icons.credit_card_rounded
                      : bookingBloc.selectedPaymentType == 'cash'
                          ? Icons.payments_outlined
                          : bookingBloc.selectedPaymentType == 'card'
                              ? Icons.credit_card_rounded
                              : Icons.account_balance_wallet_outlined,
                  size: size.width * 0.045,
                  color: Colors.white,
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
                        fontSize: 11,
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
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: size.width * 0.035,
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
        bookingBloc.preferenceDetailsList?.isNotEmpty ?? false;
    final hasSelectedPreferences =
        bookingBloc.selectedPreferenceDetailsList.isNotEmpty;

    return InkWell(
      onTap: () {
        if (bookingBloc.preferenceDetailsList?.isNotEmpty ?? false) {
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
          padding: EdgeInsets.all(size.width * 0.035),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: size.width * 0.105,
                height: size.width * 0.105,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6BA7F5),
                      Color(0xFF3A72D4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3A72D4).withValues(alpha: 0.32),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.tune,
                  size: size.width * 0.045,
                  color: Colors.white,
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
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    if (hasSelectedPreferences && hasPreferences) ...[
                      SizedBox(height: size.width * 0.005),
                      Text(
                        AppLocalizations.of(context)!.selected.replaceAll('111',
                            '${bookingBloc.selectedPreferenceDetailsList.length}'),
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
                size: size.width * 0.035,
                color: AppColors.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CouponTile extends StatelessWidget {
  final BuildContext context;
  final Size size;
  final BookingPageArguments arg;

  const _CouponTile({
    required this.context,
    required this.size,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: size.width * 0.05,
        right: size.width * 0.05,
        bottom: size.width * 0.025,
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            enableDrag: true,
            isDismissible: true,
            barrierColor: Theme.of(context).shadowColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            builder: (sheetContext) {
              return ApplyCouponWidget(cont: sheetContext, arg: arg);
            },
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.all(size.width * 0.035),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.yellowColor.withAlpha((0.15 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  AppImages.ticketImage,
                  width: size.width * 0.045,
                  color: const Color.fromARGB(255, 255, 196, 0),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.coupon,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: size.width * 0.035,
                color: AppColors.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPreferenceButton extends StatelessWidget {
  final Size size;
  final BookingPageArguments arg;

  const _AddPreferenceButton({
    required this.size,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size.width * 0.01),
      child: InkWell(
        onTap: () {
          final bookingBloc = context.read<BookingBloc>();
          final userData = bookingBloc.userData;
          final canSelectPreference = bookingBloc.transportType == 'taxi' &&
              userData != null &&
              (userData.enablePetPreferenceForUser == '1' ||
                  userData.enableLuggagePreferenceForUser == '1');

          if (canSelectPreference) {
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
        child: MyText(text: AppLocalizations.of(context)!.addPrefrence),
      ),
    );
  }
}
