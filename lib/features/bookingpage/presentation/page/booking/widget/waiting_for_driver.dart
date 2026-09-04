// ignore_for_file: unused_element_parameter

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/pickup_icon.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_divider.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/booking_bloc.dart';

class _AnimatedContainer extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _AnimatedContainer({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}

class WaitingForDriverConfirmation extends StatelessWidget {
  final double maximumTime;

  const WaitingForDriverConfirmation({
    super.key,
    required this.maximumTime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final timerDuration = context.read<BookingBloc>().timerDuration;
        Duration duration = Duration(seconds: timerDuration);
        String twoDigits(int n) => n.toString().padLeft(2, '0');
        final hours = duration.inHours;
        final minutes = duration.inMinutes.remainder(60);
        final seconds = duration.inSeconds.remainder(60);
        return Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.05 * 255).toInt()),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.width * 0.02),
                const Center(child: CustomDivider()),
                SizedBox(height: size.width * 0.02),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Theme.of(context)
                          .primaryColor
                          .withAlpha((0.1 * 255).toInt()),
                      child: Image.asset(AppImages.defaultProfile),
                    ),
                    SizedBox(width: size.width * 0.02),
                    MyText(
                      text: AppLocalizations.of(context)!.discoverYourDriver,
                      textStyle:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ],
                ),
                SizedBox(height: size.width * 0.02),
                _AnimatedContainer(
                  child: Container(
                    height: size.width * 0.03,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(size.width * 0.024),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).toInt()),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(size.width * 0.005),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.024),
                      child: LinearProgressIndicator(
                        value: (timerDuration / maximumTime),
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          (timerDuration == 0)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColor,
                        ),
                        minHeight: size.width * 0.025,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyText(
                      text: (hours > 0)
                          ? '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)} ${AppLocalizations.of(context)!.mins}'
                          : '${twoDigits(minutes)}:${twoDigits(seconds)} ${AppLocalizations.of(context)!.mins}',
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: size.width * 0.04),
                MyText(
                  text: AppLocalizations.of(context)!.bookingDetails,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.width * 0.03),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    child: Column(
                      children: [
                        ListView.builder(
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
                              return Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 4,
                                      spreadRadius: 0.5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                margin:
                                    EdgeInsets.only(bottom: size.width * 0.02),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.01),
                                        child: const PickupIcon(),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: address.address,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ListView.builder(
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
                              return Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 4,
                                      spreadRadius: 0.5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.only(top: size.width * 0.02),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.005),
                                        child: const Icon(Icons.place_rounded,
                                            size: 20, color: AppColors.red),
                                      ),
                                      Expanded(
                                        child: MyText(
                                          text: address.address,
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
                SizedBox(height: size.width * 0.05),
                if (context.read<BookingBloc>().requestData != null) ...[
                  MyText(
                    text: AppLocalizations.of(context)!.rideDetails,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.width * 0.03),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 4,
                                  spreadRadius: 0.5,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: CachedNetworkImage(
                              imageUrl: context
                                  .read<BookingBloc>()
                                  .requestData!
                                  .vehicleTypeImage,
                              height: size.width * 0.12,
                              width: size.width * 0.12,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: Loader(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Text(""),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          Expanded(
                            child: MyText(
                              text: context
                                  .read<BookingBloc>()
                                  .requestData!
                                  .vehicleTypeName,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: size.width * 0.03),
                MyText(
                  text: AppLocalizations.of(context)!.payment,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.width * 0.03),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 4,
                                spreadRadius: 0.5,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                              context.read<BookingBloc>().isSavedCardChoose
                                  ? Icons.credit_card_rounded
                                  : context
                                              .read<BookingBloc>()
                                              .selectedPaymentType ==
                                          'cash'
                                      ? Icons.payments_outlined
                                      : context
                                                  .read<BookingBloc>()
                                                  .selectedPaymentType ==
                                              'card'
                                          ? Icons.credit_card_rounded
                                          : Icons
                                              .account_balance_wallet_outlined,
                              color: Theme.of(context).primaryColorDark,
                              size: 28),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: MyText(
                            text: context.read<BookingBloc>().isSavedCardChoose
                                ? 'Card'
                                : context
                                    .read<BookingBloc>()
                                    .selectedPaymentType,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.05),
                MyText(
                  text: AppLocalizations.of(context)!.manageRide,
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.width * 0.05),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      enableDrag: false,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                      ),
                      builder: (_) {
                        return BlocProvider.value(
                            value: context.read<BookingBloc>(),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                      child: Image.asset(AppImages.cancelGif,
                                          height: size.width * 0.2)),
                                  Center(
                                    child: MyText(
                                      text: AppLocalizations.of(context)!
                                          .cancelRide,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColorDark),
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Center(
                                    child: MyText(
                                      text: AppLocalizations.of(context)!
                                          .cancelRideText,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  SizedBox(height: size.width * 0.05),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton(
                                        buttonName:
                                            AppLocalizations.of(context)!
                                                .cancelRide,
                                        borderRadius: 5,
                                        isBorder: true,
                                        width: size.width * 0.4,
                                        height: size.width * 0.1,
                                        buttonColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        textSize: context
                                                    .read<BookingBloc>()
                                                    .languageCode ==
                                                'fr'
                                            ? 14
                                            : null,
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        onTap: () {
                                          context
                                              .read<BookingBloc>()
                                              .timerCount(context,
                                                  duration: 0,
                                                  isNormalRide: true,
                                                  isCloseTimer: true);
                                          context
                                              .read<BookingBloc>()
                                              .onRideBottomPosition = -250;
                                          context.read<BookingBloc>().add(
                                              BookingCancelRequestEvent(
                                                  requestId: context
                                                      .read<BookingBloc>()
                                                      .requestData!
                                                      .id));
                                        },
                                      ),
                                      CustomButton(
                                        buttonName:
                                            AppLocalizations.of(context)!.back,
                                        borderRadius: 5,
                                        width: size.width * 0.4,
                                        height: size.width * 0.1,
                                        buttonColor:
                                            Theme.of(context).primaryColor,
                                        textColor: AppColors.white,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * 0.15),
                                ],
                              ),
                            ));
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.red,
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
                    padding: EdgeInsets.symmetric(
                        vertical: size.width * 0.03,
                        horizontal: size.width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cancel_outlined,
                            color: AppColors.white, size: 24),
                        SizedBox(width: size.width * 0.03),
                        MyText(
                          text: AppLocalizations.of(context)!.cancelRide,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                  fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.width * 0.1),
              ],
            ),
          ),
        );
      },
    );
  }
}
