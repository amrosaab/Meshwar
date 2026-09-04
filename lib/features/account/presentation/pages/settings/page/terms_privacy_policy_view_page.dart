import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../../../common/common.dart';
import '../../../../../../core/utils/custom_appbar.dart';
import '../../../../../../core/utils/custom_loader.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../application/acc_bloc.dart';

class TermsPrivacyPolicyViewPage extends StatelessWidget {
  static const String routeName = '/termsPrivacyPolicyViewPage';
  final TermsAndPrivacyPolicyArguments args;
  const TermsPrivacyPolicyViewPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AccBloc()
        ..add(AccGetDirectionEvent())
        ..add(GetHtmlStringEvent(isPrivacy: args.isPrivacyPolicy)),
      child: BlocListener<AccBloc, AccState>(
        listener: (context, state) async {
          if (state is AccDataLoadingStartState) {
            CustomLoader.loader(context);
          }
          if (state is AccDataLoadingStopState) {
            CustomLoader.dismiss(context);
          }
        },
        child: BlocBuilder<AccBloc, AccState>(builder: (context, state) {
          final accBloc = context.read<AccBloc>();
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: CustomAppBar(
                title: args.isPrivacyPolicy
                    ? AppLocalizations.of(context)!.privacyPolicy
                    : AppLocalizations.of(context)!.terms,
                automaticallyImplyLeading: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (accBloc.htmlString != null)
                      Html(
                        data: accBloc.htmlString,
                      ),
                    SizedBox(height: size.width * 0.1),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}