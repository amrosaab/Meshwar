import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../account/domain/models/service_location_model.dart';
import '../../domain/models/needed_documents_model.dart';
import '../../domain/models/upload_document_model.dart';
import '../../domain/repositories/driver_profile_repo.dart';

class DriverProfileUsecase {
  final DriverProfileRepository _driverProfileRepository;

  const DriverProfileUsecase(this._driverProfileRepository);

  Future<Either<Failure, ServiceLocationModel>> getServiceLocation() async {
    return _driverProfileRepository.getServiceLocation();
  }

  Future<Either<Failure, NeededDocumentsModel>> getDocuments(
      {String? fleetId}) async {
    return _driverProfileRepository.getDocuments(fleetId: fleetId);
  }

  Future<Either<Failure, UploadDocumentModel>> uploadDocuments(
      {required String id,
      required String? identifyNumber,
      required String? expiryDate,
      required String document,
      required String? documentBack}) async {
    return _driverProfileRepository.uploadDocuments(
      id: id,
      identifyNumber: identifyNumber,
      expiryDate: expiryDate,
      fleetId: null,
      document: document,
      documentBack: documentBack,
    );
  }
}
