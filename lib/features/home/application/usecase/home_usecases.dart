import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/network/network.dart';
import '../../../account/domain/models/history_model.dart';
import '../../domain/models/Promotions_popup_model.dart';
import '../../domain/models/recent_routes_model.dart';
import '../../domain/models/ride_modules_model.dart';
import '../../domain/models/stop_address_model.dart';
import '../../domain/models/user_details_model.dart';
import '../../domain/repositories/home_repo.dart';

class HomeUsecase {
  final HomeRepository _homeRepository;

  const HomeUsecase(this._homeRepository);

  Future<Either<Failure, UserDetailResponseModel>> userDetails(
      {String? requestId}) async {
    return _homeRepository.getUserDetails(requestId: requestId);
  }

  Future<Either<Failure, dynamic>> getAutoCompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
    String? sessionToken,
    String? languageCode,
  }) async {
    return _homeRepository.getAutoCompletePlaces(
        input: input,
        mapType: mapType,
        countryCode: countryCode,
        enbleContryRestrictMap: enbleContryRestrictMap,
        currentLatLng: currentLatLng,
        sessionToken: sessionToken,
        languageCode: languageCode);
  }

  Future<Either<Failure, dynamic>> getAutoCompletePlaceLatLng(
      {required String placeId, String? sessionToken}) async {
    return _homeRepository.getAutoCompletePlaceLatLng(
        placeId: placeId, sessionToken: sessionToken);
  }

  Future<Either<Failure, dynamic>> getAddressFromLatLng({
    required double lat,
    required double lng,
    required String mapType,
  }) async {
    return _homeRepository.getAddressFromLatLng(
        lat: lat, lng: lng, mapType: mapType);
  }

  Future<Either<Failure, HistoryResponseModel>> getOnGoingRides(
      {required String historyFilter}) async {
    return _homeRepository.getOnGoingRides(historyFilter: historyFilter);
  }

  Future<Either<Failure, RecentRoutesModel>> getRecentRoutes() async {
    return _homeRepository.getRecentRoutes();
  }

  Future<Either<Failure, dynamic>> serviceLocationVerify({
    required String rideType,
    required List<AddressModel> address,
  }) async {
    return _homeRepository.serviceLocationVerify(
        rideType: rideType, address: address);
  }

  Future<Either<Failure, RideModulesModel>> rideModules() async {
    return _homeRepository.rideModules();
  }

  Future<Either<Failure, PromotionsPopupModel>> promotionPopups() async {
    return _homeRepository.promotionPopups();
  }

  Future<Either<Failure, HistoryResponseModel>> getUpcomingRides(
      {required String historyFilter}) async {
    return _homeRepository.getUpcomingRides(historyFilter: historyFilter);
  }
}