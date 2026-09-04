import 'package:dartz/dartz.dart';
import '../../../../core/network/network.dart';
import '../../../home/domain/models/user_details_model.dart';
import '../../../home/domain/models/stop_address_model.dart';
import '../../domain/models/cancel_reason_model.dart';
import '../../domain/models/chat_history_model.dart';
import '../../domain/models/destination_change_model.dart';
import '../../domain/models/eta_details_model.dart';
import '../../domain/models/goods_type_model.dart';
import '../../domain/models/payment_change_model.dart';
import '../../domain/models/polyline_model.dart';
import '../../domain/models/promo_code_list_model.dart';
import '../../domain/models/rental_packages_model.dart';
import '../../domain/repositories/booking_repo.dart';

class BookingUsecase {
  final BookingRepository _bookingRepository;

  const BookingUsecase(this._bookingRepository);

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
  }) async {
    return _bookingRepository.etaRequest(
      picklat: picklat,
      picklng: picklng,
      droplat: droplat,
      droplng: droplng,
      rideType: rideType,
      transportType: transportType,
      promoCode: promoCode,
      vehicleType: vehicleType,
      distance: distance,
      duration: duration,
      polyLine: polyLine,
      pickupAddressList: pickupAddressList,
      dropAddressList: dropAddressList,
      isOutstationRide: isOutstationRide,
      isWithoutDestinationRide: isWithoutDestinationRide,
      preferences: preferences,
      sharedRide: sharedRide,
      seatsTaken: seatsTaken,
      isLater: isLater,
      tripStartTime: tripStartTime,
    );
  }

  // Rental Eta Details
  Future<Either<Failure, RentalPackagesModel>> rentalEtaRequest({
    required String picklat,
    required String picklng,
    required String transportType,
    String? promoCode,
    List? preferenceId,
    int? isLater,
    String? tripStartTime,
  }) async {
    return _bookingRepository.rentalEtaRequest(
        picklat: picklat,
        picklng: picklng,
        transportType: transportType,
        promoCode: promoCode,
        preferenceId: preferenceId,
        isLater: isLater,
        tripStartTime: tripStartTime);
  }

  //  createRequest
  Future<Either<Failure, dynamic>> createRequest({
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
    String? contactBookName,
  }) async {
    return _bookingRepository.createRequest(
        userData: userData,
        vehicleData: vehicleData,
        pickupAddressList: pickupAddressList,
        dropAddressList: dropAddressList,
        selectedTransportType: selectedTransportType,
        selectedPaymentType: selectedPaymentType,
        scheduleDateTime: scheduleDateTime,
        isEtaRental: isEtaRental,
        isBidRide: isBidRide,
        goodsTypeId: goodsTypeId,
        goodsQuantity: goodsQuantity,
        offeredRideFare: offeredRideFare,
        polyLine: polyLine,
        isAirport: isAirport,
        paidAt: paidAt,
        isParcel: isParcel,
        packageId: packageId,
        isOutstationRide: isOutstationRide,
        isRoundTrip: isRoundTrip,
        scheduleDateTimeForReturn: scheduleDateTimeForReturn,
        cardToken: cardToken,
        taxiInstruction: taxiInstruction,
        parcelType: parcelType,
        preferences: preferences,
        sharedRide: sharedRide,
        seatsTaken: seatsTaken,
        bookOthers: bookOthers,
        contactNumber: contactNumber,
        myself: myself,
        contactBookName: contactBookName);
  }

  // cancelRequest
  Future<Either<Failure, dynamic>> cancelRequest(
      {required String requestId,
      String? reason,
      bool? timerCancel,
      String? customReason}) async {
    return _bookingRepository.cancelRequest(
        requestId: requestId,
        reason: reason,
        timerCancel: timerCancel,
        customReason: customReason);
  }

  // User Reviews
  Future<Either<Failure, dynamic>> userReview(
      {required String requestId,
      required String ratings,
      required String feedBack}) async {
    return _bookingRepository.userReview(
        requestId: requestId, ratings: ratings, feedBack: feedBack);
  }

  // Goods Types
  Future<Either<Failure, GoodsTypeModel>> getGoodsTypes() async {
    return _bookingRepository.getGoodsTypes();
  }

  // BiddingAccept
  Future<Either<Failure, dynamic>> biddingAccept(
      {required String requestId,
      required String driverId,
      required String acceptRideFare,
      required String offeredRideFare}) async {
    return _bookingRepository.biddingAccept(
        requestId: requestId,
        driverId: driverId,
        acceptRideFare: acceptRideFare,
        offeredRideFare: offeredRideFare);
  }

  // CancelReasons
  Future<Either<Failure, CancelReasonsModel>> cancelReasons(
      {required String beforeOrAfter, required String requestId}) async {
    return _bookingRepository.cancelReasons(
        beforeOrAfter: beforeOrAfter, requestId: requestId);
  }

  // Get Polyline
  Future<Either<Failure, PolylineModel>> getPolyline({
    required double pickLat,
    required double pickLng,
    required double dropLat,
    required double dropLng,
    required List<AddressModel> stops,
    required bool isOpenStreet,
  }) async {
    return _bookingRepository.getPolyline(
      pickLat: pickLat,
      pickLng: pickLng,
      dropLat: dropLat,
      dropLng: dropLng,
      stops: stops,
      isOpenStreet: isOpenStreet,
    );
  }

  // Chat History
  Future<Either<Failure, ChatHistoryModel>> getChatHistory(
      {required String requestId}) async {
    return _bookingRepository.getChatHistory(requestId: requestId);
  }

  // Chat Seen
  Future<dynamic> seenChatMessage({required String requestId}) async {
    return _bookingRepository.seenChatMessage(requestId: requestId);
  }

  // Chat Message Send
  Future<Either<Failure, dynamic>> sendChatMessage(
      {required String requestId, required String message}) async {
    return _bookingRepository.sendChatMessage(
        requestId: requestId, message: message);
  }

  Future<Either<Failure, dynamic>> addTips(
      {required String requestId, required String amount}) async {
    return _bookingRepository.addTips(requestId: requestId, amount: amount);
  }

  Future<Either<Failure, PaymentChange>> changePaymentMethod(
      {required String requestId, required String paymentOption}) async {
    return _bookingRepository.changePaymentMethod(
        requestId: requestId, paymentOption: paymentOption);
  }

  Future<Either<Failure, DestinationChangeModel>> changeDestinationApi(
      {required String requestId,
      required String dropLat,
      required String dropLng,
      required String dropAddress,
      required String duration,
      required String distance,
      required String polyLine,
      required List<AddressModel> stops}) async {
    return _bookingRepository.changeDestinationApi(
        requestId: requestId,
        dropLat: dropLat,
        dropLng: dropLng,
        dropAddress: dropAddress,
        duration: duration,
        distance: distance,
        polyLine: polyLine,
        stops: stops);
  }

  Future<Either<Failure, PromoCodeListModel>> getPromoList() async {
    return _bookingRepository.getPromoList();
  }
}
