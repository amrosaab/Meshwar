import 'package:dio/dio.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';

class DriverProfileApi {
  //Get service Location
  Future getServiceLocation() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.getServiceLocation,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

//Get Documents
  Future getDocuments({String? fleetId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        (fleetId != null)
            ? ApiEndpoints.neededDocuments
                .toString()
                .replaceAll('fleetId', fleetId)
            : ApiEndpoints.neededDocuments,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

//Upload Documents
  Future uploadDocuments(
      {required String id,
      required String? identifyNumber,
      required String? expiryDate,
      required String? fleetId,
      required String document,
      required String? documentBack}) async {
    try {
      final token = await AppSharedPreference.getToken();
      final formData = FormData.fromMap({
        if (identifyNumber != null && identifyNumber != '')
          'identify_number': identifyNumber,
        if (expiryDate != null && expiryDate != '') 'expiry_date': expiryDate,
        'document_id': id,
        if (fleetId != null) 'fleet_id': fleetId.toString()
      });
      formData.files
          .add(MapEntry('document', await MultipartFile.fromFile(document)));
      if (documentBack != null && documentBack.isNotEmpty) {
        formData.files.add(
            MapEntry('back_image', await MultipartFile.fromFile(documentBack)));
      }
      Response response = await DioProviderImpl().post(
        ApiEndpoints.uploadDocument,
        body: formData,
        headers: {'Content-Type': 'application/json', 'Authorization': token},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
