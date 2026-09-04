part of 'home_bloc.dart';

abstract class HomeEvent {}

class UpdateEvent extends HomeEvent {}

class GetDirectionEvent extends HomeEvent {}

class GetUserDetailsEvent extends HomeEvent {}

class StreamRequestEvent extends HomeEvent {}

class GetLocationPermissionEvent extends HomeEvent {
  final GoogleMapController? controller;
  final bool isEditAddress;
  final bool isFromHomePage;

  GetLocationPermissionEvent(
      {this.controller,
      required this.isFromHomePage,
      required this.isEditAddress});
}

class ServiceTypeChangeEvent extends HomeEvent {
  final int serviceTypeIndex;
  final String transportType;
  final bool shouldNavigate;

  ServiceTypeChangeEvent({
    required this.serviceTypeIndex,
    required this.transportType,
    this.shouldNavigate = true,
  });
}

class DestinationSelectEvent extends HomeEvent {
  final bool isPickupChange;
  final String? dropAddress;
  final LatLng? dropLatLng;
  final String transportType;
  final bool isBiddingRide;
  final bool isSharedRide;

  DestinationSelectEvent({
    required this.isPickupChange,
    this.dropAddress,
    this.dropLatLng,
    required this.transportType,
    this.isBiddingRide = false,
    this.isSharedRide = false,
  });
}

class UpdateLocationEvent extends HomeEvent {
  final LatLng latLng;
  final bool isFromHomePage;
  final String mapType;

  UpdateLocationEvent(
      {required this.latLng,
      required this.isFromHomePage,
      required this.mapType});
}

class GoogleControllAssignEvent extends HomeEvent {
  final GoogleMapController controller;
  final LatLng latlng;
  final bool isFromHomePage;
  final bool isEditAddress;

  GoogleControllAssignEvent({
    required this.controller,
    required this.latlng,
    required this.isFromHomePage,
    required this.isEditAddress,
  });
}

class LocateMeEvent extends HomeEvent {
  final String mapType;

  LocateMeEvent({required this.mapType});
}

class DesinationPageInitEvent extends HomeEvent {
  final DestinationPageArguments arg;

  DesinationPageInitEvent({required this.arg});
}

class SearchPlacesEvent extends HomeEvent {
  final BuildContext context;
  final String searchText;
  final String mapType;
  final String countryCode;
  final LatLng latLng;
  final String enbleContryRestrictMap;

  SearchPlacesEvent({
    required this.context,
    required this.mapType,
    required this.countryCode,
    required this.enbleContryRestrictMap,
    required this.searchText,
    required this.latLng,
  });
}

class RecentSearchPlaceSelectEvent extends HomeEvent {
  final AddressModel address;
  final bool isPickupSelect;
  final String transportType;
  final int? serviceTypeIndex;

  RecentSearchPlaceSelectEvent(
      {required this.address,
      required this.isPickupSelect,
      required this.transportType,
      this.serviceTypeIndex});
}

class FavLocationSelectEvent extends HomeEvent {
  final FavoriteLocationData address;
  final bool isPickupSelect;

  FavLocationSelectEvent({required this.address, required this.isPickupSelect});
}

class SavedRecentTabChangeEvent extends HomeEvent {
  final bool isFavoriteSelected;

  SavedRecentTabChangeEvent({required this.isFavoriteSelected});
}

class SelectFromMapEvent extends HomeEvent {
  final bool isPickUpEdit;
  final int selectedAddressIndex;

  SelectFromMapEvent({
    required this.isPickUpEdit,
    required this.selectedAddressIndex,
  });
}

class NavigateToOnGoingRidesPageEvent extends HomeEvent {}

class GetOnGoingRidesEvent extends HomeEvent {}

class GetUpcomingRidesEvent extends HomeEvent {
  final String historyFilter;
  final int? pageNumber;
  final int? historyIndex;
  final bool? isFrom;

  GetUpcomingRidesEvent(
      {required this.historyFilter,
      this.pageNumber,
      this.historyIndex,
      this.isFrom});
}

class OnGoingRideOnTapEvent extends HomeEvent {
  final int selectedIndex;

  OnGoingRideOnTapEvent({required this.selectedIndex});
}

class ChangeBottomNavIndexEvent extends HomeEvent {
  final int index;
  final bool pushTripSummary;
  final HistoryData? historyData;
  final int? historyIndex;

  ChangeBottomNavIndexEvent({
    required this.index,
    this.pushTripSummary = false,
    this.historyData,
    this.historyIndex,
  });
}

// ConfirmLocationPageEvent

class ConfirmLocationPageInitEvent extends HomeEvent {
  final ConfirmLocationPageArguments arg;

  ConfirmLocationPageInitEvent({required this.arg});
}

class ConfirmAddressEvent extends HomeEvent {
  final bool isEditAddress;
  final bool isPickUpEdit;
  final bool isDelivery;
  final bool? isMyself;
  final String? contactNumber;
  final String? contactName;

  ConfirmAddressEvent(
      {required this.isEditAddress,
      required this.isPickUpEdit,
      required this.isDelivery,
      this.isMyself,
      this.contactNumber,
      this.contactName});
}

class ConfirmLocationSearchPlaceSelectEvent extends HomeEvent {
  final AddressModel address;
  final String mapType;

  ConfirmLocationSearchPlaceSelectEvent(
      {required this.address, required this.mapType});
}

class AddOrEditStopAddressEvent extends HomeEvent {
  final bool isPickUpEdit;
  final int choosenAddressIndex;
  final AddressModel newAddress;

  AddOrEditStopAddressEvent({
    required this.isPickUpEdit,
    required this.choosenAddressIndex,
    required this.newAddress,
  });
}

class ReceiverContactEvent extends HomeEvent {
  final String name;
  final String number;
  final bool isReceiveMyself;

  ReceiverContactEvent(
      {required this.name,
      required this.number,
      required this.isReceiveMyself});
}

class SelectContactDetailsEvent extends HomeEvent {}

class ReorderEvent extends HomeEvent {
  int oldIndex;
  int newIndex;

  ReorderEvent({required this.oldIndex, required this.newIndex});
}

//Update Scroll Event Map
class UpdateScrollPositionEvent extends HomeEvent {
  final double position;
  UpdateScrollPositionEvent(this.position);
}

class InitScrollPositionEvent extends HomeEvent {}

class UpdateScrollTopEvent extends HomeEvent {}

class AddStopEvent extends HomeEvent {}

class ConfirmRideAddressEvent extends HomeEvent {
  final List<AddressModel> addressList;
  final String rideType;

  ConfirmRideAddressEvent({required this.addressList, required this.rideType});
}

class FocusUpdateEvent extends HomeEvent {
  final int focusIndex;

  FocusUpdateEvent({required this.focusIndex});
}

class RecentRoutesEvent extends HomeEvent {}

class RecentRoutesChangeIndex extends HomeEvent {
  final int routesIndex;

  RecentRoutesChangeIndex({required this.routesIndex});
}

class RecentRouteSelectEvent extends HomeEvent {
  final RecentRouteData selectedRoute;

  RecentRouteSelectEvent({required this.selectedRoute});
}

class RideWithoutDestinationEvent extends HomeEvent {}

class CarouselIndexUpdateEvent extends HomeEvent {
  String carouselId;
  int index;
  CarouselIndexUpdateEvent({required this.carouselId, required this.index});
}

class ServiceLocationVerifyEvent extends HomeEvent {
  final String rideType;
  final List<AddressModel> address;
  final bool? isFromHomePage;

  ServiceLocationVerifyEvent(
      {required this.rideType, required this.address, this.isFromHomePage});
}

class UpdateMapTypeEvent extends HomeEvent {
  final MapType mapType;
  UpdateMapTypeEvent(this.mapType);
}

class GetRideModulesEvent extends HomeEvent {}

class GetCurrentLocationEvent extends HomeEvent {
  final String mapType;

  GetCurrentLocationEvent({required this.mapType});
}

class GetPromotionsPopupEvent extends HomeEvent {}

class SelectBookingTypeEvent extends HomeEvent {}

class SelectBookingTypeUpdateEvent extends HomeEvent {}

class SelectSavedContactRadioEvent extends HomeEvent {
  final int index;
  SelectSavedContactRadioEvent(this.index);
}

class SelectMyselfRadioEvent extends HomeEvent {}

class ConfirmBookingTypeEvent extends HomeEvent {
  final String contactName;
  final String contactMobile;
  final bool isMyself;

  ConfirmBookingTypeEvent({
    required this.contactName,
    required this.contactMobile,
    required this.isMyself,
  });
}

class SaveContactDetailsEvent extends HomeEvent {
  final String selectedContactName;
  final String selectedContactNumber;
  final bool isMyselfOrOthers;

  SaveContactDetailsEvent(
      {required this.selectedContactName,
      required this.selectedContactNumber,
      required this.isMyselfOrOthers});
}

class LoadSavedAddressEvent extends HomeEvent {}

class SetDraggingSheetEvent extends HomeEvent {
  final bool isDragging;
  SetDraggingSheetEvent({required this.isDragging});
}
