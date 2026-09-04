import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/common.dart';
import '../../../../core/network/network.dart';

class LoaderApi {
  Future updateUserLocation({required LatLng currentLocation}) async {
    try {
      final token = await AppSharedPreference.getToken();
      final formData = FormData.fromMap({
        'current_lat': '${currentLocation.latitude}',
        'current_lng': '${currentLocation.longitude}'
      });
      Response response = await DioProviderImpl().post(
          ApiEndpoints.updateLocation,
          headers: {'Authorization': token},
          body: formData);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
