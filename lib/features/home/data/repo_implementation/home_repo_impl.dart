import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/common.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/network.dart';
import '../../../account/domain/models/history_model.dart';
import '../../domain/models/Promotions_popup_model.dart';
import '../../domain/models/recent_routes_model.dart';
import '../../domain/models/ride_modules_model.dart';
import '../../domain/models/stop_address_model.dart';
import '../../domain/models/user_details_model.dart';
import '../../domain/repositories/home_repo.dart';
import '../repository/home_api.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApi _homeApi;

  HomeRepositoryImpl(this._homeApi);

  // UserDetailData
  @override
  Future<Either<Failure, UserDetailResponseModel>> getUserDetails(
      {String? requestId}) async {
    UserDetailResponseModel userDetailsResponseModel;
    try {
      Response response =
      await _homeApi.getUserDetailsApi(requestId: requestId);
      printWrapped('Get User Response : ${response.data}');
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
          userDetailsResponseModel =
              UserDetailResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(userDetailsResponseModel);
  }

  @override
  Future<Either<Failure, dynamic>> getAutoCompletePlaces({
    required String input,
    required String mapType,
    required String? countryCode,
    required String enbleContryRestrictMap,
    required LatLng currentLatLng,
    String? sessionToken,
    String? languageCode,
  }) async {
    List<dynamic> placesResponse = [];
    try {
      final response = await _homeApi.getAutocompletePlaces(
          countryCode: countryCode,
          enbleContryRestrictMap: enbleContryRestrictMap,
          input: input,
          mapType: mapType,
          currentLatLng: currentLatLng,
          sessionToken: sessionToken,
          languageCode: languageCode);
      //
      printWrapped('Places Response  : $response');
      printWrapped('Places Response  : ${countryCode } ${mapType}');
      if (response.data.toString() != '{}') {
        if (mapType == 'google_map') {
          for (var element in response.data["suggestions"]) {
            placesResponse.add({
              'place_id': element['placePrediction']['placeId'],
              'description': element['placePrediction']['text']['text'],
              'lat': '',
              'lon': '',
              'display_name': element['placePrediction']['structuredFormat']
              ['mainText']['text'],
            });
          }
        } else {
          if (response.data != null && response.data is List) {
            for (var element in response.data) {
              placesResponse.add({
                'place_id': element['osm_id'].toString(),
                'description': element['display_name'],
                'lat': element['lat'],
                'lon': element['lon'],
                'display_name': element['display_name'],
              });
            }
          }
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(placesResponse);
  }

  @override
  Future<Either<Failure, dynamic>> getAutoCompletePlaceLatLng(
      {required String placeId, String? sessionToken}) async {
    LatLng placesResponse;
    try {
      final response = await _homeApi.getAutocompletePlaceLatLng(
          placeId: placeId, sessionToken: sessionToken);
      printWrapped('Place LatLng Response : $response');
      placesResponse = response;
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    }

    return Right(placesResponse);
  }

  @override
  Future<Either<Failure, String>> getAddressFromLatLng({
    required double lat,
    required double lng,
    required String mapType,
  }) async {
    String placesResponse = '';

    try {
      final response = await _homeApi.getAddressFromLatLng(
        lat: lat,
        lng: lng,
        mapType: mapType,
      );

      /// -------- GOOGLE MAP RESPONSE ----------
      if (mapType == 'google_map') {
        final results = response.data?['results'];

        if (results != null && results is List && results.isNotEmpty) {
          for (final result in results) {
            final addressComponents = result['address_components'];

            //  SAFETY CHECK
            if (addressComponents == null ||
                addressComponents is! List ||
                addressComponents.isEmpty) {
              continue;
            }

            final types = addressComponents[0]?['types'];

            if (types == null || types is! List || types.isEmpty) {
              continue;
            }

            //  Skip Plus Code result
            if (!types.contains('plus_code')) {
              placesResponse = result['formatted_address'] ?? '';
              break;
            }
          }
        }
      }

      /// -------- OSM MAP RESPONSE ----------
      else {
        if (response.data != null && response.data['display_name'] != null) {
          placesResponse = response.data['display_name'].toString();
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(placesResponse);
  }

  @override
  Future<Either<Failure, HistoryResponseModel>> getOnGoingRides(
      {required String historyFilter}) async {
    HistoryResponseModel onGoingRidesResponse;
    try {
      Response response =
      await _homeApi.getOnGoingRidesApi(historyFilter: historyFilter);
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
          onGoingRidesResponse = HistoryResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(onGoingRidesResponse);
  }

  @override
  Future<Either<Failure, RecentRoutesModel>> getRecentRoutes() async {
    RecentRoutesModel recentRoutes;
    try {
      Response response = await _homeApi.getRecentRoutesApi();
      printWrapped('Recent Routes Response : ${response.data}');
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
          recentRoutes = RecentRoutesModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(recentRoutes);
  }

  @override
  Future<Either<Failure, dynamic>> serviceLocationVerify({
    required String rideType,
    required List<AddressModel> address,
  }) async {
    dynamic res;
    try {
      Response response = await _homeApi.serviceLocationVerifyApi(
          rideType: rideType, address: address);
      printWrapped('Service Available Response : ${response.data}');
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
          res = response.data;
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(res);
  }

  @override
  Future<Either<Failure, RideModulesModel>> rideModules() async {
    RideModulesModel res;
    try {
      Response response = await _homeApi.rideModulesApi();
      printWrapped('Ride Modules Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else if (response.statusCode != 200) {
          return Left(GetDataFailure(message: response.data['message']));
        } else {
          res = RideModulesModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(res);
  }

  @override
  Future<Either<Failure, PromotionsPopupModel>> promotionPopups() async {
    PromotionsPopupModel res;
    try {
      Response response = await _homeApi.promotionPopupsApi();
      printWrapped('Ride Modules Response : ${response.data}');
      if (response.data == null || response.data == '') {
        return Left(GetDataFailure(message: 'User bad request'));
      } else if (response.data.toString().contains('error')) {
        return Left(GetDataFailure(message: response.data['error']));
      } else {
        if (response.statusCode == 400 || response.statusCode == 401) {
          return Left(GetDataFailure(message: 'logout'));
        } else if (response.statusCode == 429) {
          return Left(GetDataFailure(message: 'Too many attempts'));
        } else if (response.statusCode != 200) {
          return Left(GetDataFailure(message: response.data['message']));
        } else {
          res = PromotionsPopupModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(res);
  }

  @override
  Future<Either<Failure, HistoryResponseModel>> getUpcomingRides(
      {required String historyFilter}) async {
    HistoryResponseModel upcomingRidesResponse;
    try {
      Response response =
      await _homeApi.getUpcomingRidesApi(historyFilter: historyFilter);
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
          upcomingRidesResponse = HistoryResponseModel.fromJson(response.data);
        }
      }
    } on FetchDataException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } on BadRequestException catch (e) {
      return Left(InPutDataFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(GetDataFailure(message: e.message));
    } catch (e) {
      return Left(GetDataFailure(message: e.toString()));
    }

    return Right(upcomingRidesResponse);
  }
}