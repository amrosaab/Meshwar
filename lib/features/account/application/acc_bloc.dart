// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart' hide PermissionStatus;
import 'package:flutter_contacts/flutter_contacts.dart' as fc show PermissionStatus;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/tobitmap.dart';
import '../../../core/utils/custom_snack_bar.dart';
import '../../../features/account/domain/models/referal_response_model.dart'
as referralModel;
import '../../../features/account/domain/models/referalhistory_model.dart'
as historyModel;

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/common.dart';
import '../../../core/utils/custom_loader.dart';
import '../../../core/utils/custom_text.dart';
import '../../../core/utils/functions.dart';
import '../../../di/locator.dart';
import '../../../l10n/app_localizations.dart';
import '../../bookingpage/application/usecases/booking_usecase.dart';
import '../../bookingpage/domain/models/point_latlng.dart';
import '../../bookingpage/domain/models/promo_code_list_model.dart';
import '../../home/domain/models/contact_model.dart';
import '../../home/application/usecase/home_usecases.dart';
import '../../home/domain/models/stop_address_model.dart';
import '../../home/domain/models/user_details_model.dart';
import '../../userprofile/domain/models/service_location_model.dart';
import '../domain/models/admin_chat_history_model.dart';
import '../domain/models/admin_chat_model.dart';
import '../domain/models/card_list_model.dart';
import '../domain/models/faq_model.dart';
import '../domain/models/history_model.dart';
import '../domain/models/makecomplaint_model.dart';
import '../domain/models/notifications_model.dart';
import '../domain/models/payment_method_model.dart';
import '../domain/models/ticket_list_model.dart';
import '../domain/models/ticket_names_model.dart';
import '../domain/models/view_ticket_model.dart';
import '../domain/models/walletpage_model.dart';
import 'usecase/acc_usecases.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart' as fmlt;
import 'package:file_picker/file_picker.dart';
part 'acc_event.dart';

part 'acc_state.dart';

class AccBloc extends Bloc<AccEvent, AccState> {
  final formKey = GlobalKey<FormState>();
  final paymentKey = GlobalKey();

  String textDirection = 'ltr';
  String languageCode = '';
  String profilePicture = '';
  String name = '';
  String mobile = '';
  String email = '';
  String gender = '';
  String profileImage = '';
  String country = '';
  String dialCode = '';
  String darkMapString = '';
  String lightMapString = '';
  String selectedGender = '';
  String chatId = '';
  String dropdownValue = 'user';
  String currentLocation = '';
  String webViewUrl = '';
  String mapType = '';
  String appVersion = '';
  String unSeenChatCount = '0';
  String? paymentUrl;
  String? selectedTicketTitle;
  String? selectedTicketTitleId;
  String? selectedTicketArea;
  String? selectedTicketAreaId;
  String? htmlString;

  Set<Polyline> polyline = {};
  LatLngBounds? bound;
  List<NotificationData> notificationDatas = [];
  List<HistoryData> historyList = [];
  List outstation = [];
  List outStationDriver = [];
  List<ComplaintList> complaintList = [];
  List<Marker> markers = [];
  List<LatLng> polylist = [];
  List<fmlt.LatLng> fmpoly = [];
  List<ReplyMessage> replyMessages = [];
  List<FavoriteLocationData> home = [];
  List<FavoriteLocationData> work = [];
  List<FavoriteLocationData> others = [];
  List<FavoriteLocationData> favAddressList = [];
  List<FaqData> faqDataList = [];
  List<WalletHistoryData> walletHistoryList = [];
  List<PaymentGateway> walletPaymentGatways = [];
  List<SavedCardDetails> savedCardsList = [];
  List<ServiceLocationData> serviceLocations = [];
  List<File> ticketAttachments = [];
  List<Attachment> viewAttachments = [];
  List<TicketNamesList> ticketNamesList = []; //support ticket
  List<TicketData> ticketList = [];
  List<SOSDatum> sosdata = [];
  List<ContactsModel> contactsList = [];
  List<ChatData> adminChatList = [];
  List<Conversation> adminChatHistory = [];
  List<AddressModel> selectedAddress = [];
  List<historyModel.Referral> referralHistory = [];
  referralModel.ReferralResponseData? referralResponse;
  List<String> genderOptions = [
    'Male',
    'Female',
    'Prefer not to say',
  ];
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: "user",
          child: MyText(
              text: AppLocalizations.of(navigatorKey.currentContext!)!.user)),
      DropdownMenuItem(
          value: "driver",
          child: MyText(
              text: AppLocalizations.of(navigatorKey.currentContext!)!.driver)),
    ];
    return menuItems;
  }

  // UserDetails
  TextEditingController updateController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  TextEditingController supportMessageReplyController = TextEditingController();
  TextEditingController supportDescriptionController = TextEditingController();
  TextEditingController newAddressController =
  TextEditingController(); //fav address
  TextEditingController walletAmountController = TextEditingController();
  TextEditingController transferPhonenumber = TextEditingController();
  TextEditingController transferAmount = TextEditingController();
  TextEditingController addSosNameController = TextEditingController();
  TextEditingController addSosMobileController = TextEditingController();
  TextEditingController adminchatText = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool isContainerClicked = false;
  bool loadMore = false;
  bool isArrow = true;
  bool paymentProcessComplete = false;
  bool paymentSuccess = false;
  bool addCardSuccess = false;
  bool sosInitLoading = false;
  bool isFavLoading = false;
  bool isSosLoading = false;
  bool firstLoad = true;
  bool isDarkTheme = false;
  bool isTicketSheetOpened = false;
  bool showRefresh = false;
  bool showReferralHistory = false;
  bool isReferralHistoryLoading = false;
  bool isReferralContentLoading = false;
  bool hasLoadedReferralHistory = false;
  bool isPromoChanging = false;
  bool isPromoListLoading = false;
  bool isGettingUserDetails = false;

  UserDetail? userData;
  HistoryData? historyData;
  DriverData? driverData;
  AddressModel? favNewAddress;
  SupportTicket? supportTicketData;
  WalletResponseModel? walletResponse;
  WalletPagination? walletPaginations;
  HistoryPagination? historyPaginations;
  NotificationPagination? notificationPaginations;

  bool isFaqLoading = false;
  bool isHtmlLoading = false;
  bool hasHtmlLoadFailed = false;
  int choosenFaqIndex = 0;
  int choosenMapIndex = 0;
  int selectedHistoryType = 0;
  int? choosenPaymentIndex = 0;
  int? selectedAmount;

  dynamic addMoney;
  dynamic isNewChat = 1;
  ContactsModel selectedContact = ContactsModel(name: '', number: '');
  ScrollController scrollController = ScrollController();
  GoogleMapController? googleMapController;
  final fm.MapController fmController = fm.MapController();

  WebViewController? webController;
  InAppWebViewController? inAppWebViewController;
  StreamSubscription<DatabaseEvent>? chatStream;
  StreamSubscription<DatabaseEvent>? outStationBidStream;

  PaymentAuthData? paymentAuthData;
  CardFormEditController? cardFormEditController;
  CardFieldInputDetails? cardDetails;

  List<PromoCodeListData> promoCodeDataList = [];
  int selectedPromoIndex = 0;
  String selectedPromoCodeValue = '';
  String selectedPromoPrice = '';

  int choosenLayoutIndex = 0;
  String homeLayoutType = '';

  static List<HistoryData> _cachedCompletedHistory = [];
  static List<HistoryData> _cachedUpcomingHistory = [];
  static List<HistoryData> _cachedCancelledHistory = [];
  static List<HistoryData> _cachedOutstationHistory = [];
  bool _isOutstationHistory = false;
  static DateTime? _historyRateLimitedUntil;
  static final Map<String, DateTime> _historyRequestTimes = {};
  static final Map<String, HistoryPagination> _historyPaginationCache = {};
  final Set<String> _historyRequestsInFlight = {};
  static const Duration _historyMinRequestGap = Duration(seconds: 4);
  static const Duration _historyRetryDelay = Duration(seconds: 15);

  AccBloc() : super(AccInitialState()) {
    on<AccUpdateEvent>((event, emit) => emit(UpdateState()));
    on<AccGetDirectionEvent>(getDirection);
    on<GetAppVersionEvent>(getAppVersion);
    on<ContainerClickedEvent>(_isClickChange);
    on<AccDataLoaderShowEvent>(showLoader);

    on<UpdateControllerWithDetailsEvent>(_updateControllerWithDetails);
    on<UserDetailsPageInitEvent>(_updateUserDetails);
    on<ReferalHistoryEvent>(_referalHistory);
    on<ReferralResponseEvent>(_referralResponse);
    on<ReferralTabChangeEvent>(_onReferralTabChange);

    //Notification
    on<NotificationGetEvent>(_getNotificationList);
    on<ClearAllNotificationsEvent>(_clearAllNotifications);
    on<DeleteNotificationEvent>(_deleteNotification);
    on<NotificationPageInitEvent>(notificationInitEvent);

    on<GetFaqListEvent>(_getFaqList);
    on<FaqOnTapEvent>(_selectedFaqIndex);
    on<ChooseMapOnTapEvent>(_selectedMapIndex);

    // History
    on<HistoryPageInitEvent>(historyInitEvent);
    on<HistoryGetEvent>(_getHistoryList);
    on<HistoryTypeChangeEvent>(_historyTypeChange);
    on<AddHistoryMarkerEvent>(addHistoryMarker);
    on<TripSummaryHistoryDataEvent>(tripSummaryHistoryDataGet);

    //Outstation
    on<OutstationGetEvent>(_getOutstationList);
    on<OutstationAcceptOrDeclineEvent>(outstationAcceptOrDecline);

    //Logout event
    on<LogoutEvent>(_logout);

    //Delete Account
    on<DeleteAccountEvent>(_deleteAccount);

    //Complaint page
    on<ComplaintEvent>(_getComplaints);
    on<ComplaintButtonEvent>(_complaintButton);
    on<SosLoadingEvent>(changeBoolSos);

    // Wallet PAge
    on<WalletPageInitEvent>(walletInitEvent);
    on<GetWalletHistoryListEvent>(_getWalletHistoryList);
    on<TransferMoneySelectedEvent>(_onTransferMoneySelected);
    on<MoneyTransferedEvent>(moneyTransfered);
    on<PaymentAuthenticationEvent>(paymentAuth);
    on<CardListEvent>(getCardList);
    on<DeleteCardEvent>(deleteCard);
    on<ShowPaymentGatewayEvent>(showPaymentGateways);
    on<AddCardDetailsEvent>(addCardDetails);
    on<AddMoneyFromCardEvent>(addMoneyFromCard);

    //gender list
    on<GenderSelectedEvent>(_onGenderSelected);
    on<DeleteContactEvent>(_deletesos);
    on<AccGetUserDetailsEvent>(getUserDetails);
    on<SelectContactDetailsEvent>(selectContactDetails);
    on<AddContactEvent>(addContactDetails);
    on<DeleteFavAddressEvent>(_deleteFavAddress);
    on<GetFavListEvent>(getFavList);
    on<SelectFromFavAddressEvent>(selectFavAddress);
    on<AddFavAddressEvent>(addFavourites);

    // update details
    on<UpdateUserDetailsEvent>(_updateTextField);
    on<UserDetailEditEvent>(userDetailEdit);
    on<UserDetailEvent>(userDetails);
    on<SendAdminMessageEvent>(sendAdminChat);
    on<GetAdminChatHistoryListEvent>(_getAdminChatHistoryList);
    on<AdminMessageSeenEvent>(_adminMessageSeenDetail);

    //update profile
    on<UpdateImageEvent>(_getProfileImage);
    on<PaymentOnTapEvent>(_selectedPaymentIndex);
    on<RideLaterCancelRequestEvent>(cancelRequest);
    on<FavNewAddressInitEvent>(newFavAddress);
    on<UserDataInitEvent>(userDataInit);
    on<AddMoneyWebViewUrlEvent>(addMoneyWebViewUrl);

    on<SosInitEvent>(sosPageInit);
    on<AdminChatInitEvent>(adminChatInit);
    on<WalletPageReUpdateEvent>(walletPageReUpdate);
    on<OnlinePaymentDoneUserEvent>(onlinePaymentDoneUser);
    //Support Ticket
    on<CreateSupportTicketEvent>(createSupportTicket);
    on<MakeTicketSubmitEvent>(makeTicketSubmit);
    on<GetTicketListEvent>(getTicketList);
    on<ViewTicketEvent>(viewTicketData);
    on<AddAttachmentTicketEvent>(addAttachment);
    on<ClearAttachmentEvent>(clearAttachment);
    on<TicketReplyMessageEvent>(ticketMessageReply);
    on<TicketTitleChangeEvent>(assignSelectedTicketValue);
    on<TicketAreaChangeEvent>(assignSelectedTicketArea);
    on<GetServiceLocationEvent>(getServiceLocation);
    on<DownloadInvoiceEvent>(downloadInvoice);
    on<GetHtmlStringEvent>(getHtmlString);

    on<DownloadInvoiceUserEvent>(downloadInvoiceUser);
    on<GetPromoCodeListEvent>(getPromoCodeList);
    on<SelectPromoCodeListIndexEvent>(selectedPromoCodeListIndex);
    on<SelectPromoCodeListApplyEvent>(selectedPromoCodeListApply);
    on<PromoCodeClearEvent>(promoCodeClear);

    on<ChooseLayoutOnTapEvent>(_selectedLayoutIndex);
  }

  //Get Direction
  Future<void> getDirection(AccEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    languageCode = await AppSharedPreference.getSelectedLanguageCode();
    textDirection = await AppSharedPreference.getLanguageDirection();
    mapType = await AppSharedPreference.getMapType();
    isDarkTheme = await AppSharedPreference.getDarkThemeStatus();
    homeLayoutType = await AppSharedPreference.getHomeLayoutType();
    lightMapString = await rootBundle.loadString('assets/light-theme.json');
    darkMapString = await rootBundle.loadString('assets/dark-theme.json');
    if (mapType == 'google_map') {
      choosenMapIndex = 0;
    } else {
      choosenMapIndex = 1;
    }
    if (homeLayoutType == 'classic_layout') {
      choosenLayoutIndex = 0;
    } else {
      choosenLayoutIndex = 1;
    }
    emit(AccDataLoadingStopState());
  }

  Future<void> showLoader(
      AccDataLoaderShowEvent event, Emitter<AccState> emit) async {
    if (event.showLoader) {
      isLoading = event.showLoader;
      emit(AccDataLoadingStartState());
    } else {
      if (isLoading) {
        emit(AccDataLoadingStopState());
      }
      isLoading = event.showLoader;
    }
  }

  void _onReferralTabChange(
      ReferralTabChangeEvent event, Emitter<AccState> emit) {
    showReferralHistory = event.showReferralHistory;
    emit(UpdateState());
  }

  Future<void> getAppVersion(AccEvent event, Emitter<AccState> emit) async {
    PackageInfo buildKeys = await PackageInfo.fromPlatform();
    appVersion = '${buildKeys.version}+${buildKeys.buildNumber}';
    emit(UpdateState());
  }

  FutureOr<void> walletPageReUpdate(
      WalletPageReUpdateEvent event, Emitter<AccState> emit) async {
    emit(WalletPageReUpdateState(
        currencySymbol: event.currencySymbol,
        money: event.money,
        requestId: event.requestId,
        url: event.url,
        userId: event.userId));
  }

  void _isClickChange(ContainerClickedEvent event, Emitter<AccState> emit) {
    isContainerClicked = !isContainerClicked;
    emit(ContainerClickState(isContainerClicked: isContainerClicked));
  }

//sos change type
  Future<void> changeBoolSos(AccEvent event, Emitter<AccState> emit) async {
    emit(SosLoadingState());

    await Future.delayed(const Duration(seconds: 2));

    emit(SosLoadedState());
  }

  Future<void> onlinePaymentDoneUser(
      OnlinePaymentDoneUserEvent event, Emitter<AccState> emit) async {
    FirebaseDatabase.instance.ref('requests').child(event.requestId).update({
      'is_user_paid': true,
      'modified_by_driver': ServerValue.timestamp,
    });
  }

  //Update userDetails controller
  Future<void> _updateControllerWithDetails(
      UpdateControllerWithDetailsEvent event, Emitter<AccState> emit) async {
    userData = event.args.userData;
    updateController.text = event.args.text;
    emit(UpdateState());
  }

  //Update User Details
  Future<void> _updateUserDetails(
      UserDetailsPageInitEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    sosdata = event.arg.userData.sos.data;
    favAddressList = event.arg.userData.favouriteLocations.data;
    if (userData != null) {
      name = userData!.name;
      mobile = userData!.mobile;
      email = userData!.email;
      gender = userData!.gender;
      profilePicture = userData!.profilePicture;
    }
    emit(UserDetailsSuccessState(userData: userData));
  }

  Future<void> notificationInitEvent(
      NotificationPageInitEvent event, Emitter<AccState> emit) async {
    add(NotificationGetEvent());
    scrollController.addListener(notificationPageScrollListener);
    emit(UpdateState());
  }

  notificationPageScrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent &&
        !isLoading &&
        !loadMore) {
      if (notificationPaginations != null &&
          notificationPaginations!.pagination != null &&
          notificationPaginations!.pagination.currentPage <
              notificationPaginations!.pagination.totalPages) {
        loadMore = true;
        add(AccUpdateEvent());
        add(NotificationGetEvent());
        add(AccUpdateEvent());
      } else {
        if (notificationPaginations!.pagination.currentPage ==
            notificationPaginations!.pagination.totalPages) {
          loadMore = false;
          add(AccUpdateEvent());
        }
      }
    }
  }

  // Get Notifications
  Future<void> _getNotificationList(
      NotificationGetEvent event, Emitter<AccState> emit) async {
    if (isLoading) return;
    final page = event.pageNumber ?? 1;
    isLoading = true;
    emit(AccDataLoadingStartState());
    try {
      final data = await serviceLocator<AccUsecase>()
          .notificationDetails(pageNo: page.toString());
      if (isClosed) return;
      isLoading = false;
      loadMore = false;
      data.fold((error) {
        emit(NotificationFailure(errorMessage: error.message ?? ''));
      }, (success) {
        if (page == 1) notificationDatas.clear();
        for (final notification in success.data) {
          final index = notificationDatas.indexWhere((item) => item.id == notification.id);
          if (index < 0) {
            notificationDatas.add(notification);
          } else {
            notificationDatas[index] = notification;
          }
        }
        notificationPaginations = success.meta;
        emit(NotificationSuccess(notificationDatas: notificationDatas));
      });
    } catch (e) {
      if (isClosed) return;
      isLoading = false;
      loadMore = false;
      emit(NotificationFailure(errorMessage: e.toString()));
    }
  }

//ook
  Future<void> historyInitEvent(
      HistoryPageInitEvent event, Emitter<AccState> emit) async {
    _isOutstationHistory = false;
    selectedHistoryType = 0;
    _restoreHistoryFromCache(emit,
        loading: !_historyPaginationCache.containsKey('is_completed=1'));
    add(HistoryGetEvent(historyFilter: 'is_completed=1'));
    scrollController.removeListener(historyPageScrollListener);
    scrollController.addListener(historyPageScrollListener);
  }

  void historyPageScrollListener() {
    if (!scrollController.hasClients || isLoading || loadMore) return;
    final position = scrollController.position;
    if (position.pixels < position.maxScrollExtent) return;
    final pagination = historyPaginations?.pagination;
    if (pagination == null || pagination.currentPage >= pagination.totalPages) {
      return;
    }
    loadMore = true;
    add(AccUpdateEvent());
    add(HistoryGetEvent(
        pageNumber: pagination.currentPage + 1,
        historyFilter: _selectedHistoryFilter));
  }

  bool _isTooManyAttempts(dynamic error) {
    final message = (error.message ?? '').toLowerCase();
    return error.statusCode == 429 ||
        message.contains('too many attempts') ||
        message.contains('too many requests') ||
        message.contains('429');
  }

  // History
  String get _selectedHistoryFilter => _isOutstationHistory
      ? 'out_station=1' : selectedHistoryType == 0
      ? 'is_completed=1'
      : selectedHistoryType == 1 ? 'is_later=1' : 'is_cancelled=1';

  List<HistoryData> _historyCacheFor(String filter) =>
      filter == 'out_station=1' ? _cachedOutstationHistory
      : filter.contains('is_completed=1') ? _cachedCompletedHistory
      : filter.contains('is_later=1') ? _cachedUpcomingHistory
      : _cachedCancelledHistory;

  Future<void> _getHistoryList(
      HistoryGetEvent event, Emitter<AccState> emit) async {
    final filter = event.historyFilter;
    if (filter == 'out_station=1') {
      _isOutstationHistory = true;
    }
    final requestKey = '$filter:${event.pageNumber ?? 1}';
    if (_historyRequestsInFlight.contains(requestKey)) return;
    final now = DateTime.now();
    if (_historyRateLimitedUntil != null &&
        now.isBefore(_historyRateLimitedUntil!)) {
      _restoreHistoryFromCache(emit);
      emit(HistoryDataSuccessState());
      return;
    }
    final lastRequest = _historyRequestTimes[filter];
    if (lastRequest != null &&
        now.difference(lastRequest) < _historyMinRequestGap &&
        event.pageNumber == null && _historyPaginationCache.containsKey(filter)) {
      _restoreHistoryFromCache(emit);
      emit(HistoryDataSuccessState());
      return;
    }

    _historyRequestTimes[filter] = now;
    _historyRequestsInFlight.add(requestKey);
    if (filter == _selectedHistoryFilter) {
      isLoading = true;
      loadMore = event.pageNumber != null && event.pageNumber! > 1;
      firstLoad = !_historyPaginationCache.containsKey(filter);
      emit(UpdateState());
    }
    try {
      final data = await serviceLocator<AccUsecase>().historyDetails(
          filter, pageNo: event.pageNumber.toString());
      data.fold((error) {
        debugPrint('History Error: ${error.toString()}');
        if (_isTooManyAttempts(error)) {
          _historyRateLimitedUntil = DateTime.now().add(_historyRetryDelay);
        }
        if (filter != _selectedHistoryFilter) return;
        _restoreHistoryFromCache(emit);
        emit(HistoryFailure(errorMessage: error.message ?? ''));
        emit(HistoryDataSuccessState());
      }, (success) {
        _historyRateLimitedUntil = null;
        final cached = event.pageNumber == null || event.pageNumber == 1
            ? success.data
            : [..._historyCacheFor(filter), ...success.data].toSet().toList();
        _updateHistoryCache(filter, cached);
        _historyPaginationCache[filter] = success.meta;
        // A slower request from another tab may update its cache, but must
        // never replace the rides currently being viewed.
        if (filter != _selectedHistoryFilter) return;
        historyList = [...cached];
        historyPaginations = success.meta;
        isLoading = false;
        loadMore = false;
        firstLoad = false;
        if (event.historyIndex != null &&
            event.historyIndex! >= 0 && event.historyIndex! < historyList.length) {
          historyData = historyList[event.historyIndex!];
        }
        emit(HistorySuccess(history: historyList));
        emit(HistoryDataSuccessState());
      });
    } finally {
      _historyRequestsInFlight.remove(requestKey);
    }
  }

  void _updateHistoryCache(String filter, List<HistoryData> list) {
    if (filter == 'out_station=1') {
      _cachedOutstationHistory = List<HistoryData>.from(list);
    } else if (filter.contains('is_completed=1')) {
      _cachedCompletedHistory = List<HistoryData>.from(list);
    } else if (filter.contains('is_later=1')) {
      _cachedUpcomingHistory = List<HistoryData>.from(list);
    } else if (filter.contains('is_cancelled=1')) {
      _cachedCancelledHistory = List<HistoryData>.from(list);
    }
  }

  void _restoreHistoryFromCache(Emitter<AccState> emit, {bool loading = false}) {
    historyList = [..._historyCacheFor(_selectedHistoryFilter)];
    historyPaginations = _historyPaginationCache[_selectedHistoryFilter];
    isLoading = loading;
    firstLoad = loading;
    loadMore = false;
    emit(HistorySuccess(history: historyList));
  }

  // Outstation
  Future<void> _getOutstationList(
      OutstationGetEvent event, Emitter<AccState> emit) async {
    if (outStationBidStream != null) {
      outStationBidStream?.cancel();
    }
    outStationBidStream = FirebaseDatabase.instance
        .ref()
        .child('bid-meta/${event.id}')
        .onValue
        .handleError((onError) {
      outStationBidStream?.cancel();
    }).listen(
          (DatabaseEvent event) {
        debugPrint("Outstation Bidding Stream");
        Map rideList = {};
        DataSnapshot snapshots = event.snapshot;
        if (snapshots.value != null) {
          rideList = jsonDecode(jsonEncode(snapshots.value));
          if (rideList['request_id'] != null) {
            if (rideList['drivers'] != null) {
              outstation.clear();
              outStationDriver.clear();
              Map driver = rideList['drivers'];
              driver.forEach((key, value) {
                if (driver[key]['is_rejected'] != 'by_driver' &&
                    driver[key]['is_rejected'] != 'by_user') {
                  outstation.add(value);
                  final dist = calculateDistance(
                    lat1: rideList['pick_lat'],
                    lon1: rideList['pick_lng'],
                    lat2: rideList['drivers'][key]['lat'],
                    lon2: rideList['drivers'][key]['lng'],
                    unit: userData?.distanceUnit ?? 'km',
                  );
                  outStationDriver.add(
                    dist.toStringAsFixed(2),
                  );
                } else {
                  outstation.removeWhere(
                          (element) => element["id"] == driver[key]["id"]);
                }
              });
              add(AccUpdateEvent());
            }
          }
        }
      },
    );
  }

  Future<void> outstationAcceptOrDecline(
      OutstationAcceptOrDeclineEvent event, Emitter<AccState> emit) async {
    if (event.isAccept) {
      final data = await serviceLocator<BookingUsecase>().biddingAccept(
          requestId: event.id,
          driverId: event.driver['driver_id'].toString(),
          acceptRideFare: event.driver['price'].toString(),
          offeredRideFare: event.offeredRideFare);
      await data.fold(
            (error) {
          isLoading = false;
          if (error.message == 'logout') {
            emit(UpdateState());
          } else {
            showToast(message: '${error.message}');
            emit(UpdateState());
          }
        },
            (success) async {
          emit(OutstationAcceptState());
          await FirebaseDatabase.instance
              .ref()
              .child('bid-meta/${event.id}')
              .remove();
        },
      );
    } else {
      await FirebaseDatabase.instance
          .ref()
          .child(
          'bid-meta/${event.id}/drivers/driver_${event.driver["driver_id"]}')
          .update({"is_rejected": 'by_user'});
      outstation.removeWhere(
              (element) => element["driver_id"] == event.driver["driver_id"]);
      emit(UpdateState());
    }
  }

  // Change History Type
  Future<void> _historyTypeChange(
      HistoryTypeChangeEvent event, Emitter<AccState> emit) async {
    _isOutstationHistory = false;
    selectedHistoryType = event.historyTypeIndex;
    String filter;
    switch (selectedHistoryType) {
      case 0:
        filter = 'is_completed=1';
        break;
      case 1:
        filter = 'is_later=1';
        break;
      case 2:
        filter = 'is_cancelled=1';
        break;
      default:
        filter = '';
    }
    _restoreHistoryFromCache(emit,
        loading: !_historyPaginationCache.containsKey(filter));
    add(HistoryGetEvent(historyFilter: filter));
  }

  FutureOr<void> addHistoryMarker(
      AddHistoryMarkerEvent event, Emitter<AccState> emit) async {
    mapType = await AppSharedPreference.getMapType();
    if (mapType == 'google_map') {
      markers.clear();
      markers.add(Marker(
        markerId: const MarkerId("pick"),
        position:
        LatLng(double.parse(event.pickLat), double.parse(event.pickLng)),
        icon: await Image.asset(
          AppImages.pickPin,
          height: 30,
          fit: BoxFit.contain,
        ).toBitmapDescriptor(
            logicalSize: const Size(20, 20), imageSize: const Size(200, 200)),
      ));
      if (event.stops!.isEmpty && event.dropLat != '') {
        markers.add(Marker(
          markerId: const MarkerId("drop"),
          position: LatLng(
              double.parse(event.dropLat!), double.parse(event.dropLng!)),
          icon: await Image.asset(
            AppImages.dropPin,
            height: 30,
            fit: BoxFit.contain,
          ).toBitmapDescriptor(
              logicalSize: const Size(20, 20), imageSize: const Size(200, 200)),
        ));
      } else if (event.stops != null) {
        for (var i = 0; i < event.stops!.length; i++) {
          markers.add(Marker(
            markerId: MarkerId("drop$i"),
            position: LatLng(
                event.stops![i]['latitude'], event.stops![i]['longitude']),
            icon: await Image.asset(
              AppImages.dropPin,
              height: 30,
              fit: BoxFit.contain,
            ).toBitmapDescriptor(
                logicalSize: const Size(20, 20),
                imageSize: const Size(200, 200)),
          ));
        }
      }
    }
    if (mapType == 'google_map') {
      if (event.dropLat != null) {
        mapBound(
            double.parse(event.pickLat),
            double.parse(event.pickLng),
            double.parse(event.dropLat!),
            double.parse(event.dropLng!),
            mapType);
      } else {
        googleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              double.parse(event.pickLat),
              double.parse(event.pickLng),
            ),
            zoom: 15)));
      }

      if (event.polyline != '') {
        await decodeEncodedPolyline(event.polyline!, mapType);
      }
    } else {
      if (event.polyline != '') {
        await decodeEncodedPolyline(event.polyline!, mapType);
      }
      if (event.dropLat != null) {
        fmController.fitCamera(fm.CameraFit.coordinates(coordinates: [
          fmlt.LatLng(double.parse(event.pickLat), double.parse(event.pickLng)),
          fmlt.LatLng(
              double.parse(event.dropLat!), double.parse(event.dropLng!))
        ]));
        fmController.move(
            fmlt.LatLng(
                double.parse(event.pickLat), double.parse(event.pickLng)),
            10);
      } else {
        fmController.move(
            fmlt.LatLng(
                double.parse(event.pickLat), double.parse(event.pickLng)),
            10);
      }
    }

    emit(UpdateState());
  }

  //Clear notification
  Future<void> _clearAllNotifications(
      ClearAllNotificationsEvent event, Emitter<AccState> emit) async {
    try {
      await serviceLocator<AccUsecase>().clearAllNotification();
      notificationDatas.clear();
      emit(NotificationClearedSuccess());
    } catch (e) {
      emit(NotificationFailure(errorMessage: e.toString()));
    }
  }

  // Delete notification
  Future<void> _deleteNotification(
      DeleteNotificationEvent event, Emitter<AccState> emit) async {
    try {
      await _deleteNotificationById(event.id);
      notificationDatas.removeWhere((value) => value.id == event.id);
      emit(NotificationDeletedSuccess());
    } catch (e) {
      emit(NotificationFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _deleteNotificationById(String id) async {
    try {
      await serviceLocator<AccUsecase>().deleteNotification(id);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  // Logout
  Future<void> _logout(LogoutEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(LogoutLoadingState());
    final data = await serviceLocator<AccUsecase>().logout();
    data.fold(
          (error) {
        printWrapped('text logout ------ ');
        emit(LogoutFailureState(errorMessage: error.toString()));
        isLoading = false;
      },
          (success) {
        isLoading = false;
        emit(LogoutSuccess());
      },
    );
  }

  // Delete account
  Future<void> _deleteAccount(
      DeleteAccountEvent event, Emitter<AccState> emit) async {
    emit(DeleteAccountLoadingState());
    final deleteResult = await serviceLocator<AccUsecase>().deleteUserAccount();
    deleteResult.fold(
          (error) {
        debugPrint('Delete Account error: ${error.toString()}');
        emit(DeleteAccountFailureState(errorMessage: error.message ?? ""));
      },
          (success) {
        emit(DeleteAccountSuccess());
      },
    );
  }

  // make complaints
  Future<void> _getComplaints(
      ComplaintEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(MakeComplaintLoading());

    try {
      final data = await serviceLocator<AccUsecase>()
          .makeComplaint(complaintType: event.complaintType.toString());
      data.fold(
            (error) {
          isLoading = false;
          debugPrint('Outstation Error: ${error.toString()}');
          emit(MakeComplaintFailure(errorMessage: error.message ?? ""));
        },
            (success) {
          isLoading = false;
          complaintList = success.data;
          emit(MakeComplaintSuccess(complaintList: complaintList));
        },
      );
    } catch (e) {
      debugPrint('An error occurred: $e');
      emit(MakeComplaintFailure(errorMessage: e.toString()));
    }
  }

// make complaint button
  Future<void> _complaintButton(
      ComplaintButtonEvent event, Emitter<AccState> emit) async {
    final complaintText = complaintController.text.trim();

    if (complaintText.length <= 10) {
      emit(ComplaintButtonFailureState(
          errorMessage: 'Complaint text must be more than 10 characters.'));
      return;
    }

    emit(ComplaintButtonLoadingState());
    final result = await serviceLocator<AccUsecase>().makeComplaintButton(
        event.complaintTitleId, complaintText, event.requestId);

    result.fold(
          (failure) {
        debugPrint('Make Complaint Button error: ${failure.toString()}');
        emit(ComplaintButtonFailureState(errorMessage: failure.toString()));
      },
          (success) {
        emit(MakeComplaintButtonSuccess());
        complaintController.clear();
      },
    );
  }

  Future<void> _onGenderSelected(
      GenderSelectedEvent event, Emitter<AccState> emit) async {
    selectedGender = event.selectedGender;
    emit(GenderSelectedState(selectedGender: selectedGender));
  }

//Faq
  Future<void> _getFaqList(
      GetFaqListEvent event, Emitter<AccState> emit) async {
    if (isFaqLoading) return;
    isFaqLoading = true;
    emit(FaqLoadingState());
    try {
      final data = await serviceLocator<AccUsecase>().getFaqDetail();
      if (isClosed) return;
      isFaqLoading = false;
      data.fold((error) {
        emit(FaqFailureState());
      }, (success) {
        faqDataList = success.data;
        emit(FaqSuccessState());
      });
    } catch (_) {
      if (isClosed) return;
      isFaqLoading = false;
      emit(FaqFailureState());
    }
  }

  Future<void> _selectedFaqIndex(
      FaqOnTapEvent event, Emitter<AccState> emit) async {
    choosenFaqIndex = choosenFaqIndex == event.selectedFaqIndex
        ? -1 : event.selectedFaqIndex;
    emit(FaqSelectState(choosenFaqIndex));
  }

  Future<void> _selectedMapIndex(
      ChooseMapOnTapEvent event, Emitter<AccState> emit) async {
    choosenMapIndex = event.chooseMapIndex;
    if (event.chooseMapIndex == 0) {
      mapType = 'google_map';
      await AppSharedPreference.setMapType(mapType);
      add(UpdateUserDetailsEvent(
          name: '',
          email: '',
          gender: '',
          profileImage: '',
          mobile: '',
          country: '',
          mapType: 'google_map'));
    } else {
      mapType = 'open_street_map';
      await AppSharedPreference.setMapType(mapType);
      add(UpdateUserDetailsEvent(
          name: '',
          email: '',
          gender: '',
          profileImage: '',
          mobile: '',
          country: '',
          mapType: 'open_street_map'));
    }
    isAppMapChange = true;
    emit(ChooseMapSelectState(choosenMapIndex));
  }

  Future<void> _selectedLayoutIndex(
      ChooseLayoutOnTapEvent event, Emitter<AccState> emit) async {
    choosenLayoutIndex = event.chooseLayoutIndex;
    if (event.chooseLayoutIndex == 0) {
      homeLayoutType = 'classic_layout'; // Classic
      await AppSharedPreference.setHomeLayoutType(homeLayoutType);
      add(UpdateUserDetailsEvent(
          name: userData?.name ?? '',
          email: userData?.email ?? '',
          gender: userData?.gender ?? '',
          profileImage: '',
          mobile: userData?.mobile ?? '',
          country: userData?.countryCode ?? '',
          mapShow: 'classic_layout'));
    } else {
      homeLayoutType = 'morden_layout'; // Modern
      await AppSharedPreference.setHomeLayoutType(homeLayoutType);
      add(UpdateUserDetailsEvent(
        name: userData?.name ?? '',
        email: userData?.email ?? '',
        gender: userData?.gender ?? '',
        profileImage: '',
        mobile: userData?.mobile ?? '',
        country: userData?.countryCode ?? '',
        mapShow: 'morden_layout',
      ));
    }
    isAppHomeLayoutChange = true;
    emit(ChooseLayoutOnTapState(choosenLayoutIndex));
  }

  FutureOr<void> _getWalletHistoryList(
      GetWalletHistoryListEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    if (firstLoad) {
      emit(WalletHistoryLoadingState());
    }
    final data =
    await serviceLocator<AccUsecase>().getWalletDetail(event.pageIndex);
    data.fold(
          (error) {
        isLoading = false;
        loadMore = false;
        firstLoad = false;
        emit(UpdateState());
        emit(WalletHistoryFailureState());
      },
          (success) {
        isLoading = false;
        loadMore = false;
        firstLoad = false;
        walletResponse = success;

        walletPaymentGatways = success.paymentGateways;
        final walletHistory = success.walletHistory;
        final List<WalletHistoryData> pageHistory =
        walletHistory is WalletHistory
            ? walletHistory.data
            : <WalletHistoryData>[];
        final WalletPagination? pageMeta =
        walletHistory is WalletHistory ? walletHistory.meta : null;
        if (event.pageIndex == 1) {
          walletHistoryList = pageHistory;
        } else {
          if (pageHistory.isNotEmpty) {
            walletHistoryList.addAll(pageHistory);
          }
        }
        walletPaginations = pageMeta;
        emit(UpdateState());
        emit(WalletHistorySuccessState(walletHistoryDatas: walletHistoryList));
      },
    );
  }

  Future<void> walletInitEvent(
      WalletPageInitEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    firstLoad = true;
    isLoading = true;
    transferPhonenumber.clear();
    transferAmount.clear();
    add(GetWalletHistoryListEvent(pageIndex: 1));
    scrollController.removeListener(walletPageScrollListener);
    scrollController.addListener(walletPageScrollListener);
    emit(UpdateState());
  }

  void walletPageScrollListener() {
    if (!scrollController.hasClients || isLoading || loadMore) return;
    final pagination = walletPaginations?.pagination;
    if (pagination == null || pagination.currentPage >= pagination.totalPages) return;
    if (scrollController.position.pixels < scrollController.position.maxScrollExtent) return;
    loadMore = true;
    add(AccUpdateEvent());
    add(GetWalletHistoryListEvent(pageIndex: pagination.currentPage + 1));
  }

  Future<void> _onTransferMoneySelected(
      TransferMoneySelectedEvent event, Emitter<AccState> emit) async {
    dropdownValue = event.selectedTransferAmountMenuItem;
    emit(TransferMoneySelectedState(
        selectedTransferAmountMenuItem: dropdownValue));
  }

  FutureOr<void> moneyTransfered(
      MoneyTransferedEvent event, Emitter<AccState> emit) async {
    if (isLoading) return;
    emit(UserProfileDetailsLoadingState());
    isLoading = true;
    final data = await serviceLocator<AccUsecase>().moneyTransfer(
        transferMobile: event.transferMobile,
        role: event.role,
        transferAmount: event.transferAmount);
    data.fold(
          (error) {
        debugPrint(error.toString());
        isLoading = false;
        emit(MoneyTransferedFailureState());
        showToast(message: error.message.toString());
      },
          (success) {
        final pageIndex = walletPaginations?.pagination.currentPage ?? 1;
        add(GetWalletHistoryListEvent(pageIndex: pageIndex));
        isLoading = false;
        emit(MoneyTransferedSuccessState());
      },
    );
  }

  Future<void> paymentAuth(
      PaymentAuthenticationEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    final data = await serviceLocator<AccUsecase>().stripeSetupIntent();
    data.fold((error) {
      debugPrint(error.toString());
    }, (success) {
      paymentAuthData = success.data;
    });
    emit(UpdateState());
  }

  Future<void> getUserDetails(
      AccGetUserDetailsEvent event, Emitter<AccState> emit) async {
    if (isClosed || isGettingUserDetails) return;
    isGettingUserDetails = true;
    try {
      final data = await serviceLocator<HomeUsecase>().userDetails();
      data.fold((error) {
        debugPrint(error.toString());
      }, (success) {
        if (isClosed) return;
        userData = success.data;
        sosdata = success.data.sos.data;
        favAddressList = success.data.favouriteLocations.data;
        name = success.data.name;
        mobile = success.data.mobile;
        email = success.data.email;
        gender = success.data.gender;
        profilePicture = success.data.profilePicture;
        country = success.data.countryCode;
        if (!isClosed) {
          emit(UserDetailsSuccessState(userData: userData));
          add(
            GetFavListEvent(
                userData: userData!, favAddressList: favAddressList),
          );
        }
      });
    } finally {
      isGettingUserDetails = false;
    }
  }

  // Delete sos
  Future<void> _deletesos(
      DeleteContactEvent event, Emitter<AccState> emit) async {
    if (isLoading) return;
    isLoading = true;
    emit(SosLoadingState());
    try {
      final data = await serviceLocator<AccUsecase>().deleteSosContact(event.id!);
      if (isClosed) return;
      isLoading = false;
      data.fold((error) {
        emit(SosFailureState());
      }, (success) {
        sosdata.removeWhere((contact) => contact.id == event.id);
        add(AccGetUserDetailsEvent());
        emit(SosDeletedSuccessState());
      });
    } catch (_) {
      if (isClosed) return;
      isLoading = false;
      emit(SosFailureState());
    }
  }

  Future<void> addContactDetails(
      AddContactEvent event, Emitter<AccState> emit) async {
    if (isLoading) return;
    isLoading = true;
    emit(UserProfileDetailsLoadingState());
    try {
      final data = await serviceLocator<AccUsecase>()
          .addSosContact(name: event.name, number: event.number);
      if (isClosed) return;
      isLoading = false;
      data.fold((error) {
        emit(AddContactFailureState());
      }, (success) {
        add(AccGetUserDetailsEvent());
        emit(AddContactSuccessState());
      });
    } catch (_) {
      if (isClosed) return;
      isLoading = false;
      emit(AddContactFailureState());
    }
  }

  Future<void> selectContactDetails(
      SelectContactDetailsEvent event, Emitter<AccState> emit) async {
    PermissionStatus status = await Permission.contacts.status;

    // Ask only once if denied
    if (status.isDenied) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      emit(AccDataLoadingStartState());

      if (contactsList.isEmpty) {
        final contactsPermissionStatus =
        await FlutterContacts.permissions.request(PermissionType.readWrite);
        if (contactsPermissionStatus == fc.PermissionStatus.granted) {
          isLoading = true;

          final contacts =
          await FlutterContacts.getAll(properties: ContactProperties.all);

          for (var contact in contacts) {
            for (var phone in contact.phones) {
              contactsList.add(ContactsModel(
                name: contact.displayName??'',
                number: phone.number,
              ));
            }
          }

          isLoading = false;
        }
      }
      emit(SelectContactDetailsState());
    }

    // User tapped "Don't Allow"
    else if (status.isDenied) {
      emit(GetContactPermissionState());
    }

    // User permanently denied (iOS: can't ask again)
    else if (status.isPermanentlyDenied || status.isRestricted) {
      emit(GetContactPermissionPermanentlyDeniedState());
    }
  }

  Future<void> _updateTextField(
      UpdateUserDetailsEvent event, Emitter<AccState> emit) async {
    final result = await serviceLocator<AccUsecase>().updateDetailsButton(
      email: event.email,
      name: event.name,
      gender: event.gender,
      profileImage: event.profileImage,
      mobile: event.mobile,
      country: event.country,
      mapType: event.mapType,
      mapShow: event.mapShow,
    );
    result.fold(
          (failure) {
        debugPrint('Update Details: ${failure.toString()}');
        emit(UpdateUserDetailsFailureState());
      },
          (success) {
        if (success is! Map) {
          emit(UpdateUserDetailsFailureState());
          return;
        }
        final data = success["data"];
        if (data is! Map) {
          emit(UpdateUserDetailsFailureState());
          return;
        }

        String valueOrFallback(dynamic value, String fallback) {
          if (value == null) return fallback;
          final text = value.toString();
          return text.isNotEmpty ? text : fallback;
        }

        final updatedName = valueOrFallback(
          data['name'],
          event.name.isNotEmpty ? event.name : (userData?.name ?? ''),
        );
        final updatedEmail = valueOrFallback(
          data['email'],
          event.email.isNotEmpty ? event.email : (userData?.email ?? ''),
        );
        final updatedGender = valueOrFallback(
          data['gender'],
          event.gender.isNotEmpty ? event.gender : (userData?.gender ?? ''),
        );
        final updatedProfileImage = valueOrFallback(
          data['profile_picture'],
          event.profileImage.isNotEmpty
              ? event.profileImage
              : (userData?.profilePicture ?? ''),
        );
        final updatedMobile = valueOrFallback(
          data['mobile'],
          event.mobile.isNotEmpty ? event.mobile : (userData?.mobile ?? ''),
        );
        final updatedCountry = valueOrFallback(
          data['country_code'],
          event.country.isNotEmpty
              ? event.country
              : (userData?.countryCode ?? ''),
        );

        if (userData != null) {
          userData = _copyUserDetailWithUpdates(
            base: userData!,
            updatedName: updatedName,
            updatedEmail: updatedEmail,
            updatedGender: updatedGender,
            updatedProfilePicture: updatedProfileImage,
            updatedMobile: updatedMobile,
            updatedCountryCode: updatedCountry,
          );
          sosdata = userData!.sos.data;
          favAddressList = userData!.favouriteLocations.data;
          emit(UserDetailsSuccessState(userData: userData));
        }
        name = updatedName;
        email = updatedEmail;
        gender = updatedGender;
        profilePicture = updatedProfileImage;
        mobile = updatedMobile;
        country = updatedCountry;

        emit(UserDetailsUpdatedState(
          name: updatedName,
          email: updatedEmail,
          gender: updatedGender,
          profileImage: updatedProfileImage,
        ));
        emit(UserDetailsButtonSuccess());
        emit(UpdateState());
      },
    );
  }

  UserDetail _copyUserDetailWithUpdates({
    required UserDetail base,
    required String updatedName,
    required String updatedEmail,
    required String updatedGender,
    required String updatedProfilePicture,
    required String updatedMobile,
    required String updatedCountryCode,
  }) {
    return UserDetail(
        id: base.id,
        approve: base.approve,
        enableUserDocument: base.enableUserDocument,
        zoneTypeId: base.zoneTypeId,
        name: updatedName,
        gender: updatedGender,
        lastName: base.lastName,
        username: base.username,
        email: updatedEmail,
        mobile: updatedMobile,
        profilePicture: updatedProfilePicture,
        active: base.active,
        emailConfirmed: base.emailConfirmed,
        mobileConfirmed: base.mobileConfirmed,
        lastKnownIp: base.lastKnownIp,
        lastLoginAt: base.lastLoginAt,
        rating: base.rating,
        noOfRatings: base.noOfRatings,
        refferalCode: base.refferalCode,
        currencyCode: base.currencyCode,
        currencySymbol: base.currencySymbol,
        currencyPointer: base.currencyPointer,
        countryCode: updatedCountryCode,
        showRentalRide: base.showRentalRide,
        isDeliveryApp: base.isDeliveryApp,
        fcmToken: base.fcmToken,
        showRideLaterFeature: base.showRideLaterFeature,
        authorizationCode: base.authorizationCode,
        enableSupportTicketFeature: base.enableSupportTicketFeature,
        enableModulesForApplications: base.enableModulesForApplications,
        contactUsMobile1: base.contactUsMobile1,
        contactUsMobile2: base.contactUsMobile2,
        contactUsLink: base.contactUsLink,
        showWalletMoneyTransferFeatureOnMobileApp:
        base.showWalletMoneyTransferFeatureOnMobileApp,
        showBankInfoFeatureOnMobileApp: base.showBankInfoFeatureOnMobileApp,
        showWalletFeatureOnMobileApp: base.showWalletFeatureOnMobileApp,
        notificationsCount: base.notificationsCount,
        completedRideCount: base.completedRideCount,
        referralComissionString: base.referralComissionString,
        userCanMakeARideAfterXMiniutes: base.userCanMakeARideAfterXMiniutes,
        maximumTimeForFindDriversForRegularRide:
        base.maximumTimeForFindDriversForRegularRide,
        maximumTimeForFindDriversForBittingRide:
        base.maximumTimeForFindDriversForBittingRide,
        enableDriverPreferenceForUser: base.enableDriverPreferenceForUser,
        enablePetPreferenceForUser: base.enablePetPreferenceForUser,
        enableLuggagePreferenceForUser: base.enableLuggagePreferenceForUser,
        biddingAmountIncreaseOrDecrease: base.biddingAmountIncreaseOrDecrease,
        showRideWithoutDestination: base.showRideWithoutDestination,
        enableCountryRestrictOnMap: base.enableCountryRestrictOnMap,
        chatId: base.chatId,
        mapType: base.mapType,
        hasOngoingRide: base.hasOngoingRide,
        showOutstationRideFeature: base.showOutstationRideFeature,
        showTaxiOutstationRideFeature: base.showTaxiOutstationRideFeature,
        showDeliveryOutstationRideFeature:
        base.showDeliveryOutstationRideFeature,
        sos: base.sos,
        bannerImage: base.bannerImage,
        wallet: base.wallet,
        onTripRequest: base.onTripRequest,
        metaRequest: base.metaRequest,
        favouriteLocations: base.favouriteLocations,
        laterMetaRequest: base.laterMetaRequest,
        showDeliveryRentalRide: base.showDeliveryRentalRide,
        showTaxiRentalRide: base.showTaxiRentalRide,
        showCardPaymentFeature: base.showCardPaymentFeature,
        distanceUnit: base.distanceUnit,
        enableMapAppearanceChange: base.enableMapAppearanceChange,
        androidApp: base.androidApp,
        iosApp: base.iosApp,
        enableOutstationRoundTripFeature: base.enableOutstationRoundTripFeature,
        showOnlyTotalAmount: base.showOnlyTotalAmount,
        contactBookingNumber: base.contactBookingNumber,
        enableMultipleRideFeature: base.enableMultipleRideFeature,
        hasUpcomingRide: base.hasUpcomingRide,
        showWalletAddMoneyFeatureOnMobileApp:
        base.showWalletAddMoneyFeatureOnMobileApp,
        enableMapShowHomeScreen: base.enableMapShowHomeScreen,
        mapShowHomePageDesign: base.mapShowHomePageDesign,
        appModuleBannerImage: base.appModuleBannerImage,
        osmMapSettings: base.osmMapSettings);
  }

  Future<void> _getProfileImage(
      UpdateImageEvent event, Emitter<AccState> emit) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    if (event.source == ImageSource.camera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else if (event.source == ImageSource.gallery) {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      profileImage = image.path;
      emit(ImageUpdateState(profileImage: profileImage));
      add(UpdateUserDetailsEvent(
        name: '',
        email: '',
        gender: '',
        profileImage: profileImage,
        mobile: '',
        country: '',
      ));
    }
  }

  Future<void> _deleteFavAddress(
      DeleteFavAddressEvent event, Emitter<AccState> emit) async {
    final data =
    await serviceLocator<AccUsecase>().deleteFavouritesAddress(event.id!);
    data.fold(
          (error) {
        debugPrint(error.toString());
        emit(FavFailureState());
      },
          (success) {
        if (event.isHome) {
          home.removeWhere((element) => element.id == event.id);
        } else if (event.isWork) {
          work.removeWhere((element) => element.id == event.id);
        } else if (event.isOthers) {
          others.removeWhere((element) => element.id == event.id);
        }
        if (userData != null) {
          userData!.favouriteLocations.data
              .removeWhere((element) => element.id == event.id);
        }
        emit(FavDeletedSuccessState());
      },
    );
  }

  //Fav loc
  FutureOr<void> getFavList(
      GetFavListEvent event, Emitter<AccState> emit) async {
    userData = event.userData;
    isFavLoading = true;
    emit(FavoriteLoadingState());
    home.clear();
    work.clear();
    others.clear();
    if (event.favAddressList.isNotEmpty) {
      for (var e in event.favAddressList) {
        if (e.addressName == 'Work') {
          work.add(e);
        } else if (e.addressName == 'Home') {
          home.add(e);
        } else {
          others.add(e);
        }
      }
    }
    isFavLoading = false;
    emit(FavoriteLoadedState());
  }

  FutureOr<void> selectFavAddress(
      SelectFromFavAddressEvent event, Emitter<AccState> emit) async {
    emit(SelectFromFavAddressState(addressType: event.addressType));
  }

  Future addFavourites(AddFavAddressEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<AccUsecase>().addFavAddress(
        address: event.address,
        name: event.name,
        lat: event.lat,
        lng: event.lng);
    isLoading = false;
    data.fold(
          (error) {
        debugPrint(error.toString());
        emit(AccDataLoadingStopState());
        emit(AddFavAddressFailureState());
      },
          (success) {
        if (!event.isOther) {
          add(AccGetUserDetailsEvent());
        }
        emit(AccDataLoadingStopState());
        emit(AddFavAddressSuccessState());
        emit(UpdateState());
      },
    );
  }

  FutureOr<void> userDetailEdit(
      UserDetailEditEvent event, Emitter<AccState> emit) async {
    emit(UserDetailEditState(header: event.header, text: event.text));
  }

  FutureOr<void> userDetails(
      UserDetailEvent event, Emitter<AccState> emit) async {
    emit(UserDetailState());
  }

  FutureOr<void> sendAdminChat(
      SendAdminMessageEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<AccUsecase>().sendAdminMessages(
        newChat: event.newChat, message: event.message, chatId: event.chatId);
    data.fold(
          (error) {
        emit(SendAdminMessageFailureState());
      },
          (success) {
        chatId = success.data.conversationId;
        adminChatList.add(ChatData(
            message: success.data.message,
            conversationId: chatId,
            senderId: userData!.id.toString(),
            senderType: success.data.senderType,
            count: success.data.count,
            newChat: success.data.newChat,
            createdAt: success.data.createdAt,
            messageSuccess: success.data.messageSuccess,
            userTimezone: success.data.userTimezone));
        isNewChat = 0;
        if (adminChatList.isNotEmpty && chatStream == null) {
          streamAdminchat();
        }
        unSeenChatCount = '0';
        emit(SendAdminMessageSuccessState());
      },
    );
  }

  FutureOr<void> _getAdminChatHistoryList(
      GetAdminChatHistoryListEvent event, Emitter<AccState> emit) async {
    emit(UserProfileDetailsLoadingState());
    final data = await serviceLocator<AccUsecase>().getAdminChatHistoryDetail();
    data.fold(
          (error) {
        emit(AdminChatHistoryFailureState());
      },
          (success) {
        adminChatList.clear();
        isNewChat = success.data.newChat;
        int count = success.data.count;
        for (var i = 0; i < success.data.conversation.length; i++) {
          adminChatList.add(ChatData(
              message: success.data.conversation[i].content,
              conversationId: success.data.conversation[i].conversationId,
              senderId: success.data.conversation[i].senderId.toString(),
              senderType: success.data.conversation[i].senderType.toString(),
              count: count,
              newChat: '0',
              createdAt: success.data.conversation[i].createdAt,
              messageSuccess: 'Data inserted successfully',
              userTimezone: success.data.conversation[i].userTimezone));
        }
        chatId = success.data.conversationId;
        if (adminChatList.isNotEmpty && chatStream == null) {
          streamAdminchat();
        }
        unSeenChatCount = '0';
        emit(AdminChatHistorySuccessState());
      },
    );
  }

  streamAdminchat() async {
    if (chatStream != null) {
      chatStream?.cancel();
      chatStream = null;
    }
    chatStream = FirebaseDatabase.instance
        .ref()
        .child(
        'conversation/${(adminChatList.length > 2) ? (userData != null) ? userData!.chatId : chatId : chatId}')
        .onValue
        .listen((event) async {
      var value = Map<String, dynamic>.from(
          jsonDecode(jsonEncode(event.snapshot.value)));
      if (userData != null) {
        if ((((adminChatList.isNotEmpty &&
            adminChatList.last.message !=
                value['message'].toString())) &&
            value['sender_id'].toString() != userData!.id.toString()) ||
            (value['sender_id'].toString() != userData!.id.toString() &&
                adminChatList.isEmpty)) {
          adminChatList.add(ChatData.fromJson(value));
          add(AccUpdateEvent());
        }
      }
      value.clear();
      if (adminChatList.isNotEmpty) {
        unSeenChatCount =
            adminChatList[adminChatList.length - 1].count.toString();
        if (unSeenChatCount == 'null') {
          unSeenChatCount = '0';
        }
      }
    });
  }

  FutureOr<void> _adminMessageSeenDetail(
      AdminMessageSeenEvent event, Emitter<AccState> emit) async {
    emit(UserProfileDetailsLoadingState());
    final data = await serviceLocator<AccUsecase>()
        .adminMessageSeenDetail(event.chatId!);
    data.fold(
          (error) {
        emit(AdminMessageSeenFailureState());
      },
          (success) {
        emit(AdminMessageSeenSuccessState());
      },
    );
  }

  Future<void> _selectedPaymentIndex(
      PaymentOnTapEvent event, Emitter<AccState> emit) async {
    choosenPaymentIndex = event.selectedPaymentIndex;
    emit(PaymentSelectState(choosenPaymentIndex!));
  }

  FutureOr cancelRequest(
      RideLaterCancelRequestEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<BookingUsecase>()
        .cancelRequest(requestId: event.requestId, reason: event.reason);
    data.fold((error) {
      debugPrint(error.toString());
      emit(AccDataLoadingStopState());
    }, (success) {
      emit(AccDataLoadingStopState());
      historyList.removeWhere((value) => value.id == event.requestId);
      emit(RequestCancelState());
    });
  }

  FutureOr newFavAddress(
      FavNewAddressInitEvent event, Emitter<AccState> emit) async {
    favNewAddress = event.arg.selectedAddress;
    userData = event.arg.userData;
    emit(UpdateState());
  }

  FutureOr addMoneyWebViewUrl(
      AddMoneyWebViewUrlEvent event, Emitter<AccState> emit) async {
    if (event.from == '1') {
      paymentUrl =
      '${event.url}?amount=${event.money}&payment_for=request&currency=${event.currencySymbol}&user_id=${event.userId.toString()}&request_id=${event.requestId.toString()}';
    } else {
      paymentUrl =
      '${event.url}?amount=${event.money}&payment_for=wallet&currency=${event.currencySymbol}&user_id=${event.userId.toString()}';
    }
    final Uri uri = Uri.parse(paymentUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } else {
      ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
        const SnackBar(content: Text("Could not open payment page")),
      );
    }
  }

  Future<void> userDataInit(
      UserDataInitEvent event, Emitter<AccState> emit) async {
    userData = event.userDetails;
    emit(UpdateState());
  }

  Future<void> sosPageInit(SosInitEvent event, Emitter<AccState> emit) async {
    isSosLoading = true;
    emit(UpdateState());
    sosdata = event.arg.sosData;
    await Future.delayed(const Duration(microseconds: 300));
    isSosLoading = false;
    emit(UpdateState());
  }

  Future<void> adminChatInit(
      AdminChatInitEvent event, Emitter<AccState> emit) async {
    userData = event.arg.userData;
    emit(UpdateState());
    add(GetAdminChatHistoryListEvent());
  }

  FutureOr addCardDetails(
      AddCardDetailsEvent event, Emitter<AccState> emit) async {
    try {
      isLoading = true;
      emit(UpdateState());
      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(
                  billingDetails: BillingDetails(
                      name: userData!.username, phone: userData!.mobile))));

      final data = await serviceLocator<AccUsecase>().stripSaveCardDetails(
          paymentMethodId: paymentMethod.id,
          last4Number: paymentMethod.card.last4!,
          cardType: paymentMethod.card.brand!,
          validThrough:
          '${paymentMethod.card.expMonth}/${paymentMethod.card.expYear}');
      data.fold((error) {
        printWrapped(error.toString());
        isLoading = false;
      }, (success) {
        if (success['success']) {
          isLoading = false;
          emit(SaveCardSuccessState());
        } else {
          isLoading = false;
          showToast(message: success['message'].toString());
          emit(UpdateState());
        }
      });
    } on StripeException catch (e) {
      isLoading = false;
      emit(UpdateState());
      printWrapped(e.toString());
      showToast(message: e.error.localizedMessage.toString());
    } catch (e) {
      isLoading = false;
      emit(UpdateState());
      printWrapped(e.toString());
      showToast(message: 'Please enter the valid data');
    }
  }

  Future<void> addMoneyFromCard(
      AddMoneyFromCardEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<AccUsecase>().addMoneyToWalletFromCard(
        amount: event.amount, cardToken: event.cardToken);
    data.fold((error) {
      printWrapped(error.toString());
      showToast(message: error.message.toString());
      emit(AccDataLoadingStopState());
      emit(PaymentUpdateState(status: false));
    }, (success) {
      emit(AccDataLoadingStopState());
      emit(PaymentUpdateState(status: success['success']));
    });
  }

  FutureOr getCardList(CardListEvent event, Emitter<AccState> emit) async {
    try {
      final data = await serviceLocator<AccUsecase>().cardList();
      data.fold((error) {
        debugPrint(error.toString());
        savedCardsList.clear();
        emit(UpdateState());
      }, (success) {
        savedCardsList.clear();
        savedCardsList = success.data;
        emit(UpdateState());
      });
    } catch (e) {
      debugPrint('getCardList error: $e');
      savedCardsList.clear();
      emit(UpdateState());
    }
  }

  FutureOr deleteCard(DeleteCardEvent event, Emitter<AccState> emit) async {
    emit(AccDataLoadingStartState());
    final data =
    await serviceLocator<AccUsecase>().deleteCard(cardId: event.cardId);
    data.fold((error) {
      debugPrint(error.toString());
      showToast(message: error.message.toString());
      emit(AccDataLoadingStopState());
    }, (success) {
      savedCardsList.removeWhere((element) => element.id == event.cardId);
      emit(AccDataLoadingStopState());
    });
  }

  FutureOr showPaymentGateways(
      ShowPaymentGatewayEvent event, Emitter<AccState> emit) async {
    emit(ShowPaymentGatewayState());
  }

  Future<List<PointLatLng>> decodeEncodedPolyline(
      String encoded, String mapType) async {
    polylist.clear();
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    polyline.clear();

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
      if (mapType == 'google_map') {
        polylist.add(p);
      } else {
        fmpoly.add(fmlt.LatLng(p.latitude, p.longitude));
      }
    }
    if (mapType == 'google_map') {
      polyline.add(
        Polyline(
            polylineId: const PolylineId('1'),
            color: AppColors.primary,
            visible: true,
            width: 4,
            points: polylist),
      );
    }
    return poly;
  }

  mapBound(pickLat, pickLng, dropLat, dropLng, mapType) {
    dynamic pick = LatLng(pickLat, pickLng);
    dynamic drop = LatLng(dropLat, dropLng);
    if (pick.latitude > drop.latitude && pick.longitude > drop.longitude) {
      bound = LatLngBounds(southwest: drop, northeast: pick);
    } else if (pick.longitude > drop.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(pick.latitude, drop.longitude),
          northeast: LatLng(drop.latitude, pick.longitude));
    } else if (pick.latitude > drop.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(drop.latitude, pick.longitude),
          northeast: LatLng(pick.latitude, drop.longitude));
    } else {
      bound = LatLngBounds(southwest: pick, northeast: drop);
    }
    if (mapType == 'google_map') {
      googleMapController
          ?.animateCamera(CameraUpdate.newLatLngBounds(bound!, 50));
    }
  }

  Future<void> makeTicketSubmit(
      MakeTicketSubmitEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(UpdateState());
    final data = await serviceLocator<AccUsecase>().makeTicket(
        titleId: event.titleId,
        description: event.description,
        serviceLocationId: event.serviceLocationId,
        attachments: event.attachement,
        requestId: event.requestId);
    data.fold((error) {
      showToast(message: error.message.toString());
      isLoading = false;
    }, (success) {
      showToast(message: success.message.toString());
      isLoading = false;
      if (event.isFromRequest == true) {
        add(HistoryGetEvent(
            historyFilter: 'is_completed=1',
            historyIndex: event.index,
            pageNumber: event.pageNumber));
      } else {
        if (!isClosed) {
          add(GetTicketListEvent(isFromAcc: false));
        }
      }

      emit(UpdateState());
    });
  }

  Future<void> viewTicketData(
      ViewTicketEvent event, Emitter<AccState> emit) async {
    viewAttachments.clear();
    final data =
    await serviceLocator<AccUsecase>().viewTicket(ticketId: event.id);
    data.fold((error) {
      showToast(message: error.message.toString());
    }, (success) {
      supportTicketData = success.supportTicket;
      viewAttachments = success.attachment;
      replyMessages = success.replyMessage;
      emit(UpdateState());
    });
  }

  Future<void> createSupportTicket(
      CreateSupportTicketEvent event, Emitter<AccState> emit) async {
    selectedTicketTitle = '';
    ticketAttachments.clear();
    supportDescriptionController.clear();
    final data = await serviceLocator<AccUsecase>()
        .supportTicketTitles(isFromRequest: event.isFromRequest);
    data.fold((error) {
      debugPrint(error.toString());
    }, (success) {
      ticketNamesList.clear();
      ticketNamesList = success.data;
      emit(UpdateState());
    });
    emit(CreateSupportTicketState(
        ticketNamesList: ticketNamesList,
        requestId: event.requestId,
        isFromRequest: event.isFromRequest,
        historyPageNumber: event.pageNumber,
        historyIndex: event.index));
  }

  FutureOr<void> getServiceLocation(
      GetServiceLocationEvent event, Emitter<AccState> emit) async {
    if (serviceLocations.isEmpty) {
      final data = await serviceLocator<AccUsecase>().getServiceLocation();
      data.fold(
            (error) {
          debugPrint(error.toString());
        },
            (success) {
          serviceLocations = success.data;
          emit(UpdateState());
        },
      );
    }
  }

  FutureOr<void> getTicketList(
      GetTicketListEvent event, Emitter<AccState> emit) async {
    if (event.isFromAcc == true) {
      emit(GetTicketListLoadingState());
    }
    isLoading = true;
    final data = await serviceLocator<AccUsecase>().getTicketList();
    data.fold(
          (error) {
        debugPrint(error.toString());
        isLoading = false;
      },
          (success) {
        ticketList = success.data;
        isLoading = false;
        emit(GetTicketListLoadedState());
      },
    );
  }

  Future<void> assignSelectedTicketValue(
      TicketTitleChangeEvent event, Emitter<AccState> emit) async {
    selectedTicketTitle = event.changedTitle;
    selectedTicketTitleId = event.id;
    emit(UpdateState());
  }

  Future<void> assignSelectedTicketArea(
      TicketAreaChangeEvent event, Emitter<AccState> emit) async {
    selectedTicketArea = event.changedArea;
    selectedTicketAreaId = event.id;
    emit(UpdateState());
  }

  Future<void> clearAttachment(
      ClearAttachmentEvent event, Emitter<AccState> emit) async {
    ticketAttachments.clear();
    emit(ClearAttachmentState());
  }

  Future<void> addAttachment(
      AddAttachmentTicketEvent event,
      Emitter<AccState> emit,
      ) async {
    if (ticketAttachments.length >= 8) {
      showToast(message: AppLocalizations.of(event.context)!.fileLimitReached);
      return;
    }
    try {
      final result = await FilePicker.pickFiles(

        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'jpeg', 'png'],
      );//
      if (result != null) {
        final allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf', 'doc'];

        final selectedFiles = result
            .where((path) => path != null)
            .map((path) => File(path?.path??''))
            .toList();

        final validFiles = <File>[];
        bool hasInvalidFile = false;

        for (var file in selectedFiles) {
          final extension = file.path.split('.').last.toLowerCase();
          if (allowedExtensions.contains(extension)) {
            validFiles.add(file);
          } else {
            hasInvalidFile = true;
          }
        }
        if (hasInvalidFile) {
          showToast(message: "Some files were not supported and skipped.");
        }

        if (validFiles.isNotEmpty) {
          ticketAttachments =
              [...ticketAttachments, ...validFiles].take(8).toList();
          emit(AddAttachmentTicketState());
        }
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      showToast(message: 'Failed to pick files');
    }
  }

  Future<void> ticketMessageReply(
      TicketReplyMessageEvent event, Emitter<AccState> emit) async {
    final data = await serviceLocator<AccUsecase>()
        .ticketReplyMessage(id: event.id, replyMessage: event.messageText);
    data.fold((error) {
      showToast(message: error.message.toString());
    }, (success) {
      showToast(
          message: AppLocalizations.of(event.context)!.messageSuccessText);
      add(ViewTicketEvent(id: event.id));
      emit(UpdateState());
      supportMessageReplyController.clear();
    });
  }

  Future<void> tripSummaryHistoryDataGet(
      TripSummaryHistoryDataEvent event, Emitter<AccState> emit) async {
    historyData = event.tripHistoryData;
    emit(UpdateState());
  }

  FutureOr<void> downloadInvoice(
      DownloadInvoiceEvent event, Emitter<AccState> emit) async {
    isLoading = true;
    emit(UpdateState());
    final data = await serviceLocator<AccUsecase>()
        .invoiceDownload(requestId: event.requestId);
    data.fold(
          (error) {
        debugPrint(error.toString());
        isLoading = false;
        emit(UpdateState());
      },
          (success) {
        isLoading = false;
        emit(UpdateState());
        if (success["success"]) {
          emit(InvoiceDownloadSuccessState());
        }
      },
    );
  }

  Future<void> getHtmlString(
      GetHtmlStringEvent event, Emitter<AccState> emit) async {
    if (isHtmlLoading) return;
    isHtmlLoading = true;
    hasHtmlLoadFailed = false;
    emit(AccDataLoadingStartState());
    try {
      final data = await serviceLocator<AccUsecase>()
          .getTermsAndPrivacyHtml(isPrivacyPage: event.isPrivacy);
      if (isClosed) return;
      isHtmlLoading = false;
      data.fold((error) {
        hasHtmlLoadFailed = true;
      }, (success) {
        if (success is Map && success['success'] == true && success['data'] is String) {
          htmlString = success['data'] as String;
        } else {
          hasHtmlLoadFailed = true;
        }
      });
      emit(AccDataLoadingStopState());
    } catch (_) {
      if (isClosed) return;
      isHtmlLoading = false;
      hasHtmlLoadFailed = true;
      emit(AccDataLoadingStopState());
    }
  }

  Future<void> _referalHistory(
      ReferalHistoryEvent event, Emitter<AccState> emit) async {
    if (isReferralHistoryLoading) return;
    isReferralHistoryLoading = true;
    emit(ReferalHistoryLoadingState());
    try {
      final data = await serviceLocator<AccUsecase>().referalHistory();
      if (isClosed) return;
      isReferralHistoryLoading = false;
      data.fold((error) {
        emit(ReferalHistoryFailureState());
      }, (success) {
        if (success is historyModel.ReferralResponse) {
          referralHistory = success.data;
          hasLoadedReferralHistory = true;
        }
        emit(ReferalHistorySuccessState());
      });
    } catch (_) {
      if (isClosed) return;
      isReferralHistoryLoading = false;
      emit(ReferalHistoryFailureState());
    }
  }

  Future<void> _referralResponse(
      ReferralResponseEvent event, Emitter<AccState> emit) async {
    if (isReferralContentLoading) return;
    isReferralContentLoading = true;
    emit(ReferralResponseLoadingState());
    try {
      final data = await serviceLocator<AccUsecase>().referalResponse();
      if (isClosed) return;
      isReferralContentLoading = false;
      data.fold((error) {
        emit(ReferralResponseFailureState());
      }, (success) {
        if (success is referralModel.ReferralResponseData) {
          referralResponse = success;
        }
        emit(ReferralResponseSuccessState());
      });
    } catch (_) {
      if (isClosed) return;
      isReferralContentLoading = false;
      emit(ReferralResponseFailureState());
    }
  }

  FutureOr<void> downloadInvoiceUser(
      DownloadInvoiceUserEvent event,
      Emitter<AccState> emit,
      ) async {
    emit(AccDataLoadingStartState());
    final data = await serviceLocator<AccUsecase>()
        .invoiceDownloadUser(journeyId: event.journeyId);

    await data.fold(
          (error) async {
        debugPrint(error.toString());

        if (emit.isDone) return;
        emit(InvoiceDownloadFailureState());
        showToast(message: error.message ?? "");
      },
          (success) async {
        if (success["success"] && success["invoice_url"] != null) {
          final invoiceUrl = success["invoice_url"].toString();

          try {
            //  Permission (Android only)
            if (Platform.isAndroid) {
              await Permission.storage.request();
            }

            //  Base directory
            Directory baseDir;
            if (Platform.isAndroid) {
              baseDir = Directory("/storage/emulated/0/Download");
            } else {
              baseDir = await getApplicationDocumentsDirectory();
            }

            if (!await baseDir.exists()) {
              await baseDir.create(recursive: true);
            }

            //  File name
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            final fileName = "invoice_${event.journeyId}_$timestamp.pdf";
            final filePath = "${baseDir.path}/$fileName";

            //  Download
            final dio = Dio();
            await dio.download(invoiceUrl, filePath);

            debugPrint("Invoice saved at: $filePath");

            //  iOS safe share path
            String shareFilePath = filePath;

            if (Platform.isIOS) {
              final tempDir = await getTemporaryDirectory();
              final tempPath = '${tempDir.path}/$fileName';
              final tempFile = await File(filePath).copy(tempPath);
              shareFilePath = tempFile.path;
            }

            //  Share
            final result = await Share.shareXFiles(
              [XFile(shareFilePath, mimeType: 'application/pdf')],
              subject: 'Invoice',
              sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
            );

            if (emit.isDone) return;
            // On iOS, sometimes status is success even if dismissed, so we check result.raw (activity type)
            if (result.status == ShareResultStatus.success &&
                (!Platform.isIOS || result.raw.isNotEmpty)) {
              emit(InvoiceDownloadSuccessState());
            } else {
              emit(AccDataLoadingStopState());
            }
          } catch (e, s) {
            debugPrint("PDF download error: $e");
            debugPrint("STACK: $s");

            if (emit.isDone) return;
            emit(InvoiceDownloadFailureState());
          }
        } else {
          if (emit.isDone) return;
          emit(InvoiceDownloadFailureState());
          showToast(message: 'Invoice URL not available');
        }
      },
    );
  }

  Future<void> getPromoCodeList(
      GetPromoCodeListEvent event, Emitter<AccState> emit) async {
    if (isPromoListLoading) return;
    isPromoListLoading = true;
    isLoading = true;
    emit(AccDataLoadingStartState());
    try {
      final data = await serviceLocator<AccUsecase>().getPromoCodeList();
      if (isClosed) return;
      isLoading = false;
      isPromoListLoading = false;
      data.fold((error) {
        emit(PromoCodeListFailureState());
      }, (success) {
        promoCodeDataList = success.data;
        emit(PromoCodeListSuccessState());
      });
    } catch (_) {
      if (isClosed) return;
      isLoading = false;
      isPromoListLoading = false;
      emit(PromoCodeListFailureState());
    }
  }

  Future<void> selectedPromoCodeListIndex(
      SelectPromoCodeListIndexEvent event, Emitter<AccState> emit) async {
    selectedPromoIndex = event.selectedPromoCodeIndex;
    selectedPromoCodeValue = event.selectedPromoCodeVale;
    emit(SelectPromoCodeListIndexState(
        selectedPromoIndex: selectedPromoIndex,
        selectedPromoCodeValues: selectedPromoCodeValue));
  }

  Future<void> selectedPromoCodeListApply(
      SelectPromoCodeListApplyEvent event, Emitter<AccState> emit) async {
    if (isPromoChanging) return;
    isPromoChanging = true;
    selectedPromoCodeValue = event.selectedPromoCode;
    emit(PromoApplyLoadingState());
    try {
      final data = await serviceLocator<AccUsecase>()
          .promoCodeRedeem(code: event.selectedPromoCode);
      if (isClosed) return;
      isPromoChanging = false;
      data.fold((error) {
        emit(PromoApplyFailureState());
      }, (success) {
        selectedPromoPrice = event.price!;
        emit(PromoApplySuccessState());
      });
    } catch (_) {
      if (isClosed) return;
      isPromoChanging = false;
      emit(PromoApplyFailureState());
    }
  }

  Future<void> promoCodeClear(
      PromoCodeClearEvent event, Emitter<AccState> emit) async {
    if (isPromoChanging) return;
    isPromoChanging = true;
    isLoading = true;
    emit(PromoClearLoadingState());
    try {
      final data = await serviceLocator<AccUsecase>().promoCodeClear();
      if (isClosed) return;
      isPromoChanging = false;
      isLoading = false;
      data.fold((error) {
        emit(PromoClearFailureState(errorMessage: error.toString()));
      }, (success) {
        if (event.from == '2') {
          add(GetPromoCodeListEvent());
        } else {
          add(SelectPromoCodeListIndexEvent(
              selectedPromoCodeIndex: selectedPromoIndex,
              selectedPromoCodeVale: selectedPromoCodeValue));
        }
        emit(PromoClearSuccessState());
      });
    } catch (error) {
      if (isClosed) return;
      isPromoChanging = false;
      isLoading = false;
      emit(PromoClearFailureState(errorMessage: error.toString()));
    }
  }
}
