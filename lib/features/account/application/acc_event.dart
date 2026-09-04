part of 'acc_bloc.dart';

abstract class AccEvent {}

class AccGetUserDetailsEvent extends AccEvent {}

class AccGetDirectionEvent extends AccEvent {}

class GetAppVersionEvent extends AccEvent {}

class ContainerClickedEvent extends AccEvent {}

class UpdateControllerWithDetailsEvent extends AccEvent {
  final UpdateDetailsArguments args;

  UpdateControllerWithDetailsEvent({required this.args});
}

class UserDetailsPageInitEvent extends AccEvent {
  final AccountPageArguments arg;

  UserDetailsPageInitEvent({required this.arg});
}

class NotificationGetEvent extends AccEvent {
  final int? pageNumber;

  NotificationGetEvent({this.pageNumber});
}

class ComplaintEvent extends AccEvent {
  final String? complaintType;

  ComplaintEvent({this.complaintType});
}

class DeleteNotificationEvent extends AccEvent {
  final String id;

  DeleteNotificationEvent({required this.id});
}

class ClearAllNotificationsEvent extends AccEvent {}

class HistoryGetEvent extends AccEvent {
  final String historyFilter;
  final int? pageNumber;
  final int? historyIndex;
  final bool? isFrom;

  HistoryGetEvent(
      {required this.historyFilter,
      this.pageNumber,
      this.historyIndex,
      this.isFrom});
}

class OutstationGetEvent extends AccEvent {
  final String id;

  OutstationGetEvent({required this.id});
}

class OutstationAcceptOrDeclineEvent extends AccEvent {
  final bool isAccept;
  final dynamic driver;
  final String id;
  final String offeredRideFare;

  OutstationAcceptOrDeclineEvent(
      {required this.isAccept,
      required this.driver,
      required this.id,
      required this.offeredRideFare});
}

class LogoutEvent extends AccEvent {}

class GetFaqListEvent extends AccEvent {}

class FaqOnTapEvent extends AccEvent {
  final int selectedFaqIndex;

  FaqOnTapEvent({required this.selectedFaqIndex});
}

class UpdateUserDetailsEvent extends AccEvent {
  final String name;
  final String email;
  final String gender;
  final String profileImage;
  final String? mapType;
  final String? mapShow;
  final String mobile;
  final String country;

  UpdateUserDetailsEvent(
      {required this.name,
      required this.email,
      required this.gender,
      required this.profileImage,
      this.mapType,
      this.mapShow,
      required this.mobile,
      required this.country});
}

class GenderSelectedEvent extends AccEvent {
  final String selectedGender;

  GenderSelectedEvent({required this.selectedGender});
}

class ChooseMapOnTapEvent extends AccEvent {
  final int chooseMapIndex;

  ChooseMapOnTapEvent({required this.chooseMapIndex});
}

class ComplaintButtonEvent extends AccEvent {
  final String complaintTitleId;
  final String complaintText;
  final String requestId;
  final BuildContext context;

  ComplaintButtonEvent(
      {required this.complaintTitleId,
      required this.complaintText,
      required this.requestId,
      required this.context});
}

class DeleteAccountEvent extends AccEvent {}

class HistoryTypeChangeEvent extends AccEvent {
  final int historyTypeIndex;

  HistoryTypeChangeEvent({required this.historyTypeIndex});
}

class GetWalletHistoryListEvent extends AccEvent {
  final int pageIndex;
  GetWalletHistoryListEvent({required this.pageIndex});
}

class TransferMoneySelectedEvent extends AccEvent {
  final String selectedTransferAmountMenuItem;

  TransferMoneySelectedEvent({required this.selectedTransferAmountMenuItem});
}

class MoneyTransferedEvent extends AccEvent {
  final String transferMobile;
  final String role;
  final String transferAmount;

  MoneyTransferedEvent(
      {required this.transferMobile,
      required this.role,
      required this.transferAmount});
}

class DeleteContactEvent extends AccEvent {
  final String? id;

  DeleteContactEvent({required this.id});
}

class SelectContactDetailsEvent extends AccEvent {}

class AddContactEvent extends AccEvent {
  final String name;
  final String number;

  AddContactEvent({required this.name, required this.number});
}

class AccUpdateEvent extends AccEvent {}

class DeleteFavAddressEvent extends AccEvent {
  final String? id;
  final bool isHome;
  final bool isWork;
  final bool isOthers;

  DeleteFavAddressEvent(
      {required this.id,
      required this.isHome,
      required this.isWork,
      required this.isOthers});
}

class GetFavListEvent extends AccEvent {
  final UserDetail userData;
  final List<FavoriteLocationData> favAddressList;

  GetFavListEvent({required this.userData, required this.favAddressList});
}

class SelectFromFavAddressEvent extends AccEvent {
  final String addressType;

  SelectFromFavAddressEvent({required this.addressType});
}

class AddFavAddressEvent extends AccEvent {
  final String address;
  final String name;
  final String lat;
  final String lng;
  final bool isOther;

  AddFavAddressEvent(
      {required this.address,
      required this.name,
      required this.lat,
      required this.lng,
      required this.isOther});
}

class UserDetailEditEvent extends AccEvent {
  final String header;
  final String text;

  UserDetailEditEvent({required this.header, required this.text});
}

class UserDetailEvent extends AccEvent {}

class SendAdminMessageEvent extends AccEvent {
  final String newChat;
  final String message;
  final String chatId;

  SendAdminMessageEvent(
      {required this.newChat, required this.message, required this.chatId});
}

class GetAdminChatHistoryListEvent extends AccEvent {}

class AdminChatInitEvent extends AccEvent {
  final AdminChatPageArguments arg;

  AdminChatInitEvent({required this.arg});
}

class AdminMessageSeenEvent extends AccEvent {
  final String? chatId;

  AdminMessageSeenEvent({required this.chatId});
}

class UpdateImageEvent extends AccEvent {
  final String name;
  final String email;
  final String gender;
  final ImageSource source;

  UpdateImageEvent({
    required this.name,
    required this.email,
    required this.gender,
    required this.source,
  });
}

class PaymentOnTapEvent extends AccEvent {
  final int selectedPaymentIndex;

  PaymentOnTapEvent({required this.selectedPaymentIndex});
}

class RideLaterCancelRequestEvent extends AccEvent {
  final String requestId;
  final String? reason;

  RideLaterCancelRequestEvent({
    required this.requestId,
    this.reason,
  });
}

class FavNewAddressInitEvent extends AccEvent {
  final ConfirmFavouriteLocationPageArguments arg;

  FavNewAddressInitEvent({required this.arg});
}

class UserDataInitEvent extends AccEvent {
  final UserDetail? userDetails;

  UserDataInitEvent({required this.userDetails});
}

class AddMoneyWebViewUrlEvent extends AccEvent {
  dynamic from;
  dynamic url;
  dynamic userId;
  dynamic requestId;
  dynamic currencySymbol;
  dynamic money;
  BuildContext context;

  AddMoneyWebViewUrlEvent({
    this.url,
    this.from,
    this.userId,
    this.requestId,
    this.currencySymbol,
    this.money,
    required this.context,
  });
}

class WalletPageReUpdateEvent extends AccEvent {
  String from;
  String url;
  String userId;
  String requestId;
  String currencySymbol;
  String money;
  WalletPageReUpdateEvent(
      {required this.from,
      required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}

class HistoryPageInitEvent extends AccEvent {}

class OnlinePaymentDoneUserEvent extends AccEvent {
  final String requestId;

  OnlinePaymentDoneUserEvent({required this.requestId});
}

class AddHistoryMarkerEvent extends AccEvent {
  final List? stops;
  final String pickLat;
  final String pickLng;
  final String? dropLat;
  final String? dropLng;
  final String? polyline;
  AddHistoryMarkerEvent(
      {this.stops,
      required this.pickLat,
      required this.pickLng,
      this.dropLat,
      this.dropLng,
      this.polyline});
}

class WalletPageInitEvent extends AccEvent {
  final WalletPageArguments arg;

  WalletPageInitEvent({required this.arg});
}

class NotificationPageInitEvent extends AccEvent {}

class SosInitEvent extends AccEvent {
  final SOSPageArguments arg;

  SosInitEvent({required this.arg});
}

class PaymentAuthenticationEvent extends AccEvent {
  final PaymentMethodArguments arg;

  PaymentAuthenticationEvent({required this.arg});
}

class AddCardDetailsEvent extends AccEvent {
  BuildContext context;

  AddCardDetailsEvent({
    required this.context,
  });
}

class CardListEvent extends AccEvent {}

class DeleteCardEvent extends AccEvent {
  final String cardId;

  DeleteCardEvent({required this.cardId});
}

class ShowPaymentGatewayEvent extends AccEvent {}

class AddMoneyFromCardEvent extends AccEvent {
  final String amount;
  final String cardToken;

  AddMoneyFromCardEvent({required this.amount, required this.cardToken});
}

class CreateSupportTicketEvent extends AccEvent {
  final bool isFromRequest;
  final String requestId;
  final int? index;
  final int? pageNumber;
  CreateSupportTicketEvent(
      {required this.isFromRequest,
      required this.requestId,
      this.index,
      this.pageNumber});
}

class MakeTicketSubmitEvent extends AccEvent {
  final String serviceLocationId;
  final String titleId;
  final String description;
  final List<File> attachement;
  final String requestId;
  final bool isFromRequest;
  final int? index;
  final int? pageNumber;

  MakeTicketSubmitEvent(
      {required this.serviceLocationId,
      required this.titleId,
      required this.description,
      required this.attachement,
      required this.requestId,
      required this.isFromRequest,
      this.index,
      this.pageNumber});
}

class TicketTitleChangeEvent extends AccEvent {
  final String changedTitle;
  final String id;
  TicketTitleChangeEvent({required this.changedTitle, required this.id});
}

class TicketAreaChangeEvent extends AccEvent {
  final String changedArea;
  final String id;
  TicketAreaChangeEvent({required this.changedArea, required this.id});
}

class GetServiceLocationEvent extends AccEvent {}

class GetTicketListEvent extends AccEvent {
  final bool isFromAcc;

  GetTicketListEvent({required this.isFromAcc});
}

class ViewTicketEvent extends AccEvent {
  final String id;
  ViewTicketEvent({required this.id});
}

class AddAttachmentTicketEvent extends AccEvent {
  final BuildContext context;

  AddAttachmentTicketEvent({required this.context});
}

class ClearAttachmentEvent extends AccEvent {}

class TicketReplyMessageEvent extends AccEvent {
  final BuildContext context;
  final String messageText;
  final String id;

  TicketReplyMessageEvent(
      {required this.messageText, required this.id, required this.context});
}

class TripSummaryHistoryDataEvent extends AccEvent {
  final HistoryData tripHistoryData;

  TripSummaryHistoryDataEvent({required this.tripHistoryData});
}

class DownloadInvoiceEvent extends AccEvent {
  final String requestId;

  DownloadInvoiceEvent({required this.requestId});
}

class AccDataLoaderShowEvent extends AccEvent {
  final bool showLoader;

  AccDataLoaderShowEvent({required this.showLoader});
}

class GetHtmlStringEvent extends AccEvent {
  final bool isPrivacy;

  GetHtmlStringEvent({required this.isPrivacy});
}

class SosLoadingEvent extends AccEvent {}

class UpdateEvent extends AccEvent {}

class ReferalHistoryEvent extends AccEvent {}

class ReferralResponseEvent extends AccEvent {}

class ReferralTabChangeEvent extends AccEvent {
  final bool showReferralHistory;

  ReferralTabChangeEvent({required this.showReferralHistory});
}

class DownloadInvoiceUserEvent extends AccEvent {
  final String journeyId;

  DownloadInvoiceUserEvent({required this.journeyId});
}

class GetPromoCodeListEvent extends AccEvent {}

class SelectPromoCodeListApplyEvent extends AccEvent {
  final String selectedPromoCode;
  final String? price;

  SelectPromoCodeListApplyEvent({required this.selectedPromoCode, this.price});
}

class SelectPromoCodeListIndexEvent extends AccEvent {
  final int selectedPromoCodeIndex;
  final String selectedPromoCodeVale;

  SelectPromoCodeListIndexEvent(
      {required this.selectedPromoCodeIndex,
      required this.selectedPromoCodeVale});
}

class PromoCodeClearEvent extends AccEvent {
  final String from;

  PromoCodeClearEvent({required this.from});
}

class ChooseLayoutOnTapEvent extends AccEvent {
  final int chooseLayoutIndex;

  ChooseLayoutOnTapEvent({required this.chooseLayoutIndex});
}
