import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/common.dart';
import '../core/utils/connectivity_check.dart';
import '../core/utils/custom_loader.dart';
import '../features/account/application/acc_bloc.dart';
import '../features/auth/application/auth_bloc.dart';
import '../features/bookingpage/application/booking_bloc.dart';
import '../features/home/application/home_bloc.dart';
import '../features/landing/application/onboarding_bloc.dart';
import '../features/language/application/language_bloc.dart';
import 'localization.dart';
import '../features/loading/application/loader_bloc.dart';
import '../features/loading/presentation/pages/loader_page.dart';
import '../l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                LocalizationBloc()..add(LocalizationGetEvent())),
        BlocProvider(create: (context) => LanguageBloc()),
        BlocProvider(create: (context) => LoaderBloc()),
        BlocProvider(create: (context) => OnBoardingBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => AccBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => BookingBloc()),
      ],
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, state) {
          Locale locale = (state is LocalizationInitialState)
              ? state.locale
              : const Locale('en');
          bool isDark =
              (state is LocalizationInitialState) ? state.isDark : false;
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: MaterialApp(
              scaffoldMessengerKey: scaffoldMessengerKey,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: AppThemes.applicationDefaultTheme(context),
              onGenerateRoute: AppRoutes.onGenerateRoutes,
              onUnknownRoute: AppRoutes.onUnknownRoute,
              initialRoute: LoaderPage.routeName,
              title: AppConstants.title,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              darkTheme: AppThemes.darkTheme(context),
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          );
        },
      ),
    );
  }
}
