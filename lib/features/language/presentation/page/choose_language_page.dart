import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../../../../common/ride_visuals.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app/localization.dart';
import '../../../landing/presentation/page/landing_page.dart';
import '../../../account/presentation/widgets/account_content.dart';
import '../../application/language_bloc.dart';
import '../widget/language_content.dart';

class ChooseLanguagePage extends StatelessWidget {
  static const String routeName = '/chooseLanguage';
  final ChooseLanguageArguments arg;
  const ChooseLanguagePage({super.key, required this.arg});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => LanguageBloc()
          ..add(LanguageGetEvent(
              isInitialLanguageChange: arg.isInitialLanguageChange)),
        child: BlocConsumer<LanguageBloc, LanguageState>(
          listener: (context, state) {
            if (state is LanguageUpdateState) {
              if (arg.isInitialLanguageChange) {
                Navigator.pushNamedAndRemoveUntil(
                    context, LandingPage.routeName, (_) => false);
              } else {
                Navigator.pop(context);
              }
            } else if (state is LanguageFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!.tryAgain)));
            }
          },
          builder: (context, state) {
            final bloc = context.read<LanguageBloc>();
            final l10n = AppLocalizations.of(context)!;
            return PopScope(
                canPop: !bloc.isUpdating,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop && bloc.choosedLanguage.isNotEmpty) {
                    context.read<LocalizationBloc>().add(
                        LocalizationInitialEvent(
                            isDark:
                                Theme.of(context).brightness == Brightness.dark,
                            locale: Locale(bloc.choosedLanguage)));
                  }
                },
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
                          MediaQuery.textScalerOf(context).scale(22) > 32
                              ? 120
                              : 64,
                      automaticallyImplyLeading: !arg.isInitialLanguageChange,
                      title: Text(
                          arg.isInitialLanguageChange
                              ? l10n.chooseLanguage
                              : l10n.changeLanguage,
                          style: AccountStyle.text(context).copyWith(
                              fontSize: 22, fontWeight: FontWeight.w700))),
                  body: LanguageContent(
                    languages: AppConstants.languageList,
                    selectedIndex: bloc.selectedIndex,
                    busy: bloc.isUpdating,
                    onSelect: (index) {
                      bloc.add(
                          LanguageSelectEvent(selectedLanguageIndex: index));
                      context.read<LocalizationBloc>().add(
                          LocalizationInitialEvent(
                              isDark: Theme.of(context).brightness ==
                                  Brightness.dark,
                              locale: Locale(
                                  AppConstants.languageList[index].lang)));
                    },
                    onConfirm: () => bloc.add(LanguageSelectUpdateEvent(
                        selectedLanguage: AppConstants
                            .languageList[bloc.selectedIndex].lang)),
                  ),
                ));
          },
        ),
      );
}
