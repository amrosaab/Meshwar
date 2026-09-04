import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/common.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../core/utils/custom_appbar.dart';
import '../../../../../core/utils/custom_loader.dart';
import '../../../../language/presentation/page/choose_language_page.dart';
import '../../../application/acc_bloc.dart';
import '../../widgets/menu_options.dart';
import '../account_page.dart';
import '../admin_chat/page/admin_chat.dart';
import '../support_ticket/page/support_ticket.dart';

class HelpPage extends StatelessWidget {
  static const String routeName = '/helpPage';
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(AccGetUserDetailsEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is DeleteAccountSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, ChooseLanguagePage.routeName, (route) => false,
                arguments: ChangeLanguageArguments(from: 0));
            await AppSharedPreference.setLoginStatus(false);
            await AppSharedPreference.setToken('');
          } else if (state is DeleteAccountFailureState) {
            Navigator.of(context).pop(); // Dismiss the dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();
          return (accBloc.userData != null)
              ? Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.helpCenter,
                    automaticallyImplyLeading: true,
                    titleFontSize: 18,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.03),
                        MenuSectionCard(
                          children: [
                            if (accBloc.userData!.enableSupportTicketFeature ==
                                '1') ...[
                              MenuOptions(
                                  icon: Icons.support_agent_outlined,
                                  iconColor: Colors.blue.shade600,
                                  iconbackground: Colors.blue.shade50,
                                  label: AppLocalizations.of(context)!
                                      .supportTicket,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SupportTicketPage.routeName,
                                        arguments: SupportTicketPageArguments(
                                            isFromRequest: false,
                                            requestId: ''));
                                  }),
                              customDivider(context),
                            ],
                            MenuOptions(
                              icon: Icons.chat_bubble_outline,
                              iconColor: Colors.green.shade600,
                              iconbackground: Colors.green.shade50,
                              label: AppLocalizations.of(context)!.chatWithUs,
                              onTap: () {
                                final userData = accBloc.userData;
                                if (userData == null) {
                                  return;
                                }
                                Navigator.pushNamed(
                                  context,
                                  AdminChat.routeName,
                                  arguments: AdminChatPageArguments(
                                      userData: userData),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              : const Scaffold(
                  body: Loader(),
                );
        }),
      ),
    );
  }
}
