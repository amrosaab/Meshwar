import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/onboarding_model.dart';
import '../../domain/repositories/onboarding_repo.dart';
import '../repository/onboarding_api.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingApi _onBoardingApi;

  OnBoardingRepositoryImpl(this._onBoardingApi);
  // OnBoardingData
  @override
  Future<Either<Failure, OnBoardingResponseModel>> getOnboarding() async {
    OnBoardingResponseModel onBoardingResponseModel;
    try {
      Response response = await _onBoardingApi.getOnboardingApi();

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else {
          onBoardingResponseModel =
              OnBoardingResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(onBoardingResponseModel);
  }
}
