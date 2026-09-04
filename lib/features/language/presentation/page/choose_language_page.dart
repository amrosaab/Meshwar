// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import '../../../../core/utils/custom_appbar.dart';
import '../../../../core/utils/custom_loader.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../landing/presentation/page/landing_page.dart';
import '../../application/language_bloc.dart';
import '../../../../app/localization.dart';
import '../../domain/models/language_listing_model.dart';

class ChooseLanguagePage extends StatelessWidget {
  static const String routeName = '/chooseLanguage';
  final ChooseLanguageArguments arg;

  const ChooseLanguagePage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return builderList(size);
  }

  Widget builderList(Size size) {
    return BlocProvider(
      create: (context) => LanguageBloc()
        ..add(LanguageInitialEvent())
        ..add(LanguageGetEvent(
            isInitialLanguageChange: arg.isInitialLanguageChange)),
      child: BlocListener<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state is LanguageInitialState) {
            CustomLoader.loader(context);
          } else if (state is LanguageLoadingState) {
            CustomLoader.loader(context);
          } else if (state is LanguageSuccessState) {
            CustomLoader.dismiss(context);
          } else if (state is LanguageFailureState) {
            CustomLoader.dismiss(context);
          } else if (state is LanguageUpdateState) {
            // Reload the app with the selected language
            if (arg.isInitialLanguageChange) {
              Navigator.pushNamedAndRemoveUntil(
                  context, LandingPage.routeName, (route) => false);
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: arg.isInitialLanguageChange
                    ? AppLocalizations.of(context)!.chooseLanguage
                    : AppLocalizations.of(context)!.changeLanguage,
                automaticallyImplyLeading:
                    arg.isInitialLanguageChange ? false : true,
                titleFontSize: 18,
                onBackTap: () {
                  Navigator.pop(context);
                  context.read<LocalizationBloc>().add(LocalizationInitialEvent(
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      locale: Locale(
                          context.read<LanguageBloc>().choosedLanguage)));
                },
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              buildLanguageList(size, AppConstants.languageList)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.width * 0.05),
                      confirmButton(size, context),
                      SizedBox(height: size.width * 0.05),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// Language List
  Widget buildLanguageList(Size size, List<LocaleLanguageList> languageList) {
    return languageList.isNotEmpty
        ? RawScrollbar(
            radius: const Radius.circular(20),
            child: ListView.builder(
              itemCount: languageList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      context.read<LanguageBloc>().add(
                          LanguageSelectEvent(selectedLanguageIndex: index));
                      context.read<LocalizationBloc>().add(
                          LocalizationInitialEvent(
                              isDark: Theme.of(context).brightness ==
                                  Brightness.dark,
                              locale: Locale(languageList[index].lang)));
                    },
                    child: Container(
                      height: 50,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color:
                                (context.read<LanguageBloc>().selectedIndex ==
                                        index)
                                    ? AppColors.primary
                                    : AppColors.borderColors,
                            width:
                                (context.read<LanguageBloc>().selectedIndex ==
                                        index)
                                    ? 1.0
                                    : 1.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: languageList[index].name,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                            ),
                            Radio(
                              value: index,
                              groupValue:
                                  context.read<LanguageBloc>().selectedIndex,
                              fillColor: MaterialStatePropertyAll(
                                (context.read<LanguageBloc>().selectedIndex ==
                                        index)
                                    ? AppColors.primary
                                    : Theme.of(context).primaryColorDark,
                              ),
                              onChanged: (value) {
                                context.read<LanguageBloc>().add(
                                    LanguageSelectEvent(
                                        selectedLanguageIndex: index));
                                context.read<LocalizationBloc>().add(
                                    LocalizationInitialEvent(
                                        isDark: Theme.of(context).brightness ==
                                            Brightness.dark,
                                        locale:
                                            Locale(languageList[index].lang)));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : const SizedBox();
  }

  Widget confirmButton(Size size, BuildContext context) {
    return Center(
      child: CustomButton(
        buttonName: AppLocalizations.of(context)!.confirm,
        width: size.width,
        textSize: 18,
        onTap: () async {
          final selectedIndex = context.read<LanguageBloc>().selectedIndex;
          context.read<LanguageBloc>().add(LanguageSelectUpdateEvent(
              selectedLanguage:
                  AppConstants.languageList.elementAt(selectedIndex).lang));
        },
      ),
    );
  }
}
