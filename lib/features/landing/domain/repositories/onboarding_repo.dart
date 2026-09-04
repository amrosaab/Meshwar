import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../models/onboarding_model.dart';

abstract class OnBoardingRepository {
  Future<Either<Failure, OnBoardingResponseModel>> getOnboarding();
}
