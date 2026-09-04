import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../common/common.dart';
import '../../../di/locator.dart';
import '../domain/models/onboarding_model.dart';
import 'usecase/onboarding_usecase.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  List<OnBoardingData> onBoardingData = [];
  PageController contentPageController = PageController();
  PageController imagePageController = PageController();
  String textDirection = 'rtl';
  int onBoardChangeIndex = 0;

  OnBoardingBloc() : super(OnBoardingInitialState()) {
    on<GetOnBoardingDataEvent>(_onBoardingDataList);
    on<OnBoardingDataChangeEvent>(_onBoardChangeIndex);
    on<SkipEvent>(_onSkipEventCalled);
  }

  FutureOr<void> _onBoardingDataList(
      OnBoardingEvent event, Emitter<OnBoardingState> emit) async {
    emit(OnBoardingLoadingState());
    textDirection = await AppSharedPreference.getLanguageDirection();
    final data = await serviceLocator<OnBoardingUsecase>().getOnboarding();
    data.fold(
      (error) {
        emit(OnBoardingFailureState());
      },
      (success) {
        if (success.data.onboarding.data.isNotEmpty) {
          onBoardingData = success.data.onboarding.data;
          emit(OnBoardingSuccessState());
        } else {
          emit(OnBoardingSuccessState());
          emit(SkipState());
        }
      },
    );
  }

  Future<void> _onBoardChangeIndex(
      OnBoardingDataChangeEvent event, Emitter<OnBoardingState> emit) async {
    onBoardChangeIndex = event.currentIndex;
    emit(OnBoardingDataChangeState());
  }

  Future<void> _onSkipEventCalled(
      SkipEvent event, Emitter<OnBoardingState> emit) async {
    await AppSharedPreference.setLandingStatus(true);
    emit(SkipState());
  }
}
