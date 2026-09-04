import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../../domain/models/onboarding_model.dart';
import '../../domain/repositories/onboarding_repo.dart';

class OnBoardingUsecase {
  final OnBoardingRepository _onboardingRepository;

  const OnBoardingUsecase(this._onboardingRepository);

  Future<Either<Failure, OnBoardingResponseModel>> getOnboarding() async {
    return _onboardingRepository.getOnboarding();
  }
}
