import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/common.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../domain/repositories/loader_repo.dart';
import '../repository/loader_api.dart';

class LoaderRepositoryImpl implements LoaderRepository {
  final LoaderApi _loaderApi;

  LoaderRepositoryImpl(this._loaderApi);

  // UserLocationUpdate
  @override
  Future<Either<Failure, dynamic>> updateUserLocation(
      {required LatLng currentLocation}) async {
    dynamic result;
    try {
      Response response =
          await _loaderApi.updateUserLocation(currentLocation: currentLocation);
      printWrapped('Update User Location Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400) {
          return Left(GetDataFailure(message: response.data["message"]));
        } else if (response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else {
          result = response;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(result);
  }
}
