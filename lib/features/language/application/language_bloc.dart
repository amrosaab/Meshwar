import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../di/locator.dart';
import 'usecases/language_usecase.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  int selectedIndex = 0;
  String choosedLanguage = '';

  LanguageBloc() : super(LanguageInitialState()) {
    on<LanguageInitialEvent>(storedLocaleLanguage);
    on<LanguageGetEvent>(_getLanguageList);
    on<LanguageSelectEvent>(_selectedLanguageIndex);
    on<LanguageSelectUpdateEvent>(_selectedLanguageUpdate);
  }

  Future storedLocaleLanguage(
      LanguageInitialEvent event, Emitter<LanguageState> emit) async {
    choosedLanguage = await AppSharedPreference.getSelectedLanguageCode();
  }

  FutureOr<void> _getLanguageList(
      LanguageGetEvent event, Emitter<LanguageState> emit) async {
    emit(LanguageLoadingState());
    if (!event.isInitialLanguageChange) {
      for (var i = 0; i < AppConstants.languageList.length; i++) {
        if (AppConstants.languageList[i].lang == choosedLanguage) {
          selectedIndex = i;
          break;
        }
      }
    }
    emit(LanguageSuccessState());
  }

  Future<void> _selectedLanguageIndex(
      LanguageSelectEvent event, Emitter<LanguageState> emit) async {
    selectedIndex = event.selectedLanguageIndex;
    emit(LanguageSelectState(selectedIndex: selectedIndex));
  }

  Future<void> _selectedLanguageUpdate(
      LanguageSelectUpdateEvent event, Emitter<LanguageState> emit) async {
    final data = await serviceLocator<LanguageUsecase>()
        .updateLanguage(event.selectedLanguage);
    data.fold(
      (error) {
        debugPrint('Update Failure');
      },
      (success) {
        debugPrint('Update Success');
      },
    );
    if (event.selectedLanguage == 'ar' ||
        event.selectedLanguage == 'ur' ||
        event.selectedLanguage == 'iw') {
      await AppSharedPreference.setLanguageDirection('rtl');
    } else {
      await AppSharedPreference.setLanguageDirection('ltr');
    }

    await AppSharedPreference.setSelectedLanguageCode(event.selectedLanguage);

    emit(LanguageUpdateState(selectedLanguageCode: event.selectedLanguage));
  }
}
