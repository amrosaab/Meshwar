part of 'loader_bloc.dart';

abstract class LoaderState {}

final class LoaderInitialState extends LoaderState {}

final class LoaderSuccessState extends LoaderState {
  final bool loginStatus;
  final bool landingStatus;
  final String selectedLanguage;
  final UserDetail? userData;

  LoaderSuccessState(
      {required this.loginStatus,
      required this.landingStatus,
      required this.selectedLanguage,
      this.userData});
}
