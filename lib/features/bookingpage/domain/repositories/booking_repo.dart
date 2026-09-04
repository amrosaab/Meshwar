import 'package:dartz/dartz.dart';

import '../../../../core/network/network.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../../home/domain/models/stop_address_model.dart';
import '../models/cancel_reason_model.dart';
import '../models/chat_history_model.dart';
import '../models/destination_change_model.dart';
import '../models/eta_details_model.dart';
import '../models/goods_type_model.dart';
import '../models/payment_change_model.dart';
import '../models/polyline_model.dart';
import '../models/promo_code_list_model.dart';
import '../models/rental_packages_model.dart';

abstract class BookingRepository {
  // Eta Details
  Future<Either<Failure, EtaDetailsListModel>> etaRequest({
    required String picklat,
    required String picklng,
    required String droplat,
    required String droplng,
    required int rideType,
    required String transportType,
    String? promoCode,
    String? vehicleType,
    required String distance,
    required String duration,
    required String polyLine,
    required List<AddressModel> pickupAddressList,
    required List<AddressModel> dropAddressList,
    required bool isOutstationRide,
    required bool isWithoutDestinationRide,
    List? preferences,
    int? sharedRide,
    int? seatsTaken,
    int? isLater,
    String? tripStartTime,
  });

  // Rental Eta Details
  Future<Either<Failure, RentalPackagesModel>> rentalEtaRequest({
    required String picklat,
    required String picklng,
    required String transportType,
    String? promoCode,
    List? preferenceId,
    int? isLater,
    String? tripStartTime,
  });

  // createRequest
  Future<Either<Failure, dynamic>> createRequest(
      {required UserDetail userData,
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
      bool? isAirport,
      bool? isParcel,
      String? packageId,
      required bool isOutstationRide,
      required bool isRoundTrip,
      required String scheduleDateTimeForReturn,
      required String taxiInstruction,
      String? cardToken,
      String? parcelType,
      required List preferences,
      int? sharedRide,
      int? seatsTaken,
      int? bookOthers,
      String? contactNumber,
      int? myself,
      String? contactBookName});

  // createRequest
  Future<Either<Failure, dynamic>> cancelRequest(
      {required String requestId,
      String? reason,
      bool? timerCancel,
      String? customReason});

  // User Reviews
  Future<Either<Failure, dynamic>> userReview(
      {required String requestId,
      required String ratings,
      required String feedBack});

  // Goods Type
  Future<Either<Failure, GoodsTypeModel>> getGoodsTypes();

  // BiddingAccept
  Future<Either<Failure, dynamic>> biddingAccept(
      {required String requestId,
      required String driverId,
      required String acceptRideFare,
      required String offeredRideFare});

  // CancelReasons
  Future<Either<Failure, CancelReasonsModel>> cancelReasons(
      {required String beforeOrAfter, required String requestId});

  // Get Polyline
  Future<Either<Failure, PolylineModel>> getPolyline({
    required double pickLat,
    required double pickLng,
    required double dropLat,
    required double dropLng,
    required List<AddressModel> stops,
    required bool isOpenStreet,
  });

  // Chat History
  Future<Either<Failure, ChatHistoryModel>> getChatHistory(
      {required String requestId});
  // Chat Seen
  Future<dynamic> seenChatMessage({required String requestId});
  // Chat Message Send
  Future<Either<Failure, dynamic>> sendChatMessage(
      {required String requestId, required String message});
  Future<Either<Failure, dynamic>> addTips(
      {required String requestId, required String amount});
  Future<Either<Failure, PaymentChange>> changePaymentMethod(
      {required String requestId, required String paymentOption});

  Future<Either<Failure, DestinationChangeModel>> changeDestinationApi(
      {required String requestId,
      required String dropLat,
      required String dropLng,
      required String dropAddress,
      required String duration,
      required String distance,
      required String polyLine,
      required List<AddressModel> stops});

  Future<Either<Failure, PromoCodeListModel>> getPromoList();
}
