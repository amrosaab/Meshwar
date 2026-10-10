import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../app/localization.dart';
import '../../../../../../common/common.dart';
import '../../../../../../common/ride_visuals.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/account_content.dart';
import '../widget/settings_content.dart';
import 'delete_account.dart';
import 'faq_page.dart';
import 'home_layout.dart';
import 'terms_privacy_policy_view_page.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settingsPage';
  final SettingsPageArguments args;
  const SettingsPage({super.key, required this.args});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AccBloc()
          ..add(AccGetDirectionEvent())
          ..add(GetAppVersionEvent()),
        child: BlocConsumer<AccBloc, AccState>(
          listener: (context, state) async {
            if (state is DeleteAccountLoadingState) {
              CustomLoader.loader(context);
            } else if (state is DeleteAccountFailureState) {
              CustomLoader.dismiss(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!.tryAgain)));
            } else if (state is DeleteAccountSuccess) {
              CustomLoader.dismiss(context);
              Navigator.pushNamed(context, DeleteAccount.routeName);
              await AppSharedPreference.setLoginStatus(false);
              await AppSharedPreference.setToken('');
            }
          },
          builder: (context, state) {
            final bloc = context.read<AccBloc>();
            final l10n = AppLocalizations.of(context)!;
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
                          MediaQuery.textScalerOf(context).scale(22) > 32
                              ? 120
                              : 64,
                      title: Text(l10n.settings,
                          style: AccountStyle.text(context).copyWith(
                              fontSize: 22, fontWeight: FontWeight.w700))),
                  body: SafeArea(
                      top: false,
                      child: SettingsContent(
                        dark: Theme.of(context).brightness == Brightness.dark,
                        version: bloc.appVersion,
                        showLayout:
                            args.userData.enableMapShowHomeScreen == '1',
                        onTheme: (value) async {
                          final locale = await AppSharedPreference
                              .getSelectedLanguageCode();
                          if (!context.mounted) return;
                          bloc.isDarkTheme = value;
                          context.read<LocalizationBloc>().add(
                              LocalizationInitialEvent(
                                  isDark: value,
                                  locale:
                                      Locale(locale.isEmpty ? 'en' : locale)));
                        },
                        onLayout: () =>
                            Navigator.pushNamed(context, HomeLayout.routeName),
                        onFaq: () =>
                            Navigator.pushNamed(context, FaqPage.routeName),
                        onPrivacy: () => Navigator.pushNamed(
                            context, TermsPrivacyPolicyViewPage.routeName,
                            arguments: TermsAndPrivacyPolicyArguments(
                                isPrivacyPolicy: true)),
                        onDelete: () async {
                          final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    title: Text(l10n.deleteAccount),
                                    content: Text(l10n.deleteText),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(
                                              dialogContext, false),
                                          child: Text(l10n.cancel)),
                                      FilledButton(
                                          style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.meshwarRed,
                                              foregroundColor: Colors.white),
                                          onPressed: () => Navigator.pop(
                                              dialogContext, true),
                                          child: Text(l10n.deleteAccount))
                                    ],
                                  ));
                          if (confirmed == true && context.mounted) {
                            bloc.add(DeleteAccountEvent());
                          }
                        },
                      )),
                ));
          },
        ),
      );
}
