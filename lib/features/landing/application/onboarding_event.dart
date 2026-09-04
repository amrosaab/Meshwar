part of 'onboarding_bloc.dart';

abstract class OnBoardingEvent {}

class GetOnBoardingDataEvent extends OnBoardingEvent {}

class OnBoardingDataChangeEvent extends OnBoardingEvent {
  final int currentIndex;

  OnBoardingDataChangeEvent({required this.currentIndex});
}

class SkipEvent extends OnBoardingEvent {}
