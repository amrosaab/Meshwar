import 'package:dartz/dartz.dart';
import '../../../../core/network/network.dart';
import '../../domain/models/language_listing_model.dart';
import '../../domain/repositories/language_list_repo.dart';

class LanguageUsecase {
  final LanguageRepository _languageRepository;

  const LanguageUsecase(this._languageRepository);

  Future<Either<Failure, LanguageListResponseModel>> getLanguages() async {
    return _languageRepository.getLanguages();
  }

  Future<Either<Failure, dynamic>> updateLanguage(String langCode) async {
    return _languageRepository.updateLanguage(langCode);
  }
}
