import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_contacts/flutter_contacts.dart' hide PermissionStatus;
import 'package:flutter_contacts/flutter_contacts.dart' as fc show PermissionStatus;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' as intel;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;
import '../../../common/app_audio.dart';
import '../../../common/common.dart';
import '../../../common/tobitmap.dart';
import '../../../core/utils/custom_loader.dart';
import '../../../core/utils/custom_snack_bar.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/utils/functions.dart';
import '../../../core/utils/geohash.dart';
import '../../../core/utils/payment_received_stream.dart';
import '../../../di/locator.dart';
import '../../account/application/usecase/acc_usecases.dart';
import '../../home/application/usecase/home_usecases.dart';
import '../../home/domain/models/contact_model.dart';
import '../../home/domain/models/user_details_model.dart';
import '../../home/domain/models/stop_address_model.dart';
import '../domain/models/cancel_reason_model.dart';
import '../domain/models/chat_history_model.dart';
import '../domain/models/eta_details_model.dart';
import '../domain/models/goods_type_model.dart';
import '../../home/presentation/widgets/contact_local_storage.dart';
import '../domain/models/nearby_eta_model.dart';
import '../domain/models/point_latlng.dart';
import '../domain/models/promo_code_list_model.dart';
import '../domain/models/rental_packages_model.dart';
import '../presentation/page/booking/widget/marker_widget.dart';
import '../../../common/vehicle_marker_helper.dart';
import 'usecases/booking_usecase.dart';
import '../domain/repositories/booking_repo.dart';
part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  TextEditingController applyCouponController = TextEditingController();
  TextEditingController feedBackController = TextEditingController();
  TextEditingController goodsQtyController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController receiverMobileController = TextEditingController();
  TextEditingController farePriceController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  TextEditingController otherReasonController = TextEditingController();
  TextEditingController addTIPController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  ScrollController chatScrollController = ScrollController();
  ScrollController etaScrollController = ScrollController();
  GoogleMapController? googleMapController;
  fm.MapController? fmController = fm.MapController();
  List<fmlt.LatLng> fmpoly = [];
  late DraggableScrollableController _draggableScrollableController;

  dynamic vsync;
  DraggableScrollableController get draggableScrollableController =>
      _draggableScrollableController;
  bool isLoading = false;
  bool detailView = false;
  bool isMyself = false;
  bool isOthers = false;
  bool isTripStart = false;
  bool isNormalRideSearching = false;
  bool isBiddingRideSearching = false;
  bool isDriverReceivedPayment = false;
  bool isBiddingIncreaseLimitReach = false;
  bool isBiddingDecreaseLimitReach = false;
  bool luggagePreference = false;
  bool petPreference = false;
  bool isMultiTypeVechiles = false;
  bool isBottomNavVisible = true;
  bool enableEtaScrolling = false;
  bool showPaymentChange = false;
  bool payAtDrop = false;
  bool isBottomDisabled = false;
  bool showBiddingVehicles = false;
  bool isEtaFilter = false;
  bool filterSuccess = false;
  bool isPop = false;
  bool cancelReasonClicked = false;
  bool isRentalRide = false;
  bool isRoundTrip = false;
  bool isSavedCardChoose = false;
  bool isOutstationRide = false;
  bool preference = false;
  int timerDuration = 0;
  int waitingTime = 0;
  bool showSharedRide = false;
  bool shouldSaveSelectedContact = false;
  bool isFromBookingTypeFlow = false;
  int selectedSharedSeats = 1;
  int selectedRatingsIndex = 0;
  int selectedVehicleIndex = 0;
  int selectedPackageIndex = 0;
  int selectedRideTypeIndex = 0;
  int selectedGoodsTypeId = 0;
  int choosenVehiclePackageIndex = 0;
  int choosenAddressIndex = 0;
  double minChildSize = 0.37;
  double initChildSize = 0.40;
  double currentSize = 0.37;
  double currentSizeTwo = 0.41;
  double currentSizeThree = 0.45;
  double minChildSizeTwo = 0.41;
  double minChildSizeThree = 0.45;
  double maxChildSize = 0.9;
  double maxChildHeight = 0.65;
  double scrollHeight = 0.0;
  double onRideBottomPosition = -250;
  double onRideBottomCurrentHeight = 0;
  double addTip = 0;
  String? selectedPackageId;
  String showDateTime = '';
  String showReturnDateTime = '';
  String textDirection = 'ltr';
  String languageCode = '';
  String scheduleDateTime = '';
  String scheduleDateTimeForReturn = '';
  String selectedPaymentType = 'cash';
  String selectedCardToken = '';
  String goodsTypeQtyOrLoose = 'Loose';
  String selectedCancelReason = '';
  String selectedCancelReasonId = '';
  String transportType = '';
  String distance = '';
  String polyLine = '';
  String duration = '';
  String promoErrorText = '';
  String dropdownValue = '';
  String lightMapString = '';
  String darkMapString = '';
  String fmDistance = '';
  String additionalChargesReason = '';
  String additionalChargesAmount = '';
  double fmDuration = 0;
  List<EtaDetails> etaDetailsList = [];
  List<RentalEtaDetails> rentalEtaDetailsList = [];
  List<RentalPackagesData> rentalPackagesList = [];
  List<CategoryData> categoryList = [];
  List<EtaDetails> sortedEtaDetailsList = [];
  List<String> paymentList = [];
  List<dynamic> savedCardList = [];
  List<GoodsTypeData> goodsTypeList = [];
  List biddingDriverList = [];
  List<CancelReasonsData> cancelReasonsList = [];
  List<AddressModel> pickUpAddressList = [];
  List<AddressModel> dropAddressList = [];
  List<ChatHistoryData> chatHistoryList = [];
  List<NearbyEtaModel> nearByEtaVechileList = [];
  List<dynamic> nearByDriversData = [];
  List<TextEditingController> addressTextControllerList = [];
  List<ContactsModel> contactsList = [];
  ContactsModel selectedContact = ContactsModel(name: '', number: '');
  List<PreferenceDetails>? preferenceDetailsList;
  List<int> selectedPreferenceDetailsList = [];
  List<String> selectedPreferenceIconsList = [];
  List<int> selectPreference = [];
  List<RentalPreferenceDetails>? rentalPreferenceDetailsList;
  // Store preferences per vehicle (keyed by vehicle typeId) so each ETA card
  // can have its own preference selection.
  List<ContactsModel> savedContacts = [];
  bool isMyselfSelected = true;
  int? selectedSavedContactIndex;
  String bookingDisplayName = "";
  Map<dynamic, List<int>> vehiclePreferenceByTypeId = {};

  Timer? normalRideTimer;
  Timer? biddingRideSearchTimer;
  Timer? biddingRideTimer;
  ScrollController scrollController = ScrollController();

  StreamSubscription<DatabaseEvent>? requestStreamStart;
  StreamSubscription<DatabaseEvent>? rideStreamStart;
  StreamSubscription<DatabaseEvent>? rideStreamUpdate;
  StreamSubscription<DatabaseEvent>? biddingRequestStream;
  StreamSubscription<DatabaseEvent>? driverDataStream;
  StreamSubscription<DatabaseEvent>? etaDurationStream;
  late RideRepository rideRepository;
  late BookingRepository bookingRepository;

  UserDetail? userData;
  OnTripRequestData? requestData;
  DriverDetailData? driverData;
  RequestBillData? requestBillData;
  AudioPlayer audioPlayers = AudioPlayer();

  BitmapDescriptor? pickupMarker;
  List markerList = [];
  // Ticks on every marker-position update (car animation frames) without
  // emitting a BookingState, so only the map widget rebuilds instead of
  // the whole booking screen. See updateMarkers().
  final ValueNotifier<int> markerNotifier = ValueNotifier<int>(0);
  LatLng? driverPosition;
  Set<Polyline> polylines = {};
  List<LatLng> polylineLatLng = [];
  LatLngBounds? bound;
//Animate
  AnimationController? animationController;
  Animation<double>? animation;
  Animation<double>? _animation1;
  AnimationController? animationController1;

  StreamSubscription<DatabaseEvent>? nearByVechileSubscription;
  Map myBearings = {};
  String mapType = 'google_map';

  double selectedEtaAmount = 0.0;
  TextEditingController filterCapacityController =
  TextEditingController(text: '1');
  int filterCapasity = 1;
  List filterCategory = [];
  List filterPermit = [];
  List filterBodyType = [];
  int applyFilterCapasity = 1;
  List applyFilterCategory = [];
  List applyFilterPermit = [];
  List applyFilterBodyType = [];
  String changedPaymentValue = '';

  MapType _selectedMapType = MapType.normal;
  MapType get selectedMapType => _selectedMapType;

  List<int> tempSelectPreference = [];
  List<String> tempSelectPreferenceIcons = [];
  final DraggableScrollableController draggableController =
  DraggableScrollableController();

  bool enableOndemandRides = false;
  bool enableBiddingRides = false;
  bool enableShareRides = false;

  bool showShareRideVehicles = false;

  bool isEtaLoading = false;
  bool isEtaApiCompleted = false;

  List<PromoCodeListData> promoCodeDataList = [];

  BookingBloc() : super(BookingInitialState()) {
    _draggableScrollableController = DraggableScrollableController();
    bookingRepository = serviceLocator<BookingRepository>();
    on<UpdateEvent>((event, emit) => emit(BookingUpdateState()));
    on<GetDirectionEvent>(getDirection);
    on<BookingInitEvent>(bookingInitEvent);
    on<BookingNavigatorPopEvent>(navigatorPop);
    on<ShowEtaInfoEvent>(showEtaDetails);
    on<BookingEtaRequestEvent>(bookingEtaRequest);
    on<BookingRentalEtaRequestEvent>(bookingRentalEtaRequest);
    on<ShowRentalPackageListEvent>(rentalPackageSelect);
    on<RentalPackageConfirmEvent>(rentalPackageConfirm);
    on<BookingEtaSelectEvent>(selectedEtaVehicleIndex);
    on<BookingRentalPackageSelectEvent>(selectedRentalPackageIndex);
    on<BookingGetUserDetailsEvent>(getUserDetails);
    on<TimerEvent>(timerEvent);
    on<NoDriversEvent>(noDriverEvent);
    on<BookingCreateRequestEvent>(createRequestEvent);
    on<BookingCancelRequestEvent>(cancelRequest);
    on<BookingStreamRequestEvent>(bookingStreamRequest);
    on<TripRideCancelEvent>(onTripRideCancel);
    on<BookingRatingsSelectEvent>(ratingsSelectEvent);
    on<BookingUserRatingsEvent>(userRatings);
    on<GetGoodsTypeEvent>(getGoodsType);
    on<EnableBiddingEvent>(enableBiddingEvent);
    on<BiddingIncreaseOrDecreaseEvent>(biddingFareIncreaseDecrease);
    on<BiddingCreateRequestEvent>(biddingCreateRequest);
    on<BiddingFareUpdateEvent>(biddingFareUpdate);
    on<BiddingAcceptOrDeclineEvent>(biddingAcceptOrDecline);
    on<CancelReasonsEvent>(getCancelReasons);
    on<PolylineEvent>(getPolyline);
    on<GetChatHistoryEvent>(getChatHistory);
    on<ChatWithDriverEvent>(chatWithDriver);
    on<SendChatMessageEvent>(sendChatMessage);
    on<SeenChatMessageEvent>(seenChatMessage);
    on<SOSEvent>(sosEvent);
    on<NotifyAdminEvent>(notifyAdmin);
    on<SelectBiddingOrDemandEvent>(typeEtaChange);
    on<SelectSharedSeatsEvent>((event, emit) {
      selectedSharedSeats = event.seats;
      emit(BookingUpdateState());
    });
    on<UpdateScrollPhysicsEvent>(enableEtaScrollingList);
    on<UpdateMinChildSizeEvent>((event, emit) {
      scrollToMinChildSize(event.minChildSize);
    });
    on<UpdateScrollSizeEvent>((event, emit) {
      scrollToBottomFunction(event.minChildSize);
    });
    on<DetailViewUpdateEvent>(enableDetailsViewFunction);
    on<WalletPageReUpdateEvents>(walletPageReUpdate);
    on<ShowAddTipEvent>(showAddTip);
    on<AddTipsEvent>(addTipEvent);
    on<InvoiceInitEvent>(invoiceInit);
    on<ChangePaymentMethodEvent>(changePaymentMethodListener);
    on<BookingLocateMeEvent>(locateMe);
    on<EditLocationEvent>(editLocation);
    on<EditLocationPageInitEvent>(editLocationInit);
    on<ReorderEvent>(reOrderAddress);
    on<AddStopEvent>(addNewAddressStop);
    on<SelectFromMapEvent>(selectFromMap);
    on<BookingAddOrEditStopAddressEvent>(addOrEditStopAddress);
    on<SelectContactDetailsEvent>(selectContactDetails);
    on<ReceiverContactEvent>(receiverContactDetails);
    on<ChangeDestinationEvent>(changeDestination);
    on<AddMarkersEvent>(addMarkers);
    on<UpdateMarkersEvent>(updateMarkers);
    on<OnRidePaymentWebViewUrlEvent>(onRidePaymentWebViewUrl);
    on<UpdateMapTypeEvent>(updateMapType);
    on<SelectedPreferenceEvent>(selectPreferenceEvent);

    on<GetPromoCodeListEvent>(getPromoCodeList);
    on<SelectBookingTypeEvent>(selectBookingType);
    on<ConfirmPreferenceSelectionEvent>(confirmPreferenceSelection);
    on<SelectMyselfRadioEvent>(selectMyselfRadio);
    on<SelectSavedContactRadioEvent>(selectSavedContactRadio);
    on<ConfirmBookingTypePageEvent>(confirmBookingTypePage);
    draggableController.addListener(_onDragChange);
    on<UpdateAddInstructionVisibilityEvent>((event, emit) {
      emit(state.copyWith(showAddInstruction: event.show));
    });
    on<ReviewPageInitEvent>((event, emit) {
      selectedRatingsIndex = 0;
      feedBackController.clear();
      emit(BookingUpdateState());
    });
  }

  void etaScrollingToMin(double targetMinChildSize) {
    try {
      etaScrollController.animateTo(
        targetMinChildSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      debugPrint("Error scrolling to minChildSize: $e");
    }
  }

  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60; // Integer division to get minutes
    int remainingSeconds = seconds % 60; // Remainder to get the seconds
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> getDirection(
      GetDirectionEvent event, Emitter<BookingState> emit) async {
    //Animate
    animationController?.dispose();
    animationController = null;
    animationController = AnimationController(
      vsync: event.vsync,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: false);

    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInOut,
    );
    animationController?.repeat(reverse: false);

    emit(BookingLoadingStartState());
    languageCode = await AppSharedPreference.getSelectedLanguageCode();
    textDirection = await AppSharedPreference.getLanguageDirection();
    lightMapString = await rootBundle.loadString('assets/light-theme.json');
    darkMapString = await rootBundle.loadString('assets/dark-theme.json');
    emit(BookingLoadingStopState());
  }

  void _onDragChange() {
    final size = draggableController.size;
    final shouldToggleByType =
        transportType == 'taxi' || isOutstationRide || isRentalRide;

    if (size >= 0.9 && shouldToggleByType) {
      add(UpdateAddInstructionVisibilityEvent(false));
    } else {
      add(UpdateAddInstructionVisibilityEvent(true));
    }
  }

  //GoogleMap Animation
  List<LatLng> getGoogleMapAnimatedPolyline(
      List<LatLng> points, double animationValue) {
    if (points.isEmpty) return [];

    final int totalPoints = points.length;
    final int animatedPointsCount = (animationValue * totalPoints).toInt();

    // Return a sublist of points that represents the current animation progress
    return points.sublist(0, animatedPointsCount.clamp(0, totalPoints));
  }

  //FlutterMap Animation
  List<fmlt.LatLng> getFlutterMapAnimatedPolyline(
      List<fmlt.LatLng> points, double animationValue) {
    if (points.isEmpty) return [];

    // Calculate how many points to show based on the animation value
    final int totalPoints = points.length;
    final int animatedPointsCount = (animationValue * totalPoints).toInt();

    // Return a subset of the polyline points (from A to B progressively)
    return points.sublist(0, animatedPointsCount.clamp(0, totalPoints));
  }

  Future<void> navigatorPop(
      BookingNavigatorPopEvent event, Emitter<BookingState> emit) async {
    vsync = null;
    animationController?.dispose();
    animationController = null;
    animationController1?.dispose();
    animationController1 = null;
    googleMapController = null;
    requestStreamStart?.cancel();
    rideStreamUpdate?.cancel();
    rideStreamStart?.cancel();
    biddingRequestStream?.cancel();
    driverDataStream?.cancel();
    etaDurationStream?.cancel();
    nearByVechileSubscription?.cancel();
    timerDuration = 0;
    normalRideTimer?.cancel();
    biddingRideSearchTimer?.cancel();
    onRideBottomPosition = -250;
    if (!isPop) {
      isPop = true;
      emit(BookingNavigatorPopState());
    }
  }

  Future<void> bookingInitEvent(
      BookingInitEvent event, Emitter<BookingState> emit) async {
    vsync = event.vsync;
    mapType = event.arg.mapType;
    pickUpAddressList = event.arg.pickupAddressList;
    dropAddressList =
    ((event.arg.isRentalRide != null && event.arg.isRentalRide!) ||
        (event.arg.isWithoutDestinationRide != null &&
            event.arg.isWithoutDestinationRide!))
        ? []
        : event.arg.stopAddressList;
    userData = event.arg.userData;
    transportType = event.arg.transportType;
    polyLine = event.arg.polyString;
    distance = event.arg.distance;
    duration = event.arg.duration;
    requestData = event.arg.userData.onTripRequest != ""
        ? event.arg.userData.onTripRequest.data
        : event.arg.userData.metaRequest != ""
        ? event.arg.userData.metaRequest.data
        : null;

    isMyself = event.arg.isMyself ?? true;
    isMyselfSelected = isMyself;
    selectedContact.name = event.arg.contactName ?? "";
    selectedContact.number = event.arg.contactNumber ?? "";
    bookingDisplayName = isMyself ? "Myself" : selectedContact.name;
    await loadSavedContacts();
    if (!isMyself) {
      final index = savedContacts.indexWhere(
            (c) => c.number == selectedContact.number,
      );
      selectedSavedContactIndex = (index != -1) ? index : null;
    } else {
      selectedSavedContactIndex = null;
    }

    if (dropAddressList.length >= 2) {
      minChildSize = 0.52;
      initChildSize = 0.55;
      for (var i = 0; i < dropAddressList.length; i++) {
        dropAddressList[i].orderId = (i + 1).toString();
      }
    }
    if (event.arg.transportType == 'delivery' &&
        event.arg.title == 'Send Parcel') {
      showPaymentChange = true;
    }
    if (event.arg.transportType == 'delivery' &&
        event.arg.title == 'Receive Parcel' &&
        event.arg.stopAddressList.length > 1) {
      payAtDrop = true;
      showPaymentChange = true;
    }
    if (event.arg.isWithoutDestinationRide != null &&
        event.arg.isWithoutDestinationRide!) {
      showBiddingVehicles = false;
    }
    if (event.arg.isBiddingRide != null && event.arg.isBiddingRide!) {
      showBiddingVehicles = true;
    }
    if (event.arg.isSharedRide != null && event.arg.isSharedRide!) {
      showSharedRide = true;
    }
    if (event.arg.isOutstationRide) {
      isOutstationRide = event.arg.isOutstationRide;
      showBiddingVehicles = true;
      showDateTime = intel.DateFormat('dd/MM/yyyy (hh:mm a)').format(
          DateTime.now().add(Duration(
              minutes: int.parse(
                  event.arg.userData.userCanMakeARideAfterXMiniutes))));
      scheduleDateTime = DateTime.now()
          .add(Duration(
          minutes:
          int.parse(event.arg.userData.userCanMakeARideAfterXMiniutes)))
          .toString();
    }
    if (event.arg.isRentalRide != null &&
        event.arg.isRentalRide! &&
        requestData == null) {
      isRentalRide = true;
      if (transportType.isNotEmpty) {
        add(BookingRentalEtaRequestEvent(
          picklat: event.arg.picklat,
          picklng: event.arg.picklng,
          transporttype: transportType,
          preferenceId: selectPreference,
        ));
      }
      markerList.add(Marker(
        markerId: const MarkerId("pick"),
        position: LatLng(
            double.parse(event.arg.picklat), double.parse(event.arg.picklng)),
        rotation: 0.0,
        icon: await MarkerWidget(
          isPickup: true,
          text: event.arg.pickupAddressList.first.address,
        ).toBitmapDescriptor(
            logicalSize: const Size(30, 30), imageSize: const Size(200, 200)),
      ));
      mapBound(double.parse(event.arg.picklat), double.parse(event.arg.picklng),
          double.parse(event.arg.picklat), double.parse(event.arg.picklng),
          isRentalRide: true);
      if (mapType == 'google_map') {
        googleMapController
            ?.animateCamera(CameraUpdate.newLatLngBounds(bound!, 100));
      } else {
        if (fmController != null) {
          fmController!.move(
              fmlt.LatLng(
                  bound!.northeast.latitude, bound!.northeast.longitude),
              13);
        }
      }
      emit(RentalPackageSelectState());
    } else {
      if (event.arg.requestId != null) {
        add(BookingGetUserDetailsEvent(requestId: event.arg.requestId));
      } else {
        if (event.arg.polyString.isEmpty &&
            (event.arg.isRentalRide == null || !event.arg.isRentalRide!) &&
            (event.arg.isWithoutDestinationRide == null ||
                !event.arg.isWithoutDestinationRide!)) {
          add(PolylineEvent(
            isInitCall: true,
            arg: event.arg,
            pickLat: double.parse(event.arg.picklat),
            pickLng: double.parse(event.arg.picklng),
            dropLat: double.parse(event.arg.droplat),
            dropLng: double.parse(event.arg.droplng),
            stops: (event.arg.stopAddressList.length > 1)
                ? event.arg.stopAddressList
                : [],
            pickAddress: event.arg.pickupAddressList.first.address,
            dropAddress: event.arg.stopAddressList.last.address,
          ));
        } else {
          if ((event.arg.isRentalRide == null || !event.arg.isRentalRide!) &&
              (event.arg.isWithoutDestinationRide == null ||
                  !event.arg.isWithoutDestinationRide!)) {
            add(BookingEtaRequestEvent(
              picklat: event.arg.picklat,
              picklng: event.arg.picklng,
              droplat: event.arg.droplat,
              droplng: event.arg.droplng,
              ridetype: 1,
              transporttype: transportType,
              distance: distance,
              duration: duration,
              polyLine: event.arg.polyString,
              pickupAddressList: pickUpAddressList,
              dropAddressList: dropAddressList,
              isOutstationRide: event.arg.isOutstationRide,
              isWithoutDestinationRide:
              event.arg.isWithoutDestinationRide ?? false,
              sharedRide: (event.arg.isSharedRide ?? false) ? 1 : null,
              seatsTaken: (event.arg.isSharedRide ?? false) ? 1 : null,
            ));
          }
          if ((event.arg.isWithoutDestinationRide != null &&
              event.arg.isWithoutDestinationRide!)) {
            add(BookingEtaRequestEvent(
              picklat: event.arg.picklat,
              picklng: event.arg.picklng,
              droplat: '',
              droplng: '',
              ridetype: 1,
              transporttype: transportType,
              distance: '',
              duration: '',
              polyLine: '',
              pickupAddressList: pickUpAddressList,
              dropAddressList: [],
              isOutstationRide: event.arg.isOutstationRide,
              isWithoutDestinationRide:
              event.arg.isWithoutDestinationRide ?? false,
              sharedRide: (event.arg.isSharedRide ?? false) ? 1 : null,
              seatsTaken: (event.arg.isSharedRide ?? false) ? 1 : null,
            ));
          }
          markerList.add(Marker(
            markerId: const MarkerId("pick"),
            position: LatLng(double.parse(event.arg.picklat),
                double.parse(event.arg.picklng)),
            rotation: 0.0,
            icon: await MarkerWidget(
              isPickup: true,
              text: event.arg.pickupAddressList.first.address,
            ).toBitmapDescriptor(
                logicalSize: const Size(30, 30),
                imageSize: const Size(200, 200)),
          ));
          if (event.arg.stopAddressList.isEmpty &&
              ((userData!.metaRequest != null && userData!.metaRequest != "") ||
                  (userData!.onTripRequest != null &&
                      userData!.onTripRequest != ""))) {
            if (((event.arg.isWithoutDestinationRide != null &&
                !event.arg.isWithoutDestinationRide!) ||
                (event.arg.isWithoutDestinationRide == null)) &&
                ((event.arg.isRentalRide != null && !event.arg.isRentalRide!) ||
                    event.arg.isRentalRide == null)) {
              await addDistanceMarker(
                  LatLng(double.parse(event.arg.droplat),
                      double.parse(event.arg.droplng)),
                  double.tryParse(distance)!,
                  time: double.parse(duration));
            }
            markerList.add(Marker(
              markerId: const MarkerId("drop"),
              position: LatLng(double.parse(event.arg.droplat),
                  double.parse(event.arg.droplng)),
              rotation: 0.0,
              icon: await MarkerWidget(
                isPickup: false,
                text: event.arg.stopAddressList.last.address,
              ).toBitmapDescriptor(
                  logicalSize: const Size(30, 30),
                  imageSize: const Size(200, 200)),
            ));
          } else if (event.arg.stopAddressList.isNotEmpty &&
              event.arg.stopAddressList.length > 1) {
            for (var i = 0; i < event.arg.stopAddressList.length; i++) {
              if (((event.arg.isWithoutDestinationRide != null &&
                  !event.arg.isWithoutDestinationRide!) ||
                  (event.arg.isWithoutDestinationRide == null)) &&
                  ((event.arg.isRentalRide != null &&
                      !event.arg.isRentalRide!) ||
                      event.arg.isRentalRide == null)) {
                await addDistanceMarker(
                    LatLng(double.parse(event.arg.droplat),
                        double.parse(event.arg.droplng)),
                    double.tryParse(distance)!,
                    time: double.parse(duration));
              }
              markerList.add(Marker(
                markerId: MarkerId("drop$i"),
                position: LatLng(event.arg.stopAddressList[i].lat,
                    event.arg.stopAddressList[i].lng),
                rotation: 0.0,
                icon: await MarkerWidget(
                  isPickup: false,
                  count: '${i + 1}',
                  text: event.arg.stopAddressList[i].address,
                ).toBitmapDescriptor(
                    logicalSize: const Size(30, 30),
                    imageSize: const Size(200, 200)),
              ));
            }
          } else {
            if (dropAddressList.isNotEmpty) {
              if (((event.arg.isWithoutDestinationRide != null &&
                  !event.arg.isWithoutDestinationRide!) ||
                  (event.arg.isWithoutDestinationRide == null)) &&
                  ((event.arg.isRentalRide != null &&
                      !event.arg.isRentalRide!) ||
                      event.arg.isRentalRide == null)) {
                await addDistanceMarker(
                    LatLng(double.parse(event.arg.droplat),
                        double.parse(event.arg.droplng)),
                    double.tryParse(distance)!,
                    time: double.parse(duration));
              }
              markerList.add(Marker(
                markerId: const MarkerId("drop"),
                position: LatLng(double.parse(event.arg.droplat),
                    double.parse(event.arg.droplng)),
                rotation: 0.0,
                icon: await MarkerWidget(
                  isPickup: false,
                  text: event.arg.stopAddressList.last.address,
                ).toBitmapDescriptor(
                    logicalSize: const Size(30, 30),
                    imageSize: const Size(200, 200)),
              ));
            }
          }
          if ((event.arg.isRentalRide == null ||
              (event.arg.isRentalRide != null &&
                  !event.arg.isRentalRide!)) &&
              (event.arg.isWithoutDestinationRide == null ||
                  (event.arg.isWithoutDestinationRide != null &&
                      !event.arg.isWithoutDestinationRide!))) {
            mapBound(
              double.parse(event.arg.picklat),
              double.parse(event.arg.picklng),
              double.parse(event.arg.droplat),
              double.parse(event.arg.droplng),
            );
            decodeEncodedPolyline(event.arg.polyString);
          } else {
            mapBound(
                double.parse(event.arg.picklat),
                double.parse(event.arg.picklng),
                double.parse(event.arg.picklat),
                double.parse(event.arg.picklng),
                isRentalRide: true);
          }
        }

        if (requestData != null) {
          if (event.arg.userData.metaRequest != "") {
            if (requestData!.isBidRide == 1) {
              biddingStreamRequest();
              isBiddingRideSearching = true;
              nearByVechileSubscription?.cancel();
              etaDurationStream?.cancel();
              // Initialize bidding flags based on current offer vs allowed range
              try {
                final double baseline =
                double.parse(requestData!.requestEtaAmount);
                final String lowPct = requestData!.biddingLowPercentage;
                final double minAllowed = (lowPct == '0')
                    ? 0.0
                    : baseline - ((double.parse(lowPct) / 100) * baseline);
                final double current =
                    double.tryParse(requestData!.offerredRideFare) ?? baseline;
                isBiddingDecreaseLimitReach = current <= minAllowed;
                isBiddingIncreaseLimitReach = false;
              } catch (e) {
                isBiddingDecreaseLimitReach = false;
                isBiddingIncreaseLimitReach = false;
              }
              if (event.arg.mapType == 'google_map') {
                if (googleMapController != null) {
                  googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(double.parse(event.arg.picklat),
                            double.parse(event.arg.picklng)),
                        zoom: 17.0,
                      )));
                }
              } else {
                if (fmController != null) {
                  fmController!.move(
                      fmlt.LatLng(double.parse(event.arg.picklat),
                          double.parse(event.arg.picklng)),
                      13);
                }
              }
              emit(BiddingCreateRequestSuccessState());
            } else {
              streamRequest();
              isNormalRideSearching = true;
              if (event.arg.mapType == 'google_map') {
                if (googleMapController != null) {
                  googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(double.parse(event.arg.picklat),
                            double.parse(event.arg.picklng)),
                        zoom: 17.0,
                      )));
                }
              } else {
                if (fmController != null) {
                  fmController!.move(
                      fmlt.LatLng(double.parse(event.arg.picklat),
                          double.parse(event.arg.picklng)),
                      13);
                }
              }
              emit(BookingCreateRequestSuccessState());
            }
          } else if (event.arg.userData.onTripRequest != "") {
            driverData = requestData!.driverDetail.data;
            isNormalRideSearching = false;
            isBiddingRideSearching = false;
            if (requestData!.isCompleted == 1) {
              rideRepository = RideRepository();
              requestBillData = requestData!.requestBill.data;
              if (driverDataStream != null) driverDataStream?.cancel();
              if (etaDurationStream != null) etaDurationStream?.cancel();
              var val = await FirebaseDatabase.instance
                  .ref('requests/${requestData!.id}')
                  .get();
              if (val.child('is_payment_received').value != null) {
                isDriverReceivedPayment =
                    (val.child('is_payment_received').value as bool?) ?? false;
                rideRepository.updatePaymentReceived(isDriverReceivedPayment);
              }
              emit(TripCompletedState(rideRepository: rideRepository));
            } else {
              streamRide();
              isTripStart = true;
              nearByVechileSubscription?.cancel();
              etaDurationStream?.cancel();
              emit(BookingUpdateState());
            }
          }
        }
        emit(BookingUpdateState());
      }
    }
  }

  Future<void> showEtaDetails(
      ShowEtaInfoEvent event, Emitter<BookingState> emit) async {
    emit(ShowEtaInfoState(infoIndex: event.infoIndex));
  }

  Future<void> selectedEtaVehicleIndex(
      BookingEtaSelectEvent event, Emitter<BookingState> emit) async {
    selectedVehicleIndex = event.selectedVehicleIndex;
    // selectedPreferenceDetailsList.clear();

    if (isRentalRide) {
      // Move the selected vehicle to the top of the list
      final selectedVehicle =
      rentalEtaDetailsList.removeAt(selectedVehicleIndex);
      rentalEtaDetailsList.insert(0, selectedVehicle);
      selectedVehicleIndex = 0;
      paymentList = rentalEtaDetailsList[0].paymentType.split(",");
      selectedPaymentType = paymentList.isNotEmpty ? paymentList.first : '';
      selectedEtaAmount = rentalEtaDetailsList[0].hasDiscount
          ? rentalEtaDetailsList[0].discountedTotel
          : rentalEtaDetailsList[0].fareAmount;
      rentalPreferenceDetailsList =
      rentalEtaDetailsList[0].rentalPreferenceList!;
    } else {
      // // Move the selected vehicle to the top of the list
      if (isMultiTypeVechiles) {
        final selectedVehicle =
        sortedEtaDetailsList.removeAt(selectedVehicleIndex);
        sortedEtaDetailsList.insert(0, selectedVehicle);
      } else {
        final selectedVehicle = etaDetailsList.removeAt(selectedVehicleIndex);
        etaDetailsList.insert(0, selectedVehicle);
      }
      selectedVehicleIndex = 0;

      final currentEta =
      isMultiTypeVechiles ? sortedEtaDetailsList[0] : etaDetailsList[0];

      preferenceDetailsList = currentEta.preferenceList ?? [];
      paymentList = currentEta.paymentType.split(",");
      selectedPaymentType = paymentList.isNotEmpty ? paymentList.first : '';
      selectedEtaAmount =
      currentEta.hasDiscount ? currentEta.discountTotal : currentEta.total;
    }
    if (!event.isOutstationRide) {
      scheduleDateTime = '';
      showDateTime = '';
      showReturnDateTime = '';
      scheduleDateTimeForReturn = '';
    }
    emit(EtaSelectState());
  }

  Future<void> selectedRentalPackageIndex(
      BookingRentalPackageSelectEvent event, Emitter<BookingState> emit) async {
    selectedPackageIndex = event.selectedPackageIndex;
    selectedPackageId = rentalPackagesList[selectedPackageIndex].id.toString();
    emit(EtaSelectState());
  }

  Future<void> timerEvent(TimerEvent event, Emitter<BookingState> emit) async {
    timerDuration = event.duration;
    emit(TimerState());
  }

  Future<void> noDriverEvent(
      NoDriversEvent event, Emitter<BookingState> emit) async {
    emit(BookingNoDriversFoundState());
  }

  void timerCount(BuildContext context,
      {required int duration,
        bool? isCloseTimer,
        required bool isNormalRide}) async {
    int count = duration;

    if (isCloseTimer == null && isNormalRide) {
      normalRideTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        count--;
        if (count <= 0) {
          normalRideTimer?.cancel();
          add(NoDriversEvent());
          isNormalRideSearching = false;
          isBiddingRideSearching = false;
          add(BookingCancelRequestEvent(
              requestId: requestData!.id, timerCancel: true));
        }
        add(TimerEvent(duration: count));
      });
    } else if (isCloseTimer == null && !isNormalRide) {
      biddingRideSearchTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        count--;
        if (count <= 0) {
          biddingRideSearchTimer?.cancel();
          add(NoDriversEvent());
          isNormalRideSearching = false;
          isBiddingRideSearching = false;
          add(BookingCancelRequestEvent(
              requestId: requestData!.id, timerCancel: true));
        }
        add(TimerEvent(duration: count));
      });
    }

    if (isCloseTimer != null && isCloseTimer && isNormalRide) {
      normalRideTimer?.cancel();
      Navigator.pop(context);
      isNormalRideSearching = false;
      isBiddingRideSearching = false;
      add(TimerEvent(duration: 0));
    } else if (isCloseTimer != null && isCloseTimer && !isNormalRide) {
      biddingRideSearchTimer?.cancel();
      Navigator.pop(context);
      isNormalRideSearching = false;
      isBiddingRideSearching = false;
      add(TimerEvent(duration: 0));
    }
  }

  Future<void> typeEtaChange(
      SelectBiddingOrDemandEvent event, Emitter<BookingState> emit) async {
    showBiddingVehicles = event.isBidding;
    // track shared ride tab selection
    showSharedRide = (event.selectedTypeEta == 'Shared') ? true : false;
    if (event.selectedTypeEta == 'Shared') {
      sortedEtaDetailsList.clear();
      // selectedPreferenceDetailsList.clear();
      for (var i = 0; i < etaDetailsList.length; i++) {
        if (etaDetailsList[i].enableSharedRide != false) {
          sortedEtaDetailsList.add(etaDetailsList[i]);
        }
      }

      selectedVehicleIndex = 0;

      if (currentSize == maxChildSize ||
          currentSizeTwo == maxChildSize ||
          currentSizeThree == maxChildSize) {
        enableEtaScrolling = true;
      }
    } else if (event.selectedTypeEta == 'On Demand') {
      sortedEtaDetailsList.clear();
      for (var i = 0; i < etaDetailsList.length; i++) {
        if (etaDetailsList[i].dispatchType != 'bidding') {
          sortedEtaDetailsList.add(etaDetailsList[i]);
        }
      }

      selectedVehicleIndex = 0;

      if (currentSize == maxChildSize ||
          currentSizeTwo == maxChildSize ||
          currentSizeThree == maxChildSize) {
        enableEtaScrolling = true;
      }
    } else if (event.selectedTypeEta == 'Bidding') {
      sortedEtaDetailsList.clear();
      for (var i = 0; i < etaDetailsList.length; i++) {
        if (etaDetailsList[i].dispatchType != 'normal') {
          sortedEtaDetailsList.add(etaDetailsList[i]);
        }
      }
      selectedVehicleIndex = 0;
      scheduleDateTime = '';
      showDateTime = '';
      showReturnDateTime = '';
      scheduleDateTimeForReturn = '';
      if (currentSize == maxChildSize ||
          currentSizeTwo == maxChildSize ||
          currentSizeThree == maxChildSize) {
        enableEtaScrolling = true;
      }
    }
    emit(BookingUpdateState());
  }

  FutureOr<void> bookingEtaRequest(
      BookingEtaRequestEvent event,
      Emitter<BookingState> emit,
      ) async {
    isEtaLoading = true;
    isEtaApiCompleted = false;

    final data = await serviceLocator<BookingUsecase>().etaRequest(
      picklat: event.picklat,
      picklng: event.picklng,
      droplat: event.droplat,
      droplng: event.droplng,
      rideType: event.ridetype,
      transportType: event.transporttype,
      promoCode: event.promocode,
      vehicleType: event.vehicleId,
      distance: event.distance,
      duration: event.duration,
      polyLine: event.polyLine,
      pickupAddressList: event.pickupAddressList,
      dropAddressList: event.dropAddressList,
      isOutstationRide: event.isOutstationRide,
      isWithoutDestinationRide: event.isWithoutDestinationRide,
      preferences: event.preferenceId,
      sharedRide: event.sharedRide,
      seatsTaken: event.seatsTaken,
      isLater: event.isLater,
      tripStartTime: event.tripStartTime,
    );

    await data.fold(
          (error) async {
        isEtaLoading = false;
        isEtaApiCompleted = true;
        if (emit.isDone) return;

        if (error.message == 'logout') {
          emit(LogoutState());
        } else if (event.promocode != null) {
          promoErrorText = error.message.toString();
          showToast(message: error.message.toString());
          applyCouponController.clear();
          emit(BookingUpdateState());
        } else if (error.message == 'distanceTooLong') {
          emit(DistanceTooLongState());
        } else if (error.message == 'outstationDistanceTooLong') {
          emit(OutstationDistanceTooLongState());
        } else {
          showToast(message: error.message.toString());
        }
      },
          (success) async {
        isEtaLoading = false;
        isEtaApiCompleted = true;
        etaDetailsList.clear();
        sortedEtaDetailsList.clear();
        nearByEtaVechileList.clear();

        await nearByVechileSubscription?.cancel();
        await etaDurationStream?.cancel();

        etaDetailsList = success.data;

        if (etaDetailsList.isEmpty) {
          if (!emit.isDone) emit(EtaNotAvailableState());
          return;
        }

        enableBiddingRides = success.enabledDispatchType.bidding;
        enableOndemandRides = success.enabledDispatchType.ondemand;
        enableShareRides = success.enabledDispatchType.shared;

        isMultiTypeVechiles = (enableOndemandRides && enableBiddingRides) ||
            (enableOndemandRides && enableShareRides) ||
            (enableBiddingRides && enableShareRides);

        if (isMultiTypeVechiles) {
          if (isOutstationRide) {
            sortedEtaDetailsList = List.from(etaDetailsList);
          } else if (showBiddingVehicles) {
            sortedEtaDetailsList = etaDetailsList
                .where((e) => e.dispatchType != 'normal')
                .toList();
          } else if (showSharedRide) {
            sortedEtaDetailsList = etaDetailsList
                .where((e) => e.enableSharedRide == true)
                .toList();
          } else {
            sortedEtaDetailsList = etaDetailsList
                .where((e) => e.dispatchType != 'bidding')
                .toList();
          }
        } else {
          isMultiTypeVechiles = false;
          if (showBiddingVehicles && !isOutstationRide) {
            etaDetailsList = etaDetailsList
                .where((e) => e.dispatchType != 'normal')
                .toList();
          }
          if (showSharedRide) {
            etaDetailsList = etaDetailsList
                .where((e) => e.enableSharedRide == true)
                .toList();
          }
        }

        preferenceDetailsList = isMultiTypeVechiles
            ? sortedEtaDetailsList[selectedVehicleIndex].preferenceList
            : etaDetailsList[selectedVehicleIndex].preferenceList;

        savedCardList = success.savedCards ?? [];

        paymentList = (isMultiTypeVechiles
            ? sortedEtaDetailsList[selectedVehicleIndex].paymentType
            : etaDetailsList[selectedVehicleIndex].paymentType)
            .split(',');

        selectedPaymentType = paymentList.isNotEmpty ? paymentList.first : '';

        selectedEtaAmount = (isMultiTypeVechiles
            ? sortedEtaDetailsList[selectedVehicleIndex]
            : etaDetailsList[selectedVehicleIndex])
            .hasDiscount
            ? (isMultiTypeVechiles
            ? sortedEtaDetailsList[selectedVehicleIndex]
            : etaDetailsList[selectedVehicleIndex])
            .discountTotal
            : (isMultiTypeVechiles
            ? sortedEtaDetailsList[selectedVehicleIndex]
            : etaDetailsList[selectedVehicleIndex])
            .total;

        if (event.promocode != null) {
          detailView = false;
          applyCouponController.clear();
        }

        //  Emit BEFORE starting stream
        if (!emit.isDone) {
          emit(BookingSuccessState());
        }

        // Start stream AFTER emit
        etaDurationGetStream(
          etaDetailsList,
          double.parse(event.picklat),
          double.parse(event.picklng),
        );
      },
    );
  }

  // Rental Eta Request
  FutureOr<void> rentalPackageSelect(
      ShowRentalPackageListEvent event, Emitter<BookingState> emit) async {
    emit(RentalPackageSelectState());
  }

  // Rental Eta Request
  FutureOr<void> bookingRentalEtaRequest(
      BookingRentalEtaRequestEvent event, Emitter<BookingState> emit) async {
    isEtaLoading = true;
    final data = await serviceLocator<BookingUsecase>().rentalEtaRequest(
      picklat: event.picklat,
      picklng: event.picklng,
      transportType: event.transporttype,
      promoCode: event.promocode,
      preferenceId: event.preferenceId,
      isLater: event.isLater,
      tripStartTime: event.tripStartTime,
    );

    data.fold(
          (error) {
        isEtaLoading = false;
        if (error.message == 'logout') {
          emit(LogoutState());
        } else if (event.promocode != null) {
          promoErrorText = error.message.toString();
          emit(BookingUpdateState());
        } else {
          showToast(message: '${error.message}');
        }
      },
          (success) async {
        isEtaLoading = false;
        rentalPackagesList = success.data;
        savedCardList = success.savedCards;

        // Only auto-confirm if it's a promo code update
        if (event.promocode != null) {
          detailView = false;
          applyCouponController.clear();
          add(RentalPackageConfirmEvent(
            picklat: event.picklat,
            picklng: event.picklng,
            preferenceId: event.preferenceId,
          ));
        } else {
          if (!emit.isDone) {
            emit(BookingSuccessState());
          }
        }
        emit(BookingUpdateState());
      },
    );
  }

  // Rental Package Confirm
  FutureOr<void> rentalPackageConfirm(
      RentalPackageConfirmEvent event, Emitter<BookingState> emit) async {
    rentalEtaDetailsList.clear();
    nearByEtaVechileList.clear();
    if (nearByVechileSubscription != null) {
      nearByVechileSubscription?.cancel();
    }
    if (etaDurationStream != null) etaDurationStream?.cancel();

    selectedPackageId = rentalPackagesList[selectedPackageIndex].id.toString();
    rentalEtaDetailsList = (rentalPackagesList.isNotEmpty &&
        rentalPackagesList[selectedPackageIndex].typesWithPrice != null)
        ? rentalPackagesList[selectedPackageIndex].typesWithPrice!.data
        : [];
    if (rentalEtaDetailsList.isNotEmpty) {
      isMultiTypeVechiles = false;
      rentalPreferenceDetailsList =
          rentalEtaDetailsList[selectedVehicleIndex].rentalPreferenceList;
      paymentList =
          rentalEtaDetailsList[selectedVehicleIndex].paymentType.split(',');
      selectedPaymentType = paymentList.isNotEmpty ? paymentList.first : '';
      selectedEtaAmount = rentalEtaDetailsList[selectedVehicleIndex].hasDiscount
          ? rentalEtaDetailsList[selectedVehicleIndex].discountedTotel
          : rentalEtaDetailsList[selectedVehicleIndex].fareAmount;

      etaDurationGetStream(rentalEtaDetailsList, double.parse(event.picklat),
          double.parse(event.picklng));
      emit(BookingSuccessState());
    }
    emit(RentalPackageConfirmState());
  }

  //Nearby Vechiles Stream
  etaDurationGetStream(List<dynamic> etaList, double pickLat, double pickLng) {
    if (etaDurationStream != null) etaDurationStream?.cancel();
    GeoHasher geo = GeoHasher();
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;
    double lowerLat = 0.0;
    double lowerLon = 0.0;
    double greaterLat = 0.0;
    double greaterLon = 0.0;
    lowerLat = pickLat - (lat * 1.24);
    lowerLon = pickLng - (lon * 1.24);

    greaterLat = pickLat + (lat * 1.24);
    greaterLon = pickLng + (lon * 1.24);

    var lower = geo.encode(lowerLon, lowerLat);
    var higher = geo.encode(greaterLon, greaterLat);

    etaDurationStream = FirebaseDatabase.instance
        .ref('drivers')
        .orderByChild('g')
        .startAt(lower)
        .endAt(higher)
        .onValue
        .handleError((onError) {
      etaDurationStream?.cancel();
    }).listen((event) async {
      debugPrint('nearByStreamStart Listening');
      if (nearByEtaVechileList.isEmpty) {
        for (var i = 0; i < etaList.length; i++) {
          nearByEtaVechileList
              .add(NearbyEtaModel(typeId: etaList[i].typeId, duration: ''));
        }
      }
      List vehicleList = [];
      List vehicles = [];
      List<double> distanceList = [];
      for (var e in event.snapshot.children) {
        vehicleList.add(e.value);
      }

      for (var i = 0; i < nearByEtaVechileList.length; i++) {
        if (vehicleList.isNotEmpty) {
          for (var e in vehicleList) {
            if (e['is_active'] == 1 &&
                e['is_available'] == true &&
                ((e['vehicle_types'] != null &&
                    e['vehicle_types']
                        .contains(nearByEtaVechileList[i].typeId)) ||
                    (e['vehicle_type'] != null &&
                        e['vehicle_type'] == nearByEtaVechileList[i].typeId))) {
              DateTime dt =
              DateTime.fromMillisecondsSinceEpoch(e['updated_at']);
              if (DateTime.now().difference(dt).inMinutes <= 2) {
                vehicles.add(e);
                if (vehicles.isNotEmpty) {
                  var dist = calculateDistance(
                    lat1: pickLat,
                    lon1: pickLng,
                    lat2: e['l'][0],
                    lon2: e['l'][1],
                    unit: userData?.distanceUnit ?? 'km',
                  );

                  distanceList.add(double.parse(dist.toString()));
                  var minDist = distanceList.reduce(math.min);
                  if (minDist > 0 && minDist <= 1) {
                    nearByEtaVechileList[i].duration = '2 mins';
                  } else if (minDist > 1 && minDist <= 3) {
                    nearByEtaVechileList[i].duration = '5 mins';
                  } else if (minDist > 3 && minDist <= 5) {
                    nearByEtaVechileList[i].duration = '8 mins';
                  } else if (minDist > 5 && minDist <= 7) {
                    nearByEtaVechileList[i].duration = '11 mins';
                  } else if (minDist > 7 && minDist <= 10) {
                    nearByEtaVechileList[i].duration = '14 mins';
                  } else if (minDist > 10) {
                    nearByEtaVechileList[i].duration = '15 mins';
                  }
                } else {
                  nearByEtaVechileList[i].duration = '';
                }
              }
            }
          }
        }
      }
    });
  }

  Future<void> createRequestEvent(
      BookingCreateRequestEvent event, Emitter<BookingState> emit) async {
    isLoading = true;
    emit(BookingUpdateState());
    final data = await serviceLocator<BookingUsecase>().createRequest(
        userData: event.userData,
        vehicleData: event.vehicleData,
        pickupAddressList: event.pickupAddressList,
        dropAddressList: event.dropAddressList,
        selectedTransportType: event.selectedTransportType,
        paidAt: event.paidAt,
        parcelType: event.parcelType,
        selectedPaymentType:
        event.cardToken.isNotEmpty ? 'card' : event.selectedPaymentType,
        cardToken: event.cardToken,
        scheduleDateTime: event.scheduleDateTime,
        isEtaRental: event.isRentalRide,
        isBidRide: false,
        goodsTypeId: event.goodsTypeId,
        goodsQuantity: event.goodsQuantity,
        offeredRideFare: "",
        polyLine: event.polyLine,
        isAirport: ((event.pickupAddressList.first.isAirportLocation != null &&
            event.pickupAddressList.first.isAirportLocation!) ||
            (event.dropAddressList.any((element) =>
            (element.isAirportLocation != null &&
                element.isAirportLocation!))))
            ? true
            : false,
        isParcel: (event.selectedTransportType == 'delivery') ? true : false,
        packageId: selectedPackageId,
        isOutstationRide: event.isOutstationRide,
        isRoundTrip: false,
        scheduleDateTimeForReturn: '',
        taxiInstruction: instructionsController.text,
        sharedRide: event.sharedRide,
        seatsTaken: event.seatsTaken,
        preferences: event.preferences,
        bookOthers: event.bookOthers,
        contactNumber: event.contactNumber,
        myself: event.myself,
        contactBookName: event.contactBookName);
    data.fold(
          (error) {
        isLoading = false;
        if (error.message == 'logout') {
          emit(LogoutState());
        } else {
          showToast(message: '${error.message}');
          emit(BookingCreateRequestFailureState());
        }
      },
          (success) async {
        isLoading = false;
        isTripStart = true;
        nearByVechileSubscription?.cancel();
        etaDurationStream?.cancel();
        onRideBottomPosition = -250;
        if (success['success']) {
          animationController?.stop();
          animationController = null;
          if (event.scheduleDateTime.isEmpty) {
            requestData = OnTripRequestData.fromJson(success["data"]);
            streamRequest();
            isNormalRideSearching = true;
            isBiddingRideSearching = false;
            if (mapType == 'google_map') {
              if (googleMapController != null) {
                googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(event.pickupAddressList.first.lat,
                          event.pickupAddressList.first.lng),
                      zoom: 15.5,
                    )));
              }
            } else {
              if (fmController != null) {
                fmController!.move(
                    fmlt.LatLng(event.pickupAddressList.first.lat,
                        event.pickupAddressList.first.lng),
                    13);
              }
            }
            emit(BookingCreateRequestSuccessState());
          } else {
            emit(BookingLaterCreateRequestSuccessState(
                isOutstation: event.isOutstationRide));
          }
        } else {
          showToast(message: '${success['message']}');
          emit(BookingCreateRequestFailureState());
        }
      },
    );
  }

  FutureOr cancelRequest(
      BookingCancelRequestEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoadingStartState());
    final data = await serviceLocator<BookingUsecase>().cancelRequest(
        requestId: event.requestId,
        reason: event.reason,
        timerCancel: event.timerCancel,
        customReason: event.customReason);
    data.fold(
          (error) {
        debugPrint(error.toString());
        emit(BookingLoadingStopState());
        if (error.message == 'logout') {
          emit(LogoutState());
        }
      },
          (success) {
        requestData = null;
        isTripStart = false;
        isNormalRideSearching = false;
        isBiddingRideSearching = false;
        isBiddingIncreaseLimitReach = false;
        isBiddingDecreaseLimitReach = false;
        onRideBottomPosition = -250;
        emit(BookingUpdateState());
        if (requestData != null) {
          if (requestData!.isBidRide == 1) {
            FirebaseDatabase.instance
                .ref('bid-meta/${requestData!.id}')
                .remove();
            if (biddingRequestStream?.isPaused == false ||
                biddingRequestStream != null) {
              biddingRequestStream?.cancel();
            }
            emit(BookingRequestCancelState());
          }
          FirebaseDatabase.instance
              .ref('requests')
              .child(requestData!.id)
              .update({'cancelled_by_user': true});
        }
        requestStreamStart?.cancel();
        rideStreamUpdate?.cancel();
        rideStreamStart?.cancel();
        biddingRequestStream?.cancel();
        driverDataStream?.cancel();
        requestStreamStart = null;
        rideStreamUpdate = null;
        rideStreamStart = null;
        driverDataStream = null;
        emit(BookingLoadingStopState());
      },
    );
  }

  FutureOr onTripRideCancel(
      TripRideCancelEvent event, Emitter<BookingState> emit) async {
    requestData = null;
    isTripStart = false;
    requestStreamStart?.cancel();
    rideStreamUpdate?.cancel();
    rideStreamStart?.cancel();
    driverDataStream?.cancel();
    requestStreamStart = null;
    rideStreamUpdate = null;
    rideStreamStart = null;
    driverDataStream = null;
    emit(TripRideCancelState(isCancelByDriver: event.isCancelByDriver));
  }

  FutureOr getUserDetails(
      BookingGetUserDetailsEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<HomeUsecase>()
        .userDetails(requestId: event.requestId);
    await data.fold((error) {
      debugPrint(error.toString());
      if (error.message == 'logout') {
        emit(LogoutState());
      }
    }, (success) async {
      userData = success.data;
      if (userData!.onTripRequest != null &&
          userData!.onTripRequest != "" &&
          userData!.onTripRequest.data != null &&
          userData!.onTripRequest.data.driverDetail != null) {
        requestData = userData!.onTripRequest.data;
        driverData = userData!.onTripRequest.data.driverDetail.data;
        if (requestData != null) {
          if (rideStreamUpdate == null ||
              rideStreamUpdate?.isPaused == true ||
              rideStreamStart == null ||
              rideStreamStart?.isPaused == true) {
            var val = await FirebaseDatabase.instance
                .ref('requests/${requestData!.id}')
                .get();
            if (val.child('additional_charges_reason').value != null) {
              additionalChargesReason =
                  val.child('additional_charges_reason').value.toString();
            }
            if (val.child('additional_charges_amount').value != null) {
              additionalChargesAmount =
                  val.child('additional_charges_amount').value.toString();
            }
            streamRide();
            isTripStart = true;
            nearByVechileSubscription?.cancel();
            etaDurationStream?.cancel();
            if (isNormalRideSearching) {
              isNormalRideSearching = false;
            }
            if (isBiddingRideSearching) {
              isBiddingRideSearching = false;
            }
            emit(BookingUpdateState());
          }
        } else {
          if (rideStreamUpdate != null ||
              rideStreamUpdate?.isPaused == false ||
              rideStreamStart != null ||
              rideStreamStart?.isPaused == false) {
            rideStreamUpdate?.cancel();
            rideStreamUpdate = null;
            rideStreamStart?.cancel();
            rideStreamStart = null;
          }
        }
        if (requestData!.isTripStart != 1 && requestData!.acceptedAt != '') {
          nearByVechileSubscription?.cancel();
          etaDurationStream?.cancel();
        }
        if ((requestData!.isTripStart != 1 ||
            requestData!.isOutStation == '1') &&
            (requestData!.arrivedAt != '') &&
            (requestData!.dropLat != '0' &&
                requestData!.dropLng != '0' &&
                !requestData!.isRental)) {
          final String iconType = driverData!.vehicleTypeIcon.toString();
          final double rotation = myBearings[driverData!.id.toString()] ?? 0.0;
          final marker = VehicleMarkerHelper.getMarker(iconType, bearing: rotation);
          if (requestData!.polyLine.isNotEmpty) {
            markerList.clear();
            markerList.add(Marker(
              markerId: const MarkerId("pick"),
              position: LatLng(double.parse(requestData!.pickLat),
                  double.parse(requestData!.pickLng)),
              rotation: 0.0,
              icon: await MarkerWidget(
                isPickup: true,
                text: requestData!.pickAddress,
              ).toBitmapDescriptor(
                  logicalSize: const Size(30, 30),
                  imageSize: const Size(200, 200)),
            ));
            if (userData != null &&
                requestData!.requestStops.data.isEmpty &&
                ((userData!.metaRequest != null &&
                    userData!.metaRequest != "") ||
                    (userData!.onTripRequest != null &&
                        userData!.onTripRequest != ""))) {
              markerList.add(Marker(
                markerId: const MarkerId("drop"),
                position: LatLng(double.parse(requestData!.dropLat),
                    double.parse(requestData!.dropLng)),
                rotation: 0.0,
                icon: await MarkerWidget(
                  isPickup: false,
                  text: requestData!.dropAddress,
                ).toBitmapDescriptor(
                    logicalSize: const Size(30, 30),
                    imageSize: const Size(200, 200)),
              ));
            } else if (requestData!.requestStops.data.isNotEmpty) {
              for (var i = 0; i < requestData!.requestStops.data.length; i++) {
                markerList.add(Marker(
                  markerId: MarkerId("drop$i"),
                  position: LatLng(requestData!.requestStops.data[i].latitude,
                      requestData!.requestStops.data[i].longitude),
                  rotation: 0.0,
                  icon: await MarkerWidget(
                    isPickup: false,
                    count: '${i + 1}',
                    text: requestData!.requestStops.data[i].address,
                  ).toBitmapDescriptor(
                      logicalSize: const Size(30, 30),
                      imageSize: const Size(200, 200)),
                ));
              }
            } else {
              markerList.add(Marker(
                markerId: const MarkerId("drop"),
                position: LatLng(double.parse(requestData!.dropLat),
                    double.parse(requestData!.dropLng)),
                rotation: 0.0,
                icon: await MarkerWidget(
                  isPickup: true,
                  text: requestData!.dropAddress,
                ).toBitmapDescriptor(
                    logicalSize: const Size(30, 30),
                    imageSize: const Size(200, 200)),
              ));
            }
            mapBound(
              double.parse(requestData!.pickLat),
              double.parse(requestData!.pickLng),
              double.parse(requestData!.dropLat),
              double.parse(requestData!.dropLng),
            );
            decodeEncodedPolyline(requestData!.polyLine);
          } else {
            markerList.clear();
            add(PolylineEvent(
              pickLat: double.parse(requestData!.pickLat),
              pickLng: double.parse(requestData!.pickLng),
              dropLat: double.parse(requestData!.dropLat),
              dropLng: double.parse(requestData!.dropLng),
              stops: (requestData != null &&
                  requestData!.arrivedAt != "" &&
                  dropAddressList.length > 1)
                  ? dropAddressList
                  : [],
              pickAddress: '',
              dropAddress: '',
              icon: marker,
            ));
          }
        } else {
          if (mapType == 'google_map') {
            if (googleMapController != null) {
              googleMapController!
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(double.parse(requestData!.pickLat),
                    double.parse(requestData!.pickLng)),
                zoom: 17.0,
              )));
            }
          } else {
            if (fmController != null) {
              fmController!.move(
                  fmlt.LatLng(double.parse(requestData!.pickLat),
                      double.parse(requestData!.pickLng)),
                  13);
            }
          }
        }
        if (requestData!.isCompleted == 1) {
          rideRepository = RideRepository();
          if (requestData!.requestBill != null) {
            requestBillData = requestData!.requestBill.data;
          }

          var val = await FirebaseDatabase.instance
              .ref('requests/${requestData!.id}')
              .get();
          if (val.child('is_payment_received').value != null) {
            isDriverReceivedPayment =
                (val.child('is_payment_received').value as bool?) ?? false;
            rideRepository.updatePaymentReceived(isDriverReceivedPayment);
          } else {
            isDriverReceivedPayment = requestData!.isPaid == 1 ? true : false;
            rideRepository.updatePaymentReceived(isDriverReceivedPayment);
          }
          if (driverDataStream != null) driverDataStream?.cancel();
          if (etaDurationStream != null) etaDurationStream?.cancel();
          emit(TripCompletedState(rideRepository: rideRepository));
        } else {
          if (normalRideTimer != null) {
            normalRideTimer?.cancel();
          }
          if (biddingRideSearchTimer != null) {
            biddingRideSearchTimer?.cancel();
          }
          if (biddingRideTimer != null) {
            biddingRideTimer?.cancel();
          }
          requestStreamStart?.cancel();
          biddingRequestStream?.cancel();
        }
        emit(BookingUpdateState());
      } else if (userData!.metaRequest != null && userData!.metaRequest != "") {
        requestData = userData!.metaRequest.data;
        if (requestStreamStart == null ||
            requestStreamStart?.isPaused == true) {
          streamRequest();
        }
      } else {
        requestData = null;
        isTripStart = false;
        isNormalRideSearching = false;
        isBiddingRideSearching = false;
        normalRideTimer?.cancel();
        biddingRideSearchTimer?.cancel();
        requestStreamStart?.cancel();
        rideStreamUpdate?.cancel();
        rideStreamStart?.cancel();
        biddingRequestStream?.cancel();
        driverDataStream?.cancel();
        etaDurationStream?.cancel();
        normalRideTimer = null;
        biddingRideSearchTimer = null;
        requestStreamStart = null;
        rideStreamUpdate = null;
        rideStreamStart = null;
        biddingRequestStream = null;
        driverDataStream = null;
        etaDurationStream = null;
        emit(BookingUpdateState());
      }
    });
  }

  FutureOr bookingStreamRequest(
      BookingStreamRequestEvent event, Emitter<BookingState> emit) async {
    emit(BookingStreamRequestState());
  }

  //requestStream
  streamRequest() {
    if (requestStreamStart != null) {
      requestStreamStart?.cancel();
    }
    if (rideStreamUpdate != null) {
      rideStreamUpdate?.cancel();
    }
    if (rideStreamStart != null) {
      rideStreamStart?.cancel();
    }

    requestStreamStart = FirebaseDatabase.instance
        .ref('request-meta')
        .child(requestData!.id)
        .onChildRemoved
        .handleError((onError) {
      requestStreamStart?.cancel();
    }).listen((event) async {
      debugPrint('requestStreamStart Listening');
      add(BookingGetUserDetailsEvent(requestId: requestData!.id));
      add(BookingStreamRequestEvent());
    });
  }

  //rideStream
  streamRide() {
    rideRepository = RideRepository();
    waitingTime = 0;
    if (requestStreamStart != null) requestStreamStart?.cancel();
    if (rideStreamUpdate != null) rideStreamUpdate?.cancel();
    if (rideStreamStart != null) rideStreamStart?.cancel();
    if (driverDataStream != null) driverDataStream?.cancel();
    rideStreamUpdate = FirebaseDatabase.instance
        .ref('requests/${requestData!.id}')
        .onChildChanged
        .handleError((onError) {
      rideStreamUpdate?.cancel();
    }).listen((DatabaseEvent event) async {
      debugPrint('rideStreamUpdate Listening');
      if (event.snapshot.key.toString() == 'modified_by_driver') {
        if (!isClosed) {
          add(BookingGetUserDetailsEvent(requestId: requestData!.id));
        }
      } else if (event.snapshot.key.toString() == 'message_by_driver') {
        add(GetChatHistoryEvent(requestId: requestData!.id));
      } else if (event.snapshot.key.toString() == 'cancelled_by_driver') {
        add(TripRideCancelEvent(isCancelByDriver: true));
        add(BookingGetUserDetailsEvent());
      } else if (event.snapshot.key.toString() == 'waiting_time_before_start') {
        var val = event.snapshot.value.toString();
        debugPrint('waiting Time : $val');
        waitingTime = int.parse(val);
      } else if (event.snapshot.key.toString() == 'is_accept') {
        markerList
            .removeWhere((element) => element.markerId.value.contains('#'));
        add(BookingGetUserDetailsEvent(requestId: requestData!.id));
      } else if (event.snapshot.value != null &&
          event.snapshot.key == 'is_user_paid') {
        add(BookingGetUserDetailsEvent(requestId: requestData!.id));
      } else if (event.snapshot.value != null &&
          event.snapshot.key == 'additional_charges_reason') {
        additionalChargesReason = event.snapshot.value.toString();
        add(UpdateEvent());
      } else if (event.snapshot.value != null &&
          event.snapshot.key == 'additional_charges_amount') {
        additionalChargesAmount = event.snapshot.value.toString();
        add(UpdateEvent());
      }

      if (event.snapshot.key.toString() == 'polyline') {
        polyLine = event.snapshot.child('polyline').value.toString();
        driverStreamRide(isFromRequstStream: true);
      }
      if (event.snapshot.key.toString() == 'distance') {
        distance = event.snapshot.child('distance').value.toString();
        add(UpdateEvent());
      }
      if (event.snapshot.key.toString() == 'duration') {
        duration = event.snapshot.child('duration').value.toString();
        if (!isClosed) {
          add(UpdateEvent());
        }
      }
      if (event.snapshot.key.toString() == 'is_payment_received') {
        isDriverReceivedPayment =
            (event.snapshot.child('is_payment_received').value as bool?) ??
                false;

        rideRepository.updatePaymentReceived(isDriverReceivedPayment);
        add(UpdateEvent());
      }
    });

    rideStreamStart = FirebaseDatabase.instance
        .ref('requests/${requestData!.id}')
        .onChildAdded
        .handleError((onError) {
      rideStreamStart?.cancel();
    }).listen((DatabaseEvent event) async {
      if (event.snapshot.key.toString() == 'cancelled_by_driver') {
        add(TripRideCancelEvent(isCancelByDriver: true));
        add(BookingGetUserDetailsEvent());
      } else if (event.snapshot.key.toString() == 'modified_by_driver') {
        add(BookingGetUserDetailsEvent(requestId: requestData!.id));
      } else if (event.snapshot.key.toString() == 'message_by_driver') {
        add(GetChatHistoryEvent(requestId: requestData!.id));
      } else if (event.snapshot.key.toString() == 'waiting_time_after_start') {
        var val = event.snapshot.value.toString();
        debugPrint('waiting Time : $val');
        waitingTime = int.parse(val);
      } else if (event.snapshot.key.toString() == 'is_accept') {
        driverStreamRide();
        markerList
            .removeWhere((element) => element.markerId.value.contains('#'));
        add(BookingGetUserDetailsEvent(requestId: requestData!.id));
      } else if (event.snapshot.value != null &&
          event.snapshot.key == 'is_user_paid') {
        add(BookingGetUserDetailsEvent(requestId: requestData!.id));
      } else if (event.snapshot.value != null &&
          event.snapshot.key == 'additional_charges_reason') {
        additionalChargesReason = event.snapshot.value.toString();
        add(UpdateEvent());
      } else if (event.snapshot.value != null &&
          event.snapshot.key == 'additional_charges_amount') {
        additionalChargesAmount = event.snapshot.value.toString();
        add(UpdateEvent());
      }

      if (event.snapshot.key.toString() == 'polyline') {
        polyLine = event.snapshot.child('polyline').value.toString();
        driverStreamRide(isFromRequstStream: true);
      }
      if (event.snapshot.key.toString() == 'distance') {
        distance = event.snapshot.child('distance').value.toString();
        add(UpdateEvent());
      }
      if (event.snapshot.key.toString() == 'duration') {
        duration = event.snapshot.child('duration').value.toString();
        add(UpdateEvent());
      }
      if (event.snapshot.key.toString() == 'is_payment_received') {
        isDriverReceivedPayment =
            (event.snapshot.child('is_payment_received').value as bool?) ??
                false;
        rideRepository.updatePaymentReceived(isDriverReceivedPayment);
        if (!isClosed) {
          add(UpdateEvent());
        }
      }
    });
  }

  driverStreamRide({int? driverId, bool? isFromRequstStream}) {
    if (driverDataStream != null) driverDataStream?.cancel();
    driverDataStream = FirebaseDatabase.instance
        .ref('drivers/driver_${(driverId != null) ? driverId : driverData!.id}')
        .onValue
        .handleError((onError) {
      driverDataStream?.cancel();
    }).listen((DatabaseEvent event) async {
      debugPrint('Driver Stream');
      dynamic driver = jsonDecode(jsonEncode(event.snapshot.value));
      final String iconType = driver['vehicle_type_icon'].toString();
      final double? incomingBearing = driver['bearing'] != null 
          ? double.tryParse(driver['bearing'].toString()) 
          : (driver['heading'] != null ? double.tryParse(driver['heading'].toString()) : null);

      if (incomingBearing != null) {
        myBearings[driver['id'].toString()] = incomingBearing;
      }
      final marker = VehicleMarkerHelper.getMarker(iconType, bearing: incomingBearing ?? (myBearings[driver['id'].toString()] ?? 0.0));

      if (vsync != null &&
          ((driverPosition != null &&
                  (driverPosition!.latitude != driver["l"][0] ||
                      driverPosition!.longitude != driver["l"][1])) ||
              incomingBearing != null) &&
          ((mapType == 'google_map' && googleMapController != null) ||
              (mapType != 'google_map' && fmController != null))) {
        animationController1 = AnimationController(
            vsync: vsync, duration: const Duration(milliseconds: 1500));
        animateCar(
            (driverPosition ?? LatLng(driver["l"][0], driver["l"][1])).latitude,
            (driverPosition ?? LatLng(driver["l"][0], driver["l"][1])).longitude,
            driver["l"][0],
            driver["l"][1],
            vsync,
            (mapType == 'google_map') ? googleMapController! : fmController!,
            'marker#${driver['id']}#${driver['vehicle_type_icon']}',
            marker,
            mapType,
            targetBearingOverride: incomingBearing);
      }
      if (isFromRequstStream != null && isFromRequstStream) {
        driverPosition = LatLng(driver["l"][0], driver["l"][1]);
        if (!markerList
            .any((element) => element.markerId.value.contains('#'))) {
          markerList.add(Marker(
            markerId: MarkerId(
                'marker#${driver['id']}#${driver['vehicle_type_icon']}'),
            position: LatLng(driver["l"][0], driver["l"][1]),
            rotation: 0.0,
            icon: marker,
          ));
        }
        if (requestData != null &&
            requestData!.arrivedAt != "" &&
            dropAddressList.length > 1 &&
            !requestData!.isRental) {
          for (var i = 0; i < dropAddressList.length; i++) {
            markerList.add(Marker(
              markerId: MarkerId("drop$i"),
              position: LatLng(dropAddressList[i].lat, dropAddressList[i].lng),
              rotation: 0.0,
              icon: await MarkerWidget(
                isPickup: false,
                count: '${i + 1}',
                text: dropAddressList[i].address,
              ).toBitmapDescriptor(
                  logicalSize: const Size(30, 30),
                  imageSize: const Size(200, 200)),
            ));
          }
        }
        if (requestData != null &&
            (!requestData!.isRental ||
                (requestData!.isRental && requestData!.arrivedAt == ""))) {
          await addDistanceMarker(
              (requestData != null && requestData!.arrivedAt == "")
                  ? LatLng(double.parse(requestData!.pickLat),
                  double.parse(requestData!.pickLng))
                  : LatLng(double.parse(requestData!.dropLat),
                  double.parse(requestData!.dropLng)),
              double.tryParse(distance)!,
              time: double.parse(duration));
        } else {
          markerList.removeWhere(
                  (element) => element.markerId == const MarkerId('distance'));
        }
        if (!requestData!.isRental) {
          markerList.add(Marker(
            markerId: const MarkerId("drop"),
            position: (requestData != null && requestData!.arrivedAt == "")
                ? LatLng(double.parse(requestData!.pickLat),
                double.parse(requestData!.pickLng))
                : LatLng(double.parse(requestData!.dropLat),
                double.parse(requestData!.dropLng)),
            rotation: 0.0,
            icon: await MarkerWidget(
              isPickup: (requestData != null && requestData!.arrivedAt == "")
                  ? true
                  : false,
              text: requestData!.dropAddress,
            ).toBitmapDescriptor(
                logicalSize: const Size(30, 30),
                imageSize: const Size(200, 200)),
          ));
        }
        if (requestData != null && requestData!.arrivedAt == "") {
          mapBound(
              driver["l"][0],
              driver["l"][1],
              double.parse(requestData!.pickLat),
              double.parse(requestData!.pickLng),
              isInitCall: false);
        } else {
          mapBound(
              driver["l"][0],
              driver["l"][1],
              double.parse(requestData!.dropLat),
              double.parse(requestData!.dropLng),
              isInitCall: false);
        }
        decodeEncodedPolyline(polyLine, isDriverStream: true);
      } else {
        if (requestData != null &&
            requestData!.isRental &&
            requestData!.arrivedAt != "") {
          polyLine = '';
          polylines.clear();
          markerList.removeWhere(
                  (element) => element.markerId.value.contains('drop'));
          markerList.removeWhere(
                  (element) => element.markerId == const MarkerId('distance'));
        }
      }
    });
  }

  // Reviews
  Future<void> ratingsSelectEvent(
      BookingRatingsSelectEvent event, Emitter<BookingState> emit) async {
    selectedRatingsIndex = event.selectedIndex;
    emit(BookingRatingsUpdateState());
  }

  Future<void> userRatings(
      BookingUserRatingsEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>().userReview(
        requestId: event.requestId,
        ratings: event.ratings,
        feedBack: event.feedBack);
    data.fold(
          (error) {
        debugPrint(error.toString());
        if (error.message == 'logout') {
          emit(LogoutState());
        }
      },
          (success) {
        emit(BookingUserRatingsSuccessState());
      },
    );
  }

  Future<void> getGoodsType(
      GetGoodsTypeEvent event, Emitter<BookingState> emit) async {
    if (goodsTypeList.isEmpty) {
      final data = await serviceLocator<BookingUsecase>().getGoodsTypes();
      data.fold(
            (error) {
          debugPrint(error.toString());
          if (error.message == 'logout') {
            emit(LogoutState());
          }
        },
            (success) {
          goodsTypeList = success.data;
          emit(SelectGoodsTypeState());
        },
      );
    } else {
      emit(SelectGoodsTypeState());
    }
  }

  Future<void> enableBiddingEvent(
      EnableBiddingEvent event, Emitter<BookingState> emit) async {
    // Ensure initial bid value and limit flags are consistent before showing UI
    try {
      final bool multi = isMultiTypeVechiles;
      final bidHighPct = multi
          ? sortedEtaDetailsList[selectedVehicleIndex].biddingHighPercentage
          : etaDetailsList[selectedVehicleIndex].biddingHighPercentage;
      final bidLowPct = multi
          ? sortedEtaDetailsList[selectedVehicleIndex].biddingLowPercentage
          : etaDetailsList[selectedVehicleIndex].biddingLowPercentage;

      final double totalValue = multi
          ? (isOutstationRide && isRoundTrip)
          ? (sortedEtaDetailsList[selectedVehicleIndex].total * 2)
          : sortedEtaDetailsList[selectedVehicleIndex].total
          : (isOutstationRide && isRoundTrip)
          ? (etaDetailsList[selectedVehicleIndex].total * 2)
          : etaDetailsList[selectedVehicleIndex].total;

      // Prefill bid value if empty
      if (farePriceController.text.isEmpty) {
        farePriceController.text = totalValue.toString();
      }

      final double currentPrice =
          double.tryParse(farePriceController.text) ?? totalValue;

      // Compute min/max allowed prices
      final double minAllowed = (bidLowPct == "0")
          ? 0.0
          : totalValue - ((double.parse(bidLowPct) / 100) * totalValue);
      final double maxAllowed = (bidHighPct == "0")
          ? double.infinity
          : totalValue + ((double.parse(bidHighPct) / 100) * totalValue);

      // Initialize flags based on current price
      isBiddingDecreaseLimitReach = currentPrice <= minAllowed;
      isBiddingIncreaseLimitReach =
          currentPrice >= maxAllowed && maxAllowed != double.infinity;
    } catch (e) {
      debugPrint('enableBiddingEvent init error: $e');
      isBiddingDecreaseLimitReach = false;
      isBiddingIncreaseLimitReach = false;
    }
    emit(ShowBiddingState());
  }

  Future<void> biddingFareIncreaseDecrease(
      BiddingIncreaseOrDecreaseEvent event, Emitter<BookingState> emit) async {
    final String bidHighPercentage = isMultiTypeVechiles
        ? sortedEtaDetailsList[selectedVehicleIndex].biddingHighPercentage
        : etaDetailsList[selectedVehicleIndex].biddingHighPercentage;
    final String bidLowPercentage = isMultiTypeVechiles
        ? sortedEtaDetailsList[selectedVehicleIndex].biddingLowPercentage
        : etaDetailsList[selectedVehicleIndex].biddingLowPercentage;
    final double basePrice = isMultiTypeVechiles
        ? sortedEtaDetailsList[selectedVehicleIndex].basePrice
        : etaDetailsList[selectedVehicleIndex].basePrice;
    final double totalValue = isMultiTypeVechiles
        ? (event.isOutStation && isRoundTrip)
        ? (sortedEtaDetailsList[selectedVehicleIndex].total * 2)
        : sortedEtaDetailsList[selectedVehicleIndex].total
        : (event.isOutStation && isRoundTrip)
        ? (etaDetailsList[selectedVehicleIndex].total * 2)
        : etaDetailsList[selectedVehicleIndex].total;

    if (farePriceController.text.isEmpty) {
      farePriceController.text = (requestData != null)
          ? requestData!.offerredRideFare
          : totalValue.toString();
    }
    if (requestData == null) {
      if (event.isIncrease) {
        if (bidHighPercentage == "0" ||
            (double.parse(farePriceController.text.toString()) +
                (double.parse(userData!.biddingAmountIncreaseOrDecrease
                    .toString()))) <=
                (totalValue +
                    ((double.parse(bidHighPercentage) / 100) * totalValue))) {
          isBiddingIncreaseLimitReach = false;
          isBiddingDecreaseLimitReach = false;
          farePriceController.text = (farePriceController.text.isEmpty)
              ? (basePrice +
              double.parse(
                  userData!.biddingAmountIncreaseOrDecrease.toString()))
              .toStringAsFixed(2)
              : (double.parse(farePriceController.text.toString()) +
              double.parse(
                  userData!.biddingAmountIncreaseOrDecrease.toString()))
              .toStringAsFixed(2);
        } else {
          isBiddingIncreaseLimitReach = true;
          isBiddingDecreaseLimitReach = false;
        }
        emit(BookingUpdateState());
      } else {
        final double step =
        double.parse(userData!.biddingAmountIncreaseOrDecrease.toString());
        final double currentPrice = farePriceController.text.isNotEmpty
            ? double.parse(farePriceController.text.toString())
            : totalValue;

        final double minAllowedPrice = bidLowPercentage == "0"
            ? 0.0
            : totalValue -
            ((double.parse(bidLowPercentage) / 100) * totalValue);

        // Only decrease if after decreasing we are still >= minAllowedPrice
        final double nextPrice = currentPrice - step;
        if (nextPrice >= minAllowedPrice) {
          isBiddingDecreaseLimitReach = false;
          isBiddingIncreaseLimitReach = false;
          farePriceController.text = nextPrice.toStringAsFixed(2);
          // If we exactly hit the min allowed price, mark limit reached for further decreases
          if (nextPrice == minAllowedPrice) {
            isBiddingDecreaseLimitReach = true;
          }
        } else {
          // Clamp to min and mark limit reached
          farePriceController.text = minAllowedPrice.toStringAsFixed(2);
          isBiddingDecreaseLimitReach = true;
          isBiddingIncreaseLimitReach = false;
        }
        emit(BookingUpdateState());
      }
    } else {
      if (event.isIncrease) {
        if ((requestData != null &&
            requestData!.biddingHighPercentage == "0") ||
            (double.parse(farePriceController.text.toString()) +
                (double.parse(userData!.biddingAmountIncreaseOrDecrease
                    .toString()))) <=
                (double.parse(requestData!.requestEtaAmount) +
                    ((double.parse(requestData!.biddingHighPercentage) / 100) *
                        double.parse(requestData!.requestEtaAmount)))) {
          isBiddingIncreaseLimitReach = false;
          isBiddingDecreaseLimitReach = false;
          farePriceController.text = (farePriceController.text.isEmpty)
              ? (double.parse(requestData!.offerredRideFare) +
              double.parse(
                  userData!.biddingAmountIncreaseOrDecrease.toString()))
              .toStringAsFixed(2)
              : (double.parse(farePriceController.text.toString()) +
              double.parse(
                  userData!.biddingAmountIncreaseOrDecrease.toString()))
              .toStringAsFixed(2);
          if (!((double.parse(farePriceController.text.toString()) +
              (double.parse(
                  userData!.biddingAmountIncreaseOrDecrease.toString()))) <=
              (double.parse(requestData!.requestEtaAmount) +
                  ((double.parse(requestData!.biddingHighPercentage) / 100) *
                      double.parse(requestData!.requestEtaAmount))))) {
            isBiddingIncreaseLimitReach = true;
            isBiddingDecreaseLimitReach = false;
          }
        } else {
          isBiddingIncreaseLimitReach = true;
          isBiddingDecreaseLimitReach = false;
        }
        emit(BookingUpdateState());
      } else {
        // Decrease branch for existing request (requestData != null)
        final double step =
        double.parse(userData!.biddingAmountIncreaseOrDecrease.toString());
        final double baseline = double.parse(requestData!.requestEtaAmount);
        final double currentPrice = farePriceController.text.isNotEmpty
            ? double.parse(farePriceController.text.toString())
            : double.parse(requestData!.offerredRideFare);

        final String reqLowPct = requestData!.biddingLowPercentage;
        final double minAllowedPrice = reqLowPct == "0"
            ? 0.0
            : baseline - ((double.parse(reqLowPct) / 100) * baseline);

        final double nextPrice = currentPrice - step;
        if (nextPrice >= minAllowedPrice) {
          isBiddingDecreaseLimitReach = false;
          isBiddingIncreaseLimitReach = false;
          farePriceController.text = nextPrice.toStringAsFixed(2);
          if (nextPrice == minAllowedPrice) {
            isBiddingDecreaseLimitReach = true;
          }
        } else {
          farePriceController.text = minAllowedPrice.toStringAsFixed(2);
          isBiddingDecreaseLimitReach = true;
          isBiddingIncreaseLimitReach = false;
        }
        emit(BookingUpdateState());
      }
    }
    emit(BookingUpdateState());
  }

  Future<void> biddingCreateRequest(
      BiddingCreateRequestEvent event, Emitter<BookingState> emit) async {
    isLoading = true;
    final data = await serviceLocator<BookingUsecase>().createRequest(
        userData: event.userData,
        vehicleData: event.vehicleData,
        pickupAddressList: event.pickupAddressList,
        dropAddressList: event.dropAddressList,
        selectedTransportType: event.selectedTransportType,
        paidAt: event.paidAt,
        parcelType: event.parcelType,
        selectedPaymentType:
        event.cardToken.isNotEmpty ? 'card' : event.selectedPaymentType,
        cardToken: event.cardToken,
        scheduleDateTime: event.scheduleDateTime,
        isEtaRental: false,
        isBidRide: true,
        goodsTypeId: event.goodsTypeId,
        goodsQuantity: event.goodsQuantity,
        offeredRideFare: event.offeredRideFare,
        polyLine: event.polyLine,
        isAirport: ((event.pickupAddressList.first.isAirportLocation != null &&
            event.pickupAddressList.first.isAirportLocation!) ||
            (event.dropAddressList.any((element) =>
            (element.isAirportLocation != null &&
                element.isAirportLocation!))))
            ? true
            : false,
        isParcel: (event.selectedTransportType == 'delivery') ? true : false,
        isOutstationRide: event.isOutstationRide,
        isRoundTrip: event.isRoundTrip,
        scheduleDateTimeForReturn: event.scheduleDateTimeForReturn,
        taxiInstruction: instructionsController.text,
        preferences: event.preferences,
        bookOthers: event.bookOthers,
        contactNumber: event.contactNumber,
        myself: event.myself,
        contactBookName: event.contactBookName);
    data.fold(
          (error) {
        isLoading = false;
        if (error.message == 'logout') {
          emit(LogoutState());
        } else {
          showToast(message: '${error.message}');
          emit(BiddingCreateRequestFailureState());
        }
      },
          (success) {
        isLoading = false;
        requestData = OnTripRequestData.fromJson(success["data"]);
        isBiddingDecreaseLimitReach = false;
        isBiddingIncreaseLimitReach = false;

        if (success['success']) {
          FirebaseDatabase.instance
              .ref()
              .child('bid-meta/${requestData!.id}')
              .update({
            'user_id': userData!.id.toString(),
            'price': requestData!.offerredRideFare,
            'base_price': event.vehicleData.total.toString(),
            'g': GeoHasher().encode(double.parse(requestData!.pickLng),
                double.parse(requestData!.pickLat)),
            'user_name': userData!.name,
            'updated_at': ServerValue.timestamp,
            'user_img': userData!.profilePicture,
            'vehicle_type': requestData!.vehicleTypeId,
            'request_id': requestData!.id,
            'request_no': requestData!.requestNumber,
            'pick_address': requestData!.pickAddress,
            'drop_address': requestData!.dropAddress,
            'trip_stops': (event.dropAddressList.length > 1)
                ? jsonEncode(event.dropAddressList)
                : 'null',
            'goods': (requestData!.transportType != 'taxi' &&
                requestData!.goodsType != '-')
                ? '${requestData!.goodsType} - ${requestData!.goodsTypeQuantity}'
                : 'null',
            'pick_lat': double.parse(requestData!.pickLat),
            'drop_lat': double.parse(requestData!.dropLat),
            'pick_lng': double.parse(requestData!.pickLng),
            'drop_lng': double.parse(requestData!.dropLng),
            'currency': userData!.currencySymbol,
            'is_out_station': event.isOutstationRide,
            'distance': event.isOutstationRide
                ? userData!.distanceUnit == 'mi'
                ? ((double.parse(requestData!.totalDistance) * 1.60934) *
                1000)
                .toString()
                : (double.parse(requestData!.totalDistance) * 1000)
                .toString()
                : isMultiTypeVechiles
                ? sortedEtaDetailsList[selectedVehicleIndex].distance
                : etaDetailsList[selectedVehicleIndex].distance.toString(),
            'completed_ride_count': userData!.completedRideCount,
            'ratings': userData!.rating,
            'trip_type': event.isOutstationRide
                ? event.isRoundTrip
                ? 'Round Trip'
                : 'One Way Trip'
                : 'Bidding',
            'start_date': requestData!.tripStartTime,
            'return_date': requestData!.returnTime,
            'polyline': requestData!.polyLine,
            'duration': requestData!.totalTime.toString(),
            'transport_type': event.selectedTransportType,
            'taxi_instruction': instructionsController.text,
            'pick_poc_instruction': requestData!.pickupPocInstruction,
            'preferences': event.preferences,
            'preferences_icon': event.preferencesIcons,
          });
          if (event.scheduleDateTime.isEmpty) {
            isTripStart = true;
            nearByVechileSubscription?.cancel();
            etaDurationStream?.cancel();
            isBiddingRideSearching = true;
            isNormalRideSearching = false;
            biddingStreamRequest();
            // Compute flags so buttons are correct on first entry
            try {
              final bool multi = isMultiTypeVechiles;
              final String lowPct = multi
                  ? sortedEtaDetailsList[selectedVehicleIndex]
                  .biddingLowPercentage
                  : etaDetailsList[selectedVehicleIndex].biddingLowPercentage;
              final double totalValue = multi
                  ? (isOutstationRide && isRoundTrip)
                  ? (sortedEtaDetailsList[selectedVehicleIndex].total * 2)
                  : sortedEtaDetailsList[selectedVehicleIndex].total
                  : (isOutstationRide && isRoundTrip)
                  ? (etaDetailsList[selectedVehicleIndex].total * 2)
                  : etaDetailsList[selectedVehicleIndex].total;
              final double minAllowed = (lowPct == '0')
                  ? 0.0
                  : totalValue - ((double.parse(lowPct) / 100) * totalValue);
              final double current =
                  double.tryParse(farePriceController.text) ?? totalValue;
              isBiddingDecreaseLimitReach = current <= minAllowed;
              isBiddingIncreaseLimitReach = false;
            } catch (e) {
              isBiddingDecreaseLimitReach = false;
              isBiddingIncreaseLimitReach = false;
            }
            if (mapType == 'google_map') {
              if (googleMapController != null) {
                googleMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(event.pickupAddressList.first.lat,
                          event.pickupAddressList.first.lng),
                      zoom: 17.0,
                    )));
              }
            } else {
              if (fmController != null) {
                fmController!.move(
                    fmlt.LatLng(event.pickupAddressList.first.lat,
                        event.pickupAddressList.first.lng),
                    13);
              }
            }
            emit(BiddingCreateRequestSuccessState());
          } else {
            emit(BookingLaterCreateRequestSuccessState(
                isOutstation: event.isOutstationRide));
          }
        } else {
          showToast(message: '${success['message']}');
          emit(BiddingCreateRequestFailureState());
        }
      },
    );
  }

  Future<void> biddingFareUpdate(
      BiddingFareUpdateEvent event, Emitter<BookingState> emit) async {
    isLoading = true;
    await FirebaseDatabase.instance
        .ref()
        .child('bid-meta/${requestData!.id}')
        .update({
      'price': farePriceController.text,
      'updated_at': ServerValue.timestamp,
    });
    await FirebaseDatabase.instance
        .ref()
        .child('bid-meta/${requestData!.id}/drivers')
        .remove();
    isLoading = false;
    emit(BiddingFareUpdateState());
  }

  //biddingStream
  biddingStreamRequest() {
    if (biddingRequestStream != null) {
      biddingRequestStream?.cancel();
    }
    biddingRequestStream = FirebaseDatabase.instance
        .ref()
        .child('bid-meta/${requestData!.id}')
        .onValue
        .handleError((onError) {
      biddingRequestStream?.cancel();
    }).listen(
          (DatabaseEvent event) {
        debugPrint("BIDDING STREAM");
        Map rideList = {};
        DataSnapshot snapshots = event.snapshot;
        if (snapshots.value != null) {
          rideList = jsonDecode(jsonEncode(snapshots.value));
          if (rideList['request_id'] != null) {
            if (rideList['drivers'] != null) {
              biddingDriverList.clear();
              Map driver = rideList['drivers'];
              driver.forEach((key, value) {
                if (driver[key]['is_rejected'] == 'none') {
                  biddingDriverList.add(value);
                  if (biddingDriverList.isNotEmpty) {
                    audioPlayers.play(AssetSource(AppAudio.notification));
                  }
                }
                biddingTimerEvent(
                    duration: int.parse(
                        userData!.maximumTimeForFindDriversForBittingRide) +
                        5);
              });
            }
          } else {
            if (requestData != null && requestData!.isOutStation == '0') {
              add(BookingCancelRequestEvent(requestId: requestData!.id));
            }
          }
        }
        add(UpdateEvent());
      },
    );
  }

  biddingTimerEvent({required int duration}) async {
    int count = duration;

    biddingRideTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      count--;
      if (count <= 0) {
        biddingRideTimer?.cancel();
      }
      add(UpdateEvent());
    });
  }

  Future<void> biddingAcceptOrDecline(
      BiddingAcceptOrDeclineEvent event, Emitter<BookingState> emit) async {
    if (event.isAccept) {
      final data = await serviceLocator<BookingUsecase>().biddingAccept(
          requestId: (requestData != null)
              ? requestData!.id
              : (event.id != null)
              ? event.id!
              : '',
          driverId: event.driver['driver_id'].toString(),
          acceptRideFare: event.driver['price'].toString(),
          offeredRideFare: farePriceController.text);
      data.fold(
            (error) {
          isLoading = false;
          if (error.message == 'logout') {
            emit(LogoutState());
          } else {
            showToast(message: '${error.message}');
            emit(BiddingCreateRequestFailureState());
          }
        },
            (success) async {
          if (requestData != null) {
            await FirebaseDatabase.instance
                .ref()
                .child('bid-meta/${requestData!.id}')
                .remove();
            driverStreamRide(driverId: event.driver["driver_id"]);
            biddingDriverList.removeWhere(
                    (element) => element["driver_id"] == event.driver["driver_id"]);
            add(BookingGetUserDetailsEvent(requestId: requestData!.id));
          }
          add(UpdateEvent());
        },
      );
    } else {
      await FirebaseDatabase.instance
          .ref()
          .child(
          'bid-meta/${requestData!.id}/drivers/driver_${event.driver["driver_id"]}')
          .update({"is_rejected": 'by_user'});
      if (biddingDriverList.isNotEmpty) {
        biddingDriverList.removeWhere(
                (element) => element["driver_id"] == event.driver["driver_id"]);
        emit(BookingUpdateState());
      }
      emit(BookingUpdateState());
    }
  }

  Future<void> getCancelReasons(
      CancelReasonsEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>().cancelReasons(
        beforeOrAfter: event.beforeOrAfter, requestId: requestData!.id);
    data.fold(
          (error) {
        if (error.message == 'logout') {
          emit(LogoutState());
        } else {
          showToast(message: '${error.message}');
          emit(BookingUpdateState());
        }
      },
          (success) {
        cancelReasonsList = success.data;
        emit(CancelReasonState());
      },
    );
  }

  FutureOr<void> getPolyline(
      PolylineEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>().getPolyline(
      pickLat: event.pickLat,
      pickLng: event.pickLng,
      dropLat: event.dropLat,
      dropLng: event.dropLng,
      stops: event.stops,
      isOpenStreet: mapType == 'open_street_map',
    );
    data.fold(
          (error) {
        debugPrint(error.toString());
        showToast(message: error.message ?? '');
        emit(BookingUpdateState());
      },
          (success) async {
        distance = success.distance;
        if (success.duration.contains('.')) {
          duration = double.parse(success.duration).toStringAsFixed(1);
        } else {
          duration = success.duration;
        }
        polyLine = success.polyString;
        if (event.isInitCall != null &&
            event.isInitCall! &&
            event.arg != null) {
          add(BookingEtaRequestEvent(
            picklat: event.arg!.picklat,
            picklng: event.arg!.picklng,
            droplat: event.arg!.droplat,
            droplng: event.arg!.droplng,
            ridetype: 1,
            transporttype: transportType,
            distance: distance,
            duration: duration,
            polyLine: polyLine,
            pickupAddressList: event.arg!.pickupAddressList,
            dropAddressList: event.arg!.stopAddressList,
            isOutstationRide: event.arg!.isOutstationRide,
            isWithoutDestinationRide:
            event.arg!.isWithoutDestinationRide ?? false,
            sharedRide: (event.arg!.isSharedRide ?? false) ? 1 : null,
            seatsTaken: (event.arg!.isSharedRide ?? false) ? 1 : null,
          ));
        }
        if (event.icon != null) {
          driverPosition = LatLng(event.pickLat, event.pickLng);
        }
        if (event.isDriverStream != null && event.isDriverStream!) {
          markerList.clear();
        }
        if (event.arg != null &&
            ((event.arg!.isWithoutDestinationRide != null &&
                !event.arg!.isWithoutDestinationRide!) ||
                (event.arg!.isWithoutDestinationRide == null)) &&
            ((event.arg!.isRentalRide != null && !event.arg!.isRentalRide!) ||
                event.arg!.isRentalRide == null)) {
          await addDistanceMarker(
              LatLng(event.dropLat, event.dropLng), double.tryParse(distance)!,
              time: double.parse(duration));
        }
        markerList.add(Marker(
          markerId: event.markerId != null
              ? MarkerId(event.markerId!)
              : const MarkerId("pick"),
          position: LatLng(event.pickLat, event.pickLng),
          rotation: 0.0,
          icon: event.icon ??
              await MarkerWidget(
                isPickup: true,
                text: event.pickAddress,
              ).toBitmapDescriptor(
                  logicalSize: const Size(30, 30),
                  imageSize: const Size(200, 200)),
        ));
        if (userData != null &&
            event.stops.isEmpty &&
            ((userData!.metaRequest != null && userData!.metaRequest != "") ||
                (userData!.onTripRequest != null &&
                    userData!.onTripRequest != ""))) {
          if (event.arg != null &&
              ((event.arg!.isWithoutDestinationRide != null &&
                  !event.arg!.isWithoutDestinationRide!) ||
                  (event.arg!.isWithoutDestinationRide == null)) &&
              ((event.arg!.isRentalRide != null && !event.arg!.isRentalRide!) ||
                  event.arg!.isRentalRide == null)) {
            await addDistanceMarker(LatLng(event.dropLat, event.dropLng),
                double.tryParse(distance)!,
                time: double.parse(duration));
          }
          markerList.add(Marker(
            markerId: const MarkerId("drop"),
            position: LatLng(event.dropLat, event.dropLng),
            rotation: 0.0,
            icon: await MarkerWidget(
              isPickup: (event.isDriverToPick != null && event.isDriverToPick!)
                  ? true
                  : false,
              text: event.dropAddress,
            ).toBitmapDescriptor(
                logicalSize: const Size(30, 30),
                imageSize: const Size(200, 200)),
          ));
        } else if (event.stops.isNotEmpty) {
          for (var i = 0; i < event.stops.length; i++) {
            markerList.add(Marker(
              markerId: MarkerId("drop$i"),
              position: LatLng(event.stops[i].lat, event.stops[i].lng),
              rotation: 0.0,
              icon: await MarkerWidget(
                isPickup: false,
                count: '${i + 1}',
                text: event.stops[i].address,
              ).toBitmapDescriptor(
                  logicalSize: const Size(30, 30),
                  imageSize: const Size(200, 200)),
            ));
          }
        } else {
          if (event.arg != null &&
              ((event.arg!.isWithoutDestinationRide != null &&
                  !event.arg!.isWithoutDestinationRide!) ||
                  (event.arg!.isWithoutDestinationRide == null)) &&
              ((event.arg!.isRentalRide != null && !event.arg!.isRentalRide!) ||
                  event.arg!.isRentalRide == null)) {
            await addDistanceMarker(LatLng(event.dropLat, event.dropLng),
                double.tryParse(distance)!,
                time: double.parse(duration));
          }
          markerList.add(Marker(
            markerId: const MarkerId("drop"),
            position: LatLng(event.dropLat, event.dropLng),
            rotation: 0.0,
            icon: await MarkerWidget(
              isPickup: (event.isDriverToPick != null && event.isDriverToPick!)
                  ? true
                  : false,
              text: event.dropAddress,
            ).toBitmapDescriptor(
                logicalSize: const Size(30, 30),
                imageSize: const Size(200, 200)),
          ));
        }
        if (event.isDropChanged != null && event.isDropChanged!) {
          await addDistanceMarker(
              LatLng(event.dropLat, event.dropLng), double.tryParse(distance)!,
              time: double.parse(duration));
        }
        mapBound(event.pickLat, event.pickLng, event.dropLat, event.dropLng,
            isInitCall: event.isInitCall);
        decodeEncodedPolyline(success.polyString,
            isDriverStream: event.isDriverStream);
      },
    );
    emit(BookingUpdateState());
  }

  mapBound(double pickLat, double pickLng, double dropLat, double dropLng,
      {bool? isInitCall, bool? isRentalRide, List<LatLng>? polyPoints, List<LatLng>? extraPoints}) {
    List<LatLng> allPoints = [];
    if (polyPoints != null) allPoints.addAll(polyPoints);
    if (extraPoints != null) allPoints.addAll(extraPoints);
    if (pickLat != 0) allPoints.add(LatLng(pickLat, pickLng));
    if (dropLat != 0) allPoints.add(LatLng(dropLat, dropLng));

    if (allPoints.isNotEmpty) {
      double minLat = allPoints.first.latitude;
      double maxLat = allPoints.first.latitude;
      double minLng = allPoints.first.longitude;
      double maxLng = allPoints.first.longitude;

      for (var point in allPoints) {
        minLat = math.min(minLat, point.latitude);
        maxLat = math.max(maxLat, point.latitude);
        minLng = math.min(minLng, point.longitude);
        maxLng = math.max(maxLng, point.longitude);
      }
      bound = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
    }

    if (!isClosed) {
      add(UpdateEvent());
    }
  }

  List<LatLng> polylist = [];
  Future<List<PointLatLng>> decodeEncodedPolyline(String encoded,
      {bool? isDriverStream}) async {
    polylist.clear();
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    polylines.clear();
    fmpoly.clear();

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polylist.add(p);
      fmpoly.add(
        fmlt.LatLng(p.latitude, p.longitude),
      );
    }

    polylines.add(
      Polyline(
          polylineId: const PolylineId('1'),
          color: AppColors.blue,
          visible: true,
          width: 4,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          points: polylist),
    );

    // Update bounds to include the entire route for a "wide fit"
    mapBound(0, 0, 0, 0, polyPoints: polylist);

    if (isDriverStream == null) {
      if (mapType == 'google_map') {
        // Use a slightly larger padding (120) to ensure points aren't right at the edge
        try {
          googleMapController
              ?.animateCamera(CameraUpdate.newLatLngBounds(bound!, 120));
        } catch (e) {
          debugPrint("Error animating camera in decodeEncodedPolyline: $e");
        }
      } else {
        if (fmController != null) {
          fmController!.fitCamera(
            fm.CameraFit.bounds(
              bounds: fm.LatLngBounds(
                fmlt.LatLng(bound!.southwest.latitude, bound!.southwest.longitude),
                fmlt.LatLng(bound!.northeast.latitude, bound!.northeast.longitude),
              ),
              padding: const EdgeInsets.all(50),
            ),
          );
        }
      }
    }
    if (!isClosed) {
      add(UpdateEvent());
    }
    return poly;
  }

  FutureOr<void> chatWithDriver(
      ChatWithDriverEvent event, Emitter<BookingState> emit) async {
    add(GetChatHistoryEvent(requestId: event.requestId));
    emit(ChatWithDriverState());
  }

  FutureOr<void> getChatHistory(
      GetChatHistoryEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>()
        .getChatHistory(requestId: event.requestId);
    data.fold((error) {
      debugPrint(error.toString());
      if (error.message == 'logout') {
        emit(LogoutState());
      } else {
        emit(BookingUpdateState());
      }
    }, (success) {
      chatHistoryList = success.data;
      if (chatHistoryList.isNotEmpty) {
        add(SeenChatMessageEvent(requestId: event.requestId));
      }
      emit(BookingUpdateState());
    });
  }

  FutureOr<void> sendChatMessage(
      SendChatMessageEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>()
        .sendChatMessage(requestId: event.requestId, message: event.message);
    data.fold((error) {
      debugPrint(error.toString());
      if (error.message == 'logout') {
        emit(LogoutState());
      } else {
        emit(BookingUpdateState());
      }
    }, (success) {
      add(GetChatHistoryEvent(requestId: event.requestId));
      FirebaseDatabase.instance
          .ref('requests/${event.requestId}')
          .update({'message_by_user': chatHistoryList.length});
      emit(BookingUpdateState());
    });
  }

  FutureOr<void> seenChatMessage(
      SeenChatMessageEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>()
        .seenChatMessage(requestId: event.requestId);
    data.fold((error) {
      debugPrint(error.toString());
      if (error.message == 'logout') {
        emit(LogoutState());
      } else {
        emit(BookingUpdateState());
      }
    }, (success) {
      emit(BookingUpdateState());
    });
  }

  FutureOr<void> sosEvent(SOSEvent event, Emitter<BookingState> emit) async {
    emit(SosState());
  }

  FutureOr<void> notifyAdmin(
      NotifyAdminEvent event, Emitter<BookingState> emit) async {
    await FirebaseDatabase.instance
        .ref()
        .child('SOS/${event.requestId}')
        .update({
      "is_driver": "0",
      "is_user": "1",
      "req_id": event.requestId,
      "serv_loc_id": event.serviceLocId,
      "updated_at": ServerValue.timestamp
    });
    emit(BookingUpdateState());
  }

  @override
  Future<void> close() {
    // Dispose the DraggableScrollableController when the bloc is closed
    _draggableScrollableController.dispose();
    markerNotifier.dispose();
    if (animationController != null) {
      animationController?.dispose();
    }
    if (animationController1 != null) {
      animationController1?.dispose();
    }
    if (requestStreamStart != null) {
      requestStreamStart?.cancel();
    }
    if (biddingRequestStream != null) {
      biddingRequestStream?.cancel();
    }
    if (driverDataStream != null) {
      driverDataStream?.cancel();
    }

    if (etaDurationStream != null) {
      etaDurationStream?.cancel();
    }
    if (nearByVechileSubscription != null) {
      nearByVechileSubscription?.cancel();
    }

    return super.close();
  }

  // ===========================VECHILE MARKER ADD======================================>

  nearByVechileCheckStream(
      BuildContext context, dynamic vsync, LatLng currentLatLng) async {
    GeoHasher geo = GeoHasher();
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;
    double lowerLat = 0.0;
    double lowerLon = 0.0;
    double greaterLat = 0.0;
    double greaterLon = 0.0;
    lowerLat = currentLatLng.latitude - (lat * 1.24);
    lowerLon = currentLatLng.longitude - (lon * 1.24);

    greaterLat = currentLatLng.latitude + (lat * 1.24);
    greaterLon = currentLatLng.longitude + (lon * 1.24);

    var lower = geo.encode(lowerLon, lowerLat);
    var higher = geo.encode(greaterLon, greaterLat);

    if (nearByVechileSubscription != null) {
      nearByVechileSubscription?.cancel();
    }
    nearByVechileSubscription = FirebaseDatabase.instance
        .ref('drivers')
        .orderByChild('g')
        .startAt(lower)
        .endAt(higher)
        .onValue
        .listen((onData) {
      debugPrint('Pickup NearBy Vechiles : ${onData.snapshot.children}');
      if (onData.snapshot.exists) {
        // List driverData = [];
        nearByDriversData.clear();
        for (var element in onData.snapshot.children) {
          nearByDriversData.add(element.value);
        }
        checkNearByEta(nearByDriversData, vsync);
      }
    });
  }

  Future<void> checkNearByEta(List<dynamic> driverData, vsync) async {
    List etaList = !isRentalRide
        ? isMultiTypeVechiles
        ? sortedEtaDetailsList
        : etaDetailsList
        : rentalEtaDetailsList;
    String choosenEtaTypeId =
    etaList.isNotEmpty ? etaList[selectedVehicleIndex].typeId : '';
    for (var element in driverData) {
      if (element['is_active'] == 1 &&
          element['is_available'] == true &&
          ((element['vehicle_types'] != null &&
              element['vehicle_types'].contains(choosenEtaTypeId)) ||
              (element['vehicle_type'] != null &&
                  element['vehicle_type'] == choosenEtaTypeId))) {
        if (((transportType == 'taxi' && element['transport_type'] == 'taxi') ||
            (transportType == 'delivery' &&
                element['transport_type'] == 'delivery') ||
            element['transport_type'] == 'bidding' ||
            element['transport_type'] == 'both')
        // || (transportType == 'delivery' &&  element['transport_type'] == 'both')
        ) {
          DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(element['updated_at']);

          if (DateTime.now().difference(dt).inMinutes <= 2) {
            final String driverId = element['id'].toString();
            final String iconType = element['vehicle_type_icon'].toString();
            
            // Prioritize 'heading' (compass) over 'bearing' (movement direction)
            final double? incomingBearing = element['heading'] != null 
                ? double.tryParse(element['heading'].toString()) 
                : (element['bearing'] != null ? double.tryParse(element['bearing'].toString()) : null);

            final lastMarker = markerList.lastWhere(
              (e) => e.markerId.value.contains('marker#$driverId#'),
              orElse: () => const Marker(markerId: MarkerId('none')),
            );

            if (lastMarker.markerId.value == 'none') {
              // New driver, just add
              final double rotation = incomingBearing ?? 0.0;
              markerList.add(Marker(
                markerId: MarkerId('marker#$driverId#$iconType'),
                rotation: VehicleMarkerHelper.isSpriteBased(iconType) ? 0.0 : rotation,
                position: LatLng(element['l'][0], element['l'][1]),
                icon: VehicleMarkerHelper.getMarker(iconType, bearing: rotation),
              ));
              if (incomingBearing != null) myBearings[driverId] = incomingBearing;
            } else {
              // Existing driver, check for movement OR rotation change
              bool hasMoved = lastMarker.position.latitude != element['l'][0] || lastMarker.position.longitude != element['l'][1];
              bool hasRotated = incomingBearing != null && (myBearings[driverId] ?? 0.0) != incomingBearing;

              if (hasMoved || hasRotated) {
                var dist = calculateDistance(
                  lat1: lastMarker.position.latitude,
                  lon1: lastMarker.position.longitude,
                  lat2: double.parse(element['l'][0].toString()),
                  lon2: double.parse(element['l'][1].toString()),
                  unit: 'km',
                );
                
                // If it moved more than 2 meters OR it's just a rotation update
                if (dist > 0.002 || (hasRotated && !hasMoved)) {
                  animateCar(
                      lastMarker.position.latitude,
                      lastMarker.position.longitude,
                      double.parse(element['l'][0].toString()),
                      double.parse(element['l'][1].toString()),
                      vsync,
                      (mapType == 'google_map') ? googleMapController : fmController,
                      lastMarker.markerId.value,
                      VehicleMarkerHelper.getMarker(iconType, bearing: incomingBearing ?? (myBearings[driverId] ?? 0.0)),
                      mapType,
                      targetBearingOverride: incomingBearing);
                }
              }
            }
          }
        }
      } else {
        if (markerList
            .where((e) => e.markerId.toString().contains(
            'marker#${element['id']}#${element['vehicle_type_icon']}'))
            .isNotEmpty) {
          markerList.removeWhere((e) => e.markerId.toString().contains(
              'marker#${element['id']}#${element['vehicle_type_icon']}'));
        }
      }
    }
    // add(UpdateEvent());
  }

  // =======================================================================================>

  double getBearing(LatLng begin, LatLng end) {
    double lat1 = begin.latitude * math.pi / 180;
    double lng1 = begin.longitude * math.pi / 180;
    double lat2 = end.latitude * math.pi / 180;
    double lng2 = end.longitude * math.pi / 180;

    double dLon = lng2 - lng1;

    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    double radians = math.atan2(y, x);
    return (radians * 180 / math.pi + 360) % 360;
  }

  animateCar(
      double fromLat, //Starting latitude
      double fromLong, //Starting longitude
      double toLat, //Ending latitude
      double toLong, //Ending longitude
      TickerProvider provider, //Ticker provider of the widget. This is used for animation
      dynamic controller, //Google map controller of our widget
      markerid,
      icon,
      map,
      {double? targetBearingOverride}) async {
    
    final String driverId = markerid.toString().split('#')[1];
    final double startRotation = myBearings[driverId] ?? 0.0;
    
    // Calculate new target bearing: use override (from sensor) if available, otherwise calculate from movement
    double targetBearing = targetBearingOverride ?? getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));
    
    // If movement is zero and no override, don't change bearing
    if (fromLat == toLat && fromLong == toLong && targetBearingOverride == null) {
      targetBearing = startRotation;
    }
    
    myBearings[driverId] = targetBearing;

    animationController1?.dispose();
    animationController1 = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: provider,
    );

    Tween<double> tween = Tween(begin: 0, end: 1);
    
    // Animate from current rotation to target bearing using the shortest path
    double rotationDiff = (targetBearing - startRotation + 180) % 360 - 180;
    if (rotationDiff < -180) rotationDiff += 360;

    _animation1 = tween.animate(CurvedAnimation(
      parent: animationController1!,
      curve: Curves.linear,
    ))..addListener(() async {
        markerList.removeWhere((element) => element.markerId.value == markerid);

        final v = _animation1!.value;

        // Interpolate position
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);
        
        // Interpolate rotation smoothly
        double currentRotation = (startRotation + (rotationDiff * v)) % 360;
        
        final String iconType = markerid.toString().split('#')[2];
        final bool isSprite = VehicleMarkerHelper.isSpriteBased(iconType);

        final carMarker = Marker(
            markerId: MarkerId(markerid.toString()),
            position: newPos,
            icon: VehicleMarkerHelper.getMarker(iconType, bearing: currentRotation),
            rotation: isSprite ? 0.0 : currentRotation,
            anchor: const Offset(0.5, 0.5),
            flat: true,
            draggable: false);

        markerList.add(carMarker);
        if (!isClosed) {
          add(UpdateMarkersEvent(markers: markerList));
        }
      });

    //Starting the animation
    driverPosition = LatLng(toLat, toLong);
    await animationController1!.forward();
    
    // Auto-follow camera logic
    if (userData != null && (userData!.onTripRequest != "" || userData!.metaRequest != "")) {
      if (map == 'google_map') {
        try {
          googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(toLat, toLong),
            tilt: 45.0,
            bearing: targetBearing,
            zoom: 17.0,
          )));
        } catch (e) {
          debugPrint("Error animating camera in animateCar: $e");
        }
      } else {
        fmController?.move(fmlt.LatLng(toLat, toLong), 15.0);
      }
    }
  }

  Future<void> enableEtaScrollingList(
      UpdateScrollPhysicsEvent event, Emitter<BookingState> emit) async {
    enableEtaScrolling = event.enableEtaScrolling;
    emit(BookingScrollPhysicsUpdated(enableEtaScrolling: enableEtaScrolling));
  }

  double snapToPosition(double currentSize, double minSize, double maxSize) {
    if (currentSize >= (minSize + maxSize) / 2) {
      return maxSize;
    } else {
      return minSize;
    }
  }

  void updateScrollHeight(double height) {
    scrollHeight = height;
    enableEtaScrolling = scrollHeight >= maxChildSize;
    add(UpdateScrollPhysicsEvent(enableEtaScrolling: enableEtaScrolling));
  }

  void scrollToMinChildSize(double targetMinChildSize) {
    currentSize = maxChildSize;
  }

  void scrollToBottomFunction(int length) {
    if (length == 1) {
      currentSize = minChildSize;
    } else if (length == 2) {
      currentSizeTwo = minChildSizeTwo;
    } else {
      currentSizeThree = minChildSizeThree;
    }
  }

  Future<void> enableDetailsViewFunction(
      DetailViewUpdateEvent event, Emitter<BookingState> emit) async {
    detailView = event.detailView;
    emit(DetailViewUpdateState(detailView));
  }

  FutureOr<void> walletPageReUpdate(
      WalletPageReUpdateEvents event, Emitter<BookingState> emit) async {
    emit(WalletPageReUpdateStates(
        currencySymbol: event.currencySymbol,
        money: event.money,
        requestId: event.requestId,
        url: event.url,
        userId: event.userId));
  }

  FutureOr<void> invoiceInit(
      InvoiceInitEvent event, Emitter<BookingState> emit) async {
    requestData = event.arg.requestData;
    driverData = event.arg.driverData;
    requestBillData = event.arg.requestBillData;
    if (requestData!.enableDriverTipsFeature == '1' &&
        requestBillData!.driverTips == '0') {
      selectedPaymentType = requestData!.paymentTypeString;
      printWrapped("Getting payment type:$selectedPaymentType");
      emit(ShowAddTipState(isDriverReceivedPayment: isDriverReceivedPayment));
    } else {
      emit(BookingUpdateState());
    }
    streamRide();
  }

  FutureOr<void> showAddTip(
      ShowAddTipEvent event, Emitter<BookingState> emit) async {}

  FutureOr<void> addTipEvent(
      AddTipsEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>()
        .addTips(requestId: event.requestId, amount: event.amount);
    data.fold(
          (error) {
        debugPrint(error.toString());
        if (error.message == 'logout') {
          emit(LogoutState());
        }
      },
          (success) {
        if (success['success']) {
          requestBillData = RequestBillData.fromJson(success['data']);
          FirebaseDatabase.instance
              .ref('requests/${event.requestId}')
              .update({'driver_tips': event.amount});
        }
        emit(TipsAddedState(requestBillData: requestBillData!));
      },
    );
  }

  Future addDistanceMarker(LatLng position, double distanceMeter,
      {double? time}) async {
    markerList.removeWhere(
            (element) => element.markerId == const MarkerId('distance'));
    double duration;
    String totalDistance;
    String unitLabel;

    bool isMiles = userData?.distanceUnit == 'mi';

    double convertedDistance =
    isMiles ? ((distanceMeter / 1000) * 0.621371) : (distanceMeter / 1000);

    unitLabel = isMiles ? 'MI' : 'KM';

    if (convertedDistance < 0.5) {
      totalDistance = '0.5';
      duration = 1;
      fmDistance = '0.5';
      fmDuration = 1;
      add(UpdateEvent());
    } else {
      totalDistance = convertedDistance.toStringAsFixed(1);
      duration = (time != null)
          ? (time > 0 ? time : 2)
          : (convertedDistance * 1.5).roundToDouble();
      fmDistance = convertedDistance.toStringAsFixed(1);
      fmDuration = (time != null)
          ? (time > 0 ? time : 2)
          : (convertedDistance * 1.5).roundToDouble();
      add(UpdateEvent());
    }

    markerList.add(Marker(
      anchor: const Offset(0.5, 0.0),
      markerId: const MarkerId("distance"),
      position: position,
      rotation: 0.0,
      icon: await Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: 60,
            width: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary, width: 1)),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 60,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                      color: AppColors.primary),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: MyText(
                          text: totalDistance,
                          textStyle: AppTextStyle.normalStyle().copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      MyText(
                        text: unitLabel,
                        textStyle: AppTextStyle.normalStyle().copyWith(
                            color: Colors.white,
                            fontSize: 8),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        color: Colors.white),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: MyText(
                          text: ((duration) > 60)
                              ? '${(duration / 60).toStringAsFixed(1)} hrs'
                              : '${duration.toStringAsFixed(0)} mins',
                          textStyle: AppTextStyle.normalStyle()
                              .copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )).toBitmapDescriptor(
        logicalSize: const Size(120, 70),
        imageSize: const Size(240, 140),
      ),
    ));
    if (!isClosed) {
      add(UpdateEvent());
    }
  }

  Future<void> changePaymentMethodListener(
      ChangePaymentMethodEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>().changePaymentMethod(
        requestId: event.requestData.id, paymentOption: event.paymentMethod);
    data.fold((error) {
      showToast(message: error.message.toString());
    }, (success) {
      FirebaseDatabase.instance
          .ref('requests/${event.requestData.id}')
          .update({'payment_method': event.paymentMethod});
    });
    emit(ChangePaymentState());
  }

  Future<void> locateMe(
      BookingLocateMeEvent event, Emitter<BookingState> emit) async {
    await Permission.location.request();
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted || status.isLimited) {
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        double lat = position.latitude;
        double long = position.longitude;
        final currentLatLng = LatLng(lat, long);
        AppConstants.currentLocations = LatLng(lat, long);
        if (event.mapType == 'google_map') {
          if (event.controller != null) {
            event.controller!
                .animateCamera(CameraUpdate.newLatLng(currentLatLng));
          }
        } else {
          if (event.controller != null) {
            event.controller!.move(fmlt.LatLng(lat, long), 15);
          }
        }
      }
    } else {
      showToast(
          message: 'allow location permission to get your current location');
    }
  }

  Future<void> editLocation(
      EditLocationEvent event, Emitter<BookingState> emit) async {
    List<AddressModel> addressList = [];

    if (event.requestData != null &&
        event.requestData!.requestStops != null &&
        event.requestData!.requestStops.data.isNotEmpty) {
      for (var i = 0; i < event.requestData!.requestStops.data.length; i++) {
        addressList.add(AddressModel(
            orderId: '${i + 1}',
            address: event.requestData!.requestStops.data[i].address,
            lat: event.requestData!.requestStops.data[i].latitude,
            lng: event.requestData!.requestStops.data[i].longitude,
            name: event.requestData!.requestStops.data[i].pocName,
            number: event.requestData!.requestStops.data[i].pocMobile,
            instructions:
            event.requestData!.requestStops.data[i].pocInstruction,
            pickup: false));
      }
    } else if (event.requestData != null &&
        event.requestData!.dropAddress.isNotEmpty) {
      addressList.add(AddressModel(
          orderId: '2',
          address: event.requestData!.dropAddress,
          lat: double.parse(event.requestData!.dropLat),
          lng: double.parse(event.requestData!.dropLng),
          name: event.requestData!.dropPocName,
          number: event.requestData!.dropPocMobile,
          instructions: event.requestData!.dropPocInstruction,
          pickup: false));
    }

    if (event.requestData != null) {
      emit(EditLocationState(
          requestData: event.requestData!, addressList: addressList));
    }
  }

  Future editLocationInit(
      EditLocationPageInitEvent event, Emitter<BookingState> emit) async {
    dropAddressList = event.arg.addressList;
    requestData = event.arg.requestData;
    mapType = event.arg.mapType;
    polyLine = event.arg.requestData.polyLine;
    distance = event.arg.requestData.unit == 'MILES'
        ? ((double.parse(event.arg.requestData.totalDistance) * 1.60934) * 1000)
        .toString()
        : (double.parse(event.arg.requestData.totalDistance) * 1000).toString();
    duration = event.arg.requestData.totalTime;
    for (var i = 0; i < dropAddressList.length; i++) {
      addressTextControllerList
          .add(TextEditingController(text: dropAddressList[i].address));
    }
    markerList.add(Marker(
      markerId: const MarkerId("pick"),
      position: LatLng(double.parse(event.arg.requestData.pickLat),
          double.parse(event.arg.requestData.pickLng)),
      rotation: 0.0,
      icon: await MarkerWidget(
        isPickup: true,
        text: event.arg.requestData.pickAddress,
      ).toBitmapDescriptor(
          logicalSize: const Size(30, 30), imageSize: const Size(200, 200)),
    ));
    mapBound(
        double.parse(event.arg.requestData.pickLat),
        double.parse(event.arg.requestData.pickLng),
        double.parse(event.arg.requestData.dropLat),
        double.parse(event.arg.requestData.dropLng),
        isRentalRide: true);
    if (event.arg.addressList.length > 1) {
      for (var i = 0; i < event.arg.addressList.length; i++) {
        markerList.add(Marker(
          markerId: MarkerId("drop$i"),
          position: LatLng(
              event.arg.addressList[i].lat, event.arg.addressList[i].lng),
          rotation: 0.0,
          icon: await MarkerWidget(
            isPickup: false,
            count: '${i + 1}',
            text: event.arg.addressList[i].address,
          ).toBitmapDescriptor(
              logicalSize: const Size(30, 30), imageSize: const Size(200, 200)),
        ));
      }
    } else {
      markerList.add(Marker(
        markerId: const MarkerId("drop"),
        position: LatLng(double.parse(event.arg.requestData.dropLat),
            double.parse(event.arg.requestData.dropLng)),
        rotation: 0.0,
        icon: await MarkerWidget(
          isPickup: false,
          text: event.arg.requestData.dropAddress,
        ).toBitmapDescriptor(
            logicalSize: const Size(30, 30), imageSize: const Size(200, 200)),
      ));
    }

    await addDistanceMarker(
        LatLng(double.parse(event.arg.requestData.dropLat),
            double.parse(event.arg.requestData.dropLng)),
        (double.tryParse(distance)!),
        time: double.parse(duration));
    await decodeEncodedPolyline(polyLine);
    emit(BookingUpdateState());
  }

  Future<void> reOrderAddress(
      ReorderEvent event, Emitter<BookingState> emit) async {
    if (event.oldIndex < event.newIndex) {
      event.newIndex -= 1;
    }
    final item = dropAddressList.removeAt(event.oldIndex);
    final itemController = addressTextControllerList.removeAt(event.oldIndex);
    dropAddressList.insert(event.newIndex, item);
    addressTextControllerList.insert(event.newIndex, itemController);
    add(UpdateEvent());
  }

  Future<void> addNewAddressStop(
      AddStopEvent event, Emitter<BookingState> emit) async {
    dropAddressList.add(AddressModel(
        orderId: '',
        address: '',
        lat: 0,
        lng: 0,
        name: '',
        number: '',
        pickup: false));
    addressTextControllerList.add(TextEditingController(text: ''));
    emit(BookingUpdateState());
  }

  Future<void> selectFromMap(
      SelectFromMapEvent event, Emitter<BookingState> emit) async {
    emit(SelectFromMapState());
  }

  FutureOr<void> addOrEditStopAddress(BookingAddOrEditStopAddressEvent event,
      Emitter<BookingState> emit) async {
    addressTextControllerList[event.choosenAddressIndex].text =
        event.newAddress.address;
    dropAddressList[event.choosenAddressIndex] = event.newAddress;
    if (requestData != null) {
      add(PolylineEvent(
        pickLat: double.parse(requestData!.pickLat),
        pickLng: double.parse(requestData!.pickLng),
        dropLat: dropAddressList.last.lat,
        dropLng: dropAddressList.last.lng,
        stops: (dropAddressList.length > 1) ? dropAddressList : [],
        pickAddress: requestData!.pickAddress,
        dropAddress: dropAddressList.last.address,
        isDropChanged: true,
      ));
    }
    emit(BookingUpdateState());
  }

  Future<void> loadSavedContacts() async {
    savedContacts = await ContactLocalStorage.getContacts();
  }

  void selectMyselfRadio(
      SelectMyselfRadioEvent event, Emitter<BookingState> emit) {
    isMyselfSelected = true;
    selectedSavedContactIndex = null;
    emit(RadioSelectionUpdatedState());
  }

  void selectSavedContactRadio(
      SelectSavedContactRadioEvent event, Emitter<BookingState> emit) {
    isMyselfSelected = false;
    selectedSavedContactIndex = event.index;
    emit(RadioSelectionUpdatedState());
  }

  Future<void> confirmBookingTypePage(
      ConfirmBookingTypePageEvent event, Emitter<BookingState> emit) async {
    isOthers = !event.isMyself;
    isMyself = event.isMyself;
    isMyselfSelected = event.isMyself;
    selectedContact.name = event.contactName;
    selectedContact.number = event.contactMobile;
    bookingDisplayName = isMyself ? "Myself" : event.contactName;

    receiverNameController.text = selectedContact.name;
    receiverMobileController.text = selectedContact.number;

    await AppSharedPreference.setIsMyself(isMyself);
    await AppSharedPreference.setContactName(selectedContact.name);
    await AppSharedPreference.setContactNumber(selectedContact.number);

    if (!isMyself &&
        event.contactName.isNotEmpty &&
        event.contactMobile.isNotEmpty) {
      await ContactLocalStorage.saveContact(
          ContactsModel(name: event.contactName, number: event.contactMobile));
      await loadSavedContacts();

      final index = savedContacts.indexWhere(
            (c) => c.number == event.contactMobile,
      );
      selectedSavedContactIndex = (index != -1) ? index : null;
    } else {
      selectedSavedContactIndex = null;
    }

    emit(ConfirmBookingTypeSuccessState(
      isMyselfSelected: isMyself,
      selectedContactName: selectedContact.name,
      selectedContactMobile: selectedContact.number,
    ));
    emit(BookingUpdateState());
  }

  Future<void> receiverContactDetails(
      ReceiverContactEvent event, Emitter<BookingState> emit) async {
    selectedContact.name = event.name;
    selectedContact.number = event.number;
    isMyself = event.isReceiveMyself;
    isOthers = !event.isReceiveMyself;

    await AppSharedPreference.setIsMyself(isMyself);
    await AppSharedPreference.setContactName(event.name);
    await AppSharedPreference.setContactNumber(event.number);

    emit(BookingUpdateState());
  }

  Future<void> selectContactDetails(
      SelectContactDetailsEvent event, Emitter<BookingState> emit) async {
    await Permission.contacts.request();
    PermissionStatus status = await Permission.contacts.status;
    if (status.isGranted) {
      emit(BookingLoadingStartState());
      if (contactsList.isEmpty) {
        final contactsPermissionStatus =
        await FlutterContacts.permissions.request(PermissionType.readWrite);
        if (contactsPermissionStatus == fc.PermissionStatus.granted) {
          List<Contact> contacts =
          await FlutterContacts.getAll(properties: ContactProperties.all);
          for (var contact in contacts) {
            for (var phone in contact.phones) {
              contactsList.add(ContactsModel(
                name: contact.displayName??'',
                number: phone.number,
              ));
            }
          }
        }
      }
      emit(BookingLoadingStopState());
      emit(SelectContactDetailsState());
    } else {
      debugPrint("Permission Denied");
      bool isOpened = await openAppSettings();
      if (isOpened) {
        debugPrint('App settings opened.');
      } else {
        debugPrint('Failed to open app settings.');
      }
      emit(BookingUpdateState());
    }
  }

  Future<void> selectBookingType(
      SelectBookingTypeEvent event, Emitter<BookingState> emit) async {
    emit(SelectBookingTypeState());
  }

  Future<void> changeDestination(
      ChangeDestinationEvent event, Emitter<BookingState> emit) async {
    final data = await serviceLocator<BookingUsecase>().changeDestinationApi(
        requestId: event.requestId,
        dropLat: event.dropAddressList.last.lat.toString(),
        dropLng: event.dropAddressList.last.lng.toString(),
        dropAddress: event.dropAddressList.last.address,
        duration: event.duration,
        distance: event.distance,
        polyLine: event.polyLine,
        stops: event.dropAddressList);
    data.fold((error) {
      showToast(message: error.message.toString());
    }, (success) {
      requestData = OnTripRequestData.fromJson(success.data.toJson());
      FirebaseDatabase.instance.ref('requests/${event.requestId}').update({
        'polyline': event.polyLine,
        'distance': event.distance,
        'duration': event.duration,
        'destination_change': ServerValue.timestamp
      });
      emit(DestinationChangeSuccessState(
          requestData: requestData!, dropAddressList: event.dropAddressList));
    });
  }

  Future<void> addMarkers(
      AddMarkersEvent event, Emitter<BookingState> emit) async {
    if (event.addressList == null) {
      markerList.removeWhere(
              (element) => !element.markerId.value.toString().contains('#'));
      if (event.requestData.requestStops != null &&
          event.requestData.requestStops.data.length > 1) {
        for (var i = 0; i < event.requestData.requestStops.data.length; i++) {
          markerList.add(Marker(
            markerId: MarkerId("drop$i"),
            position: LatLng(event.requestData.requestStops.data[i].latitude,
                event.requestData.requestStops.data[i].longitude),
            rotation: 0.0,
            icon: await MarkerWidget(
              isPickup: false,
              count: '${i + 1}',
              text: event.requestData.requestStops.data[i].address,
            ).toBitmapDescriptor(
                logicalSize: const Size(30, 30),
                imageSize: const Size(200, 200)),
          ));
        }
      } else {
        markerList.add(Marker(
          markerId: const MarkerId("drop"),
          position: LatLng(double.parse(event.requestData.dropLat),
              double.parse(event.requestData.dropLng)),
          rotation: 0.0,
          icon: await MarkerWidget(
            isPickup: false,
            text: event.requestData.dropAddress,
          ).toBitmapDescriptor(
              logicalSize: const Size(30, 30), imageSize: const Size(200, 200)),
        ));
      }
      await addDistanceMarker(
          LatLng(double.parse(event.requestData.dropLat),
              double.parse(event.requestData.dropLng)),
          event.requestData.unit == 'MILES'
              ? ((double.parse(event.requestData.totalDistance) * 1.60934) *
              1000)
              : (double.parse(event.requestData.totalDistance) * 1000),
          time: double.parse(event.requestData.totalTime));
    } else {
      markerList.removeWhere(
              (element) => !element.markerId.value.toString().contains('#'));
      if (event.addressList!.length > 1) {
        for (var i = 0; i < event.addressList!.length; i++) {
          markerList.add(Marker(
            markerId: MarkerId("drop$i"),
            position:
            LatLng(event.addressList![i].lat, event.addressList![i].lng),
            rotation: 0.0,
            icon: await MarkerWidget(
              isPickup: false,
              count: '${i + 1}',
              text: event.addressList![i].address,
            ).toBitmapDescriptor(
                logicalSize: const Size(30, 30),
                imageSize: const Size(200, 200)),
          ));
        }
      } else {
        markerList.add(Marker(
          markerId: const MarkerId("drop"),
          position:
          LatLng(event.addressList!.last.lat, event.addressList!.last.lng),
          rotation: 0.0,
          icon: await MarkerWidget(
            isPickup: false,
            text: event.addressList!.last.address,
          ).toBitmapDescriptor(
              logicalSize: const Size(30, 30), imageSize: const Size(200, 200)),
        ));
      }
      await addDistanceMarker(
          LatLng(event.addressList!.last.lat, event.addressList!.last.lng),
          (double.tryParse(distance)!),
          time: double.parse(duration));
    }
    emit(BookingUpdateState());
  }

  Future<void> updateMarkers(
      UpdateMarkersEvent event, Emitter<BookingState> emit) async {
    markerList = event.markers;
    // Deliberately not emitting a BookingState here: this fires on every
    // animation frame while a driver marker is moving (see animateCar),
    // and routing it through BlocBuilder rebuilds the entire booking
    // screen (map, bottom sheet, overlays) dozens of times a second.
    // markerNotifier lets just the map widget refresh instead.
    markerNotifier.value++;
  }

  FutureOr onRidePaymentWebViewUrl(
      OnRidePaymentWebViewUrlEvent event, Emitter<BookingState> emit) async {
    String paymentUrl = '';
    printWrapped('text 111 ---- ');
    if (event.from == '1') {
      printWrapped('text 222111 ---- ');
      paymentUrl =
      '${event.url}?amount=${event.money}&payment_for=request&currency=${event.currencySymbol}&user_id=${event.userId.toString()}&request_id=${event.requestId.toString()}';
    }
    final Uri uri = Uri.parse(paymentUrl);
    if (await canLaunchUrl(uri)) {
      printWrapped('text 3331111 ---- ');
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } else {
      printWrapped('text 444111 ---- ');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
        const SnackBar(content: Text("Could not open payment page")),
      );
    }
  }

  Future<void> updateMapType(
      UpdateMapTypeEvent event, Emitter<BookingState> emit) async {
    _selectedMapType = event.mapType;
    emit(BookingUpdateState());
  }

  Future<void> selectPreferenceEvent(
      SelectedPreferenceEvent event,
      Emitter<BookingState> emit,
      ) async {
    if (event.isSelected) {
      if (!tempSelectPreference.contains(event.prefId)) {
        tempSelectPreference.add(event.prefId);
        tempSelectPreferenceIcons.add(event.prefIcon);
      }
    } else {
      final index = tempSelectPreference.indexOf(event.prefId);
      if (index != -1) {
        tempSelectPreference.removeAt(index);
        tempSelectPreferenceIcons.removeAt(index);
      }
    }
    emit(BookingUpdateState());
  }

  Future<void> confirmPreferenceSelection(
      ConfirmPreferenceSelectionEvent event,
      Emitter<BookingState> emit,
      ) async {
    selectPreference = List<int>.from(tempSelectPreference);
    selectedPreferenceDetailsList = List<int>.from(tempSelectPreference);
    selectedPreferenceIconsList = List<String>.from(tempSelectPreferenceIcons);

    // Also persist preferences per vehicle (non-rental) so each vehicle card
    // can display its own selection. We key by a stable field: typeId.
    if (!isRentalRide && tempSelectPreference.isNotEmpty) {
      final baseList =
      isMultiTypeVechiles ? sortedEtaDetailsList : etaDetailsList;
      if (baseList.isNotEmpty &&
          selectedVehicleIndex >= 0 &&
          selectedVehicleIndex < baseList.length) {
        try {
          final currentTypeId =
              (baseList[selectedVehicleIndex] as dynamic).typeId;
          vehiclePreferenceByTypeId[currentTypeId] =
          List<int>.from(tempSelectPreference);
        } catch (_) {
          // If for some reason typeId is not available, skip per-vehicle storage
        }
      }
    }
    emit(BookingUpdateState());
  }

  FutureOr<void> getPromoCodeList(
      GetPromoCodeListEvent event, Emitter<BookingState> emit) async {
    emit(PromoCodeListLoadingState());
    final data = await serviceLocator<AccUsecase>().getPromoCodeList();
    data.fold(
          (error) {
        emit(PromoCodeListFailureState());
      },
          (success) {
        promoCodeDataList = success.data;
        for (var element in promoCodeDataList) {
          if (element.isApplied) {
            applyCouponController.text = element.code;
            break;
          }
        }
        emit(PromoCodeListSuccessState());
      },
    );
  }
}