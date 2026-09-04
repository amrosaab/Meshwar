import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/liquid_glass_container.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/app_images.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/application/auth_bloc.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/add_money_wallet_widget.dart';
import '../widget/card_list_widget.dart';
import '../widget/wallet_history_list_widget.dart';
import '../widget/wallet_history_shimmer.dart';
import '../widget/wallet_transfer_money_widget.dart';

class WalletHistoryPage extends StatelessWidget {
  static const String routeName = '/walletHistory';
  final WalletPageArguments arg;

  const WalletHistoryPage({
    super.key,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(WalletPageInitEvent(arg: arg))
        ..add(CardListEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          final accBloc = context.read<AccBloc>();
          if (state is AuthInitialState) {
            CustomLoader.loader(context);
          } else if (state is MoneyTransferedSuccessState) {
            Navigator.pop(context);
          } else if (state is WalletPageReUpdateState) {
            accBloc.showRefresh = true;
            Navigator.of(context, rootNavigator: true).popUntil((route) =>
            route.isFirst ||
                route.settings.name == WalletHistoryPage.routeName);
            accBloc.add(
              AddMoneyWebViewUrlEvent(
                currencySymbol: state.currencySymbol,
                from: '',
                requestId: state.requestId,
                money: state.money,
                url: state.url,
                userId: state.userId,
                context: context,
              ),
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();

          print('asdasdas${context.read<AccBloc>().walletResponse}');
          if (accBloc.userData == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.wallet,
                titleFontSize: 18,
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  Future<void> onrefresh() async {
                    accBloc.add(GetWalletHistoryListEvent(pageIndex: 1));
                  }

                  return onrefresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(minHeight: size.height),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Refresh Button
                        if (accBloc.showRefresh)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.width * 0.03),
                              child: InkWell(
                                onTap: () {
                                  accBloc.showRefresh = false;
                                  accBloc.add(
                                      GetWalletHistoryListEvent(pageIndex: 1));
                                },
                                child: Column(
                                  children: [
                                    const Icon(Icons.refresh_outlined,
                                        size: 28),
                                    SizedBox(height: size.width * 0.01),
                                    MyText(
                                      text:
                                      AppLocalizations.of(context)!.refresh,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Wallet Balance Card
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            size.width * 0.04,
                            size.width * 0.02,
                            size.width * 0.04,
                            size.width * 0.04,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.meshwarRed.withOpacity(0.25),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: AppColors.beaconGradient,
                              ),
                              padding: EdgeInsets.all(size.width * 0.05),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .walletBalance,
                                      textStyle: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: size.width * 0.02),
                                    if (context.read<AccBloc>().isLoading &&
                                        !context.read<AccBloc>().loadMore)
                                      SizedBox(
                                        height: size.width * 0.08,
                                        width: size.width * 0.08,
                                        child: const CircularProgressIndicator(
                                          color: AppColors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    if (context.read<AccBloc>().walletResponse !=
                                        null)
                                      MyText(
                                        text:
                                        '${context.read<AccBloc>().walletResponse!.currencySymbol} ${double.tryParse(context.read<AccBloc>().walletResponse!.walletBalance) != null ? double.tryParse(context.read<AccBloc>().walletResponse!.walletBalance)!.toStringAsFixed(2) : context.read<AccBloc>().walletResponse!.walletBalance}',
                                        textStyle: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    SizedBox(height: size.width * 0.05),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            size.width * 0.04,
                            size.width * 0.02,
                            size.width * 0.04,
                            size.width * 0.04,
                          ),
                          child: Row(
                            children: [
                              if (context
                                  .read<AccBloc>()
                                  .userData!
                                  .showWalletAddMoneyFeatureOnMobileApp ==
                                  '1') ...[
                                Expanded(
                                  child: _buildActionButton(
                                    context: context,
                                    label:
                                    AppLocalizations.of(context)!.addMoney,
                                    onPressed: () {
                                      context
                                          .read<AccBloc>()
                                          .walletAmountController
                                          .clear();
                                      context.read<AccBloc>().addMoney = null;
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        enableDrag: false,
                                        isDismissible: true,
                                        useSafeArea: true,
                                        backgroundColor:
                                        AppColors.surfaceStrong(context),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16)),
                                        ),
                                        builder: (_) {
                                          return FractionallySizedBox(
                                            heightFactor: 1.0,
                                            child: AddMoneyWalletWidget(
                                              cont: context,
                                              minWalletAmount: context
                                                  .read<AccBloc>()
                                                  .walletResponse!
                                                  .minimumAmountAddedToWallet,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                              if (context
                                  .read<AccBloc>()
                                  .userData!
                                  .showWalletMoneyTransferFeatureOnMobileApp ==
                                  '1') ...[
                                if (context
                                    .read<AccBloc>()
                                    .userData!
                                    .showWalletAddMoneyFeatureOnMobileApp ==
                                    '1') ...[
                                  SizedBox(width: size.width * 0.02),
                                ],
                                Expanded(
                                  child: _buildActionButton(
                                    context: context,
                                    label: AppLocalizations.of(context)!
                                        .transferText,
                                    onPressed: () {
                                      context
                                          .read<AccBloc>()
                                          .transferAmount
                                          .clear();
                                      context
                                          .read<AccBloc>()
                                          .transferPhonenumber
                                          .clear();
                                      context.read<AccBloc>().dropdownValue =
                                      'user';
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        enableDrag: false,
                                        isDismissible: true,
                                        builder: (_) {
                                          return WalletTransferMoneyWidget(
                                              cont: context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Saved Cards Section
                        if (context.read<AccBloc>().walletResponse != null &&
                            context
                                .read<AccBloc>()
                                .walletResponse!
                                .enableSaveCard)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText(
                                      text: AppLocalizations.of(context)!
                                          .savedCards,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .primaryColorDark,
                                      ),
                                    ),
                                    if (context
                                        .read<AccBloc>()
                                        .savedCardsList
                                        .isNotEmpty)
                                      IconButton(
                                        icon:
                                        const Icon(Icons.arrow_forward_ios),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            CardListWidget.routeName,
                                            arguments: PaymentMethodArguments(
                                                userData: context
                                                    .read<AccBloc>()
                                                    .userData!),
                                          ).then((value) {
                                            if (!context.mounted) return;
                                            context.read<AccBloc>().add(
                                                GetWalletHistoryListEvent(
                                                    pageIndex: 1));
                                            context
                                                .read<AccBloc>()
                                                .add(CardListEvent());
                                          });
                                        },
                                      )
                                  ],
                                ),
                                SizedBox(height: size.width * 0.03),
                                if (context
                                    .read<AccBloc>()
                                    .savedCardsList
                                    .isEmpty) ...[
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        CardListWidget.routeName,
                                        arguments: PaymentMethodArguments(
                                            userData: context
                                                .read<AccBloc>()
                                                .userData!),
                                      ).then((value) {
                                        if (!context.mounted) return;
                                        context.read<AccBloc>().add(
                                            GetWalletHistoryListEvent(
                                                pageIndex: 1));
                                        context
                                            .read<AccBloc>()
                                            .add(CardListEvent());
                                      });
                                    },
                                    child: Container(
                                      padding:
                                      EdgeInsets.all(size.width * 0.04),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color:
                                            AppColors.surfaceBorder(context)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            color: Theme.of(context).hintColor,
                                            size: 24,
                                          ),
                                          const SizedBox(height: 16),
                                          MyText(
                                            text: AppLocalizations.of(context)!
                                                .noCardsAdded,
                                            textAlign: TextAlign.center,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .hintColor,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          CustomButton(
                                            buttonName:
                                            AppLocalizations.of(context)!
                                                .addCard,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                CardListWidget.routeName,
                                                arguments:
                                                PaymentMethodArguments(
                                                    userData: context
                                                        .read<AccBloc>()
                                                        .userData!),
                                              ).then((value) {
                                                if (!context.mounted) return;
                                                context.read<AccBloc>().add(
                                                    GetWalletHistoryListEvent(
                                                        pageIndex: 1));
                                                context
                                                    .read<AccBloc>()
                                                    .add(CardListEvent());
                                              });
                                            },
                                            width: size.width,
                                            buttonColor: AppColors.primary,
                                            textColor: AppColors.white,
                                            textSize: 16,
                                            borderRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: context
                                        .read<AccBloc>()
                                        .savedCardsList
                                        .length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: size.width * 0.02),
                                    itemBuilder: (context, index) {
                                      final card = context
                                          .read<AccBloc>()
                                          .savedCardsList
                                          .elementAt(index);
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          gradient: AppColors.beaconGradient,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Image.asset(
                                                  AppImages.simCard,
                                                  height: size.width * 0.1,
                                                  width: size.width * 0.1,
                                                ),
                                                Image.asset(
                                                  (card.cardType
                                                      .toLowerCase()
                                                      .contains('visa'))
                                                      ? AppImages.visa
                                                      : (card.cardType
                                                      .toLowerCase()
                                                      .contains(
                                                      'eftpos'))
                                                      ? AppImages.eftpos
                                                      : (card.cardType
                                                      .toLowerCase()
                                                      .contains(
                                                      'american'))
                                                      ? AppImages
                                                      .americanExpress
                                                      : (card.cardType
                                                      .toLowerCase()
                                                      .contains(
                                                      'jcb'))
                                                      ? AppImages
                                                      .jcb
                                                      : (card.cardType
                                                      .toLowerCase()
                                                      .contains(
                                                      'discover || dinners'))
                                                      ? AppImages
                                                      .discover
                                                      : AppImages
                                                      .master,
                                                  height: size.width * 0.1,
                                                  width: size.width * 0.2,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: size.width * 0.04),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                MyText(
                                                  text:
                                                  '**** **** **** ${card.lastNumber}',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                    color: AppColors.white,
                                                    fontSize:
                                                    size.width * 0.06,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        SizedBox(
                          height: size.width * 0.05,
                        ),

                        // Recent Transactions Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.width * 0.02),
                          child: MyText(
                            text: AppLocalizations.of(context)!
                                .recentTransactions,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              fontSize: 18,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),

                        // Transaction List
                        if (context.read<AccBloc>().isLoading &&
                            context.read<AccBloc>().firstLoad)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return ShimmerWalletHistory(size: size);
                            },
                          )
                        else if (context
                            .read<AccBloc>()
                            .walletHistoryList
                            .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                WalletHistoryDataWidget(
                                  walletHistoryList:
                                  context.read<AccBloc>().walletHistoryList,
                                  cont: context,
                                ),
                                if (context.read<AccBloc>().loadMore)
                                  Padding(
                                    padding: EdgeInsets.all(size.width * 0.04),
                                    child: const CircularProgressIndicator(),
                                  ),
                              ],
                            ),
                          )
                        else
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: size.width * 0.15),
                              child: Column(
                                children: [
                                  LiquidGlassContainer(
                                    circular: true,
                                    width: 148,
                                    height: 148,
                                    blurSigma: 14,
                                    fillOpacity: 0.1,
                                    child: Center(
                                      child: Image.asset(
                                        AppImages.noData,
                                        height: 92,
                                        width: 92,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  MyText(
                                    text: AppLocalizations.of(context)!
                                        .noWalletHistory,
                                    textAlign: TextAlign.center,
                                    textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: LiquidGlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}//