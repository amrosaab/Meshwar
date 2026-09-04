// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../../../common/common.dart";
import "../../../../../../core/utils/custom_appbar.dart";
import "../../../../../../core/utils/custom_background.dart";
import "../../../../../../core/utils/custom_button.dart";
import "../../../../../../core/utils/custom_container.dart";
import "../../../../../../core/utils/custom_loader.dart";
import "../../../../../../core/utils/custom_snack_bar.dart";
import "../../../../../../core/utils/custom_text.dart";
import "../../../../../../l10n/app_localizations.dart";
import "../../../../application/acc_bloc.dart";
import "../../support_ticket/widgets/create_ticket_sheet.dart";
import "../widget/cancel_ride_widget.dart";
import "../widget/delivery_proof_view.dart";
import "../widget/trip_driver_details_widget.dart";
import "../widget/trip_fare_breakup_widget.dart";
import "../widget/trip_vehicle_info_widget.dart";

class HistoryTripSummaryPage extends StatelessWidget {
  static const String routeName = '/historytripsummary';
  final TripHistoryPageArguments arg;

  const HistoryTripSummaryPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(TripSummaryHistoryDataEvent(tripHistoryData: arg.historyData))
        ..add(GetServiceLocationEvent())
        ..add(AddHistoryMarkerEvent(
            stops: (arg.historyData.requestStops != null)
                ? arg.historyData.requestStops!.data
                : [],
            pickLat: arg.historyData.pickLat,
            pickLng: arg.historyData.pickLng,
            dropLat: arg.historyData.dropLat,
            dropLng: arg.historyData.dropLng,
            polyline: arg.historyData.polyLine))
        ..add(ComplaintEvent(complaintType: 'request')),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStartState) {
            CustomLoader.loader(context);
          } else if (state is AccDataLoadingStopState) {
            CustomLoader.dismiss(context);
          } else if (state is RequestCancelState) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is GetTicketListLoadedState) {
            CustomLoader.dismiss(context);
          } else if (state is CreateSupportTicketState) {
            if (context.read<AccBloc>().isTicketSheetOpened) return;
            context.read<AccBloc>().isTicketSheetOpened = true;
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              isDismissible: true,
              context: context,
              builder: (cont) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: CreateTicketSheet(
                    requestId: state.requestId,
                    cont: context,
                    ticketNamesList: state.ticketNamesList,
                    isFromReuest: state.isFromRequest,
                    index: state.historyIndex,
                    historyPagenumber: state.historyPageNumber,
                  ),
                );
              },
            ).whenComplete(() {
              if (context.mounted) {
                context.read<AccBloc>().isTicketSheetOpened = false;
              }
            });
          } else if (state is InvoiceDownloadingState) {
            CustomLoader.loader(context);
          } else if (state is InvoiceDownloadSuccessState) {
            showToast(
                message: AppLocalizations.of(context)!
                    .invoiceDownloadedSuccessfully);
            CustomLoader.dismiss(context);
          } else if (state is InvoiceDownloadFailureState) {
            CustomLoader.dismiss(context);
            showToast(
                message: AppLocalizations.of(context)!.invoiceDownloadFailed);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final tripHistoryData = context.read<AccBloc>().historyData;

          if (Theme.of(context).brightness == Brightness.dark) {
            if (context.read<AccBloc>().googleMapController != null) {
              context
                  .read<AccBloc>()
                  .googleMapController!
                  .setMapStyle(context.read<AccBloc>().darkMapString);
            }
          } else {
            if (context.read<AccBloc>().googleMapController != null) {
              context
                  .read<AccBloc>()
                  .googleMapController!
                  .setMapStyle(context.read<AccBloc>().lightMapString);
            }
          }

          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.rideDetails,
                automaticallyImplyLeading: true,
                titleFontSize: 18,
              ),
              body: CustomBackground(
                child: (tripHistoryData != null)
                    ? SafeArea(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: size.height,
                        width: size.width,
                        child: CustomScrollView(
                          slivers: [
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    childCount: 1, (context, index) {
                                  return Container(
                                    padding:
                                    EdgeInsets.all(size.width * 0.03),
                                    width: size.width,
                                    child: Column(
                                      children: [
                                        // Fare Breakdown
                                        if (tripHistoryData.isCompleted ==
                                            1 ||
                                            tripHistoryData.isCancelled == 1)
                                          TripFarebreakupWidget(
                                              cont: context, arg: arg),

                                        SizedBox(height: size.width * 0.02),

                                        // Tips Section for Bid Rides
                                        if (tripHistoryData.isBidRide == 1 &&
                                            tripHistoryData.requestBill !=
                                                null &&
                                            tripHistoryData.requestBill.data
                                                .driverTips !=
                                                "0")
                                          CustomContainer(
                                            borderRadius: 14,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  size.width * 0.05),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  MyText(
                                                    text: AppLocalizations
                                                        .of(context)!
                                                        .tips,
                                                    textStyle: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                        fontSize: 18),
                                                  ),
                                                  MyText(
                                                    text:
                                                    '${tripHistoryData.requestBill.data.requestedCurrencySymbol} ${tripHistoryData.requestBill.data.driverTips}',
                                                    textStyle: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                        if (tripHistoryData.isBidRide == 1 &&
                                            tripHistoryData.requestBill !=
                                                null &&
                                            tripHistoryData.requestBill.data
                                                .driverTips !=
                                                "0")
                                          SizedBox(height: size.width * 0.02),

                                        // Driver Details
                                        TripDriverDetailsWidget(
                                            cont: context, arg: arg),

                                        SizedBox(height: size.width * 0.02),

                                        // Vehicle Info
                                        TripVehicleInfoWidget(
                                            cont: context, arg: arg),

                                        SizedBox(height: size.width * 0.02),

                                        // Delivery Proof Section
                                        if (tripHistoryData.transportType ==
                                            'delivery' &&
                                            tripHistoryData.requestProofs
                                                .data.isNotEmpty)
                                          CustomContainer(
                                            borderRadius: 14,
                                            child: InkWell(
                                              borderRadius:
                                              BorderRadius.circular(14),
                                              onTap: () {
                                                if (arg
                                                    .historyData
                                                    .requestProofs
                                                    .data
                                                    .isNotEmpty) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DeliveryProofViewPage(
                                                              images: arg
                                                                  .historyData
                                                                  .requestProofs
                                                                  .data),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    size.width * 0.05),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.image,
                                                        color:
                                                        AppColors.blue),
                                                    const SizedBox(width: 8),
                                                    MyText(
                                                      text: AppLocalizations
                                                          .of(context)!
                                                          .loadShipmentProof,
                                                      textStyle: const TextStyle(
                                                          color: AppColors
                                                              .blue,
                                                          decoration:
                                                          TextDecoration
                                                              .underline,
                                                          decorationColor:
                                                          AppColors.blue,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                        if (tripHistoryData.transportType ==
                                            'delivery' &&
                                            tripHistoryData.requestProofs
                                                .data.isNotEmpty)
                                          SizedBox(height: size.width * 0.02),

                                        // Trip ID Section
                                        CustomContainer(
                                          borderRadius: 14,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                size.width * 0.05),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    MyText(
                                                      text: AppLocalizations
                                                          .of(context)!
                                                          .tripId,
                                                      textStyle: Theme.of(
                                                          context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                          fontSize: 18),
                                                    ),
                                                    SizedBox(
                                                        height: size.width *
                                                            0.02),
                                                    MyText(
                                                      text: tripHistoryData
                                                          .requestNumber,
                                                      textStyle: Theme.of(
                                                          context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: size.width * 0.02),

                                        // Ratings Section
                                        if (tripHistoryData.isCompleted ==
                                            1) ...[
                                          CustomContainer(
                                            borderRadius: 14,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  size.width * 0.05),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  MyText(
                                                    text: AppLocalizations
                                                        .of(context)!
                                                        .ratings,
                                                    textStyle: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                        fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                      height: size.width *
                                                          0.02),
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: List.generate(
                                                      5,
                                                          (index) {
                                                        return (index <
                                                            tripHistoryData
                                                                .rideDriverRating)
                                                            ? const Icon(
                                                            Icons.star,
                                                            size: 25,
                                                            color: AppColors
                                                                .primary)
                                                            : Icon(
                                                            Icons
                                                                .star_border_outlined,
                                                            size: 25,
                                                            color: AppColors
                                                                .darkGrey);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],

                                        SizedBox(height: size.width * 0.5),
                                      ],
                                    ),
                                  );
                                })),
                          ],
                        ),
                      ),

                      // Bottom Action Buttons
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: (tripHistoryData.isCompleted == 1 &&
                            tripHistoryData.supportTicketExist ==
                                true &&
                            arg.isSupportTicketEnabled == '1')
                            ? Padding(
                          padding: const EdgeInsets.only(
                              left: 10,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: _TicketStatusChip(
                            width: size.width * 0.5,
                            ticketId:
                            tripHistoryData.supportTicketId,
                            status:
                            tripHistoryData.supportTicketStatus,
                          ),
                        )
                            : (tripHistoryData.isCompleted == 1)
                            ? Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                AppColors.surface(context),
                                border: Border(
                                  top: BorderSide(
                                      color: AppColors
                                          .surfaceBorder(
                                          context)),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        size.width * 0.05,
                                        size.width * 0.05,
                                        size.width * 0.05,
                                        size.width * 0),
                                    child: CustomButton(
                                        width: size.width,
                                        buttonName:
                                        AppLocalizations.of(
                                            context)!
                                            .downloadInvoice,
                                        onTap: () {
                                          context
                                              .read<AccBloc>()
                                              .add(
                                            DownloadInvoiceUserEvent(
                                                journeyId:
                                                tripHistoryData
                                                    .id
                                                    .toString()),
                                          );
                                        }),
                                  ),
                                  if (arg.isSupportTicketEnabled ==
                                      '1')
                                    Padding(
                                      padding: EdgeInsets.all(
                                          size.width * 0.05),
                                      child: GestureDetector(
                                        onDoubleTap: null,
                                        onDoubleTapDown: null,
                                        onTap: () {
                                          context.read<AccBloc>().add(
                                              CreateSupportTicketEvent(
                                                  requestId:
                                                  tripHistoryData
                                                      .requestNumber,
                                                  isFromRequest:
                                                  true,
                                                  index: arg
                                                      .historyIndex,
                                                  pageNumber: arg
                                                      .pageNumber));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            const Icon(
                                                Icons
                                                    .report_outlined,
                                                size: 20,
                                                color: AppColors
                                                    .red),
                                            SizedBox(
                                                width: size
                                                    .width *
                                                    0.01),
                                            MyText(
                                              text: AppLocalizations.of(
                                                  context)!
                                                  .reportIssues,
                                              textStyle: Theme.of(
                                                  context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                  color: AppColors
                                                      .red,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  fontSize:
                                                  13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                            : (tripHistoryData.isLater &&
                            tripHistoryData.isCancelled == 0)
                            ? Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color:
                            AppColors.surface(context),
                            border: Border(
                              top: BorderSide(
                                  color: AppColors
                                      .surfaceBorder(
                                      context)),
                            ),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                CustomButton(
                                  width: size.width * 0.9,
                                  height:
                                  size.width * 0.12,
                                  buttonName:
                                  AppLocalizations.of(
                                      context)!
                                      .cancel,
                                  borderRadius: 20,
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled:
                                        false,
                                        enableDrag: false,
                                        isDismissible:
                                        true,
                                        builder: (_) {
                                          return CancelRideWidget(
                                              cont:
                                              context,
                                              requestId:
                                              tripHistoryData
                                                  .id);
                                        });
                                  },
                                ),
                                SizedBox(
                                    height:
                                    size.width * 0.02),
                              ],
                            ),
                          ),
                        )
                            : Container(),
                      )
                    ],
                  ),
                )
                    : const SizedBox(),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Support-ticket status pill — replaces the old flat grey box (which used
/// `Theme.of(context).disabledColor` as both fill and border) with a chip
/// tinted to the actual status color, matching the rest of the brand system.
class _TicketStatusChip extends StatelessWidget {
  final double width;
  final String ticketId;
  final int status;

  const _TicketStatusChip({
    required this.width,
    required this.ticketId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = status == 1
        ? AppColors.blue
        : status == 2
        ? AppColors.orange
        : AppColors.red;
    final String statusLabel = status == 1
        ? AppLocalizations.of(context)!.pending
        : status == 2
        ? AppLocalizations.of(context)!.acknowledged
        : AppLocalizations.of(context)!.closed;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.12),
        border: Border.all(color: statusColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                text: "${AppLocalizations.of(context)!.ticketCreated} :",
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(width: width * 0.04),
              MyText(
                text: ticketId,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          MyText(
            text: statusLabel,
            textStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}