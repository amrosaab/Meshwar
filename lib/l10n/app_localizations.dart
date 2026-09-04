import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('az'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('sq'),
    Locale('vi')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @continueN.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueN;

  /// No description provided for @selectContry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectContry;

  /// No description provided for @emailAddressOrMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Email address or mobile number'**
  String get emailAddressOrMobileNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the'**
  String get byContinuing;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'terms of service'**
  String get terms;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'privacy policy'**
  String get privacyPolicy;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get chooseLanguage;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @validEmailMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email or mobile number'**
  String get validEmailMobile;

  /// No description provided for @enterEmailMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter email or mobile number'**
  String get enterEmailMobile;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @otpSendContent.
  ///
  /// In en, this message translates to:
  /// **'An One Time Password (OTP) has been sent to this number or email'**
  String get otpSendContent;

  /// No description provided for @passwordContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter the password you have set for the number or email below'**
  String get passwordContent;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'CHANGE'**
  String get change;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signInUsingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sign in using OTP'**
  String get signInUsingOtp;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @signInUsingPass.
  ///
  /// In en, this message translates to:
  /// **'Sign in using password'**
  String get signInUsingPass;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterYourMobile;

  /// No description provided for @validMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get validMobile;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get validEmail;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @isThisCorrect.
  ///
  /// In en, this message translates to:
  /// **'Is this correct ? '**
  String get isThisCorrect;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @typeofRide.
  ///
  /// In en, this message translates to:
  /// **'Type of Ride'**
  String get typeofRide;

  /// No description provided for @fareBreakup.
  ///
  /// In en, this message translates to:
  /// **'Fare Breakup'**
  String get fareBreakup;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// No description provided for @distancePrice.
  ///
  /// In en, this message translates to:
  /// **'Distance Price'**
  String get distancePrice;

  /// No description provided for @timePrice.
  ///
  /// In en, this message translates to:
  /// **'Time Price'**
  String get timePrice;

  /// No description provided for @waitingPrice.
  ///
  /// In en, this message translates to:
  /// **'Waiting Price'**
  String get waitingPrice;

  /// No description provided for @convenienceFee.
  ///
  /// In en, this message translates to:
  /// **'Convenience Fee'**
  String get convenienceFee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @taxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get taxes;

  /// No description provided for @tripSummary.
  ///
  /// In en, this message translates to:
  /// **'Trip Summary'**
  String get tripSummary;

  /// No description provided for @enterUserName.
  ///
  /// In en, this message translates to:
  /// **'Please enter user name'**
  String get enterUserName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get enterEmail;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get enterMobile;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enterPassword;

  /// No description provided for @validPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid password'**
  String get validPassword;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @minPassRequired.
  ///
  /// In en, this message translates to:
  /// **'minimum 8 characters required'**
  String get minPassRequired;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @applyRefferal.
  ///
  /// In en, this message translates to:
  /// **'Apply Refferal'**
  String get applyRefferal;

  /// No description provided for @enterRefferalCode.
  ///
  /// In en, this message translates to:
  /// **'Enter refferal code'**
  String get enterRefferalCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get myAccount;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @referEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referEarn;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @favoriteLocation.
  ///
  /// In en, this message translates to:
  /// **'Favorite Location'**
  String get favoriteLocation;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @mapAppearance.
  ///
  /// In en, this message translates to:
  /// **'Map Appearance'**
  String get mapAppearance;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat With Us'**
  String get chatWithUs;

  /// No description provided for @makeComplaint.
  ///
  /// In en, this message translates to:
  /// **'Make Complaint'**
  String get makeComplaint;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @privacyPolicyAccounts.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyAccounts;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address '**
  String get emailAddress;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @whereAreYouGoing.
  ///
  /// In en, this message translates to:
  /// **'Where are you going ?'**
  String get whereAreYouGoing;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @taxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get taxi;

  /// No description provided for @commercial.
  ///
  /// In en, this message translates to:
  /// **'Commercial'**
  String get commercial;

  /// No description provided for @sendAndReceive.
  ///
  /// In en, this message translates to:
  /// **'Send and Receive Packages with Ease'**
  String get sendAndReceive;

  /// No description provided for @ourParcelService.
  ///
  /// In en, this message translates to:
  /// **'Our parcel services make sending and receiving packages simple and convenient'**
  String get ourParcelService;

  /// No description provided for @sendParcel.
  ///
  /// In en, this message translates to:
  /// **'Send Parcel'**
  String get sendParcel;

  /// No description provided for @receiveParcel.
  ///
  /// In en, this message translates to:
  /// **'Receive Parcel'**
  String get receiveParcel;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @youCanEdit.
  ///
  /// In en, this message translates to:
  /// **'You can edit your *** here'**
  String get youCanEdit;

  /// No description provided for @noNotification.
  ///
  /// In en, this message translates to:
  /// **'No notifications available'**
  String get noNotification;

  /// No description provided for @historyDetails.
  ///
  /// In en, this message translates to:
  /// **'History Details'**
  String get historyDetails;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'Upi'**
  String get upi;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get mins;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'KM'**
  String get km;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @rental.
  ///
  /// In en, this message translates to:
  /// **'Rental 111'**
  String get rental;

  /// No description provided for @bidding.
  ///
  /// In en, this message translates to:
  /// **'Bidding'**
  String get bidding;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// No description provided for @transferMoney.
  ///
  /// In en, this message translates to:
  /// **'Transfer Money'**
  String get transferMoney;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @enterAmountHere.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount Here'**
  String get enterAmountHere;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @shareYourInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Share your invite code'**
  String get shareYourInviteCode;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @tapAddAddress.
  ///
  /// In en, this message translates to:
  /// **'Tap to add address'**
  String get tapAddAddress;

  /// No description provided for @newaddress.
  ///
  /// In en, this message translates to:
  /// **'New Address'**
  String get newaddress;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get deleteAddress;

  /// No description provided for @deleteAddressSubText.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from all services'**
  String get deleteAddressSubText;

  /// No description provided for @deleteSos.
  ///
  /// In en, this message translates to:
  /// **'Delete Sos'**
  String get deleteSos;

  /// No description provided for @deleteContact.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to Delete this Contact?'**
  String get deleteContact;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add a Contact'**
  String get addContact;

  /// No description provided for @nososContacts.
  ///
  /// In en, this message translates to:
  /// **'No SOS contacts found.'**
  String get nososContacts;

  /// No description provided for @addContactsText.
  ///
  /// In en, this message translates to:
  /// **'Add contacts now to ensure your safety.'**
  String get addContactsText;

  /// No description provided for @selectContact.
  ///
  /// In en, this message translates to:
  /// **'Select Contact'**
  String get selectContact;

  /// No description provided for @adminChat.
  ///
  /// In en, this message translates to:
  /// **'Admin Chat'**
  String get adminChat;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @chooseComplaint.
  ///
  /// In en, this message translates to:
  /// **'Choose your complaint'**
  String get chooseComplaint;

  /// No description provided for @complaintdetails.
  ///
  /// In en, this message translates to:
  /// **'Complaint Details'**
  String get complaintdetails;

  /// No description provided for @writeYourComplaint.
  ///
  /// In en, this message translates to:
  /// **'Write your complaint here...'**
  String get writeYourComplaint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @complaintLength.
  ///
  /// In en, this message translates to:
  /// **'Complaint must be at least * characters long.'**
  String get complaintLength;

  /// No description provided for @complaintSubmited.
  ///
  /// In en, this message translates to:
  /// **'Complaint has been submitted'**
  String get complaintSubmited;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @comeBackSoon.
  ///
  /// In en, this message translates to:
  /// **'Come back soon!'**
  String get comeBackSoon;

  /// No description provided for @logoutText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you want to Logout?'**
  String get logoutText;

  /// No description provided for @deleteText.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will erase all personal data. Do you want to proceed?'**
  String get deleteText;

  /// No description provided for @deleteDetailText.
  ///
  /// In en, this message translates to:
  /// **'We have received your request to delete your account. It will be deactivated within ** hours and permanently deleted after *** days, along with any unused credits, promotions, or rewards.'**
  String get deleteDetailText;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history found.'**
  String get noHistory;

  /// No description provided for @noHistoryText.
  ///
  /// In en, this message translates to:
  /// **'Make a new booking to view it here.'**
  String get noHistoryText;

  /// No description provided for @pickupAddress.
  ///
  /// In en, this message translates to:
  /// **'Pickup address'**
  String get pickupAddress;

  /// No description provided for @destinationAddress.
  ///
  /// In en, this message translates to:
  /// **'Destination address'**
  String get destinationAddress;

  /// No description provided for @addStopAddress.
  ///
  /// In en, this message translates to:
  /// **'Add stop address'**
  String get addStopAddress;

  /// No description provided for @selectFromMap.
  ///
  /// In en, this message translates to:
  /// **'Select from Map'**
  String get selectFromMap;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @searchResult.
  ///
  /// In en, this message translates to:
  /// **'Search Result'**
  String get searchResult;

  /// No description provided for @minimumSearchLength.
  ///
  /// In en, this message translates to:
  /// **'Please enter minimum * characters to search'**
  String get minimumSearchLength;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search places'**
  String get searchPlaces;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @recentSearchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get recentSearchHistory;

  /// No description provided for @receiverDetails.
  ///
  /// In en, this message translates to:
  /// **'Receiver Details'**
  String get receiverDetails;

  /// No description provided for @receiveMyself.
  ///
  /// In en, this message translates to:
  /// **'Receive MySelf'**
  String get receiveMyself;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @selectReceiver.
  ///
  /// In en, this message translates to:
  /// **'Select Receiver'**
  String get selectReceiver;

  /// No description provided for @senderDetails.
  ///
  /// In en, this message translates to:
  /// **'Sender Details'**
  String get senderDetails;

  /// No description provided for @sendMyself.
  ///
  /// In en, this message translates to:
  /// **'Send MySelf'**
  String get sendMyself;

  /// No description provided for @onDemand.
  ///
  /// In en, this message translates to:
  /// **'On Demand'**
  String get onDemand;

  /// No description provided for @rideDetails.
  ///
  /// In en, this message translates to:
  /// **'Ride details'**
  String get rideDetails;

  /// No description provided for @preference.
  ///
  /// In en, this message translates to:
  /// **'Select Your Preference'**
  String get preference;

  /// No description provided for @luggage.
  ///
  /// In en, this message translates to:
  /// **'Luggage'**
  String get luggage;

  /// No description provided for @pet.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get pet;

  /// No description provided for @rideNow.
  ///
  /// In en, this message translates to:
  /// **'Ride Now'**
  String get rideNow;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get coupon;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @scheduleRide.
  ///
  /// In en, this message translates to:
  /// **'Schedule Ride'**
  String get scheduleRide;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get applyCoupon;

  /// No description provided for @applyCouponText.
  ///
  /// In en, this message translates to:
  /// **'Apply coupon to claim the offer'**
  String get applyCouponText;

  /// No description provided for @couponInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid coupon code'**
  String get couponInvalid;

  /// No description provided for @choosePayment.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment'**
  String get choosePayment;

  /// No description provided for @rideFare.
  ///
  /// In en, this message translates to:
  /// **'Ride Fare'**
  String get rideFare;

  /// No description provided for @estimateFare.
  ///
  /// In en, this message translates to:
  /// **'Total estimated fare.'**
  String get estimateFare;

  /// No description provided for @infoText.
  ///
  /// In en, this message translates to:
  /// **'The price may change if you modify the pickup or drop-off location.'**
  String get infoText;

  /// No description provided for @infoWaitingPrice.
  ///
  /// In en, this message translates to:
  /// **'Waiting charges of *** per minute apply after the driver has been waiting for * minutes.'**
  String get infoWaitingPrice;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @dropLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop Location'**
  String get dropLocation;

  /// No description provided for @offerYourFare.
  ///
  /// In en, this message translates to:
  /// **'Offer Your Fare'**
  String get offerYourFare;

  /// No description provided for @minimumRecommendedFare.
  ///
  /// In en, this message translates to:
  /// **'Recommended fare minimum ***'**
  String get minimumRecommendedFare;

  /// No description provided for @createRequest.
  ///
  /// In en, this message translates to:
  /// **'Create Request'**
  String get createRequest;

  /// No description provided for @discoverYourDriver.
  ///
  /// In en, this message translates to:
  /// **'Discover your Driver'**
  String get discoverYourDriver;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @manageRide.
  ///
  /// In en, this message translates to:
  /// **'Manage Ride'**
  String get manageRide;

  /// No description provided for @cancelRide.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancelRide;

  /// No description provided for @cancelRideText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to cancel this ride?'**
  String get cancelRideText;

  /// No description provided for @lookingNearbyDrivers.
  ///
  /// In en, this message translates to:
  /// **'Looking For Nearby Drivers'**
  String get lookingNearbyDrivers;

  /// No description provided for @currentFare.
  ///
  /// In en, this message translates to:
  /// **'Current Fare'**
  String get currentFare;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'Driver is on the way'**
  String get onTheWay;

  /// No description provided for @driverArriveText.
  ///
  /// In en, this message translates to:
  /// **'The driver will arrive within ** minutes be ready to meet him.'**
  String get driverArriveText;

  /// No description provided for @rideCharge.
  ///
  /// In en, this message translates to:
  /// **'Ride Charge'**
  String get rideCharge;

  /// No description provided for @selectCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Please select the reason for cancellation'**
  String get selectCancelReason;

  /// No description provided for @driverArrived.
  ///
  /// In en, this message translates to:
  /// **'Driver Arrived'**
  String get driverArrived;

  /// No description provided for @arrivedMessage.
  ///
  /// In en, this message translates to:
  /// **'After * minutes, a *** /min surcharge applies for additional waiting time.'**
  String get arrivedMessage;

  /// No description provided for @reachingDestination.
  ///
  /// In en, this message translates to:
  /// **'Reaching Destination'**
  String get reachingDestination;

  /// No description provided for @leaveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Leave Feedback'**
  String get leaveFeedback;

  /// No description provided for @lastRideReview.
  ///
  /// In en, this message translates to:
  /// **'How was your last ride with *?'**
  String get lastRideReview;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @loadingUnloadingTimeInfo.
  ///
  /// In en, this message translates to:
  /// **'Free ** mins of loading-unloading time included'**
  String get loadingUnloadingTimeInfo;

  /// No description provided for @tripFare.
  ///
  /// In en, this message translates to:
  /// **'Trip Fare'**
  String get tripFare;

  /// No description provided for @amountPayable.
  ///
  /// In en, this message translates to:
  /// **'Amount Payable'**
  String get amountPayable;

  /// No description provided for @goodsType.
  ///
  /// In en, this message translates to:
  /// **'Goods Type'**
  String get goodsType;

  /// No description provided for @selectGoodsType.
  ///
  /// In en, this message translates to:
  /// **'Select goods type'**
  String get selectGoodsType;

  /// No description provided for @sender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get sender;

  /// No description provided for @receiver.
  ///
  /// In en, this message translates to:
  /// **'Receiver'**
  String get receiver;

  /// No description provided for @payAt.
  ///
  /// In en, this message translates to:
  /// **'Pay at'**
  String get payAt;

  /// No description provided for @changeLower.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeLower;

  /// No description provided for @readBeforeBooking.
  ///
  /// In en, this message translates to:
  /// **'Read before booking'**
  String get readBeforeBooking;

  /// No description provided for @deliveryInfoLoadingTime.
  ///
  /// In en, this message translates to:
  /// **'The fare includes ** minutes of free loading and unloading time.'**
  String get deliveryInfoLoadingTime;

  /// No description provided for @deliveryInfoLoadingCharged.
  ///
  /// In en, this message translates to:
  /// **'Additional loading or unloading time will be charged at *** per minute.'**
  String get deliveryInfoLoadingCharged;

  /// No description provided for @deliveryInfoFare.
  ///
  /// In en, this message translates to:
  /// **'The fare may vary if there are changes in the route or location.'**
  String get deliveryInfoFare;

  /// No description provided for @deliveryInfoParkingCharge.
  ///
  /// In en, this message translates to:
  /// **'Customers are responsible for any parking charges incurred.'**
  String get deliveryInfoParkingCharge;

  /// No description provided for @deliveryInfoOverloading.
  ///
  /// In en, this message translates to:
  /// **'Overloading is strictly prohibited.'**
  String get deliveryInfoOverloading;

  /// No description provided for @loose.
  ///
  /// In en, this message translates to:
  /// **'Loose'**
  String get loose;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @notifyAdmin.
  ///
  /// In en, this message translates to:
  /// **'Notify Admin'**
  String get notifyAdmin;

  /// No description provided for @sosContacts.
  ///
  /// In en, this message translates to:
  /// **'SOS Contats'**
  String get sosContacts;

  /// No description provided for @sosRideEmergencyText.
  ///
  /// In en, this message translates to:
  /// **'By clicking this button, the admin will be notified that you are in an emergency.'**
  String get sosRideEmergencyText;

  /// No description provided for @notifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Notified Successfully.'**
  String get notifiedSuccessfully;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @onGoingRides.
  ///
  /// In en, this message translates to:
  /// **'OnGoing Rides'**
  String get onGoingRides;

  /// No description provided for @arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// No description provided for @tripStarted.
  ///
  /// In en, this message translates to:
  /// **'Trip Started'**
  String get tripStarted;

  /// No description provided for @loadShipmentProof.
  ///
  /// In en, this message translates to:
  /// **'Load Shipment Proof'**
  String get loadShipmentProof;

  /// No description provided for @uploadShipmentProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Shipment Proof'**
  String get uploadShipmentProof;

  /// No description provided for @complaintListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No complaint list available.'**
  String get complaintListEmpty;

  /// No description provided for @enterTheCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please enter the credentials'**
  String get enterTheCredentials;

  /// No description provided for @failedUpdateDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to update details'**
  String get failedUpdateDetails;

  /// No description provided for @clearNotifications.
  ///
  /// In en, this message translates to:
  /// **'Clear Notifications'**
  String get clearNotifications;

  /// No description provided for @clearNotificationsText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you clear all notifications?'**
  String get clearNotificationsText;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @deleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get deleteNotification;

  /// No description provided for @deleteNotificationText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to Delete this Notification?'**
  String get deleteNotificationText;

  /// No description provided for @returnTrip.
  ///
  /// In en, this message translates to:
  /// **'Return trip'**
  String get returnTrip;

  /// No description provided for @oneWayTrip.
  ///
  /// In en, this message translates to:
  /// **'One way trip'**
  String get oneWayTrip;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get noDataAvailable;

  /// No description provided for @mapSettings.
  ///
  /// In en, this message translates to:
  /// **'Map Settings'**
  String get mapSettings;

  /// No description provided for @googleMap.
  ///
  /// In en, this message translates to:
  /// **'Google Map'**
  String get googleMap;

  /// No description provided for @openStreet.
  ///
  /// In en, this message translates to:
  /// **'Open Street'**
  String get openStreet;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @selectCards.
  ///
  /// In en, this message translates to:
  /// **'Select Cards'**
  String get selectCards;

  /// No description provided for @selectCardText.
  ///
  /// In en, this message translates to:
  /// **'You can choose which card numbers you want to display in the list of payment methods on the invoice.'**
  String get selectCardText;

  /// No description provided for @addCard.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get addCard;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @okText.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okText;

  /// No description provided for @referralCodeCopy.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied to clipboard!'**
  String get referralCodeCopy;

  /// No description provided for @referralInviteText.
  ///
  /// In en, this message translates to:
  /// **'Join me on **! using my invite code **** To make easy your ride'**
  String get referralInviteText;

  /// No description provided for @rideLater.
  ///
  /// In en, this message translates to:
  /// **'Ride later'**
  String get rideLater;

  /// No description provided for @rideLaterCancelText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this ride?'**
  String get rideLaterCancelText;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Details updated successfully'**
  String get updateSuccess;

  /// No description provided for @updateText.
  ///
  /// In en, this message translates to:
  /// **'Update ***'**
  String get updateText;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Success!'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed!'**
  String get paymentFailed;

  /// No description provided for @paymenyHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payment history yet.'**
  String get paymenyHistoryEmpty;

  /// No description provided for @paymenyHistoryEmptyText.
  ///
  /// In en, this message translates to:
  /// **'Start your journey by booking a ride today!'**
  String get paymenyHistoryEmptyText;

  /// No description provided for @cameraText.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraText;

  /// No description provided for @galleryText.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryText;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @preferNotSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotSay;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @noRidesFound.
  ///
  /// In en, this message translates to:
  /// **'No Rides Found'**
  String get noRidesFound;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @exclusiveOffers.
  ///
  /// In en, this message translates to:
  /// **'Exclusive offers'**
  String get exclusiveOffers;

  /// No description provided for @pleaseSelectReceiver.
  ///
  /// In en, this message translates to:
  /// **'Please select the receiver'**
  String get pleaseSelectReceiver;

  /// No description provided for @pleaseEnterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get pleaseEnterQuantity;

  /// No description provided for @driverArrivedLocation.
  ///
  /// In en, this message translates to:
  /// **'Driver has arrived at the location'**
  String get driverArrivedLocation;

  /// No description provided for @reachingDestinationInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Reaching Destination in ***'**
  String get reachingDestinationInMinutes;

  /// No description provided for @noDriverFound.
  ///
  /// In en, this message translates to:
  /// **'No Drivers Found. Try Again Later.'**
  String get noDriverFound;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @availableDrivers.
  ///
  /// In en, this message translates to:
  /// **'Available drivers'**
  String get availableDrivers;

  /// No description provided for @offeredRideFare.
  ///
  /// In en, this message translates to:
  /// **'Offered ride fare ***'**
  String get offeredRideFare;

  /// No description provided for @pleaseSelectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please select credentials'**
  String get pleaseSelectCredentials;

  /// No description provided for @pleaseGiveRatings.
  ///
  /// In en, this message translates to:
  /// **'Please give ratings'**
  String get pleaseGiveRatings;

  /// No description provided for @rideCancelled.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled'**
  String get rideCancelled;

  /// No description provided for @rideCancelledByDriver.
  ///
  /// In en, this message translates to:
  /// **'Ride was cancelled by driver'**
  String get rideCancelledByDriver;

  /// No description provided for @rideScheduledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ride scheduled successfully'**
  String get rideScheduledSuccessfully;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @adminCommission.
  ///
  /// In en, this message translates to:
  /// **'Admin Commission'**
  String get adminCommission;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @minimumRideFareError.
  ///
  /// In en, this message translates to:
  /// **'Offer ride fare must be greater than minimum fare.'**
  String get minimumRideFareError;

  /// No description provided for @maximumRideFareError.
  ///
  /// In en, this message translates to:
  /// **'Offer ride fare must lesser than maximum fare.'**
  String get maximumRideFareError;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @totalRides.
  ///
  /// In en, this message translates to:
  /// **'Total Rides'**
  String get totalRides;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'OTHERS'**
  String get others;

  /// No description provided for @national.
  ///
  /// In en, this message translates to:
  /// **'National'**
  String get national;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @openBody.
  ///
  /// In en, this message translates to:
  /// **'Open Body'**
  String get openBody;

  /// No description provided for @packBody.
  ///
  /// In en, this message translates to:
  /// **'Pack Body'**
  String get packBody;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @capacityContent.
  ///
  /// In en, this message translates to:
  /// **'You can select the desired passenger range here'**
  String get capacityContent;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categoryContent.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred vehicle category below'**
  String get categoryContent;

  /// No description provided for @permit.
  ///
  /// In en, this message translates to:
  /// **'Permit'**
  String get permit;

  /// No description provided for @permitContent.
  ///
  /// In en, this message translates to:
  /// **'Select the appropriate permit below'**
  String get permitContent;

  /// No description provided for @bodyType.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyType;

  /// No description provided for @bodyTypeContent.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred body type below'**
  String get bodyTypeContent;

  /// No description provided for @applyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilter;

  /// No description provided for @pleaseSelectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Please select the vehicle'**
  String get pleaseSelectVehicle;

  /// No description provided for @notValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'The provided phone number is not valid'**
  String get notValidPhoneNumber;

  /// No description provided for @otpSendTo.
  ///
  /// In en, this message translates to:
  /// **'OTP send to ***'**
  String get otpSendTo;

  /// No description provided for @otpForLogin.
  ///
  /// In en, this message translates to:
  /// **'Otp for Login'**
  String get otpForLogin;

  /// No description provided for @testOtp.
  ///
  /// In en, this message translates to:
  /// **'Login to your account with test OTP ***'**
  String get testOtp;

  /// No description provided for @enterValidOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid OTP'**
  String get enterValidOtp;

  /// No description provided for @verifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Verified Successfully'**
  String get verifySuccess;

  /// No description provided for @pleaseEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'please enter the OTP'**
  String get pleaseEnterOtp;

  /// No description provided for @selectProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Select Profile Image'**
  String get selectProfileImage;

  /// No description provided for @pleaseEnterRefferalCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter referral code'**
  String get pleaseEnterRefferalCode;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login Successfully'**
  String get loginSuccess;

  /// No description provided for @passCheck.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get passCheck;

  /// No description provided for @minComplaintText.
  ///
  /// In en, this message translates to:
  /// **'Complaint text must be more than *** characters'**
  String get minComplaintText;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registered Successfully'**
  String get registerSuccess;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @noInternetCheckContent.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet settings'**
  String get noInternetCheckContent;

  /// No description provided for @recentSearchRoutes.
  ///
  /// In en, this message translates to:
  /// **'Search Routes'**
  String get recentSearchRoutes;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @selectPackage.
  ///
  /// In en, this message translates to:
  /// **'Select Package'**
  String get selectPackage;

  /// No description provided for @pleaseSelectGoodsType.
  ///
  /// In en, this message translates to:
  /// **'Please Select Goods Type'**
  String get pleaseSelectGoodsType;

  /// No description provided for @enterCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Card Details'**
  String get enterCardDetails;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save Card'**
  String get saveCard;

  /// No description provided for @selectedPackage.
  ///
  /// In en, this message translates to:
  /// **'Selected Package'**
  String get selectedPackage;

  /// No description provided for @otherReason.
  ///
  /// In en, this message translates to:
  /// **'Other Reason'**
  String get otherReason;

  /// No description provided for @locationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location access is needed for running the app, please enable it in settings and tap done'**
  String get locationAccess;

  /// No description provided for @openSetting.
  ///
  /// In en, this message translates to:
  /// **'Open Setting'**
  String get openSetting;

  /// No description provided for @additional.
  ///
  /// In en, this message translates to:
  /// **'Additional'**
  String get additional;

  /// No description provided for @baseDistancePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Distance Price'**
  String get baseDistancePrice;

  /// No description provided for @locationPermissionAllow.
  ///
  /// In en, this message translates to:
  /// **'allow location permission to get your current location'**
  String get locationPermissionAllow;

  /// No description provided for @addStop.
  ///
  /// In en, this message translates to:
  /// **'Add Stop'**
  String get addStop;

  /// No description provided for @outStation.
  ///
  /// In en, this message translates to:
  /// **'Outstation'**
  String get outStation;

  /// No description provided for @pleaseSelectReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Please select return date'**
  String get pleaseSelectReturnDate;

  /// No description provided for @getDropOff.
  ///
  /// In en, this message translates to:
  /// **'Get Dropped off'**
  String get getDropOff;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// No description provided for @keepTheCarTillReturn.
  ///
  /// In en, this message translates to:
  /// **'Keep the car till return'**
  String get keepTheCarTillReturn;

  /// No description provided for @leaveOn.
  ///
  /// In en, this message translates to:
  /// **'Leave On'**
  String get leaveOn;

  /// No description provided for @returnBy.
  ///
  /// In en, this message translates to:
  /// **'Return By'**
  String get returnBy;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @offeredRide.
  ///
  /// In en, this message translates to:
  /// **'Offered Ride'**
  String get offeredRide;

  /// No description provided for @myOfferedFare.
  ///
  /// In en, this message translates to:
  /// **'My Offered Fare'**
  String get myOfferedFare;

  /// No description provided for @assigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get assigned;

  /// No description provided for @unAssigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unAssigned;

  /// No description provided for @biddingLimitCrossed.
  ///
  /// In en, this message translates to:
  /// **'Bidding Limit Crossed'**
  String get biddingLimitCrossed;

  /// No description provided for @chooseAdriver.
  ///
  /// In en, this message translates to:
  /// **'Choose a Driver'**
  String get chooseAdriver;

  /// No description provided for @noBidRideContent.
  ///
  /// In en, this message translates to:
  /// **'No bids yet for your ride. We\'re finding drivers—please check back soon!'**
  String get noBidRideContent;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, User'**
  String get welcomeUser;

  /// No description provided for @minTime.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minTime;

  /// No description provided for @pleaseEnterTheValidData.
  ///
  /// In en, this message translates to:
  /// **'Please enter the valid data'**
  String get pleaseEnterTheValidData;

  /// No description provided for @registeredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Registered Successfully'**
  String get registeredSuccessfully;

  /// No description provided for @lowWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Low wallet balance'**
  String get lowWalletBalance;

  /// No description provided for @getYourCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'allow location permission to get your current location'**
  String get getYourCurrentLocation;

  /// No description provided for @serviceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Service not available for this location'**
  String get serviceNotAvailable;

  /// No description provided for @cancellationFee.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Fee'**
  String get cancellationFee;

  /// No description provided for @ride.
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get ride;

  /// No description provided for @additionalCharges.
  ///
  /// In en, this message translates to:
  /// **'Additional Charges'**
  String get additionalCharges;

  /// No description provided for @showAppreciationTip.
  ///
  /// In en, this message translates to:
  /// **'Show appreciation with a tip!'**
  String get showAppreciationTip;

  /// No description provided for @addTip.
  ///
  /// In en, this message translates to:
  /// **'Add Tip'**
  String get addTip;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @waitingChargeText.
  ///
  /// In en, this message translates to:
  /// **'a * /min surcharge applies for additional waiting time.'**
  String get waitingChargeText;

  /// No description provided for @addTipError.
  ///
  /// In en, this message translates to:
  /// **'Please fill the tips field'**
  String get addTipError;

  /// No description provided for @pickMeHere.
  ///
  /// In en, this message translates to:
  /// **'Pick me here'**
  String get pickMeHere;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @supportTicket.
  ///
  /// In en, this message translates to:
  /// **'Support Ticket'**
  String get supportTicket;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get cardDetails;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @createTicket.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get createTicket;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @selectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Title'**
  String get selectTitle;

  /// No description provided for @selectArea.
  ///
  /// In en, this message translates to:
  /// **'Select Area'**
  String get selectArea;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description :'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter Description'**
  String get enterDescription;

  /// No description provided for @ticketId.
  ///
  /// In en, this message translates to:
  /// **'Ticket ID :'**
  String get ticketId;

  /// No description provided for @titleColonText.
  ///
  /// In en, this message translates to:
  /// **'Title :'**
  String get titleColonText;

  /// No description provided for @assignTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to :'**
  String get assignTo;

  /// No description provided for @requestType.
  ///
  /// In en, this message translates to:
  /// **'Request Type'**
  String get requestType;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @opened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get opened;

  /// No description provided for @acknowledged.
  ///
  /// In en, this message translates to:
  /// **'Acknowledged'**
  String get acknowledged;

  /// No description provided for @viewTicket.
  ///
  /// In en, this message translates to:
  /// **'View Ticket :'**
  String get viewTicket;

  /// No description provided for @deleteCardText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to delete this card ?'**
  String get deleteCardText;

  /// No description provided for @supportType.
  ///
  /// In en, this message translates to:
  /// **'Support Type :'**
  String get supportType;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not Assigned'**
  String get notAssigned;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments : '**
  String get attachments;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send '**
  String get send;

  /// No description provided for @fillTheMessageField.
  ///
  /// In en, this message translates to:
  /// **'Please Fill the message field'**
  String get fillTheMessageField;

  /// No description provided for @supportEmptyText.
  ///
  /// In en, this message translates to:
  /// **'No support tickets found.'**
  String get supportEmptyText;

  /// No description provided for @supportEmptySubText.
  ///
  /// In en, this message translates to:
  /// **'Need help? Create a new support request.'**
  String get supportEmptySubText;

  /// No description provided for @replyText.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyText;

  /// No description provided for @messageText.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageText;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter Message...'**
  String get enterMessage;

  /// No description provided for @fileLimitReached.
  ///
  /// In en, this message translates to:
  /// **'File Limit Reached'**
  String get fileLimitReached;

  /// No description provided for @messageSuccessText.
  ///
  /// In en, this message translates to:
  /// **'Reply Message Sent Successfully'**
  String get messageSuccessText;

  /// No description provided for @noMessagesHere.
  ///
  /// In en, this message translates to:
  /// **'No Messages Here'**
  String get noMessagesHere;

  /// No description provided for @noAttachmentsText.
  ///
  /// In en, this message translates to:
  /// **'No Attachments Here'**
  String get noAttachmentsText;

  /// No description provided for @uploadMaxFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File (Max: 8 Files)'**
  String get uploadMaxFile;

  /// No description provided for @filesUploaded.
  ///
  /// In en, this message translates to:
  /// **'File(s) Uploaded'**
  String get filesUploaded;

  /// No description provided for @noVehicleTypes.
  ///
  /// In en, this message translates to:
  /// **'No vehicle types available for this location'**
  String get noVehicleTypes;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @fillTheRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Please Fill the required field'**
  String get fillTheRequiredField;

  /// No description provided for @requestId.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestId;

  /// No description provided for @ticketCreated.
  ///
  /// In en, this message translates to:
  /// **'Ticket Created'**
  String get ticketCreated;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @reportIssues.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssues;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @permissionDeniedText.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDeniedText;

  /// No description provided for @colorText.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorText;

  /// No description provided for @savedCards.
  ///
  /// In en, this message translates to:
  /// **'Saved Cards'**
  String get savedCards;

  /// No description provided for @downloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get downloadInvoice;

  /// No description provided for @addInstructions.
  ///
  /// In en, this message translates to:
  /// **'Add Instructions'**
  String get addInstructions;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @invoiceSendContent.
  ///
  /// In en, this message translates to:
  /// **'Invoice send to your registered email'**
  String get invoiceSendContent;

  /// No description provided for @airportSurgefee.
  ///
  /// In en, this message translates to:
  /// **'Airport Surge Fee'**
  String get airportSurgefee;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @searchByVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by vehicle number'**
  String get searchByVehicleNumber;

  /// No description provided for @satellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get satellite;

  /// No description provided for @terrain.
  ///
  /// In en, this message translates to:
  /// **'Terrain'**
  String get terrain;

  /// No description provided for @hybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get hybrid;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @maxDistanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Distance is too long'**
  String get maxDistanceTitle;

  /// No description provided for @maxDistanceText.
  ///
  /// In en, this message translates to:
  /// **'Please make sure your route is within the limit.'**
  String get maxDistanceText;

  /// No description provided for @changeRoute.
  ///
  /// In en, this message translates to:
  /// **'Change Route'**
  String get changeRoute;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @convertToOutstation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to convert ride to Outstation?'**
  String get convertToOutstation;

  /// No description provided for @preferenceTotal.
  ///
  /// In en, this message translates to:
  /// **'Preference Charges'**
  String get preferenceTotal;

  /// No description provided for @preferenceNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Preference Not Available'**
  String get preferenceNotAvailable;

  /// No description provided for @selectSeats.
  ///
  /// In en, this message translates to:
  /// **'Select seats'**
  String get selectSeats;

  /// No description provided for @shareRide.
  ///
  /// In en, this message translates to:
  /// **'Share ride'**
  String get shareRide;

  /// No description provided for @yourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your Account'**
  String get yourAccount;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @addProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a Profile Photo so the driver can recognize you'**
  String get addProfilePhoto;

  /// No description provided for @smsVerification.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an SMS code for verification'**
  String get smsVerification;

  /// No description provided for @tripId.
  ///
  /// In en, this message translates to:
  /// **'Trip ID'**
  String get tripId;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @selectRecipientType.
  ///
  /// In en, this message translates to:
  /// **'Select recipient type and enter details'**
  String get selectRecipientType;

  /// No description provided for @yourId.
  ///
  /// In en, this message translates to:
  /// **'Your ID'**
  String get yourId;

  /// No description provided for @yourReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your Referral Code'**
  String get yourReferralCode;

  /// No description provided for @referAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer and Earn'**
  String get referAndEarn;

  /// No description provided for @referralHistory.
  ///
  /// In en, this message translates to:
  /// **'Referral History'**
  String get referralHistory;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get howItWorks;

  /// No description provided for @addFromContact.
  ///
  /// In en, this message translates to:
  /// **'Add from Contact'**
  String get addFromContact;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add Manually'**
  String get addManually;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @noReferralHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No Referral History Found'**
  String get noReferralHistoryFound;

  /// No description provided for @referralContentIsUnavailablePleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Referral content is unavailable. Please try again later.'**
  String get referralContentIsUnavailablePleaseTryAgainLater;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @noCardsAdded.
  ///
  /// In en, this message translates to:
  /// **'No Cards Added'**
  String get noCardsAdded;

  /// No description provided for @noWalletHistory.
  ///
  /// In en, this message translates to:
  /// **'No Wallet History'**
  String get noWalletHistory;

  /// No description provided for @enterNameIdOrPassport.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name as it appears on your ID or passport.'**
  String get enterNameIdOrPassport;

  /// No description provided for @enterYourGender.
  ///
  /// In en, this message translates to:
  /// **'Please enter your gender.'**
  String get enterYourGender;

  /// No description provided for @pleaseEnterMobileOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number or email to continue.'**
  String get pleaseEnterMobileOrEmail;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Dont Have an Account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUsingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sign in using OTP'**
  String get signUsingOtp;

  /// No description provided for @signUsingPassword.
  ///
  /// In en, this message translates to:
  /// **'Sign in using Password'**
  String get signUsingPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @verifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Account'**
  String get verifyYourAccount;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit code to'**
  String get sendCode;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Number'**
  String get changeNumber;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @enterValidMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get enterValidMobile;

  /// No description provided for @pleaseEnterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'please enter mobile number'**
  String get pleaseEnterMobileNumber;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get enterValidEmail;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself to get started.'**
  String get getStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already Have an Account?'**
  String get alreadyHaveAccount;

  /// No description provided for @confirmOtpNumber.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a one-time password (OTP) to this number to confirm your identity.'**
  String get confirmOtpNumber;

  /// No description provided for @verifyMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify your mobile number'**
  String get verifyMobileNumber;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone'**
  String get verifyPhone;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @userConnect.
  ///
  /// In en, this message translates to:
  /// **'User Connect'**
  String get userConnect;

  /// No description provided for @loginContent.
  ///
  /// In en, this message translates to:
  /// **'Login as User'**
  String get loginContent;

  /// No description provided for @addPrefrence.
  ///
  /// In en, this message translates to:
  /// **'AddPreference'**
  String get addPrefrence;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @planYourRide.
  ///
  /// In en, this message translates to:
  /// **'Plan your ride'**
  String get planYourRide;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @verifyEmailId.
  ///
  /// In en, this message translates to:
  /// **'Verify your email id'**
  String get verifyEmailId;

  /// No description provided for @verifyEmailText.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmailText;

  /// No description provided for @deliveryOutStation.
  ///
  /// In en, this message translates to:
  /// **'Delivery OutStation'**
  String get deliveryOutStation;

  /// No description provided for @deliveryRental.
  ///
  /// In en, this message translates to:
  /// **'Delivery Rental'**
  String get deliveryRental;

  /// No description provided for @deliveryRide.
  ///
  /// In en, this message translates to:
  /// **'Delivery Ride'**
  String get deliveryRide;

  /// No description provided for @pleaseContactAdminToBook.
  ///
  /// In en, this message translates to:
  /// **'Please contact admin to book your ride.'**
  String get pleaseContactAdminToBook;

  /// No description provided for @callAdmin.
  ///
  /// In en, this message translates to:
  /// **'Call Admin'**
  String get callAdmin;

  /// No description provided for @transferText.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferText;

  /// No description provided for @saveUptoText.
  ///
  /// In en, this message translates to:
  /// **'Save 111 on your ride!'**
  String get saveUptoText;

  /// No description provided for @promoInfoText.
  ///
  /// In en, this message translates to:
  /// **'Use promo code 111 and save up to 222 on bookings above 333'**
  String get promoInfoText;

  /// No description provided for @tapToApply.
  ///
  /// In en, this message translates to:
  /// **'Tap to apply'**
  String get tapToApply;

  /// No description provided for @couponAppliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Coupon applyed successfully'**
  String get couponAppliedSuccessfully;

  /// No description provided for @couponRemovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Coupon removed successfully'**
  String get couponRemovedSuccessfully;

  /// No description provided for @promoApplied.
  ///
  /// In en, this message translates to:
  /// **'111 applied'**
  String get promoApplied;

  /// No description provided for @appliedPromoText.
  ///
  /// In en, this message translates to:
  /// **'111 savings with this coupon.'**
  String get appliedPromoText;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'load more'**
  String get loadMore;

  /// No description provided for @agreeTermsText.
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get agreeTermsText;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @signupAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our'**
  String get signupAgree;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicyText.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy.'**
  String get privacyPolicyText;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @selectRecipentTypeDetails.
  ///
  /// In en, this message translates to:
  /// **'Select recipient type and enter details.'**
  String get selectRecipentTypeDetails;

  /// No description provided for @choosePaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get choosePaymentMethods;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @noVehiclesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No vehicles available'**
  String get noVehiclesAvailable;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @giveRatings.
  ///
  /// In en, this message translates to:
  /// **'Give Ratings'**
  String get giveRatings;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @acceptTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Please accept Terms & Conditions to continue'**
  String get acceptTermsAndConditions;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @contactsPermissionContent.
  ///
  /// In en, this message translates to:
  /// **'We need access to your contacts to add SOS contacts.'**
  String get contactsPermissionContent;

  /// No description provided for @contactsPermissionSettingsContent.
  ///
  /// In en, this message translates to:
  /// **'Contacts access is disabled. Please enable it from Settings to continue.'**
  String get contactsPermissionSettingsContent;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @invoiceDownloadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice downloaded successfully!'**
  String get invoiceDownloadedSuccessfully;

  /// No description provided for @invoiceDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Invoice download failed. Please try again.'**
  String get invoiceDownloadFailed;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @drop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get drop;

  /// No description provided for @referralContentUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Referral content is unavailable. Please try again later.'**
  String get referralContentUnavailable;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'111 selected'**
  String get selected;

  /// No description provided for @pleaseTryAgainFewMoments.
  ///
  /// In en, this message translates to:
  /// **'Please try again in a few moments.'**
  String get pleaseTryAgainFewMoments;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop 111'**
  String get stop;

  /// No description provided for @addAnyNotesRideSmoother.
  ///
  /// In en, this message translates to:
  /// **'Add any notes for the driver to make your ride smoother.'**
  String get addAnyNotesRideSmoother;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponCode;

  /// No description provided for @myself.
  ///
  /// In en, this message translates to:
  /// **'Myself'**
  String get myself;

  /// No description provided for @saveCards.
  ///
  /// In en, this message translates to:
  /// **'SAVED CARDS'**
  String get saveCards;

  /// No description provided for @walletOption.
  ///
  /// In en, this message translates to:
  /// **'WALLET'**
  String get walletOption;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'ONLINE PAYMENT'**
  String get onlinePayment;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified 111'**
  String get verified;

  /// No description provided for @veryBad.
  ///
  /// In en, this message translates to:
  /// **'Very Bad'**
  String get veryBad;

  /// No description provided for @bad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get bad;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get veryGood;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get great;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @choosePickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose pickup location'**
  String get choosePickupLocation;

  /// No description provided for @recentSearch.
  ///
  /// In en, this message translates to:
  /// **'Recent Search'**
  String get recentSearch;

  /// No description provided for @activeJourney.
  ///
  /// In en, this message translates to:
  /// **'Active Journey'**
  String get activeJourney;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live;

  /// No description provided for @pickupTime.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time:- '**
  String get pickupTime;

  /// No description provided for @someoneElseTakingThisRide.
  ///
  /// In en, this message translates to:
  /// **'Someone else taking this ride?'**
  String get someoneElseTakingThisRide;

  /// No description provided for @savedContacts.
  ///
  /// In en, this message translates to:
  /// **'Saved Contacts'**
  String get savedContacts;

  /// No description provided for @chooseContact.
  ///
  /// In en, this message translates to:
  /// **'Choose contact'**
  String get chooseContact;

  /// No description provided for @chooseLayout.
  ///
  /// In en, this message translates to:
  /// **'Choose Layout'**
  String get chooseLayout;

  /// No description provided for @classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classic;

  /// No description provided for @modern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get modern;

  /// No description provided for @selectedText.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedText;

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingsYet;

  /// No description provided for @youHaveAnyBookings.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any bookings yet. Create one to get started.'**
  String get youHaveAnyBookings;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @pricePerkm.
  ///
  /// In en, this message translates to:
  /// **'Price per km'**
  String get pricePerkm;

  /// No description provided for @pricePerMiles.
  ///
  /// In en, this message translates to:
  /// **'Price per mi'**
  String get pricePerMiles;

  /// No description provided for @rideoptions.
  ///
  /// In en, this message translates to:
  /// **'Ride Options'**
  String get rideoptions;

  /// No description provided for @activeride.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE RIDE'**
  String get activeride;

  /// No description provided for @requiredInfo.
  ///
  /// In en, this message translates to:
  /// **'Fill out this form'**
  String get requiredInfo;

  /// No description provided for @waitingForApprovelText.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Approval'**
  String get waitingForApprovelText;

  /// No description provided for @evaluatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Your document didn\'t meet our requirements'**
  String get evaluatingProfile;

  /// No description provided for @tapToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to Upload Image'**
  String get tapToUploadImage;

  /// No description provided for @pickImaeFrom.
  ///
  /// In en, this message translates to:
  /// **'Pick image from'**
  String get pickImaeFrom;

  /// No description provided for @profileDeclined.
  ///
  /// In en, this message translates to:
  /// **'Profile Declined'**
  String get profileDeclined;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocument;

  /// No description provided for @profileApprove.
  ///
  /// In en, this message translates to:
  /// **'Please review the guidelines and resubmit'**
  String get profileApprove;

  /// No description provided for @provideCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get provideCompanyName;

  /// No description provided for @reuploaded_declined.
  ///
  /// In en, this message translates to:
  /// **'Reuploaded and declined'**
  String get reuploaded_declined;

  /// No description provided for @reupload_document.
  ///
  /// In en, this message translates to:
  /// **'Reupload document'**
  String get reupload_document;

  /// No description provided for @reuploaded_waiting_approval.
  ///
  /// In en, this message translates to:
  /// **'Reuploaded and waiting for approval'**
  String get reuploaded_waiting_approval;

  /// No description provided for @view_document.
  ///
  /// In en, this message translates to:
  /// **'View document'**
  String get view_document;

  /// No description provided for @uploaded_approved.
  ///
  /// In en, this message translates to:
  /// **'Uploaded and approved'**
  String get uploaded_approved;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'az',
        'en',
        'es',
        'fr',
        'sq',
        'vi'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'sq':
      return AppLocalizationsSq();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
