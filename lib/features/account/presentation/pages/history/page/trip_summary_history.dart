// ignore_for_file: deprecated_member_use

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../../../common/common.dart";
import "../../../../../../common/ride_visuals.dart";
import "../widget/history_detail_widgets.dart";
import "../../../../../../core/utils/custom_loader.dart";
import "../../../../../../core/utils/custom_snack_bar.dart";
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

          final l10n = AppLocalizations.of(context)!;
          final dark = Theme.of(context).brightness == Brightness.dark;
          final surface = dark ? AppColors.bgAsphaltLight : Colors.white;
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: RideVisuals.canvas(context),
              appBar: AppBar(
                backgroundColor: surface,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 64,
                centerTitle: true,
                leading: IconButton(
                  tooltip: l10n.back,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_rounded,
                      color: HistoryDetailStyle.ink(context), size: 22),
                ),
                title: Text(l10n.rideDetails,
                    style: HistoryDetailStyle.text(context)
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              body: tripHistoryData == null
                  ? const SizedBox.shrink()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                      children: [
                        if (tripHistoryData.isCompleted == 1 ||
                            tripHistoryData.isCancelled == 1)
                          _spaced(
                              TripFarebreakupWidget(cont: context, arg: arg)),
                        if (tripHistoryData.isBidRide == 1 &&
                            tripHistoryData.requestBill != null &&
                            tripHistoryData.requestBill.data.driverTips != '0')
                          _spaced(HistoryDetailCard(
                            icon: Icons.volunteer_activism_rounded,
                            gradient: RideVisuals.green,
                            title: l10n.tips,
                            child: Text(
                                '${tripHistoryData.requestBill.data.requestedCurrencySymbol} ${tripHistoryData.requestBill.data.driverTips}',
                                style: HistoryDetailStyle.text(context)
                                    .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                          )),
                        _spaced(
                            TripDriverDetailsWidget(cont: context, arg: arg)),
                        _spaced(TripVehicleInfoWidget(cont: context, arg: arg)),
                        if (tripHistoryData.transportType == 'delivery' &&
                            tripHistoryData.requestProofs.data.isNotEmpty)
                          _spaced(HistoryDetailCard(
                            child: InkWell(
                              onTap: () {
                                if (arg.historyData.requestProofs.data
                                    .isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DeliveryProofViewPage(
                                              images: arg.historyData
                                                  .requestProofs.data)));
                                }
                              },
                              child: Row(children: [
                                const RideColorBadge(
                                    icon: Icons.image_rounded,
                                    gradient: RideVisuals.blue,
                                    size: 34,
                                    iconSize: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Text(l10n.loadShipmentProof,
                                        style:
                                            HistoryDetailStyle.text(context))),
                                const Icon(Icons.chevron_right_rounded,
                                    size: 20),
                              ]),
                            ),
                          )),
                        _spaced(HistoryDetailCard(
                          title: l10n.tripId,
                          icon: Icons.confirmation_number_outlined,
                          gradient: RideVisuals.blue,
                          child: Text(tripHistoryData.requestNumber,
                              style: HistoryDetailStyle.text(context).copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        )),
                        if (tripHistoryData.isCompleted == 1)
                          HistoryDetailCard(
                            title: l10n.ratings,
                            icon: Icons.star_rounded,
                            gradient: RideVisuals.amber,
                            child: Semantics(
                              label:
                                  '${l10n.ratings}: ${tripHistoryData.rideDriverRating} / 5',
                              child: ExcludeSemantics(
                                  child: Wrap(
                                spacing: 4,
                                children: List.generate(
                                    5,
                                    (index) => Icon(
                                        index < tripHistoryData.rideDriverRating
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        size: 26,
                                        color: index <
                                                tripHistoryData.rideDriverRating
                                            ? const Color(0xFFE6862A)
                                            : HistoryDetailStyle.muted(
                                                context))),
                              )),
                            ),
                          ),
                      ],
                    ),
              bottomNavigationBar: tripHistoryData == null
                  ? null
                  : tripHistoryData.isCompleted == 1 ||
                          (tripHistoryData.isLater &&
                              tripHistoryData.isCancelled == 0)
                      ? Container(
                          decoration: BoxDecoration(
                              color: surface,
                              border: Border(
                                  top: BorderSide(
                                      color:
                                          HistoryDetailStyle.border(context)))),
                          child: SafeArea(
                            top: false,
                            minimum: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (tripHistoryData.isCompleted == 1 &&
                                      tripHistoryData.supportTicketExist &&
                                      arg.isSupportTicketEnabled == '1')
                                    _TicketStatusChip(
                                        ticketId:
                                            tripHistoryData.supportTicketId,
                                        status:
                                            tripHistoryData.supportTicketStatus)
                                  else if (tripHistoryData.isCompleted ==
                                      1) ...[
                                    HistoryDetailButton(
                                      label: l10n.downloadInvoice,
                                      icon: Icons.download_rounded,
                                      onPressed: () => context
                                          .read<AccBloc>()
                                          .add(DownloadInvoiceUserEvent(
                                              journeyId: tripHistoryData.id
                                                  .toString())),
                                    ),
                                    if (arg.isSupportTicketEnabled == '1')
                                      TextButton.icon(
                                        onPressed: () => context
                                            .read<AccBloc>()
                                            .add(CreateSupportTicketEvent(
                                                requestId: tripHistoryData
                                                    .requestNumber,
                                                isFromRequest: true,
                                                index: arg.historyIndex,
                                                pageNumber: arg.pageNumber)),
                                        icon: const Icon(
                                            Icons.help_outline_rounded,
                                            size: 18),
                                        label: Text(l10n.reportIssues,
                                            textAlign: TextAlign.center,
                                            style:
                                                HistoryDetailStyle.text(context)
                                                    .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                      ),
                                  ] else
                                    HistoryDetailButton(
                                      label: l10n.cancel,
                                      icon: Icons.close_rounded,
                                      onPressed: () => showModalBottomSheet<
                                              void>(
                                          context: context,
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          isDismissible: true,
                                          builder: (_) => CancelRideWidget(
                                              cont: context,
                                              requestId: tripHistoryData.id)),
                                    ),
                                ]),
                          ),
                        )
                      : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _spaced(Widget child) =>
      Padding(padding: const EdgeInsets.only(bottom: 14), child: child);
}

class _TicketStatusChip extends StatelessWidget {
  const _TicketStatusChip({required this.ticketId, required this.status});
  final String ticketId;
  final int status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = status == 1
        ? AppColors.blue
        : status == 2
            ? const Color(0xFFE6862A)
            : AppColors.routeGreen;
    final statusLabel = status == 1
        ? l10n.pending
        : status == 2
            ? l10n.acknowledged
            : l10n.closed;
    return HistoryDetailCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${l10n.ticketCreated}: $ticketId',
            style: HistoryDetailStyle.text(context)
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(statusLabel,
            style: HistoryDetailStyle.text(context)
                .copyWith(color: statusColor, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
