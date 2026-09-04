import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_dialoges.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';
import '../../../widgets/menu_options.dart';
import '../../account_page.dart';
import 'delete_account.dart';
import 'faq_page.dart';
import 'home_layout.dart';
import 'map_settings.dart';
import 'terms_privacy_policy_view_page.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = '/settingsPage';
  final SettingsPageArguments args;
  const SettingsPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetAppVersionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is DeleteAccountLoadingState) {
            CustomLoader.loader(context);
          } else if (state is DeleteAccountFailureState) {
            CustomLoader.dismiss(context);
          } else if (state is DeleteAccountSuccess) {
            CustomLoader.dismiss(context);
            Navigator.pushNamed(context, DeleteAccount.routeName);
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();
          return Directionality(
              textDirection: context.read<AccBloc>().textDirection == 'rtl'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: SafeArea(
                top: false,
                bottom: false,
                child: Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.settings,
                    automaticallyImplyLeading: true,
                    titleFontSize: 18,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.03),
                        MenuSectionCard(children: [
                          MenuOptions(
                            icon: Icons.dark_mode_outlined,
                            iconColor: Colors.indigo.shade600,
                            iconbackground: Colors.indigo.shade50,
                            label: AppLocalizations.of(context)!.theme,
                            showTheme: true,
                            onTap: () {},
                          ),

                          // If you comment this, also change in HomeBloc GetUserDetails change MapType
                          if (args.userData.enableMapAppearanceChange == '1')
                            customDivider(context),
                          // MenuOptions(
                          //   icon: Icons.map_outlined,
                          //   iconColor: Colors.teal.shade600,
                          //   iconbackground: Colors.teal.shade50,
                          //   label: AppLocalizations.of(context)!.mapAppearance,
                          //   onTap: () {
                          //     Navigator.pushNamed(
                          //       context,
                          //       MapSettingsPage.routeName,
                          //     );
                          //   },
                          // ),
                          if (args.userData.enableMapShowHomeScreen == '1') ...[
                            customDivider(context),
                            MenuOptions(
                              imagePath: AppImages.layout,
                              imageColor: Colors.indigo.shade600,
                              label: AppLocalizations.of(context)!.chooseLayout,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  HomeLayout.routeName,
                                );
                              },
                            ),
                          ],
                          customDivider(context),
                          MenuOptions(
                            icon: Icons.help_outline,
                            iconColor: Colors.blue.shade600,
                            iconbackground: Colors.blue.shade50,
                            label: AppLocalizations.of(context)!.faq,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                FaqPage.routeName,
                              );
                            },
                          ),
                          customDivider(context),
                          MenuOptions(
                            icon: Icons.privacy_tip_outlined,
                            iconColor: Colors.green.shade600,
                            iconbackground: Colors.green.shade50,
                            label: AppLocalizations.of(context)!
                                .privacyPolicyAccounts,
                            onTap: () async {
                              Navigator.pushNamed(
                                  context, TermsPrivacyPolicyViewPage.routeName,
                                  arguments: TermsAndPrivacyPolicyArguments(
                                      isPrivacyPolicy: true));
                            },
                          ),
                          customDivider(context),
                          MenuOptions(
                            icon: Icons.delete_outline,
                            iconColor: Colors.red.shade600,
                            iconbackground: Colors.red.shade50,
                            label: AppLocalizations.of(context)!.deleteAccount,
                            textColor: AppColors.errorLight,
                            imagePath: AppImages.trash,
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Colors.black54,
                                builder: (BuildContext _) {
                                  return BlocProvider.value(
                                    value: BlocProvider.of<AccBloc>(context),
                                    child: CustomSingleButtonDialoge(
                                      title:
                                      '${AppLocalizations.of(context)!.deleteAccount} ?',
                                      content: AppLocalizations.of(context)!
                                          .deleteText,
                                      btnName: AppLocalizations.of(context)!
                                          .deleteAccount,
                                      btnColor: AppColors.red,
                                      onTap: () {
                                        context
                                            .read<AccBloc>()
                                            .add(DeleteAccountEvent());
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ]),
                        const Spacer(),
                        Center(
                            child: MyText(
                              text: 'V ${accBloc.appVersion}',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Theme.of(context).dividerColor),
                            )),
                        SizedBox(height: size.width * 0.05),
                      ],
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }
}