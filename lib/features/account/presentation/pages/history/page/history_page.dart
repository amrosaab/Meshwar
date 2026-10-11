import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/history_model.dart';
import '../../outstation/widget/outstation_offered_page.dart';
import '../widget/history_card_shimmer.dart';
import '../widget/history_card_widget.dart';
import '../widget/history_filter_tabs.dart';
import '../widget/history_nodata.dart';
import 'trip_summary_history.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = '/historyPage';
  final HistoryPageArguments arg;
  const HistoryPage({super.key, required this.arg});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccBloc>().add(AccGetDirectionEvent());
    context.read<AccBloc>().add(HistoryPageInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AccBloc, AccState>(builder: (context, state) {
      final bloc = context.read<AccBloc>();
      final dark = Theme.of(context).brightness == Brightness.dark;
      final surface = dark ? AppColors.bgAsphaltLight : Colors.white;
      final ink = dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
      return Directionality(
        // Follow locale changes even while this tab stays mounted.
        textDirection: Directionality.of(context),
        child: Scaffold(
          backgroundColor: RideVisuals.canvas(context),
          appBar: AppBar(
            backgroundColor: surface,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 72,
            titleSpacing: 20,
            centerTitle: false,
            title: Row(children: [
              const ExcludeSemantics(
                  child: RideColorBadge(
                      icon: Icons.history_rounded,
                      gradient: RideVisuals.amber,
                      size: 40,
                      iconSize: 22,
                      radius: 14)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(AppLocalizations.of(context)!.history,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: ink))),
            ]),
          ),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: HistoryFilterTabs(
                selectedIndex: bloc.selectedHistoryType,
                onSelected: (index) {
                  bloc.add(HistoryTypeChangeEvent(historyTypeIndex: index));
                },
              ),
            ),
            Expanded(
              child: CustomScrollView(
                controller: bloc.scrollController,
                slivers: [
                  if (bloc.isLoading &&
                      bloc.firstLoad &&
                      bloc.historyList.isEmpty)
                    SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverToBoxAdapter(
                            child: HistoryShimmer(size: size))),
                  if (!bloc.isLoading && bloc.historyList.isEmpty)
                    const SliverFillRemaining(
                        hasScrollBody: false, child: HistoryNodataWidget()),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) {
                          final history = bloc.historyList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () =>
                                    _openHistory(context, history, index),
                                borderRadius: BorderRadius.circular(24),
                                child: HistoryCardWidget(
                                    cont: context, history: history),
                              ),
                            ),
                          );
                        },
                        childCount: bloc.historyList.length,
                      ),
                    ),
                  ),
                  if (bloc.historyList.isNotEmpty && bloc.loadMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))),
                      ),
                    ),
                  SliverToBoxAdapter(
                      child: SizedBox(
                          height: MediaQuery.paddingOf(context).bottom + 20)),
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }

  void _openHistory(BuildContext context, HistoryData history, int index) {
    if (history.isLater == true && history.isCancelled != 1) {
      if (history.isOutStation == 1 && history.driverDetail == null) {
        Navigator.pushNamed(context, OutStationOfferedPage.routeName,
            arguments: OutStationOfferedPageArguments(
              requestId: history.id,
              currencySymbol: history.requestedCurrencySymbol,
              dropAddress: history.dropAddress,
              pickAddress: history.pickAddress,
              updatedAt: history.tripStartTimeWithDate,
              offeredFare: history.offerredRideFare.toString(),
            )).then(
          (value) {
            if (!context.mounted) {
              return;
            }
            context.read<AccBloc>().historyList.clear();
            context
                .read<AccBloc>()
                .add(HistoryGetEvent(historyFilter: 'is_later=1'));
          },
        );
      } else {
        Navigator.pushNamed(
          context,
          HistoryTripSummaryPage.routeName,
          arguments: TripHistoryPageArguments(
              historyData: history,
              historyIndex: index,
              isSupportTicketEnabled: widget.arg.isSupportTicketEnabled,
              pageNumber: context
                  .read<AccBloc>()
                  .historyPaginations!
                  .pagination
                  .currentPage),
        ).then((value) {
          if (!context.mounted) {
            return;
          }
          context.read<AccBloc>().historyList.clear();
          context.read<AccBloc>().add(
                HistoryGetEvent(
                    historyFilter:
                        (context.read<AccBloc>().selectedHistoryType == 0)
                            ? "is_completed=1"
                            : (context.read<AccBloc>().selectedHistoryType == 1)
                                ? "is_later=1"
                                : "is_cancelled=1",
                    pageNumber: context
                        .read<AccBloc>()
                        .historyPaginations!
                        .pagination
                        .currentPage),
              );
          context.read<AccBloc>().add(AccUpdateEvent());
        });
      }
    } else {
      Navigator.pushNamed(
        context,
        HistoryTripSummaryPage.routeName,
        arguments: TripHistoryPageArguments(
            historyData: history,
            historyIndex: index,
            isSupportTicketEnabled: widget.arg.isSupportTicketEnabled,
            pageNumber: context
                .read<AccBloc>()
                .historyPaginations!
                .pagination
                .currentPage),
      ).then((value) {
        if (!context.mounted) return;
        context.read<AccBloc>().add(
              HistoryGetEvent(
                  historyFilter:
                      (context.read<AccBloc>().selectedHistoryType == 0)
                          ? "is_completed=1"
                          : (context.read<AccBloc>().selectedHistoryType == 1)
                              ? "is_later=1"
                              : "is_cancelled=1",
                  pageNumber: context
                      .read<AccBloc>()
                      .historyPaginations!
                      .pagination
                      .currentPage),
            );
        context.read<AccBloc>().add(AccUpdateEvent());
      });
    }
  }
}
