import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/language_listing_model.dart';
import '../../domain/repositories/language_list_repo.dart';
import '../repository/language_api.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageApi _languageApi;

  LanguageRepositoryImpl(this._languageApi);

  @override
  Future<Either<Failure, LanguageListResponseModel>> getLanguages() async {
    try {
      final response = await _languageApi.getLanguages();

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['errors']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        final languageListResponseModel =
            LanguageListResponseModel.fromJson(response.data);
        return Right(languageListResponseModel);
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, dynamic>> updateLanguage(String langCode) async {
    try {
      final response = await _languageApi.updateLanguage(langCode);

      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return Left(GetDataFailure(message: response.data["message"]));
      } else {
        return Right(response.data);
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }
  }
}
