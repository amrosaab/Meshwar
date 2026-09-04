part of 'language_bloc.dart';

abstract class LanguageState {}

final class LanguageInitialState extends LanguageState {}

final class LanguageLoadingState extends LanguageState {}

final class LanguageFailureState extends LanguageState {}

final class LanguageSuccessState extends LanguageState {}

final class LanguageSelectState extends LanguageState {
  final int selectedIndex;

  LanguageSelectState({required this.selectedIndex});
}

class LanguageUpdateState extends LanguageState {
  final String selectedLanguageCode;

  LanguageUpdateState({required this.selectedLanguageCode});
}
