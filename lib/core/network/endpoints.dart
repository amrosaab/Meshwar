class ApiEndpoints {
  static String languageList = 'api/v1/translation/list';
  static String countryList = 'api/v1/countries';
  //  static String exceptionCheck = 'api/v1/test-exception?';
  // Onboarding
  static String onBoarding = 'api/v1/on-boarding';

  static String updateLocation = 'api/v1/user/update-location';

  // Authentication
  static String verifyUser = 'api/v1/user/validate-mobile-for-login';
  static String userLogin = 'api/v1/user/login';
  static String commonModule = 'api/v1/common/modules';
  static String sendMobileOtp = 'api/v1/mobile-otp';
  static String verifyMobileOtp = 'api/v1/validate-otp';
  static String sendEmailOtp = 'api/v1/send-mail-otp';
  static String verifyEmailOtp = 'api/v1/validate-email-otp';
  static String registerUser = 'api/v1/user/register';
  static String referral = 'api/v1/update/user/referral';
  static String updatePassword = 'api/v1/user/update-password';
  static String veryfymobile = 'api/v1/user/validate-mobile';

  // Home
  static String userDetails = 'api/v1/user';
  static String recentRoutes = 'api/v1/request/list-recent-searches';
  static String rideModules = 'api/v1/common/ride_modules';

  //notifications
  static String notification = 'api/v1/notifications/get-notification';
  static String deleteNotification = 'api/v1/notifications/delete-notification';
  static String clearAllNotification =
      'api/v1/notifications/delete-all-notification';

  //History
  static String history = 'api/v1/request/history';
  static String downloadInvoice = 'api/v1/request/invoice/';

  //Outstation
  static String outstation = 'api/v1/request/outstation_rides';

  //logout
  static String logout = 'api/v1/logout';

  //delete account
  static String deleteAccount = 'api/v1/user/delete-user-account';

  // make complaint
  static String makeComplaint = 'api/v1/common/complaint-titles';
  static String makeComplaintButton = 'api/v1/common/make-complaint';

  //update Details button
  static String updateUserDetailsButton = 'api/v1/user/profile';

  // Booking
  static String etaDetails = 'api/v1/request/eta';
  static String rentalEtaDetails = 'api/v1/request/list-packages';
  static String createRequest = 'api/v1/request/create';
  static String cancelRequest = 'api/v1/request/cancel';
  static String deliveryCreateRequest = 'api/v1/request/delivery/create';
  static String goodsType = 'api/v1/common/goods-types';
  static String userReview = 'api/v1/request/rating';
  static String biddingAccept = 'api/v1/request/respond-for-bid';
  static String cancelReasons = 'api/v1/common/cancallation/reasons';
  static String chatHistory = 'api/v1/request/chat-history';
  static String chatMessageSeen = 'api/v1/request/seen';
  static String sendChatMessage = 'api/v1/request/send';
  static String changeDestination = 'api/v1/request/change-drop-location';

  // Favourite Locations
  static String addFavLocation = 'api/v1/user/add-favourite-location';
  static String removeFavAddress = 'api/v1/user/delete-favourite-location';

  //Faq
  static String faqData = 'api/v1/common/faq/list';

  //wallet
  static String walletHistory = 'api/v1/payment/wallet/history';
  static String transferMoney =
      'api/v1/payment/wallet/transfer-money-from-wallet';
  static String stripCreate = 'api/v1/payment/stripe/create-setup-intent';
  static String stripSavedCardsDetail = 'api/v1/payment/stripe/save-card';
  static String savedCardList = 'api/v1/payment/cards/list';
  static String deleteCardsDetail = 'api/v1/payment/cards/delete/';
  static String stripAddMoneyToWallet =
      'api/v1/payment/stripe/add-money-to-wallet';
  //sos
  static String addSosContact = 'api/v1/common/sos/store';
  static String deleteSosContact = 'api/v1/common/sos/delete';

  //admin chat
  static String sendAdminMessage = 'api/v1/request/user-send-message';
  static String adminChatHistory = 'api/v1/request/user-chat-history';
  static String adminMessageSeen = 'api/v1/request/update-notification-count';

  //Map Apis
  static String getPolyline =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  //Update Language
  static String updateLanguage = 'api/v1/user/update-my-lang';

  // Service Verify
  static String serviceVerify = 'api/v1/request/serviceVerify';

  // Add Tips
  static String addTips = 'api/v1/request/user/driver-tip';

  //Support Ticket
  static String ticketTitles = 'api/v1/common/ticket-titles';
  static String makeTicket = 'api/v1/common/make-ticket';
  static String replyTicket = 'api/v1/common/reply-message';
  static String viewTicket = 'api/v1/common/view-ticket';
  static String ticketList = 'api/v1/common/list';
  static String getServiceLocation = 'api/v1/servicelocation';

  //Change payment
  static String changePaymentMethod = 'api/v1/request/user/payment-method';

  // privacy && terms
  static String termsAndPrivacyHtml = 'api/v1/common/mobile/';

//referal
  static String referralResponse = 'api/v1/common/referral/referral-condition';
  static String referalHistory = 'api/v1/common/referral/history';

  //downloadInvoice
  static String downloadInvoiceUser = 'api/v1/user/download-invoice/';

  //promo list
  static String promoCodeList = 'api/v1/request/promocode-list';
  static String promotionsPopup = 'api/v1/promotions/popup';
  static String promoCodeRedeem = 'api/v1/request/promocode-redeem';
  static String promoCodeClear = 'api/v1/request/promocode-clear';

  //Documents
  static String neededDocuments = 'api/v1/user/documents/needed';
  static String uploadDocument = 'api/v1/user/upload/documents';
}
