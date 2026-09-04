part of 'onboarding_bloc.dart';

abstract class OnBoardingState {}

final class OnBoardingInitialState extends OnBoardingState {}

final class OnBoardingLoadingState extends OnBoardingState {}

final class OnBoardingSuccessState extends OnBoardingState {}

final class OnBoardingFailureState extends OnBoardingState {}

final class OnBoardingDataChangeState extends OnBoardingState {}

final class SkipState extends OnBoardingState {}
