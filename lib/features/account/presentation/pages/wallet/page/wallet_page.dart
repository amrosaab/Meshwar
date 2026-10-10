import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/add_money_wallet_widget.dart';
import '../widget/card_list_widget.dart';
import '../widget/wallet_content.dart';
import '../widget/wallet_history_shimmer.dart';
import '../widget/wallet_transfer_money_widget.dart';

class WalletHistoryPage extends StatelessWidget {
  static const String routeName = '/walletHistory';
  final WalletPageArguments arg;
  const WalletHistoryPage({super.key, required this.arg});

  Future<void> _refresh(AccBloc bloc) async {
    if (bloc.isLoading || bloc.loadMore) return;
    final completed = bloc.stream.firstWhere((state) =>
        state is WalletHistorySuccessState ||
        state is WalletHistoryFailureState);
    bloc.showRefresh = false;
    bloc.add(GetWalletHistoryListEvent(pageIndex: 1));
    await completed;
  }

  void _addMoney(BuildContext context, AccBloc bloc) {
    final wallet = bloc.walletResponse;
    if (wallet == null) return;
    bloc.walletAmountController.clear();
    bloc.addMoney = null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColors.surfaceStrong(context),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => FractionallySizedBox(
          heightFactor: 1,
          child: AddMoneyWalletWidget(
              cont: context,
              minWalletAmount: wallet.minimumAmountAddedToWallet)),
    );
  }

  void _transfer(BuildContext context, AccBloc bloc) {
    bloc.transferAmount.clear();
    bloc.transferPhonenumber.clear();
    bloc.dropdownValue = 'user';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      clipBehavior: Clip.antiAlias,
      builder: (_) => WalletTransferMoneyWidget(cont: context),
    );
  }

  Future<void> _manageCards(BuildContext context, AccBloc bloc) async {
    await Navigator.pushNamed(context, CardListWidget.routeName,
        arguments:
            PaymentMethodArguments(userData: bloc.userData ?? arg.userData));
    if (!context.mounted) return;
    bloc.add(GetWalletHistoryListEvent(pageIndex: 1));
    bloc.add(CardListEvent());
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(WalletPageInitEvent(arg: arg))
          ..add(CardListEvent()),
        child: BlocListener<AccBloc, AccState>(
          listener: (context, state) {
            final bloc = context.read<AccBloc>();
            if (state is MoneyTransferedSuccessState) {
              Navigator.pop(context);
            } else if (state is WalletPageReUpdateState) {
              bloc.showRefresh = true;
              Navigator.of(context, rootNavigator: true).popUntil((route) =>
                  route.isFirst ||
                  route.settings.name == WalletHistoryPage.routeName);
              bloc.add(AddMoneyWebViewUrlEvent(
                currencySymbol: state.currencySymbol,
                from: '',
                requestId: state.requestId,
                money: state.money,
                url: state.url,
                userId: state.userId,
                context: context,
              ));
            }
          },
          child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
            final bloc = context.read<AccBloc>();
            final l10n = AppLocalizations.of(context)!;
            final user = bloc.userData ?? arg.userData;
            final wallet = bloc.walletResponse;
            final balance = wallet == null
                ? null
                : '${wallet.currencySymbol} ${double.tryParse(wallet.walletBalance)?.toStringAsFixed(2) ?? wallet.walletBalance}';
            final actions = <Widget>[
              if (user.showWalletAddMoneyFeatureOnMobileApp == '1')
                WalletActionCard(
                    label: l10n.addMoney,
                    icon: Icons.add_rounded,
                    gradient: RideVisuals.blue,
                    onPressed:
                        wallet == null ? null : () => _addMoney(context, bloc)),
              if (user.showWalletMoneyTransferFeatureOnMobileApp == '1')
                WalletActionCard(
                    label: l10n.transferText,
                    icon: Icons.swap_horiz_rounded,
                    gradient: RideVisuals.green,
                    onPressed:
                        wallet == null ? null : () => _transfer(context, bloc)),
            ];
            return Scaffold(
              backgroundColor: RideVisuals.canvas(context),
              appBar: AppBar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.bgAsphaltLight
                    : Colors.white,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0,
                toolbarHeight: 72,
                titleSpacing: 20,
                centerTitle: false,
                title: Row(children: [
                  const ExcludeSemantics(
                      child: RideColorBadge(
                          icon: Icons.account_balance_wallet_rounded,
                          gradient: RideVisuals.blue,
                          size: 40,
                          iconSize: 22,
                          radius: 14)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(l10n.wallet,
                          style: WalletStyle.text(context).copyWith(
                              fontSize: 22, fontWeight: FontWeight.w700))),
                ]),
              ),
              body: RefreshIndicator(
                color: AppColors.meshwarRed,
                onRefresh: () => _refresh(bloc),
                child: CustomScrollView(
                  controller: bloc.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                      sliver: SliverToBoxAdapter(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (bloc.showRefresh) ...[
                            Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: TextButton.icon(
                                    onPressed: () => _refresh(bloc),
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: Text(l10n.refresh))),
                            const SizedBox(height: 12),
                          ],
                          WalletBalanceCard(
                              label: l10n.walletBalance, balance: balance),
                          if (actions.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            LayoutBuilder(builder: (context, constraints) {
                              if (constraints.maxWidth < 300 ||
                                  MediaQuery.textScalerOf(context).scale(14) >
                                      20) {
                                return Column(children: [
                                  for (var i = 0; i < actions.length; i++) ...[
                                    if (i > 0) const SizedBox(height: 12),
                                    SizedBox(
                                        width: double.infinity,
                                        child: actions[i]),
                                  ],
                                ]);
                              }
                              return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i = 0;
                                        i < actions.length;
                                        i++) ...[
                                      if (i > 0) const SizedBox(width: 12),
                                      Expanded(child: actions[i]),
                                    ]
                                  ]);
                            }),
                          ],
                          if (wallet?.enableSaveCard == true) ...[
                            const SizedBox(height: 28),
                            Row(children: [
                              Expanded(
                                  child:
                                      _sectionTitle(context, l10n.savedCards)),
                              IconButton(
                                  tooltip: l10n.addCard,
                                  onPressed: () => _manageCards(context, bloc),
                                  icon: const Icon(Icons.add_rounded)),
                            ]),
                            const SizedBox(height: 12),
                            if (bloc.savedCardsList.isEmpty)
                              WalletActionCard(
                                  label: l10n.addCard,
                                  icon: Icons.credit_card_rounded,
                                  gradient: RideVisuals.blue,
                                  onPressed: () => _manageCards(context, bloc)),
                            for (final card in bloc.savedCardsList) ...[
                              WalletSavedCard(
                                  brand: card.cardType,
                                  lastNumber: card.lastNumber
                                      .toString()
                                      .padLeft(4, '0'),
                                  onPressed: () => _manageCards(context, bloc)),
                              const SizedBox(height: 10),
                            ],
                          ],
                          const SizedBox(height: 28),
                          _sectionTitle(context, l10n.recentTransactions),
                          const SizedBox(height: 16),
                          if (wallet == null &&
                              bloc.firstLoad &&
                              bloc.isLoading)
                            for (var i = 0; i < 3; i++)
                              ShimmerWalletHistory(
                                  size: MediaQuery.sizeOf(context)),
                          if (!bloc.isLoading && bloc.walletHistoryList.isEmpty)
                            WalletEmptyTransactions(
                                title: l10n.paymenyHistoryEmpty,
                                message: l10n.paymenyHistoryEmptyText),
                        ],
                      )),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((_, index) {
                        final transaction = bloc.walletHistoryList[index];
                        final currency = transaction.currencySymbol.isNotEmpty
                            ? transaction.currencySymbol
                            : wallet?.currencySymbol ?? '';
                        final amount = NumberFormat.currency(
                                locale: 'en_IN', symbol: '', decimalDigits: 2)
                            .format(transaction.amount);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: WalletTransactionTile(
                              remarks: transaction.remarks,
                              date: transaction.createdAt,
                              amount:
                                  '${transaction.isCredit == 0 ? '- ' : ''}$currency $amount',
                              isDebit: transaction.isCredit == 0),
                        );
                      }, childCount: bloc.walletHistoryList.length)),
                    ),
                    if (bloc.loadMore)
                      const SliverToBoxAdapter(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                  child: SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))))),
                    SliverToBoxAdapter(
                        child: SizedBox(
                            height: MediaQuery.paddingOf(context).bottom + 20)),
                  ],
                ),
              ),
            );
          }),
        ),
      );

  Widget _sectionTitle(BuildContext context, String title) => Semantics(
      header: true,
      child: Text(title,
          style: WalletStyle.text(context)
              .copyWith(fontSize: 18, fontWeight: FontWeight.w700)));
}
