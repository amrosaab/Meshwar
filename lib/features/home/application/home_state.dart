part of 'home_bloc.dart';

abstract class HomeState {}

final class HomeInitialState extends HomeState {}

final class LogoutState extends HomeState {}

final class HomeUpdateState extends HomeState {}

final class VechileStreamMarkerState extends HomeState {}

final class HomeLoadingStartState extends HomeState {}

final class HomeLoadingStopState extends HomeState {}

final class GetLocationPermissionState extends HomeState {}

final class UserOnTripState extends HomeState {
  final OnTripRequestData tripData;

  UserOnTripState({required this.tripData});
}

final class UserTripSummaryState extends HomeState {
  final OnTripRequestData requestData;
  final RequestBillData requestBillData;
  final DriverDetailData driverData;
  final RideRepository rideRepository;

  UserTripSummaryState({
    required this.requestData,
    required this.requestBillData,
    required this.driverData,
    required this.rideRepository,
  });
}

final class UpdateLocationState extends HomeState {}

final class UpdateZoneLocationState extends HomeState {}

final class DestinationSelectState extends HomeState {
  final bool isPickupChange;
  final String? dropAddress;
  final LatLng? dropLatLng;
  final String transportType;
  final bool isBiddingRide;
  final bool isSharedRide;

  DestinationSelectState({
    required this.isPickupChange,
    this.dropAddress,
    this.dropLatLng,
    required this.transportType,
    this.isBiddingRide = false,
    this.isSharedRide = false,
  });
}

final class SearchOnChangeState extends HomeState {}

final class RecentSearchPlaceSelectState extends HomeState {
  final AddressModel address;
  final String transportType;
  final int? serviceTypeIndex;

  RecentSearchPlaceSelectState(
      {required this.address,
      required this.transportType,
      this.serviceTypeIndex});
}

final class SelectFromMapState extends HomeState {
  final bool isPickUpEdit;

  SelectFromMapState({
    required this.isPickUpEdit,
  });
}

final class OnGoingRidesFailureState extends HomeState {}

final class OnGoingRidesSuccessState extends HomeState {}

final class UpcomingRidesFailureState extends HomeState {}

final class UpcomingRidesSuccessState extends HomeState {}

final class NavigateToOnGoingRidesPageState extends HomeState {}

final class ChangeBottomNavIndexState extends HomeState {
  final int index;
  final bool pushTripSummary;
  final HistoryData? historyData;
  final int? historyIndex;

  ChangeBottomNavIndexState({
    required this.index,
    this.pushTripSummary = false,
    this.historyData,
    this.historyIndex,
  });
}

// ConfirmPageState
final class ConfirmAddressState extends HomeState {
  final bool isEditAddress;
  final bool isPickUpEdit;
  final AddressModel address;
  final bool? isFavouriteAddress;
  final bool? isDelivery;

  ConfirmAddressState(
      {required this.isEditAddress,
      required this.isPickUpEdit,
      required this.address,
      this.isFavouriteAddress,
      this.isDelivery});
}

final class ReceiverDetailsState extends HomeState {
  final AddressModel address;

  ReceiverDetailsState({required this.address});
}

final class SelectContactDetailsState extends HomeState {}

final class UpdateScrollPositionState extends HomeState {
  final double sheetSize;
  UpdateScrollPositionState(this.sheetSize);
}

final class DeliverySelectState extends HomeState {}

final class RentalSelectState extends HomeState {}

final class OutStationSelectState extends HomeState {}

final class ConfirmRideAddressState extends HomeState {}

final class AddOrEditAddressState extends HomeState {}

final class RecentRouteSelectState extends HomeState {
  final RecentRouteData selectedRoute;

  RecentRouteSelectState({required this.selectedRoute});
}

final class RideWithoutDestinationState extends HomeState {}

final class CarouselUpdateState extends HomeState {
  final Map<String, int> carouselIndices;
  CarouselUpdateState({required this.carouselIndices});
}

final class ServiceNotAvailableState extends HomeState {
  final String message;

  ServiceNotAvailableState({required this.message});
}

final class PromotionsPopupLoadingState extends HomeState {}

final class PromotionsPopupLoadingSuccessState extends HomeState {}

final class PromotionsPopupVisibleState extends HomeState {}

final class PromotionsPopupHiddingState extends HomeState {}

final class PromotionsPopupFailureState extends HomeState {}

final class SelectBookingTypeState extends HomeState {}

final class RadioSelectionUpdatedState extends HomeState {}

final class ConfirmBookingTypeSuccessState extends HomeState {
  final bool isMyselfSelected;
  final String selectedContactName;
  final String selectedContactMobile;

  ConfirmBookingTypeSuccessState({
    required this.isMyselfSelected,
    required this.selectedContactName,
    required this.selectedContactMobile,
  });
}

final class DocumentApprovedFailureState extends HomeState {}

class HomeLoadedState extends HomeState {
  final bool isMyself;
  final String contactName;
  final String contactNumber;
  // add other fields from your bloc if needed

  HomeLoadedState({
    this.isMyself = true,
    this.contactName = '',
    this.contactNumber = '',
    // initialize other fields
  });

  HomeLoadedState copyWith({
    bool? isMyself,
    String? contactName,
    String? contactNumber,
    // other fields
  }) {
    return HomeLoadedState(
      isMyself: isMyself ?? this.isMyself,
      contactName: contactName ?? this.contactName,
      contactNumber: contactNumber ?? this.contactNumber,
      // copy other fields
    );
  }
}
