import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/common.dart';

// Event
abstract class LocalizationEvent {}

class LocalizationInitialEvent extends LocalizationEvent {
  final Locale locale;
  final bool isDark;

  LocalizationInitialEvent({required this.locale, required this.isDark});
}

class LocalizationGetEvent extends LocalizationEvent {}

// State
abstract class LocalizationState {}

class LocalizationInitialState extends LocalizationState {
  final Locale locale;
  final bool isDark;

  LocalizationInitialState({required this.locale, required this.isDark});
}

// Bloc
class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc()
      : super(LocalizationInitialState(
            locale: const Locale('en'), isDark: false)) {
    // Register the event handler
    on<LocalizationInitialEvent>((event, emit) async {
      if (event.locale.languageCode == 'ar' ||
          event.locale.languageCode == 'ur' ||
          event.locale.languageCode == 'iw') {
        await AppSharedPreference.setLanguageDirection('rtl');
      } else {
        await AppSharedPreference.setLanguageDirection('ltr');
      }
      await AppSharedPreference.setSelectedLanguageCode(
          event.locale.languageCode);

      await AppSharedPreference.setDarkThemeStatus(event.isDark);
      emit(
          LocalizationInitialState(locale: event.locale, isDark: event.isDark));
    });

    on<LocalizationGetEvent>((event, emit) async {
      final isDark = await AppSharedPreference.getDarkThemeStatus();
      final code = await AppSharedPreference.getSelectedLanguageCode();
      emit(LocalizationInitialState(
          locale: Locale(code.isNotEmpty ? code : 'en'), isDark: isDark));
    });
  }
}
