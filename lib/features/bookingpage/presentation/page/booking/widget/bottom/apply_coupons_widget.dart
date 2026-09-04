// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/utils/custom_button.dart';
import '../../../../../../../core/utils/custom_text.dart';
import '../../../../../../../core/utils/custom_textfield.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';

class ApplyCouponWidget extends StatelessWidget {
  final BuildContext cont;
  final BookingPageArguments arg;
  const ApplyCouponWidget({
    super.key,
    required this.arg,
    required this.cont,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccessState) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final bookingBloc = context.read<BookingBloc>();
          return SafeArea(
            child: SizedBox(
              height: size.height * 0.9,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.05,
                        size.width * 0.05,
                        size.width * 0.05,
                        size.width * 0.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.applyCoupon,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.05,
                        right: size.width * 0.05,
                        top: size.width * 0.05),
                    child: Row(
                      children: [
                        MyText(
                          text: AppLocalizations.of(context)!.applyCouponText,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: AppColors.hintColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.width * 0.025),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.04, right: size.width * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: CustomTextField(
                            onTap: () {},
                            readOnly: (!context.read<BookingBloc>().isRentalRide &&
                                        (context.read<BookingBloc>().isMultiTypeVechiles
                                            ? (context.read<BookingBloc>().sortedEtaDetailsList.isNotEmpty &&
                                                    context.read<BookingBloc>().selectedVehicleIndex <
                                                        context
                                                            .read<BookingBloc>()
                                                            .sortedEtaDetailsList
                                                            .length
                                                ? context
                                                    .read<BookingBloc>()
                                                    .sortedEtaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                    .hasDiscount
                                                : false)
                                            : (context.read<BookingBloc>().etaDetailsList.isNotEmpty &&
                                                    context.read<BookingBloc>().selectedVehicleIndex <
                                                        context
                                                            .read<BookingBloc>()
                                                            .etaDetailsList
                                                            .length
                                                ? context
                                                    .read<BookingBloc>()
                                                    .etaDetailsList[context
                                                        .read<BookingBloc>()
                                                        .selectedVehicleIndex]
                                                    .hasDiscount
                                                : false))) ||
                                    (context.read<BookingBloc>().isRentalRide &&
                                            context
                                                .read<BookingBloc>()
                                                .rentalEtaDetailsList
                                                .isNotEmpty &&
                                            context.read<BookingBloc>().selectedVehicleIndex <
                                                context
                                                    .read<BookingBloc>()
                                                    .rentalEtaDetailsList
                                                    .length
                                        ? context
                                            .read<BookingBloc>()
                                            .rentalEtaDetailsList[context.read<BookingBloc>().selectedVehicleIndex]
                                            .hasDiscount
                                        : false)
                                ? true
                                : false,
                            controller: context
                                .read<BookingBloc>()
                                .applyCouponController,
                            hintText:
                                AppLocalizations.of(context)!.enterCouponCode,
                            hintTextStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w500,
                                ),
                            onChange: (p0) {
                              context.read<BookingBloc>().promoErrorText = '';
                              context.read<BookingBloc>().add(UpdateEvent());
                            },
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.width * 0.035,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            focusedBorder: (context
                                    .read<BookingBloc>()
                                    .promoErrorText
                                    .isNotEmpty)
                                ? OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.red,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  )
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).hintColor,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                            enabledBorder: (context
                                    .read<BookingBloc>()
                                    .promoErrorText
                                    .isNotEmpty)
                                ? OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.red,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  )
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                            autofocus: false,
                            suffixConstraints:
                                BoxConstraints(maxWidth: size.width * 0.12),
                            suffixIcon: context
                                    .read<BookingBloc>()
                                    .applyCouponController
                                    .text
                                    .isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      context
                                          .read<BookingBloc>()
                                          .promoErrorText = '';
                                      context
                                          .read<BookingBloc>()
                                          .applyCouponController
                                          .clear();
                                      context
                                          .read<BookingBloc>()
                                          .add(UpdateEvent());
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          padding: const EdgeInsets.all(
                                              4), // 🔥 ADDED

                                          child: Icon(
                                            Icons.cancel_outlined,
                                            color: Theme.of(context).hintColor,
                                          )),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///  BODY SCROLL AREA
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ///  PROMO LIST
                            if (bookingBloc.promoCodeDataList.isNotEmpty)
                              SizedBox(
                                height: size.height * .35,
                                child: ListView.builder(
                                  itemCount:
                                      bookingBloc.promoCodeDataList.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        bookingBloc.promoCodeDataList[index];

                                    final bool isSelected = bookingBloc
                                            .applyCouponController
                                            .text
                                            .isNotEmpty
                                        ? (bookingBloc
                                                .applyCouponController.text ==
                                            item.code)
                                        : (item.isApplied == true);

                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        bookingBloc.applyCouponController.text =
                                            item.code;
                                        bookingBloc.promoErrorText = '';
                                        bookingBloc.add(UpdateEvent());
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 14),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.12)
                                              : Theme.of(context)
                                                  .dividerColor
                                                  .withOpacity(0.05),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(text: item.code),
                                                MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .saveUptoText
                                                      .replaceAll('111',
                                                          '${bookingBloc.userData!.wallet.data.currencySymbol}${item.maximumDiscountAmount.toString()}'),
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: size.width * 0.05,
                                              width: size.width * 0.05,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Container(
                                                width: size.width * 0.03,
                                                height: size.width * 0.03,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: context
                                                            .watch<
                                                                BookingBloc>()
                                                            .applyCouponController
                                                            .text
                                                            .isNotEmpty
                                                        ? ((context
                                                                    .watch<
                                                                        BookingBloc>()
                                                                    .applyCouponController
                                                                    .text ==
                                                                item.code)
                                                            ? Theme.of(context)
                                                                .primaryColorDark
                                                            : Colors
                                                                .transparent)
                                                        : ((item.isApplied ==
                                                                true)
                                                            ? Theme.of(context)
                                                                .primaryColorDark
                                                            : Colors
                                                                .transparent)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                            SizedBox(height: size.width * .03),

                            /// your textfield stays same
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (context.read<BookingBloc>().promoErrorText.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        child: MyText(
                            text: context.read<BookingBloc>().promoErrorText,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.red)),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.05, right: size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          width: size.width * 0.4,
                          buttonName: AppLocalizations.of(context)!.remove,
                          borderRadius: 5,
                          isBorder: true,
                          isLoader: context.read<BookingBloc>().isEtaLoading,
                          height: size.width * 0.1,
                          buttonColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          textColor: Theme.of(context).primaryColor,
                          onTap: () {
                            final bloc = context.read<BookingBloc>();

                            bloc.applyCouponController.clear();
                            bloc.detailView = false;

                            if (!bloc.isRentalRide) {
                              bloc.add(
                                BookingEtaRequestEvent(
                                  picklat: arg.picklat,
                                  picklng: arg.picklng,
                                  droplat: arg.droplat,
                                  droplng: arg.droplng,
                                  ridetype: 1,
                                  transporttype: arg.transportType,
                                  distance: bloc.distance,
                                  duration: bloc.duration,
                                  polyLine: bloc.polyLine,
                                  pickupAddressList: arg.pickupAddressList,
                                  dropAddressList: arg.stopAddressList,
                                  isOutstationRide: arg.isOutstationRide,
                                  isWithoutDestinationRide:
                                      arg.isWithoutDestinationRide ?? false,
                                  sharedRide:
                                      arg.isSharedRide == true ? 1 : null,
                                  seatsTaken: arg.isSharedRide == true
                                      ? bloc.selectedSharedSeats
                                      : null,
                                ),
                              );

                              // Navigator.pop(context);
                            } else {
                              bloc.add(
                                BookingRentalEtaRequestEvent(
                                  picklat: arg.picklat,
                                  picklng: arg.picklng,
                                  transporttype: arg.transportType,
                                  promocode: '',
                                ),
                              );
                            }
                          },
                        ),
                        CustomButton(
                          width: size.width * 0.4,
                          buttonName: AppLocalizations.of(context)!.apply,
                          isLoader: context.read<BookingBloc>().isEtaLoading,
                          onTap: () {
                            final bloc = context.read<BookingBloc>();

                            if (bloc.applyCouponController.text.isEmpty) {
                              bloc.promoErrorText =
                                  AppLocalizations.of(context)!
                                      .enterTheCredentials;
                              bloc.add(UpdateEvent());
                              return;
                            }

                            if (!bloc.isRentalRide) {
                              bloc.add(
                                BookingEtaRequestEvent(
                                  picklat: arg.picklat,
                                  picklng: arg.picklng,
                                  droplat: arg.droplat,
                                  droplng: arg.droplng,
                                  ridetype: 1,
                                  transporttype: arg.transportType,
                                  promocode: bloc.applyCouponController.text,
                                  vehicleId: (arg.transportType != 'taxi')
                                      ? bloc.isMultiTypeVechiles
                                          ? bloc
                                              .sortedEtaDetailsList[
                                                  bloc.selectedVehicleIndex]
                                              .zoneTypeId
                                          : bloc
                                              .etaDetailsList[
                                                  bloc.selectedVehicleIndex]
                                              .zoneTypeId
                                      : null,
                                  distance: bloc.distance,
                                  duration: bloc.duration,
                                  polyLine: bloc.polyLine,
                                  pickupAddressList: arg.pickupAddressList,
                                  dropAddressList: arg.stopAddressList,
                                  isOutstationRide: arg.isOutstationRide,
                                  isWithoutDestinationRide:
                                      arg.isWithoutDestinationRide ?? false,
                                  sharedRide:
                                      arg.isSharedRide == true ? 1 : null,
                                  seatsTaken: arg.isSharedRide == true
                                      ? bloc.selectedSharedSeats
                                      : null,
                                ),
                              );

                              // Navigator.pop(context);
                            } else {
                              bloc.add(
                                BookingRentalEtaRequestEvent(
                                  picklat: arg.picklat,
                                  picklng: arg.picklng,
                                  transporttype: arg.transportType,
                                  promocode: bloc.applyCouponController.text,
                                  preferenceId: bloc.selectPreference,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.width * 0.08),
                  SizedBox(height: size.width * 0.1)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
