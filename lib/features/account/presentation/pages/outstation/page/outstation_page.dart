import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/presentation/pages/home_page.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/history_model.dart';
import '../../../widgets/account_content.dart';
import '../../history/widget/history_card_shimmer.dart';
import '../../history/widget/history_nodata.dart';
import '../../history/page/trip_summary_history.dart';
import '../widget/outstation_offered_page.dart';
import '../widget/outstation_history_card.dart';

class OutstationHistoryPage extends StatelessWidget {
  const OutstationHistoryPage({super.key, required this.arg});
  final OutstationHistoryPageArguments arg;
  static const String routeName = '/outstationHistory';

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(AccGetDirectionEvent())
          ..add(HistoryGetEvent(historyFilter: 'out_station=1')),
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final l10n = AppLocalizations.of(context)!;
          final pagination = bloc.historyPaginations?.pagination;
          final hasMore = pagination != null &&
              pagination.currentPage < pagination.totalPages;
          void goHome() => Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (_) => false);
          return Directionality(
            textDirection: bloc.textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: RideVisuals.canvas(context),
              appBar: AppBar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.bgAsphaltLight
                    : Colors.white,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                toolbarHeight:
                    MediaQuery.textScalerOf(context).scale(22) > 32 ? 96 : 64,
                foregroundColor: AccountStyle.ink(context),
                leading: IconButton(
                    icon: const BackButtonIcon(),
                    tooltip:
                        MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () =>
                        arg.isFromBooking ? goHome() : Navigator.pop(context)),
                title: Text(l10n.outStation,
                    maxLines: 2,
                    style: AccountStyle.text(context)
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              body: CustomScrollView(slivers: [
                if (bloc.isLoading && bloc.historyList.isEmpty)
                  SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      sliver: SliverToBoxAdapter(
                          child: HistoryShimmer(
                              size: MediaQuery.sizeOf(context)))),
                if (!bloc.isLoading && bloc.historyList.isEmpty)
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: HistoryNodataWidget(onBookRide: goHome)),
                SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    sliver: SliverList.builder(
                        itemCount: bloc.historyList.length,
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(24),
                                    onTap: () => _openRide(
                                        context, bloc.historyList[index]),
                                    child: OutstationHistoryCard(
                                        history: bloc.historyList[index])))))),
                if (hasMore && bloc.historyList.isNotEmpty)
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                              child: bloc.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.meshwarRed))
                                  : OutlinedButton.icon(
                                      icon:
                                          const Icon(Icons.expand_more_rounded),
                                      label: Text(l10n.loadMore),
                                      onPressed: () => bloc.add(HistoryGetEvent(
                                          historyFilter: 'out_station=1',
                                          pageNumber:
                                              pagination.currentPage + 1)))))),
                SliverToBoxAdapter(
                    child: SizedBox(
                        height: MediaQuery.paddingOf(context).bottom + 12)),
              ]),
            ),
          );
        }),
      );

  Future<void> _openRide(BuildContext context, HistoryData history) async {
    final bloc = context.read<AccBloc>();
    if (history.isLater &&
        history.isOutStation == 1 &&
        history.driverDetail == null) {
      await Navigator.pushNamed(context, OutStationOfferedPage.routeName,
          arguments: OutStationOfferedPageArguments(
              requestId: history.id,
              currencySymbol: history.requestedCurrencySymbol,
              dropAddress: history.dropAddress,
              pickAddress: history.pickAddress,
              updatedAt: history.tripStartTimeWithDate,
              offeredFare: history.offerredRideFare.toString()));
    } else {
      await Navigator.pushNamed(context, HistoryTripSummaryPage.routeName,
          arguments: TripHistoryPageArguments(
              historyData: history,
              isSupportTicketEnabled: '0',
              pageNumber:
                  bloc.historyPaginations?.pagination?.currentPage ?? 1));
    }
    if (context.mounted && history.isLater) {
      bloc.add(HistoryGetEvent(historyFilter: 'out_station=1', pageNumber: 1));
    }
  }
}
