import 'package:dartz/dartz.dart';


import '../../../../core/network/network.dart';
import '../../../account/domain/models/service_location_model.dart';
import '../models/needed_documents_model.dart';
import '../models/upload_document_model.dart';

abstract class DriverProfileRepository {
  Future<Either<Failure, ServiceLocationModel>> getServiceLocation();

  Future<Either<Failure, NeededDocumentsModel>> getDocuments({String? fleetId});

  Future<Either<Failure, UploadDocumentModel>> uploadDocuments(
      {required String id,
      required String? identifyNumber,
      required String? expiryDate,
      required String? fleetId,
      required String document,
      required String? documentBack});
}
