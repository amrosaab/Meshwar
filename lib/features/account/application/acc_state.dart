part of 'acc_bloc.dart';

abstract class AccState {}

class AccInitialState extends AccState {}

class AccDataLoadingStopState extends AccState {}

class AccDataLoadingStartState extends AccState {}

class UserProfileDetailsLoadingState extends AccState {}

class SaveCardSuccessState extends AccState {}

class GenderSelectedState extends AccState {
  final String selectedGender;

  GenderSelectedState({required this.selectedGender});
}

final class GetContactPermissionPermanentlyDeniedState extends AccState {}

class UserDetailsUpdatedState extends AccState {
  final String name;
  final String email;
  final String gender;
  final String profileImage;

  UserDetailsUpdatedState(
      {required this.name,
      required this.email,
      required this.gender,
      required this.profileImage});
}

class UserDetailsSuccessState extends AccState {
  final UserDetail? userData;

  UserDetailsSuccessState({this.userData});
}

class NotificationFailure extends AccState {
  final String errorMessage;

  NotificationFailure({required this.errorMessage});
}

class HistoryFailure extends AccState {
  final String errorMessage;

  HistoryFailure({required this.errorMessage});
}

class MakeComplaintFailure extends AccState {
  final String errorMessage;

  MakeComplaintFailure({required this.errorMessage});
}

class ComplaintButtonFailureState extends AccState {
  final String errorMessage;

  ComplaintButtonFailureState({required this.errorMessage});
}

class NotificationSuccess extends AccState {
  final List<NotificationData>? notificationDatas;

  NotificationSuccess({required this.notificationDatas});
}

class HistorySuccess extends AccState {
  final List<HistoryData>? history;

  HistorySuccess({required this.history});
}

class UpdatedUserDetailsState extends AccState {
  final UserDetail updatedUserData;

  UpdatedUserDetailsState({required this.updatedUserData});
}

class LogoutSuccess extends AccState {}

class ImageUpdateState extends AccState {
  final String profileImage;

  ImageUpdateState({required this.profileImage});
}

class MakeComplaintButtonSuccess extends AccState {}

class MakeComplaintLoading extends AccState {}

class DeleteAccountSuccess extends AccState {}

class UpdateUserDetailsFailureState extends AccState {}

class MakeComplaintSuccess extends AccState {
  final List<ComplaintList>? complaintList;

  MakeComplaintSuccess({required this.complaintList});
}

class NotificationClearedSuccess extends AccState {}

class NotificationDeletedSuccess extends AccState {}

class LogoutLoadingState extends AccState {}

class ComplaintButtonLoadingState extends AccState {}

class DeleteAccountLoadingState extends AccState {}

class LogoutFailureState extends AccState {
  final String errorMessage;

  LogoutFailureState({required this.errorMessage});
}

final class ChooseMapSelectState extends AccState {
  final int selectedMapIndex;

  ChooseMapSelectState(this.selectedMapIndex);
}

final class ChooseLayoutOnTapState extends AccState {
  final int chooseLayoutIndex;

  ChooseLayoutOnTapState(this.chooseLayoutIndex);
}

class MakeComplaintFailureState extends AccState {
  final String errorMessage;

  MakeComplaintFailureState({required this.errorMessage});
}

class DeleteAccountFailureState extends AccState {
  final String errorMessage;

  DeleteAccountFailureState({required this.errorMessage});
}

final class FaqSuccessState extends AccState {}

final class FaqFailureState extends AccState {}

final class FaqLoadingState extends AccState {}

final class FaqSelectState extends AccState {
  final int selectedIndex;

  FaqSelectState(this.selectedIndex);

  List<Object> get props => [selectedIndex];
}

class WalletHistorySuccessState extends AccState {
  final List<WalletHistoryData>? walletHistoryDatas;

  WalletHistorySuccessState({required this.walletHistoryDatas});
}

final class WalletHistoryFailureState extends AccState {}

final class WalletHistoryLoadingState extends AccState {}

class TransferMoneySelectedState extends AccState {
  final String selectedTransferAmountMenuItem;

  TransferMoneySelectedState({required this.selectedTransferAmountMenuItem});
}

final class MoneyTransferedSuccessState extends AccState {}

final class MoneyTransferedFailureState extends AccState {}

class SosDeletedSuccessState extends AccState {}

class SosFailureState extends AccState {}

final class GetContactPermissionState extends AccState {}

final class SelectContactDetailsState extends AccState {}

final class AddContactSuccessState extends AccState {}

final class AddContactFailureState extends AccState {}

final class UpdateState extends AccState {}

class FavDeletedSuccessState extends AccState {}

class FavFailureState extends AccState {}

final class SelectFromFavAddressState extends AccState {
  final String addressType;

  SelectFromFavAddressState({required this.addressType});
}

final class AddFavAddressFailureState extends AccState {}

final class AddFavAddressSuccessState extends AccState {}

final class UserDetailEditState extends AccState {
  final String header;
  final String text;

  UserDetailEditState({required this.header, required this.text});
}

final class UserDetailState extends AccState {}

final class SendAdminMessageSuccessState extends AccState {}

final class SendAdminMessageFailureState extends AccState {}

final class AdminChatHistorySuccessState extends AccState {}

final class AdminChatHistoryFailureState extends AccState {}

final class AdminMessageSeenSuccessState extends AccState {}

final class AdminMessageSeenFailureState extends AccState {}

final class PaymentSelectState extends AccState {
  final int selectedIndex;

  PaymentSelectState(this.selectedIndex);
}

final class RequestCancelState extends AccState {}

class HistoryDataSuccessState extends AccState {}

class HistoryDataLoadingState extends AccState {
  get data => null;
}

final class AddMoneyWebViewUrlState extends AccState {
  dynamic from;
  dynamic url;
  dynamic userId;
  dynamic requestId;
  dynamic currencySymbol;
  dynamic money;

  AddMoneyWebViewUrlState(
      {this.url,
      this.from,
      this.userId,
      this.requestId,
      this.currencySymbol,
      this.money});
}

class WalletPageReUpdateState extends AccState {
  String url;
  String userId;
  String requestId;
  String currencySymbol;
  String money;
  WalletPageReUpdateState(
      {required this.url,
      required this.userId,
      required this.requestId,
      required this.currencySymbol,
      required this.money});
}

class FavoriteLoadingState extends AccState {}

class FavoriteLoadedState extends AccState {}

class ContainerClickState extends AccState {
  final bool isContainerClicked;

  ContainerClickState({required this.isContainerClicked});
}

class OutstationAcceptState extends AccState {}

class ShowPaymentGatewayState extends AccState {}

class PaymentUpdateState extends AccState {
  final bool status;

  PaymentUpdateState({required this.status});
}

class CreateSupportTicketState extends AccState {
  final List<TicketNamesList> ticketNamesList;
  final String requestId;
  final bool isFromRequest;
  final int? historyIndex;
  final int? historyPageNumber;

  CreateSupportTicketState(
      {required this.ticketNamesList,
      required this.requestId,
      required this.isFromRequest,
      this.historyIndex,
      this.historyPageNumber});
}

class MakeTicketSubmitState extends AccState {}

class GetTicketListLoadedState extends AccState {}

class GetTicketListLoadingState extends AccState {}

class AddAttachmentTicketState extends AccState {}

class ClearAttachmentState extends AccState {}

class TicketReplyMessageState extends AccState {}

class SosLoadingState extends AccState {}

class SosLoadedState extends AccState {}

class UserDetailsButtonSuccess extends AccState {}

final class ReferalHistoryLoadingState extends AccState {}

final class ReferalHistorySuccessState extends AccState {}

final class ReferalHistoryFailureState extends AccState {}

final class ReferralResponseLoadingState extends AccState {}

final class ReferralResponseSuccessState extends AccState {}

final class ReferralResponseFailureState extends AccState {}

final class InvoiceDownloadSuccessState extends AccState {}

final class InvoiceDownloadFailureState extends AccState {}

final class InvoiceDownloadingState extends AccState {}

final class PromoCodeListSuccessState extends AccState {}

final class PromoCodeListFailureState extends AccState {}

final class PromoCodeListLoadingState extends AccState {}

final class SelectPromoCodeListIndexState extends AccState {
  final int selectedPromoIndex;
  final String selectedPromoCodeValues;

  SelectPromoCodeListIndexState(
      {required this.selectedPromoIndex,
      required this.selectedPromoCodeValues});
}

class SelectPromoCodeListApplyState extends AccState {
  final String selectedPromoCode;

  SelectPromoCodeListApplyState({required this.selectedPromoCode});
}

class PromoClearLoadingState extends AccState {}

class PromoClearFailureState extends AccState {
  final String errorMessage;

  PromoClearFailureState({required this.errorMessage});
}

class PromoClearSuccessState extends AccState {}

class PromoApplySuccessState extends AccState {}

class PromoApplyLoadingState extends AccState {}

class PromoApplyFailureState extends AccState {}
