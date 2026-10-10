import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../../common/common.dart';
import '../../../../../../../core/utils/custom_loader.dart';
import '../../../../../../../core/utils/functions.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../application/booking_bloc.dart';
import 'onride_payment_gateway_widget.dart';
import 'ride_sheet_content.dart';

class OnRideBottomSheet extends StatelessWidget {
  const OnRideBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final bloc = context.read<BookingBloc>();
        final request = bloc.requestData;
        final driver = bloc.driverData;
        if (request == null || driver == null) {
          return const SizedBox(height: 180, child: Center(child: Loader()));
        }
        final l10n = AppLocalizations.of(context)!;
        final beforeTrip = request.isTripStart == 0;
        final accepted = request.acceptedAt.isNotEmpty;
        final arrived = accepted && request.arrivedAt.isNotEmpty;
        final onTheWay = accepted && !arrived && beforeTrip;
        final duration = double.tryParse(bloc.duration);
        final minutes = duration != null && duration > 0
            ? duration.toStringAsFixed(0)
            : '2';
        String? subtitle;
        if (beforeTrip) {
          if (onTheWay) {
            subtitle = l10n.driverArriveText.replaceAll('**', minutes);
          } else if (arrived) {
            if (request.isBidRide == 1 || request.isRental) {
              subtitle = l10n.driverArrivedLocation;
            } else if (request.freeWaitingTimeInMinsBeforeTripStart == 0 ||
                request.freeWaitingTimeInMinsAfterTripStart == 0) {
              subtitle = l10n.waitingChargeText.replaceAll('*',
                  '${request.requestedCurrencySymbol} ${request.waitingCharge}');
            } else {
              subtitle = l10n.arrivedMessage
                  .replaceAll('***',
                      '${request.requestedCurrencySymbol} ${request.waitingCharge}')
                  .replaceAll('*',
                      request.freeWaitingTimeInMinsBeforeTripStart.toString());
            }
          } else {
            subtitle =
                l10n.reachingDestinationInMinutes.replaceAll('***', minutes);
          }
        }
        final showWaiting = arrived &&
            beforeTrip &&
            (bloc.waitingTime / 60).toStringAsFixed(0) != '0' &&
            request.isBidRide == 0 &&
            !request.isRental;
        final showOtp = arrived &&
            (beforeTrip ||
                (request.transportType == 'delivery' &&
                    request.isTripStart == 1)) &&
            request.showOtpFeature;
        final canEdit =
            request.isTripStart == 1 && request.transportType == 'taxi';
        void editLocation() =>
            bloc.add(EditLocationEvent(requestData: request));
        final stops = <RideSheetStop>[
          RideSheetStop(
            label: l10n.pickup,
            address: request.pickAddress,
            isPickup: true,
            instruction: request.transportType == 'delivery'
                ? request.pickupPocInstruction
                : '',
          ),
        ];
        if (!request.isRental) {
          if (request.requestStops.data.isNotEmpty) {
            for (final stop in request.requestStops.data) {
              stops.add(RideSheetStop(
                label: l10n.drop,
                address: stop.address,
                instruction: request.transportType == 'delivery'
                    ? stop.pocInstruction
                    : '',
                onEdit: canEdit ? editLocation : null,
              ));
            }
          } else if (request.dropAddress.isNotEmpty) {
            stops.add(RideSheetStop(
              label: l10n.drop,
              address: request.dropAddress,
              instruction: request.transportType == 'delivery'
                  ? request.dropPocInstruction
                  : '',
              onEdit: canEdit ? editLocation : null,
            ));
          }
        }
        final fare = request.isBidRide == 1
            ? request.acceptedRideFare
            : request.discountedTotal != null && request.discountedTotal != ''
                ? request.discountedTotal.toString()
                : request.requestEtaAmount;
        final contactEnabled =
            (beforeTrip && request.transportType == 'taxi') ||
                request.transportType != 'taxi';
        final canPay = request.transportType == 'delivery' &&
            !bloc.payAtDrop &&
            request.paymentOpt == '0' &&
            request.isDriverArrived == 1 &&
            request.isPaid == 0;
        return RideSheetContent(
          status: onTheWay
              ? l10n.onTheWay
              : arrived && beforeTrip
                  ? l10n.driverArrived
                  : l10n.reachingDestination,
          statusIcon: arrived && beforeTrip
              ? Icons.location_on_rounded
              : Icons.directions_car_rounded,
          subtitle: subtitle,
          eta: onTheWay ? minutes : null,
          otp: showOtp ? request.rideOtp.toString() : null,
          waiting: showWaiting ? bloc.formatDuration(bloc.waitingTime) : null,
          stops: stops,
          driverName: driver.name,
          avatarUrl: driver.profilePicture,
          rating: driver.rating,
          completedRides: driver.completedRides,
          vehicleName: '${driver.carMakeName} ${driver.carModelName}'.trim(),
          vehicleColor: driver.carColor,
          vehiclePlate: driver.carNumber,
          driverInstruction: (request.transportType == 'taxi' ||
                  request.isOutStation == '1' ||
                  request.isRental)
              ? request.pickupPocInstruction
              : '',
          preferenceIcons: request.requestPreferences == null
              ? const []
              : [
                  for (final preference in request.requestPreferences.data)
                    preference.icon.toString()
                ],
          hasUnreadMessages: bloc.chatHistoryList
              .any((message) => message.fromType == 2 && message.seen == 0),
          onMessage: contactEnabled
              ? () => bloc.add(ChatWithDriverEvent(requestId: request.id))
              : null,
          onCall: contactEnabled
              ? () async => openUrl('tel:${driver.mobile}')
              : null,
          onShare: contactEnabled
              ? () async {
                  await SharePlus.instance.share(ShareParams(
                    text:
                        'Your Driver is ${driver.name}. ${driver.carColor} ${driver.carMakeName} ${driver.carModelName}, Vehicle Number: ${driver.carNumber}. Track with link: ${AppConstants.baseUrl}track/request/${request.id}',
                    sharePositionOrigin: _shareOrigin(context),
                  ));
                }
              : null,
          fareLabel:
              request.isRental ? request.rentalPackageName : l10n.rideFare,
          fare: '${request.requestedCurrencySymbol} $fare',
          paymentLabel: request.paymentOpt == '1'
              ? l10n.cash
              : request.paymentOpt == '2'
                  ? l10n.wallet
                  : l10n.card,
          paymentIcon: request.paymentOpt == '1'
              ? Icons.payments_outlined
              : request.paymentOpt == '2'
                  ? Icons.account_balance_wallet_outlined
                  : Icons.credit_card_rounded,
          extraChargeLabel: bloc.additionalChargesReason,
          extraCharge: bloc.additionalChargesAmount.isEmpty
              ? ''
              : '+ ${request.requestedCurrencySymbol} ${bloc.additionalChargesAmount}',
          onPay: canPay
              ? () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: AppColors.surfaceStrong(context),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (_) => BlocProvider.value(
                      value: bloc,
                      child: OnridePaymentGatewayWidget(
                          cont: context,
                          walletPaymentGatways: request.paymentGateways),
                    ),
                  )
              : null,
          onCancel: beforeTrip
              ? () {
                  bloc.selectedCancelReason = '';
                  bloc.add(CancelReasonsEvent(
                      beforeOrAfter:
                          request.isDriverArrived == 0 ? 'before' : 'after'));
                }
              : null,
        );
      },
    );
  }

  Rect? _shareOrigin(BuildContext context) {
    final box = context.findRenderObject();
    return box is RenderBox && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
  }
}
