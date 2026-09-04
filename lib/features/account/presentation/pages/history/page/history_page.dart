// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_background.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/history_card_shimmer.dart';
import '../../outstation/widget/outstation_offered_page.dart';
import '../widget/history_card_widget.dart';
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
    context.read<AccBloc>().add(AccGetDirectionEvent());
    context.read<AccBloc>().add(HistoryPageInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocProvider.value(
      value: context.read<AccBloc>(),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {
          if (state is AccInitialState) {
            CustomLoader.loader(context);
          } else if (state is HistoryDataLoadingState) {
            CustomLoader.loader(context);
          } else if (state is HistoryDataSuccessState ||
              state is HistoryFailure) {
            CustomLoader.dismiss(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(
          builder: (context, state) {
            final selectedIndex = context.read<AccBloc>().selectedHistoryType;
            return SafeArea(

              top: false,

              child: Directionality(
                textDirection: context.read<AccBloc>().textDirection == 'rtl'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Scaffold(
                    extendBodyBehindAppBar: true,

                    appBar: CustomAppBar(
                      title: AppLocalizations.of(context)!.history,
                      showBottomBorder: false,
                      onBackTap: () {
                        Navigator.of(context).pop();
                        context.read<AccBloc>().scrollController.dispose();
                      },
                    ),
                    body: Padding(
                      padding: EdgeInsets.only(
                          top: kToolbarHeight +
                              MediaQuery.of(context).padding.top),
                      child: Column(
                        children: [
                          // Modern Tab Section — full pill glass with a real
                          // painted specular highlight, matching the reference
                          // image's bubble-glass look.
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: LiquidGlassContainer(
                              borderRadius: 30,
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  _buildModernTab(
                                      context,
                                      AppLocalizations.of(context)!.completed,
                                      0,
                                      selectedIndex),
                                  _buildModernTab(
                                      context,
                                      AppLocalizations.of(context)!.upcoming,
                                      1,
                                      selectedIndex),
                                  _buildModernTab(
                                      context,
                                      AppLocalizations.of(context)!.cancelled,
                                      2,
                                      selectedIndex),
                                ],
                              ),
                            ),
                          ),

                          // Content Section
                          Expanded(
                            child: SingleChildScrollView(
                              controller: context.read<AccBloc>().scrollController,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    if (context.read<AccBloc>().isLoading &&
                                        context.read<AccBloc>().firstLoad)
                                      HistoryShimmer(size: size),
                                    if (!context.read<AccBloc>().isLoading &&
                                        context.read<AccBloc>().historyList.isEmpty)
                                      SizedBox(
                                        height: size.height * 0.6,
                                        child: const Center(
                                          child: HistoryNodataWidget(),
                                        ),
                                      ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: context
                                          .read<AccBloc>()
                                          .historyList
                                          .length,
                                      itemBuilder: (_, index) {
                                        final history = context
                                            .read<AccBloc>()
                                            .historyList
                                            .elementAt(index);
                                        return Padding(
                                          padding:
                                          const EdgeInsets.only(bottom: 12),
                                          child: InkWell(
                                            onTap: () {
                                              if (history.isLater == true &&
                                                  history.isCancelled != 1) {
                                                if (history.isOutStation == 1 &&
                                                    history.driverDetail == null) {
                                                  Navigator.pushNamed(
                                                      context,
                                                      OutStationOfferedPage
                                                          .routeName,
                                                      arguments:
                                                      OutStationOfferedPageArguments(
                                                        requestId: history.id,
                                                        currencySymbol: history
                                                            .requestedCurrencySymbol,
                                                        dropAddress:
                                                        history.dropAddress,
                                                        pickAddress:
                                                        history.pickAddress,
                                                        updatedAt: history
                                                            .tripStartTimeWithDate,
                                                        offeredFare: history
                                                            .offerredRideFare
                                                            .toString(),
                                                      )).then(
                                                        (value) {
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      context
                                                          .read<AccBloc>()
                                                          .historyList
                                                          .clear();
                                                      context.read<AccBloc>().add(
                                                          HistoryGetEvent(
                                                              historyFilter:
                                                              'is_later=1'));
                                                    },
                                                  );
                                                } else {
                                                  Navigator.pushNamed(
                                                    context,
                                                    HistoryTripSummaryPage
                                                        .routeName,
                                                    arguments: TripHistoryPageArguments(
                                                        historyData: history,
                                                        historyIndex: index,
                                                        isSupportTicketEnabled: widget
                                                            .arg
                                                            .isSupportTicketEnabled,
                                                        pageNumber: context
                                                            .read<AccBloc>()
                                                            .historyPaginations!
                                                            .pagination
                                                            .currentPage),
                                                  ).then((value) {
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    context
                                                        .read<AccBloc>()
                                                        .historyList
                                                        .clear();
                                                    context.read<AccBloc>().add(
                                                      HistoryGetEvent(
                                                          historyFilter: (context
                                                              .read<
                                                              AccBloc>()
                                                              .selectedHistoryType ==
                                                              0)
                                                              ? "is_completed=1"
                                                              : (context
                                                              .read<
                                                              AccBloc>()
                                                              .selectedHistoryType ==
                                                              1)
                                                              ? "is_later=1"
                                                              : "is_cancelled=1",
                                                          pageNumber: context
                                                              .read<AccBloc>()
                                                              .historyPaginations!
                                                              .pagination
                                                              .currentPage),
                                                    );
                                                    context
                                                        .read<AccBloc>()
                                                        .add(AccUpdateEvent());
                                                  });
                                                }
                                              } else {
                                                Navigator.pushNamed(
                                                  context,
                                                  HistoryTripSummaryPage.routeName,
                                                  arguments: TripHistoryPageArguments(
                                                      historyData: history,
                                                      historyIndex: index,
                                                      isSupportTicketEnabled: widget
                                                          .arg
                                                          .isSupportTicketEnabled,
                                                      pageNumber: context
                                                          .read<AccBloc>()
                                                          .historyPaginations!
                                                          .pagination
                                                          .currentPage),
                                                ).then((value) {
                                                  if (!context.mounted) return;
                                                  context.read<AccBloc>().add(
                                                    HistoryGetEvent(
                                                        historyFilter: (context
                                                            .read<
                                                            AccBloc>()
                                                            .selectedHistoryType ==
                                                            0)
                                                            ? "is_completed=1"
                                                            : (context
                                                            .read<
                                                            AccBloc>()
                                                            .selectedHistoryType ==
                                                            1)
                                                            ? "is_later=1"
                                                            : "is_cancelled=1",
                                                        pageNumber: context
                                                            .read<AccBloc>()
                                                            .historyPaginations!
                                                            .pagination
                                                            .currentPage),
                                                  );
                                                  context
                                                      .read<AccBloc>()
                                                      .add(AccUpdateEvent());
                                                });
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: HistoryCardWidget(
                                                cont: context, history: history),
                                          ),
                                        );
                                      },
                                    ),
                                    if (context
                                        .read<AccBloc>()
                                        .walletHistoryList
                                        .isNotEmpty &&
                                        context.read<AccBloc>().loadMore)
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: SizedBox(
                                              height: size.width * 0.08,
                                              width: size.width * 0.08,
                                              child:
                                              const CircularProgressIndicator()),
                                        ),
                                      ),
                                    SizedBox(height: size.width * 0.2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernTab(
      BuildContext context, String title, int index, int selectedIndex) {
    final isSelected = index == selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index != selectedIndex && !context.read<AccBloc>().isLoading) {
            context.read<AccBloc>().historyList.clear();
            context.read<AccBloc>().add(AccUpdateEvent());
            context
                .read<AccBloc>()
                .add(HistoryTypeChangeEvent(historyTypeIndex: index));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(

            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: MyText(
              text: title,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected
                    ? AppColors.white
                    : Theme.of(context).primaryColorDark,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}