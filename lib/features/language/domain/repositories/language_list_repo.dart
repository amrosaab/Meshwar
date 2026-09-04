import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../models/language_listing_model.dart';

abstract class LanguageRepository {
  Future<Either<Failure, LanguageListResponseModel>> getLanguages();
  Future<Either<Failure, dynamic>> updateLanguage(String langCode);
}
