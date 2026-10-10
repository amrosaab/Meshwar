import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_arguments.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/coupon_list_widget.dart';
import '../widget/coupon_content.dart';
import '../widget/coupon_shimmer.dart';

class CouponsListPage extends StatelessWidget {
  const CouponsListPage({super.key, required this.args});
  final CouponListPageArguments args;
  static const String routeName = '/couponsListPage';
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(AccGetDirectionEvent())
          ..add(GetPromoCodeListEvent()),
        child: BlocListener<AccBloc, AccState>(listener: (context, state) {
          final bloc = context.read<AccBloc>();
          final l10n = AppLocalizations.of(context)!;
          if (state is PromoApplySuccessState) {
            showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                      icon: const Center(
                          child: RideColorBadge(
                              icon: Icons.check_rounded,
                              gradient: RideVisuals.green,
                              size: 56,
                              iconSize: 30,
                              radius: 19)),
                      title: Text(l10n.promoApplied.replaceAll(
                          '111', "'${bloc.selectedPromoCodeValue}'")),
                      content: Text(l10n.appliedPromoText.replaceAll('111',
                          '${args.userData.currencySymbol}${bloc.selectedPromoPrice}')),
                      actions: [
                        FilledButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text(l10n.okText))
                      ],
                    ));
            bloc.add(GetPromoCodeListEvent());
          } else if (state is PromoApplyFailureState ||
              state is PromoCodeListFailureState ||
              state is PromoClearFailureState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.tryAgain)));
          } else if (state is PromoClearSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.couponRemovedSuccessfully)));
          }
        }, child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final l10n = AppLocalizations.of(context)!;
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
                title: Text(l10n.coupon,
                    maxLines: 2,
                    style: AccountStyle.text(context)
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
                actions: [
                  IconButton(
                      tooltip: l10n.refresh,
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: bloc.isLoading || bloc.isPromoChanging
                          ? null
                          : () => bloc.add(GetPromoCodeListEvent()))
                ],
              ),
              body: bloc.promoCodeDataList.isNotEmpty
                  ? CouponsListWidget(
                      cont: context,
                      promoCodeDataList: bloc.promoCodeDataList,
                      currencySymbol: args.userData.currencySymbol)
                  : CustomScrollView(slivers: [
                      if (bloc.isLoading)
                        SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: SliverToBoxAdapter(
                                child: CouponShimmer(
                                    size: MediaQuery.sizeOf(context))))
                      else
                        SliverFillRemaining(
                            hasScrollBody: false,
                            child: CouponEmptyContent(
                                onRefresh: () =>
                                    bloc.add(GetPromoCodeListEvent()))),
                    ]),
            ),
          );
        })),
      );
}
