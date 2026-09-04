part of 'driver_profile_bloc.dart';

abstract class DriverProfileState {}

final class DriverProfileInitialState extends DriverProfileState {}

final class PageChangeState extends DriverProfileState {}

class ShowErrorState extends DriverProfileState {
  final String message;
  ShowErrorState({required this.message});
}

final class LoadingStartState extends DriverProfileState {}

final class LoadingStopState extends DriverProfileState {}

final class ErrorState extends DriverProfileState {}

final class DriverUpdateState extends DriverProfileState {}

final class EnableEditState extends DriverProfileState {
  final bool isEditable;

  EnableEditState({required this.isEditable});
}
