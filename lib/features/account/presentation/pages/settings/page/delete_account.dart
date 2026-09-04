import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_button.dart';
import '../../../../../../core/utils/custom_text.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../auth/presentation/pages/login_page.dart';
import '../../../../application/acc_bloc.dart';

class DeleteAccount extends StatelessWidget {
  static const String routeName = '/deleteAccount';

  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()..add(AccGetDirectionEvent()),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) {},
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          return Directionality(
            textDirection: context.read<AccBloc>().textDirection == 'rtl'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: PopScope(
              canPop: false,
              child: SafeArea(
                top: false,
                child: Scaffold(
                    appBar: CustomAppBar(
                        title: AppLocalizations.of(context)!.deleteAccount,
                        automaticallyImplyLeading: false),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: size.width * 0.05),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: MyText(
                                text: AppLocalizations.of(context)!
                                    .deleteDetailText
                                    .replaceAll('***', '30')
                                    .replaceAll('**', '24'),
                                maxLines: 8,
                              ),
                            ),
                            SizedBox(height: size.width * 0.1),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              child: CustomButton(
                                buttonName:
                                AppLocalizations.of(context)!.okText,
                                width: size.width,
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      LoginPage.routeName, (route) => false);
                                },
                              ),
                            ),
                            SizedBox(height: size.width * 0.1)
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          );
        }),
      ),
    );
  }
}