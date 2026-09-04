import 'package:dio/dio.dart';

import '../../../../core/network/network.dart';

class OnBoardingApi {
  Future<dynamic> getOnboardingApi() async {
    try {
      Response response = await DioProviderImpl().get(ApiEndpoints.onBoarding);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
