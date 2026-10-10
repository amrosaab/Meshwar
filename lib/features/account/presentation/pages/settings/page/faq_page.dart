import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/app_colors.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/faq_list_widget.dart';
import '../widget/settings_document_content.dart';

class FaqPage extends StatelessWidget {
  static const String routeName = '/faqPage';
  const FaqPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (_) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetFaqListEvent()),
      child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
        final bloc = context.read<AccBloc>();
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
                  toolbarHeight:
                      MediaQuery.textScalerOf(context).scale(22) > 32 ? 96 : 64,
                  foregroundColor: AccountStyle.ink(context),
                  title: Text(AppLocalizations.of(context)!.faq,
                      style: AccountStyle.text(context).copyWith(
                          fontSize: 22, fontWeight: FontWeight.w700))),
              body: SafeArea(
                  top: false,
                  child: bloc.faqDataList.isNotEmpty
                      ? FaqDataListWidget(
                          cont: context, faqDataList: bloc.faqDataList)
                      : bloc.isFaqLoading
                          ? const SettingsContentPlaceholder()
                          : CustomScrollView(slivers: [
                              SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: SettingsContentNotice(
                                      icon: Icons.help_outline_rounded,
                                      failed: state is FaqFailureState,
                                      onRetry: () =>
                                          bloc.add(GetFaqListEvent())))
                            ])),
            ));
      }));
}
