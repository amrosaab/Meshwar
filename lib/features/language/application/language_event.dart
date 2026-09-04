part of 'language_bloc.dart';

abstract class LanguageEvent {}

class LanguageInitialEvent extends LanguageEvent {}

class LanguageGetEvent extends LanguageEvent {
  final bool isInitialLanguageChange;

  LanguageGetEvent({required this.isInitialLanguageChange});
}

class LanguageSelectUpdateEvent extends LanguageEvent {
  final String selectedLanguage;

  LanguageSelectUpdateEvent({required this.selectedLanguage});
}

class LanguageSelectEvent extends LanguageEvent {
  final int selectedLanguageIndex;

  LanguageSelectEvent({required this.selectedLanguageIndex});
}
