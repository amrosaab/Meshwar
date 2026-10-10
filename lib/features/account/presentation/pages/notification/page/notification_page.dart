import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../widgets/account_content.dart';
import '../../../../application/acc_bloc.dart';
import '../widget/notification_card_widget.dart';
import '../widget/notification_content.dart';
import '../widget/notification_page_shimmer.dart';

class NotificationPage extends StatelessWidget {
  static const String routeName = '/notification';
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(AccGetDirectionEvent())
          ..add(NotificationGetEvent()),
        child: BlocListener<AccBloc, AccState>(
          listener: (context, state) {
            final bloc = context.read<AccBloc>();
            final pagination = bloc.notificationPaginations?.pagination;
            if (state is NotificationDeletedSuccess &&
                bloc.notificationDatas.isEmpty &&
                pagination != null &&
                pagination.currentPage < pagination.totalPages) {
              bloc.add(NotificationGetEvent());
            }
            if (state is NotificationFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
            final bloc = context.read<AccBloc>();
            final l10n = AppLocalizations.of(context)!;
            final pagination = bloc.notificationPaginations?.pagination;
            final hasMore = pagination != null &&
                pagination.currentPage < pagination.totalPages;
            return Directionality(
              textDirection: bloc.textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: RideVisuals.canvas(context),
                appBar: AppBar(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.bgAsphaltLight
                          : Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: false,
                  foregroundColor: AccountStyle.ink(context),
                  toolbarHeight:
                      MediaQuery.textScalerOf(context).scale(22) > 32 ? 96 : 64,
                  title: Text(l10n.notifications,
                      maxLines: 2,
                      style: AccountStyle.text(context)
                          .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
                ),
                body: CustomScrollView(slivers: [
                  if (bloc.notificationDatas.isNotEmpty)
                    SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                        sliver: SliverToBoxAdapter(
                            child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.delete_sweep_outlined,
                                      size: 20),
                                  label: Text(l10n.clearAll),
                                  style: TextButton.styleFrom(
                                      foregroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? const Color(0xFFFF82A6)
                                              : AppColors.meshwarRed),
                                  onPressed: bloc.isLoading
                                      ? null
                                      : () async {
                                          final confirmed = await showDialog<
                                                  bool>(
                                              context: context,
                                              builder: (dialogContext) =>
                                                  AlertDialog(
                                                      title: Text(l10n
                                                          .clearNotifications),
                                                      content: Text(l10n
                                                          .clearNotificationsText),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    dialogContext,
                                                                    false),
                                                            child: Text(
                                                                l10n.cancel)),
                                                        FilledButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    dialogContext,
                                                                    true),
                                                            child: Text(
                                                                l10n.confirm)),
                                                      ]));
                                          if (confirmed == true &&
                                              context.mounted) {
                                            bloc.add(
                                                ClearAllNotificationsEvent());
                                          }
                                        },
                                )))),
                  if (bloc.notificationDatas.isEmpty && bloc.isLoading)
                    SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverToBoxAdapter(
                            child: NotificationShimmer(
                                size: MediaQuery.sizeOf(context)))),
                  if (bloc.notificationDatas.isEmpty && !bloc.isLoading)
                    SliverFillRemaining(
                        hasScrollBody: false,
                        child: NotificationEmptyContent(
                            label: l10n.noNotification)),
                  SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList.builder(
                          itemCount: bloc.notificationDatas.length,
                          itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: NotificationCardWidget(
                                  cont: context,
                                  notificationData:
                                      bloc.notificationDatas[index])))),
                  if (hasMore && bloc.notificationDatas.isNotEmpty)
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
                                        onPressed: () => bloc.add(
                                            NotificationGetEvent(
                                                pageNumber:
                                                    pagination.currentPage +
                                                        1)),
                                        icon: const Icon(
                                            Icons.expand_more_rounded),
                                        label: Text(l10n.loadMore))))),
                  SliverToBoxAdapter(
                      child: SizedBox(
                          height: MediaQuery.paddingOf(context).bottom + 12)),
                ]),
              ),
            );
          }),
        ),
      );
}
