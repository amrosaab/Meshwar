import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../common/local_data.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../../account/domain/models/service_location_model.dart';
import '../../domain/models/needed_documents_model.dart';
import '../../domain/models/upload_document_model.dart';
import '../../domain/repositories/driver_profile_repo.dart';
import '../repository/driver_profile_api.dart';

class DriverProfileRepositoryImpl implements DriverProfileRepository {
  final DriverProfileApi _driverProfileApi;

  DriverProfileRepositoryImpl(this._driverProfileApi);

  // UserDetailData
  @override
  Future<Either<Failure, ServiceLocationModel>> getServiceLocation() async {
    ServiceLocationModel serviceLocationModel;
    try {
      Response response = await _driverProfileApi.getServiceLocation();
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data['error'] != null) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          serviceLocationModel = ServiceLocationModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(serviceLocationModel);
  }

  @override
  Future<Either<Failure, NeededDocumentsModel>> getDocuments(
      {String? fleetId}) async {
    NeededDocumentsModel neededDocumentsModel;
    try {
      Response response =
          await _driverProfileApi.getDocuments(fleetId: fleetId);
      printWrapped(response.data.toString());
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data['error'] != null) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          neededDocumentsModel = NeededDocumentsModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(neededDocumentsModel);
  }

  @override
  Future<Either<Failure, UploadDocumentModel>> uploadDocuments(
      {required String id,
      required String? identifyNumber,
      required String? expiryDate,
      required String? fleetId,
      required String document,
      required String? documentBack}) async {
    UploadDocumentModel uploadDocumentModel;
    try {
      Response response = await _driverProfileApi.uploadDocuments(
          id: id,
          identifyNumber: identifyNumber,
          expiryDate: expiryDate,
          fleetId: fleetId,
          document: document,
          documentBack: documentBack);
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data['error'] != null) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode != 200) {
          return Left(GetDataFailure(
              message: response.data["message"],
              statusCode: response.statusCode!));
        } else {
          printWrapped(
              "Dcoument Upload Response=============> ${response.data.toString()}");
          uploadDocumentModel = UploadDocumentModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(uploadDocumentModel);
  }
}
