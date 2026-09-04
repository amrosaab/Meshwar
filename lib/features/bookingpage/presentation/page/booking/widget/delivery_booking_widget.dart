import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/pickup_icon.dart';
import '../../../../../../core/utils/custom_divider.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';
import 'bottom/apply_coupons_widget.dart';
import 'bottom/select_payment_widget.dart';

class DeliveryBookingWidget extends StatelessWidget {
  final BuildContext cont;
  final dynamic eta;
  final BookingPageArguments arg;
  const DeliveryBookingWidget(
      {super.key, required this.cont, this.eta, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
        value: cont.read<BookingBloc>(),
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(-1, -2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      color: Theme.of(context).splashColor)
                ],
              ),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.width * 0.05),
                      const Center(child: CustomDivider()),
                      SizedBox(height: size.width * 0.06),
                      MyText(
                          text: arg.title,
                          textStyle: Theme.of(context).textTheme.displayMedium),
                      SizedBox(height: size.width * 0.06),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: AppColors.borderColor)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        itemCount: arg.pickupAddressList.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final address = arg.pickupAddressList
                                              .elementAt(index);
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withAlpha(
                                                      (0.1 * 255).toInt()),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                size.width *
                                                                    0.01),
                                                    child: const PickupIcon(),
                                                  ),
                                                  Expanded(
                                                    child: MyText(
                                                      text: address.address,
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                    SizedBox(height: size.width * 0.01),
                                    ListView.builder(
                                        itemCount: arg.stopAddressList.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final address = arg.stopAddressList
                                              .elementAt(index);
                                          return Container(
                                            margin: EdgeInsets.only(
                                                bottom: size.width * 0.01),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withAlpha(
                                                      (0.1 * 255).toInt()),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  size.width *
                                                                      0.005),
                                                      child: const DropIcon()),
                                                  Expanded(
                                                    child: MyText(
                                                      text: address.address,
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.width * 0.04),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: AppColors.borderColor)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: CachedNetworkImage(
                                                imageUrl: (context
                                                        .read<BookingBloc>()
                                                        .isRentalRide)
                                                    ? eta.icon
                                                    : eta.vehicleIcon,
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
                                            SizedBox(width: size.width * 0.04),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                MyText(
                                                  text: eta.name,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (context
                                                  .read<BookingBloc>()
                                                  .nearByEtaVechileList
                                                  .isNotEmpty)
                                                MyText(
                                                  text: context
                                                      .read<BookingBloc>()
                                                      .nearByEtaVechileList
                                                      .elementAt(context
                                                          .read<BookingBloc>()
                                                          .nearByEtaVechileList
                                                          .indexWhere(
                                                              (element) =>
                                                                  element
                                                                      .typeId ==
                                                                  eta.typeId))
                                                      .duration,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        context
                                            .read<BookingBloc>()
                                            .draggableScrollableController
                                            .animateTo(
                                                context
                                                    .read<BookingBloc>()
                                                    .draggableScrollableController
                                                    .size,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeIn);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight
                                                .withAlpha((0.2 * 255).toInt()),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                  Icons.info_outline_rounded,
                                                  size: 15),
                                              SizedBox(
                                                width: size.width * 0.01,
                                              ),
                                              SizedBox(
                                                width: size.width * 0.7,
                                                child: MyText(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .loadingUnloadingTimeInfo
                                                      .replaceAll('**',
                                                          '${(context.read<BookingBloc>().isRentalRide) ? (eta.freeMin) : (eta.freeWaitingTimeInMinsBeforeTripStart + eta.freeWaitingTimeInMinsAfterTripStart)}'),
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(fontSize: 10),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.width * 0.04),
                            if (!context.read<BookingBloc>().isRentalRide &&
                                !context
                                    .read<BookingBloc>()
                                    .showBiddingVehicles) ...[
                              InkWell(
                                onTap: () {
                                  final bookingBloc = context
                                      .read<BookingBloc>(); // Store reference
                                  bookingBloc.promoErrorText = '';
                                  bookingBloc.add(UpdateEvent());
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    barrierColor: Theme.of(context).shadowColor,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0),
                                      ),
                                    ),
                                    builder: (sheetContext) {
                                      return BlocProvider.value(
                                        value: bookingBloc,
                                        child: ApplyCouponWidget(
                                          arg: arg,
                                          cont: sheetContext,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.borderColor)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.percent_rounded,
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                            MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .applyCoupon,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColorDark),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            if (eta.hasDiscount)
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .remove,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: AppColors.red),
                                              ),
                                            if (!eta.hasDiscount)
                                              const Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 20)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.width * 0.04),
                            ],
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: AppColors.borderColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyText(
                                          text: AppLocalizations.of(context)!
                                              .tripFare,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                        ),
                                        MyText(
                                          text: AppLocalizations.of(context)!
                                              .amountPayable,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MyText(
                                            text:
                                                '${eta.currency} ${!context.read<BookingBloc>().isRentalRide ? eta.hasDiscount ? eta.discountTotal : eta.total.toStringAsFixed(1) : eta.hasDiscount ? eta.discountedTotel : eta.fareAmount}',
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (eta.enableGoodsType == true) ...[
                              SizedBox(height: size.width * 0.04),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.borderColor)),
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<BookingBloc>()
                                        .add(GetGoodsTypeEvent());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .goodsType,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .disabledColor),
                                              ),
                                              Wrap(
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.6,
                                                    child: MyText(
                                                      text: (context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .selectedGoodsTypeId ==
                                                              0)
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .selectGoodsType
                                                          : '${context.read<BookingBloc>().goodsTypeList.firstWhere((element) => element.id == context.read<BookingBloc>().selectedGoodsTypeId).goodsTypeName} ',
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium!,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  if (context
                                                          .read<BookingBloc>()
                                                          .goodsTypeQtyOrLoose ==
                                                      'Qty')
                                                    MyText(
                                                        text:
                                                            '| ${context.read<BookingBloc>().goodsQtyController.text}',
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium!),
                                                  if (context
                                                              .read<
                                                                  BookingBloc>()
                                                              .selectedGoodsTypeId !=
                                                          0 &&
                                                      context
                                                              .read<
                                                                  BookingBloc>()
                                                              .goodsTypeQtyOrLoose !=
                                                          'Qty')
                                                    MyText(
                                                        text:
                                                            '| ${AppLocalizations.of(context)!.loose}',
                                                        textStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium!),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        MyText(
                                            text: (context
                                                        .read<BookingBloc>()
                                                        .selectedGoodsTypeId !=
                                                    0)
                                                ? AppLocalizations.of(context)!
                                                    .changeLower
                                                : AppLocalizations.of(context)!
                                                    .select,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontWeight:
                                                        FontWeight.w600))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (!context.read<BookingBloc>().isRentalRide) ...[
                              SizedBox(height: size.width * 0.04),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors.borderColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .payment,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                          ),
                                          MyText(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .payAt,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if ((arg.title == 'Send Parcel') ||
                                              (arg.title == 'Receive Parcel' &&
                                                  arg.stopAddressList.length ==
                                                      1))
                                            InkWell(
                                              onTap: () {
                                                if (context
                                                            .read<BookingBloc>()
                                                            .transportType ==
                                                        'delivery' &&
                                                    arg.title ==
                                                        'Send Parcel') {
                                                  context
                                                      .read<BookingBloc>()
                                                      .showPaymentChange = true;
                                                } else {
                                                  context
                                                          .read<BookingBloc>()
                                                          .showPaymentChange =
                                                      false;
                                                  context
                                                          .read<BookingBloc>()
                                                          .isSavedCardChoose =
                                                      false;
                                                  context
                                                      .read<BookingBloc>()
                                                      .selectedCardToken = '';
                                                  context
                                                          .read<BookingBloc>()
                                                          .selectedPaymentType =
                                                      'cash';
                                                }
                                                context
                                                    .read<BookingBloc>()
                                                    .payAtDrop = false;
                                                context
                                                    .read<BookingBloc>()
                                                    .add(UpdateEvent());
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    color: (!context
                                                            .read<BookingBloc>()
                                                            .payAtDrop)
                                                        ? Theme.of(context)
                                                            .dividerColor
                                                            .withAlpha(
                                                                (0.8 * 255)
                                                                    .toInt())
                                                        : null,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .sender,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          SizedBox(width: size.width * 0.01),
                                          if (arg.stopAddressList.length == 1 ||
                                              (arg.title == 'Receive Parcel' &&
                                                  arg.stopAddressList.length >
                                                      1))
                                            InkWell(
                                              onTap: () {
                                                if (context
                                                            .read<BookingBloc>()
                                                            .transportType ==
                                                        'delivery' &&
                                                    arg.title ==
                                                        'Receive Parcel') {
                                                  context
                                                      .read<BookingBloc>()
                                                      .showPaymentChange = true;
                                                } else {
                                                  context
                                                          .read<BookingBloc>()
                                                          .showPaymentChange =
                                                      false;
                                                  context
                                                          .read<BookingBloc>()
                                                          .isSavedCardChoose =
                                                      false;
                                                  context
                                                      .read<BookingBloc>()
                                                      .selectedCardToken = '';
                                                  context
                                                          .read<BookingBloc>()
                                                          .selectedPaymentType =
                                                      'cash';
                                                }
                                                context
                                                    .read<BookingBloc>()
                                                    .payAtDrop = true;
                                                context
                                                    .read<BookingBloc>()
                                                    .add(UpdateEvent());
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    color: (context
                                                            .read<BookingBloc>()
                                                            .payAtDrop)
                                                        ? Theme.of(context)
                                                            .dividerColor
                                                            .withAlpha(
                                                                (0.5 * 255)
                                                                    .toInt())
                                                        : null,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: MyText(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .receiver,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(height: size.width * 0.04),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: AppColors.borderColor)),
                              child: InkWell(
                                onTap: () {
                                  if (context
                                      .read<BookingBloc>()
                                      .showPaymentChange) {
                                    showModalBottomSheet(
                                        context: context,
                                        barrierColor:
                                            Theme.of(context).shadowColor,
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        builder: (_) {
                                          return SelectPaymentMethodWidget(
                                              cont: context);
                                        });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .paymentMethod,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                  context
                                                          .read<BookingBloc>()
                                                          .isSavedCardChoose
                                                      ? Icons
                                                          .credit_card_rounded
                                                      : context
                                                                  .read<
                                                                      BookingBloc>()
                                                                  .selectedPaymentType ==
                                                              'cash'
                                                          ? Icons
                                                              .payments_outlined
                                                          : context
                                                                      .read<
                                                                          BookingBloc>()
                                                                      .selectedPaymentType ==
                                                                  'card'
                                                              ? Icons
                                                                  .credit_card_rounded
                                                              : Icons
                                                                  .account_balance_wallet_outlined,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColorDark),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                              MyText(
                                                text: context
                                                        .read<BookingBloc>()
                                                        .isSavedCardChoose
                                                    ? 'Card'
                                                    : context
                                                        .read<BookingBloc>()
                                                        .selectedPaymentType,
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (context
                                          .read<BookingBloc>()
                                          .showPaymentChange)
                                        MyText(
                                            text: AppLocalizations.of(context)!
                                                .changeLower,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontWeight:
                                                        FontWeight.w600))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.width * 0.04),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: AppColors.borderColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .readBeforeBooking,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .disabledColor),
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.width * 0.02,
                                          width: size.width * 0.02,
                                          margin: EdgeInsets.only(
                                              top: size.width * 0.015),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .deliveryInfoLoadingTime
                                                .replaceAll('**',
                                                    '${context.read<BookingBloc>().isRentalRide ? eta.freeMin : eta.freeWaitingTimeInMinsBeforeTripStart + eta.freeWaitingTimeInMinsAfterTripStart}'),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.width * 0.02,
                                          width: size.width * 0.02,
                                          margin: EdgeInsets.only(
                                              top: size.width * 0.015),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .deliveryInfoLoadingCharged
                                                .replaceAll('***',
                                                    '${eta.currency} ${context.read<BookingBloc>().isRentalRide ? eta.timePricePerMin : eta.waitingCharge}'),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.width * 0.02,
                                          width: size.width * 0.02,
                                          margin: EdgeInsets.only(
                                              top: size.width * 0.015),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .deliveryInfoFare,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.width * 0.02,
                                          width: size.width * 0.02,
                                          margin: EdgeInsets.only(
                                              top: size.width * 0.015),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .deliveryInfoParkingCharge,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.width * 0.02,
                                          width: size.width * 0.02,
                                          margin: EdgeInsets.only(
                                              top: size.width * 0.015),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.8,
                                          child: MyText(
                                            text: AppLocalizations.of(context)!
                                                .deliveryInfoOverloading,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width * 0.05,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
