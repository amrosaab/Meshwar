import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/network/network.dart';
import '../../../account/domain/models/history_model.dart';
import '../models/Promotions_popup_model.dart';
import '../models/recent_routes_model.dart';
import '../models/ride_modules_model.dart';
import '../models/stop_address_model.dart';
import '../models/user_details_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserDetailResponseModel>> getUserDetails(
      {String? requestId});

  Future<Either<Failure, dynamic>> getAutoCompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
    String? sessionToken,
    String? languageCode,
  });

  Future<Either<Failure, dynamic>> getAutoCompletePlaceLatLng(
      {required String placeId, String? sessionToken});

  Future<Either<Failure, dynamic>> getAddressFromLatLng({
    required double lat,
    required double lng,
    required String mapType,
  });

  Future<Either<Failure, HistoryResponseModel>> getOnGoingRides(
      {required String historyFilter});

  Future<Either<Failure, RecentRoutesModel>> getRecentRoutes();

  Future<Either<Failure, dynamic>> serviceLocationVerify({
    required String rideType,
    required List<AddressModel> address,
  });

  Future<Either<Failure, RideModulesModel>> rideModules();

  Future<Either<Failure, PromotionsPopupModel>> promotionPopups();

  Future<Either<Failure, HistoryResponseModel>> getUpcomingRides(
      {required String historyFilter});
}