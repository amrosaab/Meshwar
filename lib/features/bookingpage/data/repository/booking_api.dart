import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../common/common.dart';
import '../../../../core/network/network.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../../home/domain/models/stop_address_model.dart';

class BookingApi {
  // Eta Details
  Future<dynamic> etaRequestApi({
    required String picklat,
    required String picklng,
    required String droplat,
    required String droplng,
    required int rideType,
    required String transportType,
    required String distance,
    required String duration,
    required String polyLine,
    required List<AddressModel> pickupAddressList,
    required List<AddressModel> dropAddressList,
    String? promoCode,
    String? vehicleType,
    required bool isOutstationRide,
    required bool isWithoutDestinationRide,
    List? preferences,
    int? sharedRide,
    int? seatsTaken,
    int? isLater,
    String? tripStartTime,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      List stopList = [];
      if (dropAddressList.length > 1) {
        for (var i = 0; i < dropAddressList.length; i++) {
          if (i != dropAddressList.length - 1) {
            stopList.add(dropAddressList[i].toJson());
          }
        }
      }
      Response response = await DioProviderImpl().post(ApiEndpoints.etaDetails,
          headers: {'Authorization': token},
          body: FormData.fromMap({
            'pick_lat': picklat,
            'pick_lng': picklng,
            if (droplat.isNotEmpty && !isWithoutDestinationRide)
              'drop_lat': droplat,
            if (droplng.isNotEmpty && !isWithoutDestinationRide)
              'drop_lng': droplng,
            'ride_type': rideType,
            if (promoCode != null) 'promo_code': promoCode,
            if (vehicleType != null) 'vehicle_type': vehicleType,
            'transport_type': transportType,
            'distance': distance,
            'duration': duration,
            'polyline': polyLine,
            'pick_address': pickupAddressList.first.address,
            'pick_short_address': pickupAddressList.first.address.split(',')[0],
            'drop_address': (dropAddressList.isNotEmpty)
                ? dropAddressList.last.address
                : '',
            'drop_short_address': (dropAddressList.isNotEmpty)
                ? dropAddressList.last.address.split(',')[0]
                : '',
            if (stopList.isNotEmpty) 'stops': jsonEncode(stopList),
            if (isOutstationRide) 'is_out_station': '1',
            if (preferences != null && preferences.isNotEmpty)
              'preferences': jsonEncode(preferences),
            if (sharedRide != null) 'shared_ride': sharedRide,
            if (seatsTaken != null) 'seats_taken': seatsTaken,
            if (isLater != null) 'is_later': isLater,
            if (tripStartTime != null) 'trip_start_time': tripStartTime,
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Rental Eta Details
  Future<dynamic> rentalEtaRequestApi({
    required String picklat,
    required String picklng,
    required String transportType,
    String? promoCode,
    List? preferenceId,
    int? isLater,
    String? tripStartTime,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response =
          await DioProviderImpl().post(ApiEndpoints.rentalEtaDetails,
              headers: {
                'Authorization': token,
              },
              body: FormData.fromMap({
                'pick_lat': picklat,
                'pick_lng': picklng,
                'transport_type': transportType,
                if (promoCode != null) 'promo_code': promoCode,
                if (preferenceId != null && preferenceId.isNotEmpty)
                  'preferences': jsonEncode(preferenceId),
                if (isLater != null) 'is_later': isLater,
                if (tripStartTime != null) 'trip_start_time': tripStartTime,
              }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future createRequestApi({
    required UserDetail userData,
    required dynamic vehicleData,
    required List<AddressModel> pickupAddressList,
    required List<AddressModel> dropAddressList,
    required String selectedTransportType,
    required String selectedPaymentType,
    required String scheduleDateTime,
    required bool isEtaRental,
    required bool isBidRide,
    String? goodsTypeId,
    String? goodsQuantity,
    required String offeredRideFare,
    required String polyLine,
    required String paidAt,
    required bool isOutstationRide,
    required bool isRoundTrip,
    required String scheduleDateTimeForReturn,
    required String taxiInstruction,
    bool? isAirport,
    bool? isParcel,
    String? packageId,
    String? cardToken,
    String? parcelType,
    required List preferences,
    int? sharedRide,
    int? seatsTaken,
    int? bookOthers,
    String? contactNumber,
    int? myself,
    String? contactBookName,
  }) async {
    try {
      final token = await AppSharedPreference.getToken();
      final body = {
        if (isAirport != null && isAirport) 'is_airport': true,
        if (isParcel != null && isParcel) 'is_parcel': 1,
        if (parcelType != null && parcelType.isNotEmpty)
          'parcel_type': parcelType,
        'pick_lat': pickupAddressList[0].lat,
        'pick_lng': pickupAddressList[0].lng,
        'pick_address': pickupAddressList[0].address,
        if (dropAddressList.isNotEmpty) 'drop_lat': dropAddressList.last.lat,
        if (dropAddressList.isNotEmpty) 'drop_lng': dropAddressList.last.lng,
        if (dropAddressList.isNotEmpty)
          'drop_address': dropAddressList.first.address,
        'ride_type': 1,
        'vehicle_type': vehicleData.zoneTypeId,
        if (selectedTransportType != 'taxi') 'paid_at': paidAt,
        'payment_opt': (selectedPaymentType == 'cash')
            ? 1
            : (selectedPaymentType == 'wallet')
                ? 2
                : (selectedPaymentType == 'card' ||
                        selectedPaymentType == 'online')
                    ? 0
                    : '',
        if (cardToken != null && cardToken.isNotEmpty) 'card_token': cardToken,
        'transport_type':
            (selectedTransportType == 'taxi') ? 'taxi' : 'delivery',
        'request_eta_amount':
            (!isEtaRental) ? vehicleData.total : vehicleData.fareAmount,
        if (offeredRideFare.isNotEmpty) 'offerred_ride_fare': offeredRideFare,
        if (scheduleDateTime.isNotEmpty) 'is_later': 1,
        if (selectedTransportType == 'taxi' && taxiInstruction.isNotEmpty)
          'pickup_poc_instruction': taxiInstruction,
        if (scheduleDateTime.isNotEmpty)
          'trip_start_time': scheduleDateTime.toString().substring(0, 19),
        'is_bid_ride': (scheduleDateTime.isNotEmpty)
            ? 0
            : (!isEtaRental && isBidRide)
                ? 1
                : 0,
        if (selectedTransportType != 'taxi')
          'pickup_poc_name': pickupAddressList[0].name,
        if (selectedTransportType != 'taxi')
          'pickup_poc_mobile': pickupAddressList[0].number,
        if (selectedTransportType != 'taxi')
          'pickup_poc_instruction': pickupAddressList[0].instructions,
        if (selectedTransportType != 'taxi' && !isEtaRental)
          'drop_poc_name': dropAddressList[dropAddressList.length - 1].name,
        if (selectedTransportType != 'taxi' && !isEtaRental)
          'drop_poc_mobile': dropAddressList[dropAddressList.length - 1].number,
        if (selectedTransportType != 'taxi' && !isEtaRental)
          'drop_poc_instruction':
              dropAddressList[dropAddressList.length - 1].instructions,
        if (selectedTransportType != 'taxi' && goodsTypeId != null)
          'goods_type_id': goodsTypeId,
        if (selectedTransportType != 'taxi' && goodsQuantity != null)
          'goods_type_quantity': goodsQuantity,
        if (dropAddressList.length > 1) 'stops': jsonEncode(dropAddressList),
        if (isEtaRental && packageId != null) 'rental_pack_id': packageId,
        if (vehicleData.hasDiscount == true)
          'promocode_id': vehicleData.promocodeId,
        if (vehicleData.hasDiscount == true)
          'discounted_total': vehicleData.discountTotal,
        'poly_line': polyLine,
        if (!isEtaRental) 'distance': vehicleData.distanceInMeters,
        if (!isEtaRental) 'duration': vehicleData.time.toString(),
        if (isOutstationRide) 'is_out_station': '1',
        if (isOutstationRide && isRoundTrip) 'is_round_trip': '1',
        if (isOutstationRide && isRoundTrip)
          'return_time': scheduleDateTimeForReturn,
        'preferences': jsonEncode(preferences),
        if (sharedRide != null) 'shared_ride': sharedRide,
        if (seatsTaken != null) 'seats_taken': seatsTaken,
        'book_for_other': bookOthers,
        'contact_no_other': contactNumber,
        'myself': myself,
        'other_contact_name': contactBookName,
      };
      Response response = await DioProviderImpl().post(
        (selectedTransportType == 'taxi')
            ? ApiEndpoints.createRequest
            : ApiEndpoints.deliveryCreateRequest,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: FormData.fromMap(body),
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future cancelRequestApi(
      {required String requestId,
      String? reason,
      bool? timerCancel,
      String? customReason}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.cancelRequest,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({
            'request_id': requestId,
            if (reason != null) 'reason': reason,
            'custom_reason': customReason,
            if (timerCancel != null && timerCancel) 'cancel_method': 0
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // User Reviews
  Future<dynamic> userReviewApi(
      {required String requestId,
      required String ratings,
      required String feedBack}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(ApiEndpoints.userReview,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({
            'request_id': requestId,
            'rating': ratings,
            'comment': feedBack
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Goods Type
  Future<dynamic> goodsTypeApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.goodsType,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Bidding Accept
  Future<dynamic> biddingAcceptApi(
      {required String requestId,
      required String driverId,
      required String acceptRideFare,
      required String offeredRideFare}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.biddingAccept,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({
            'driver_id': driverId,
            'request_id': requestId,
            'accepted_ride_fare': acceptRideFare,
            'offerred_ride_fare': offeredRideFare,
          }));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Cancel Reasons
  Future<dynamic> cancelReasonsApi(
      {required String beforeOrAfter, required String requestId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.cancelReasons}?arrived=$beforeOrAfter&&request_id=$requestId',
        headers: {'Authorization': token},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // GetPolyline
  Future getPolylineApi({
    required double pickLat,
    required double pickLng,
    required double dropLat,
    required double dropLng,
    required List<AddressModel> stops,
    required bool isOpenStreet,
  }) async {
    try {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      String signKey = buildKeys.buildSignature;
      String packageName = buildKeys.packageName;
      List intermediates = [];

      // Construct waypoints if any
      if (isOpenStreet) {
        String wayPoints = '';
        String url = '';
        if (stops.isNotEmpty) {
          for (var stop in stops) {
            wayPoints += '${stop.lng},${stop.lat};'; // OSRM requires "lng,lat"
          }
          // Remove the last semicolon
          wayPoints = wayPoints.substring(0, wayPoints.length - 1);
        }

        // Construct the API request URL
        if (wayPoints.isNotEmpty) {
          url = 'https://routing.openstreetmap.de/routed-car/route/v1/driving/'
              '$pickLng,$pickLat;$wayPoints?overview=full';
        } else {
          url = 'https://routing.openstreetmap.de/routed-car/route/v1/driving/'
              '$pickLng,$pickLat;$dropLng,$dropLat?overview=full';
        }

        // Make the HTTP request
        Response response = await DioProviderImpl().getUri(Uri.parse(url));
        return response;
      } else {
        if (stops.isNotEmpty) {
          for (var stop in stops) {
            intermediates.add({
              "location": {
                "latLng": {"latitude": stop.lat, "longitude": stop.lng}
              }
            });
          }
        }
        Response response = await DioProviderImpl().post(
          ApiEndpoints.getPolyline,
          body: {
            "origin": {
              "location": {
                "latLng": {"latitude": pickLat, "longitude": pickLng}
              }
            },
            "destination": {
              "location": {
                "latLng": {"latitude": dropLat, "longitude": dropLng}
              }
            },
            "intermediates": intermediates,
            "travelMode": "DRIVE",
            "routingPreference": "TRAFFIC_AWARE",
            "computeAlternativeRoutes": false,
            "routeModifiers": {
              "avoidTolls": false,
              "avoidHighways": false,
              "avoidFerries": false
            },
            "languageCode": "en-US",
            "units": "IMPERIAL"
          },
          headers: {
            'X-Goog-Api-Key': AppConstants.mapKey,
            'Content-Type': 'application/json',
            'X-Goog-FieldMask':
                'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
            if (Platform.isAndroid) 'X-Android-Package': packageName,
            if (Platform.isAndroid) 'X-Android-Cert': signKey,
            if (Platform.isIOS) 'X-IOS-Bundle-Identifier': packageName,
          },
        );
        return response;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getChatHistoryApi({required String requestId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        '${ApiEndpoints.chatHistory}/$requestId',
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> chatMessageSeenApi({required String requestId}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.chatMessageSeen,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: FormData.fromMap({'request_id': requestId}));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> sendChatMessageApi(
      {required String requestId, required String message}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
          ApiEndpoints.sendChatMessage,
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body:
              FormData.fromMap({'request_id': requestId, 'message': message}));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> addTipsApi(
      {required String requestId, required String amount}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().post(
        '${ApiEndpoints.addTips}?request_id=$requestId&tip_amount=$amount',
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  //change payment
  Future changePaymentMethod(
      {required String requestId, required String paymentOption}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response =
          await DioProviderImpl().post(ApiEndpoints.changePaymentMethod,
              headers: {'Authorization': token},
              body: FormData.fromMap({
                'request_id': requestId,
                'payment_opt': (paymentOption == 'cash')
                    ? 1
                    : (paymentOption == 'card' || paymentOption == 'online')
                        ? 0
                        : '',
              }));

      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // Change Destination
  Future changeDestinationApi(
      {required String requestId,
      required String dropLat,
      required String dropLng,
      required String dropAddress,
      required String duration,
      required String distance,
      required String polyLine,
      required List<AddressModel> stops}) async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response =
          await DioProviderImpl().post(ApiEndpoints.changeDestination,
              headers: {'Authorization': token},
              body: FormData.fromMap({
                "request_id": requestId,
                "drop_lat": dropLat,
                "drop_lng": dropLng,
                "drop_address": dropAddress,
                "duration": duration,
                "distance": distance,
                "poly_line": polyLine,
                if (stops.isNotEmpty && stops.length > 1)
                  "stops": jsonEncode(stops)
              }));

      if (kDebugMode) {
        printWrapped(response.data.toString());
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getPromoListApi() async {
    try {
      final token = await AppSharedPreference.getToken();
      Response response = await DioProviderImpl().get(
        ApiEndpoints.promoCodeList,
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
