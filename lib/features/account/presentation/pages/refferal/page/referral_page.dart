import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/application/auth_bloc.dart';
import '../../../../../home/presentation/pages/home_page.dart';
import '../../../../../userprofile/presentation/pages/driver_profile_pages.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/referral_content.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key, required this.args});
  final ReferralArguments args;
  static const String routeName = '/ReferralPage';

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  ReferralArguments get args => widget.args;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(AccGetDirectionEvent())
          ..add(AccGetUserDetailsEvent())
          ..add(ReferralResponseEvent()),
        child: BlocListener<AccBloc, AccState>(listener: (context, state) {
          if (state is ReferralSuccessState) {
            final user = context.read<AuthBloc>().userData;
            if (user?.approve == 0 && user?.enableUserDocument == '1') {
              Navigator.pushNamedAndRemoveUntil(
                  context, DriverProfilePage.routeName, (_) => false,
                  arguments:
                      const DriverProfilePageArguments(from: 'onboarding'));
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.routeName, (_) => false);
            }
          }
        }, child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final bloc = context.read<AccBloc>();
          final user = bloc.userData ?? args.userData;
          final l10n = AppLocalizations.of(context)!;
          final code = user.refferalCode;
          final html =
              bloc.referralResponse?.data.referralContent.data.description ??
                  '';
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
                title: Text(args.title,
                    maxLines: 2,
                    style: AccountStyle.text(context)
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
              ),
              body: ListView(padding: const EdgeInsets.all(20), children: [
                ReferralRewardCard(
                    message: user.referralComissionString.isEmpty
                        ? l10n.referEarn
                        : user.referralComissionString),
                const SizedBox(height: 18),
                ReferralCodeCard(
                    code: code,
                    onCopy: () async {
                      await Clipboard.setData(ClipboardData(text: code));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.referralCodeCopy)));
                    }),
                const SizedBox(height: 18),
                ReferralTabs(
                    showHistory: bloc.showReferralHistory,
                    onSelected: (history) {
                      bloc.add(
                          ReferralTabChangeEvent(showReferralHistory: history));
                      if (history && !bloc.hasLoadedReferralHistory) {
                        bloc.add(ReferalHistoryEvent());
                      }
                    }),
                const SizedBox(height: 20),
                if (bloc.showReferralHistory) ...[
                  if (bloc.isReferralHistoryLoading &&
                      bloc.referralHistory.isEmpty)
                    const _ReferralLoading(),
                  if (!bloc.isReferralHistoryLoading &&
                      bloc.referralHistory.isEmpty)
                    ReferralNotice(
                        message: state is ReferalHistoryFailureState
                            ? l10n.referralContentUnavailable
                            : l10n.noReferralHistoryFound,
                        onRetry: () => bloc.add(ReferalHistoryEvent())),
                  for (final item in bloc.referralHistory) ...[
                    ReferralHistoryTile(
                        name: item.name,
                        date: item.createdAt,
                        earning: '${item.currencySymbol}${item.earning}',
                        status: item.referralStatus.isEmpty
                            ? ''
                            : item.referralStatus[0].toUpperCase() +
                                item.referralStatus.substring(1).toLowerCase()),
                    const SizedBox(height: 14),
                  ],
                ] else ...[
                  if (bloc.isReferralContentLoading && html.isEmpty)
                    const _ReferralLoading(),
                  if (!bloc.isReferralContentLoading && html.isEmpty)
                    ReferralNotice(
                        message: l10n.referralContentUnavailable,
                        onRetry: () => bloc.add(ReferralResponseEvent())),
                  if (html.isNotEmpty)
                    ReferralSurface(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(children: [
                            const ExcludeSemantics(
                                child: RideColorBadge(
                                    icon: Icons.auto_awesome_rounded,
                                    gradient: RideVisuals.blue,
                                    size: 36,
                                    iconSize: 19,
                                    radius: 12)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Text(l10n.howItWorks,
                                    style: AccountStyle.text(context).copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700))),
                          ]),
                          const SizedBox(height: 16),
                          Html(data: html, style: {
                            'body': Style(
                                fontSize: FontSize(14),
                                color: AccountStyle.muted(context),
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero),
                            'strong': Style(
                                color: AccountStyle.ink(context),
                                fontWeight: FontWeight.w600),
                            'li': Style(margin: Margins.only(bottom: 12)),
                          }),
                        ])),
                ],
              ]),
              bottomNavigationBar: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Builder(
                      builder: (buttonContext) => FilledButton.icon(
                            onPressed: code.isEmpty
                                ? null
                                : () async {
                                    final box = buttonContext.findRenderObject()
                                        as RenderBox?;
                                    await SharePlus.instance.share(ShareParams(
                                        text:
                                            "${l10n.referralInviteText.replaceAll('****', code).replaceAll('**', AppConstants.title)}\n${user.androidApp} \n${user.iosApp}",
                                        sharePositionOrigin: box == null
                                            ? null
                                            : box.localToGlobal(Offset.zero) &
                                                box.size));
                                  },
                            icon: const Icon(Icons.ios_share_rounded, size: 20),
                            label: Text(l10n.invite,
                                style: AccountStyle.text(context).copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            style: FilledButton.styleFrom(
                                backgroundColor: AppColors.meshwarRed,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(58),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ))),
            ),
          );
        })),
      );
}

class _ReferralLoading extends StatelessWidget {
  const _ReferralLoading();
  @override
  Widget build(BuildContext context) => ReferralSurface(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: LinearProgressIndicator(
              color: AppColors.meshwarRed,
              backgroundColor: AppColors.surfaceBorder(context),
              minHeight: 3)));
}
