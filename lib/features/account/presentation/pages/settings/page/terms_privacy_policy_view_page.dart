import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/settings_document_content.dart';

class TermsPrivacyPolicyViewPage extends StatelessWidget {
  static const String routeName = '/termsPrivacyPolicyViewPage';
  final TermsAndPrivacyPolicyArguments args;
  const TermsPrivacyPolicyViewPage({super.key, required this.args});
  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetHtmlStringEvent(isPrivacy: args.isPrivacyPolicy)),
      child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
        final bloc = context.read<AccBloc>();
        final l10n = AppLocalizations.of(context)!;
        final title = args.isPrivacyPolicy ? l10n.privacyPolicy : l10n.terms;
        final html = bloc.htmlString ?? '';
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
                  toolbarHeight: MediaQuery.textScalerOf(context).scale(22) > 32
                      ? 120
                      : 64,
                  foregroundColor: AccountStyle.ink(context),
                  title: Text(title,
                      maxLines: 2,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 22, fontWeight: FontWeight.w700))),
              body: SafeArea(
                  top: false,
                  child: html.trim().isNotEmpty
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: PolicyDocumentCard(
                              html: html,
                              title: title,
                              privacy: args.isPrivacyPolicy))
                      : bloc.isHtmlLoading
                          ? const SettingsContentPlaceholder()
                          : CustomScrollView(slivers: [
                              SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: SettingsContentNotice(
                                      icon: args.isPrivacyPolicy
                                          ? Icons.privacy_tip_outlined
                                          : Icons.description_outlined,
                                      failed: bloc.hasHtmlLoadFailed,
                                      onRetry: () => bloc.add(
                                          GetHtmlStringEvent(
                                              isPrivacy:
                                                  args.isPrivacyPolicy))))
                            ])),
            ));
      }));
}
