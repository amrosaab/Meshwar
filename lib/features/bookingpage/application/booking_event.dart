part of 'booking_bloc.dart';

abstract class BookingEvent {}

class UpdateEvent extends BookingEvent {}

class BookingGetEvent extends BookingEvent {}

class BookingInitEvent extends BookingEvent {
  final BookingPageArguments arg;
  final dynamic vsync;

  BookingInitEvent({required this.arg, required this.vsync});
}

class GetDirectionEvent extends BookingEvent {
  final dynamic vsync;

  GetDirectionEvent({required this.vsync});
}

// Get eta request
class BookingEtaRequestEvent extends BookingEvent {
  final String picklat;
  final String picklng;
  final String droplat;
  final String droplng;
  final int ridetype;
  final String transporttype;
  final String? promocode;
  final String? vehicleId;
  final String distance;
  final String duration;
  final String polyLine;
  final List<AddressModel> pickupAddressList;
  final List<AddressModel> dropAddressList;
  final bool isOutstationRide;
  final bool isWithoutDestinationRide;
  final List? preferenceId;
  final int? sharedRide;
  final int? seatsTaken;
  final int? isLater;
  final String? tripStartTime;
  BookingEtaRequestEvent({
    required this.picklat,
    required this.picklng,
    required this.droplat,
    required this.droplng,
    required this.ridetype,
    required this.transporttype,
    this.promocode,
    this.vehicleId,
    required this.distance,
    required this.duration,
    required this.polyLine,
    required this.pickupAddressList,
    required this.dropAddressList,
    required this.isOutstationRide,
    required this.isWithoutDestinationRide,
    this.preferenceId,
    this.sharedRide,
    this.seatsTaken,
    this.isLater,
    this.tripStartTime,
  });
}

class BookingRentalEtaRequestEvent extends BookingEvent {
  final String picklat;
  final String picklng;
  final String transporttype;
  final String? promocode;
  final List? preferenceId;
  final int? isLater;
  final String? tripStartTime;

  BookingRentalEtaRequestEvent({
    required this.picklat,
    required this.picklng,
    required this.transporttype,
    this.promocode,
    this.preferenceId,
    this.isLater,
    this.tripStartTime,
  });
}

class BookingEtaSelectEvent extends BookingEvent {
  final int selectedVehicleIndex;
  final bool isOutstationRide;
  final String? selectedTypeEta;

  BookingEtaSelectEvent(
      {required this.selectedVehicleIndex,
      required this.isOutstationRide,
      this.selectedTypeEta});
}

class BookingRentalPackageSelectEvent extends BookingEvent {
  final int selectedPackageIndex;

  BookingRentalPackageSelectEvent({required this.selectedPackageIndex});
}

class ShowRentalPackageListEvent extends BookingEvent {}

class RentalPackageConfirmEvent extends BookingEvent {
  final String picklat;
  final String picklng;
  final List? preferenceId;

  RentalPackageConfirmEvent({
    required this.picklat,
    required this.picklng,
    this.preferenceId,
  });
}

class BookingNavigatorPopEvent extends BookingEvent {}

class BookingStreamRequestEvent extends BookingEvent {}

class TimerEvent extends BookingEvent {
  final int duration;

  TimerEvent({
    required this.duration,
  });
}

class NoDriversEvent extends BookingEvent {}

class BookingCreateRequestEvent extends BookingEvent {
  final UserDetail userData;
  final dynamic vehicleData;
  final List<AddressModel> pickupAddressList;
  final List<AddressModel> dropAddressList;
  final String selectedTransportType;
  final String selectedPaymentType;
  final String cardToken;
  final String scheduleDateTime;
  final String? goodsTypeId;
  final String? goodsQuantity;
  final String polyLine;
  final bool isRentalRide;
  final String paidAt;
  final String? parcelType;
  final List preferences;
  final int? sharedRide;
  final int? seatsTaken;
  final int? bookOthers;
  final String? contactNumber;
  final int? myself;
  final String? contactBookName;
  final bool isOutstationRide;

  BookingCreateRequestEvent(
      {required this.userData,
      required this.vehicleData,
      required this.pickupAddressList,
      required this.dropAddressList,
      required this.selectedTransportType,
      required this.selectedPaymentType,
      required this.cardToken,
      required this.scheduleDateTime,
      this.goodsTypeId,
      this.goodsQuantity,
      required this.polyLine,
      required this.isRentalRide,
      required this.paidAt,
      this.parcelType,
      required this.preferences,
      this.sharedRide,
      this.seatsTaken,
      this.bookOthers,
      this.contactNumber,
      this.myself,
      this.contactBookName,
      required this.isOutstationRide});
}

class BookingCancelRequestEvent extends BookingEvent {
  final String requestId;
  final String? reason;
  final bool? timerCancel;
  final String? customReason;

  BookingCancelRequestEvent(
      {required this.requestId,
      this.reason,
      this.timerCancel,
      this.customReason});
}

class TripRideCancelEvent extends BookingEvent {
  final bool isCancelByDriver;

  TripRideCancelEvent({required this.isCancelByDriver});
}

class BookingGetUserDetailsEvent extends BookingEvent {
  final String? requestId;

  BookingGetUserDetailsEvent({this.requestId});
}

class ShowEtaInfoEvent extends BookingEvent {
  final int infoIndex;
  ShowEtaInfoEvent({required this.infoIndex});
}

class BookingRatingsSelectEvent extends BookingEvent {
  final int selectedIndex;

  BookingRatingsSelectEvent({required this.selectedIndex});
}

class BookingUserRatingsEvent extends BookingEvent {
  final String requestId;
  final String ratings;
  final String feedBack;

  BookingUserRatingsEvent(
      {required this.requestId, required this.ratings, required this.feedBack});
}

class GetGoodsTypeEvent extends BookingEvent {}

class EnableBiddingEvent extends BookingEvent {}

class BiddingIncreaseOrDecreaseEvent extends BookingEvent {
  final bool isIncrease;
  final bool isOutStation;

  BiddingIncreaseOrDecreaseEvent(
      {required this.isIncrease, required this.isOutStation});
}

class BiddingCreateRequestEvent extends BookingEvent {
  final UserDetail userData;
  final EtaDetails vehicleData;
  final List<AddressModel> pickupAddressList;
  final List<AddressModel> dropAddressList;
  final String selectedTransportType;
  final String selectedPaymentType;
  final String cardToken;
  final String scheduleDateTime;
  final String? goodsTypeId;
  final String? goodsQuantity;
  final String offeredRideFare;
  final String polyLine;
  final String paidAt;
  final bool isOutstationRide;
  final bool isRoundTrip;
  final String scheduleDateTimeForReturn;
  final String? parcelType;
  final List preferences;
  final List preferencesIcons;
  final int? bookOthers;
  final String? contactNumber;
  final int? myself;
  final String? contactBookName;

  BiddingCreateRequestEvent(
      {required this.userData,
      required this.vehicleData,
      required this.pickupAddressList,
      required this.dropAddressList,
      required this.selectedTransportType,
      required this.selectedPaymentType,
      required this.cardToken,
      required this.scheduleDateTime,
      this.goodsTypeId,
      this.goodsQuantity,
      required this.offeredRideFare,
      required this.polyLine,
      required this.paidAt,
      required this.isOutstationRide,
      required this.isRoundTrip,
      required this.scheduleDateTimeForReturn,
      this.parcelType,
      required this.preferences,
      required this.preferencesIcons,
      this.bookOthers,
      this.contactNumber,
      this.myself,
      this.contactBookName});
}

class BiddingFareUpdateEvent extends BookingEvent {}

class BiddingAcceptOrDeclineEvent extends BookingEvent {
  final bool isAccept;
  final dynamic driver;
  final String? id;
  final String? offeredRideFare;

  BiddingAcceptOrDeclineEvent({
    required this.isAccept,
    required this.driver,
    this.id,
    this.offeredRideFare,
  });
}

class CancelReasonsEvent extends BookingEvent {
  final String beforeOrAfter;
  CancelReasonsEvent({required this.beforeOrAfter});
}

class PolylineEvent extends BookingEvent {
  final double pickLat;
  final double pickLng;
  final double dropLat;
  final double dropLng;
  final String pickAddress;
  final String dropAddress;
  final List<AddressModel> stops;
  final bool? isInitCall;
  final bool? isDriverStream;
  final bool? isDriverToPick;
  final BookingPageArguments? arg;
  final BitmapDescriptor? icon;
  final String? markerId;
  final bool? isDropChanged;
  PolylineEvent(
      {required this.pickLat,
      required this.pickLng,
      required this.dropLat,
      required this.dropLng,
      required this.stops,
      required this.pickAddress,
      required this.dropAddress,
      this.isInitCall,
      this.isDriverStream,
      this.isDriverToPick,
      this.arg,
      this.icon,
      this.markerId,
      this.isDropChanged});
}

class ChatWithDriverEvent extends BookingEvent {
  final String requestId;

  ChatWithDriverEvent({required this.requestId});
}

class GetChatHistoryEvent extends BookingEvent {
  final String requestId;

  GetChatHistoryEvent({required this.requestId});
}

class SeenChatMessageEvent extends BookingEvent {
  final String requestId;

  SeenChatMessageEvent({required this.requestId});
}

class SendChatMessageEvent extends BookingEvent {
  final String message;
  final String requestId;

  SendChatMessageEvent({required this.message, required this.requestId});
}

class SOSEvent extends BookingEvent {}

class NotifyAdminEvent extends BookingEvent {
  final String serviceLocId;
  final String requestId;

  NotifyAdminEvent({required this.serviceLocId, required this.requestId});
}

class SelectBiddingOrDemandEvent extends BookingEvent {
  final String selectedTypeEta;
  final bool isBidding;
  final bool shareRide;

  SelectBiddingOrDemandEvent(
      {required this.selectedTypeEta,
      required this.isBidding,
      required this.shareRide});
}

class UpdateMinChildSizeEvent extends BookingEvent {
  final double minChildSize;
  UpdateMinChildSizeEvent({required this.minChildSize});
}

class UpdateScrollPhysicsEvent extends BookingEvent {
  final bool enableEtaScrolling;
  UpdateScrollPhysicsEvent({required this.enableEtaScrolling});
}

class UpdateScrollSizeEvent extends BookingEvent {
  final int minChildSize;
  UpdateScrollSizeEvent({required this.minChildSize});
}

class DetailViewUpdateEvent extends BookingEvent {
  final bool detailView;

  DetailViewUpdateEvent(this.detailView);
}

class WalletPageReUpdateEvents extends BookingEvent {
  String from;
  String url;
  String userId;
  String requestId;
  String currencySymbol;
  String money;
  WalletPageReUpdateEvents(
      {required this.from,
      required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}

class InvoiceInitEvent extends BookingEvent {
  final InvoicePageArguments arg;

  InvoiceInitEvent({required this.arg});
}

class ShowAddTipEvent extends BookingEvent {
  final bool showTipFeature;

  ShowAddTipEvent({required this.showTipFeature});
}

class AddTipsEvent extends BookingEvent {
  final String requestId;
  final String amount;
  AddTipsEvent({required this.requestId, required this.amount});
}

class ChangePaymentMethodEvent extends BookingEvent {
  final String paymentMethod;
  final OnTripRequestData requestData;
  ChangePaymentMethodEvent(
      {required this.paymentMethod, required this.requestData});
}

class EditLocationEvent extends BookingEvent {
  final OnTripRequestData? requestData;

  EditLocationEvent({required this.requestData});
}

class EditLocationPageInitEvent extends BookingEvent {
  final EditLocationPageArguments arg;

  EditLocationPageInitEvent({required this.arg});
}

class BookingLocateMeEvent extends BookingEvent {
  final String mapType;
  final dynamic controller;

  BookingLocateMeEvent({required this.mapType, required this.controller});
}

class ReorderEvent extends BookingEvent {
  int oldIndex;
  int newIndex;

  ReorderEvent({required this.oldIndex, required this.newIndex});
}

class AddStopEvent extends BookingEvent {}

class SelectFromMapEvent extends BookingEvent {}

class BookingAddOrEditStopAddressEvent extends BookingEvent {
  final int choosenAddressIndex;
  final AddressModel newAddress;

  BookingAddOrEditStopAddressEvent({
    required this.choosenAddressIndex,
    required this.newAddress,
  });
}

class ReceiverContactEvent extends BookingEvent {
  final String name;
  final String number;
  final bool isReceiveMyself;

  ReceiverContactEvent(
      {required this.name,
      required this.number,
      required this.isReceiveMyself});
}

class SelectContactDetailsEvent extends BookingEvent {}

class ChangeDestinationEvent extends BookingEvent {
  final String requestId;
  final String duration;
  final String distance;
  final String polyLine;
  final List<AddressModel> dropAddressList;

  ChangeDestinationEvent(
      {required this.requestId,
      required this.duration,
      required this.distance,
      required this.polyLine,
      required this.dropAddressList});
}

class AddMarkersEvent extends BookingEvent {
  final OnTripRequestData requestData;
  final List<AddressModel>? addressList;

  AddMarkersEvent({required this.requestData, this.addressList});
}

class UpdateMarkersEvent extends BookingEvent {
  final List markers;

  UpdateMarkersEvent({required this.markers});
}

class OnRidePaymentWebViewUrlEvent extends BookingEvent {
  dynamic from;
  dynamic url;
  dynamic userId;
  dynamic requestId;
  dynamic currencySymbol;
  dynamic money;

  OnRidePaymentWebViewUrlEvent({
    this.url,
    this.from,
    this.userId,
    this.requestId,
    this.currencySymbol,
    this.money,
  });
}

class UpdateMapTypeEvent extends BookingEvent {
  final MapType mapType;
  UpdateMapTypeEvent(this.mapType);
}

class SelectedPreferenceEvent extends BookingEvent {
  final int prefId;
  final bool isSelected;
  final String prefIcon;
  SelectedPreferenceEvent(
      {required this.prefId, required this.isSelected, required this.prefIcon});
}

class ConfirmPreferenceSelectionEvent extends BookingEvent {
  final BookingPageArguments arg;
  final List<int> selectedPreferences;
  ConfirmPreferenceSelectionEvent(
      {required this.arg, required this.selectedPreferences});
}

class SelectSharedSeatsEvent extends BookingEvent {
  final int seats;
  SelectSharedSeatsEvent({required this.seats});
}

class BookingResetEvent extends BookingEvent {}

class HideBottomBarEvent extends BookingEvent {}

class UpdateAddInstructionVisibilityEvent extends BookingEvent {
  final bool show;
  UpdateAddInstructionVisibilityEvent(this.show);
}

class GetPromoCodeListEvent extends BookingEvent {}

class SelectPromoEvent extends BookingEvent {
  final int index;
  SelectPromoEvent(this.index);
}

class ClearPromoEvent extends BookingEvent {}

class SelectBookingTypeEvent extends BookingEvent {}

class SelectMyselfRadioEvent extends BookingEvent {}

class SelectSavedContactRadioEvent extends BookingEvent {
  final int index;
  SelectSavedContactRadioEvent(this.index);
}

class ConfirmBookingTypePageEvent extends BookingEvent {
  final String contactName;
  final String contactMobile;
  final bool isMyself;

  ConfirmBookingTypePageEvent({
    required this.contactName,
    required this.contactMobile,
    required this.isMyself,
  });
}

class ReviewPageInitEvent extends BookingEvent {}
