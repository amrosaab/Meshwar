import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../../../bookingpage/domain/models/promo_code_list_model.dart';
import '../../../userprofile/domain/models/service_location_model.dart';
import '../../domain/models/admin_chat_history_model.dart';
import '../../domain/models/admin_chat_model.dart';
import '../../domain/models/card_list_model.dart';
import '../../domain/models/delete_account_model.dart';
import '../../domain/models/faq_model.dart';
import '../../domain/models/history_model.dart';
import '../../domain/models/make_ticket_model.dart';
import '../../domain/models/makecomplaint_model.dart';
import '../../domain/models/notifications_model.dart';
import '../../domain/models/payment_method_model.dart';
import '../../domain/models/promo_code_clear_model.dart';
import '../../domain/models/ticket_list_model.dart';
import '../../domain/models/ticket_names_model.dart';
import '../../domain/models/view_ticket_model.dart';
import '../../domain/models/walletpage_model.dart';
import '../../domain/repositories/acc_repo.dart';

class AccUsecase {
  final AccRepository _accRepository;

  const AccUsecase(this._accRepository);

  // Notifications
  Future<Either<Failure, NotificationResponseModel>> notificationDetails(
      {String? pageNo}) async {
    return _accRepository.getUserNotificationsDetails(pageNo: pageNo);
  }

  //make complaints
  Future<Either<Failure, ComplaintResponseModel>> makeComplaint(
      {String? complaintType}) async {
    return _accRepository.makeComplaintList(complaintType: complaintType);
  }

  //Delete Notification
  Future<Either<Failure, dynamic>> deleteNotification(String id) async {
    return _accRepository.deleteNotification(id);
  }

  Future<Either<Failure, dynamic>> clearAllNotification() async {
    return _accRepository.clearAllNotification();
  }

  //make complaints button
  Future<Either<Failure, dynamic>> makeComplaintButton(
      String complaintTitleId, String complaintText, String requestId) async {
    return _accRepository.makeComplaintButton(
        complaintTitleId, complaintText, requestId);
  }

  // History
  Future<Either<Failure, HistoryResponseModel>> historyDetails(
      String historyFilter,
      {String? pageNo}) async {
    return _accRepository.getUserHistoryDetails(historyFilter, pageNo: pageNo);
  }

  // logout
  Future<Either<Failure, dynamic>> logout() async {
    return _accRepository.logout();
  }

  // Delete account
  Future<Either<Failure, DeleteAccountResponseModel>>
      deleteUserAccount() async {
    return _accRepository.deleteAccount();
  }

  //Faq
  Future<Either<Failure, FaqResponseModel>> getFaqDetail() async {
    return _accRepository.getFaqDetails();
  }

  Future<Either<Failure, WalletResponseModel>> getWalletDetail(int page) async {
    return _accRepository.getWalletHistoryDetails(page);
  }

  Future<Either<Failure, dynamic>> moneyTransfer(
      {required String transferMobile,
      required String role,
      required String transferAmount}) async {
    return _accRepository.moneyTransfer(
        transferMobile: transferMobile,
        role: role,
        transferAmount: transferAmount);
  }

  //update details
  Future<Either<Failure, dynamic>> updateDetailsButton(
      {required String email,
      required String name,
      required String gender,
      required String profileImage,
      required String mobile,
      required String country,
      String? mapType,
      String? mapShow,
      bool? updateFcmToken}) async {
    return _accRepository.updateDetailsButton(
        email: email,
        name: name,
        gender: gender,
        profileImage: profileImage,
        mobile: mobile,
        country: country,
        mapType: mapType,
        mapShow: mapShow,
        updateFcmToken: updateFcmToken);
  }

  //Delete fav
  Future<Either<Failure, dynamic>> deleteFavouritesAddress(String id) async {
    return _accRepository.deleteFav(id);
  }

  Future<Either<Failure, dynamic>> addFavAddress({
    required String address,
    required String name,
    required String lat,
    required String lng,
  }) async {
    return _accRepository.addFavAddress(
        address: address, name: name, lat: lat, lng: lng);
  }

  Future<Either<Failure, dynamic>> deleteSosContact(String id) async {
    return _accRepository.deleteSos(id);
  }

  Future<Either<Failure, dynamic>> addSosContact({
    required String name,
    required String number,
  }) async {
    return _accRepository.addSos(
      name: name,
      number: number,
    );
  }

  Future<Either<Failure, AdminChatModel>> sendAdminMessages({
    required String newChat,
    required String message,
    required String chatId,
  }) async {
    return _accRepository.sendAdminMessage(
      newChat: newChat,
      message: message,
      chatId: chatId,
    );
  }

  Future<Either<Failure, AdminChatHistoryModel>>
      getAdminChatHistoryDetail() async {
    return _accRepository.getAdminChatHistoryDetails();
  }

  Future<Either<Failure, dynamic>> adminMessageSeenDetail(String chatId) async {
    return _accRepository.adminMessageSeenDetails(chatId);
  }

  Future<Either<Failure, PaymentAuthModel>> stripeSetupIntent() async {
    return _accRepository.stripeSetupIntent();
  }

  Future<Either<Failure, dynamic>> stripSaveCardDetails({
    required String paymentMethodId,
    required String last4Number,
    required String cardType,
    required String validThrough,
  }) async {
    return _accRepository.stripeSaveCardDetails(
        paymentMethodId: paymentMethodId,
        last4Number: last4Number,
        cardType: cardType,
        validThrough: validThrough);
  }

  Future<Either<Failure, CardListModel>> cardList() async {
    return _accRepository.cardList();
  }

  Future<Either<Failure, dynamic>> deleteCard({required String cardId}) async {
    return _accRepository.deleteCard(cardId: cardId);
  }

  Future addMoneyToWalletFromCard({
    required String amount,
    required String cardToken,
  }) async {
    return _accRepository.addMoneyToWalletFromCard(
        amount: amount, cardToken: cardToken);
  }

  //support ticket
  Future<Either<Failure, TicketNamesModel>> supportTicketTitles(
      {required bool isFromRequest}) async {
    return _accRepository.supportTicketTitles(isFromRequest: isFromRequest);
  }

  Future<Either<Failure, ServiceLocationModel>> getServiceLocation() async {
    return _accRepository.getServiceLocation();
  }

  Future<Either<Failure, MakeTicketModel>> makeTicket({
    required String titleId,
    required String description,
    required String serviceLocationId,
    required String requestId,
    required List<File> attachments,
  }) async {
    return _accRepository.makeTicket(
        titleId: titleId,
        description: description,
        serviceLocationId: serviceLocationId,
        attachments: attachments,
        requestId: requestId);
  }

  Future<Either<Failure, TicketListModel>> getTicketList() async {
    return _accRepository.getTicketList();
  }

  Future<Either<Failure, ViewTicketModel>> viewTicket(
      {required String ticketId}) async {
    return _accRepository.viewTicket(ticketId: ticketId);
  }

  Future<Either<Failure, ReplyMessage>> ticketReplyMessage(
      {required String id, required String replyMessage}) async {
    return _accRepository.ticketReplyMessage(
        id: id, replyMessage: replyMessage);
  }

  Future<Either<Failure, dynamic>> invoiceDownload(
      {required String requestId}) async {
    return _accRepository.invoiceDownload(requestId: requestId);
  }

  Future<Either<Failure, dynamic>> getTermsAndPrivacyHtml(
      {required bool isPrivacyPage}) async {
    return _accRepository.getTermsAndPrivacyHtml(isPrivacyPage: isPrivacyPage);
  }

  Future<Either<Failure, dynamic>> referalHistory() async {
    return _accRepository.referalHistory();
  }

  Future<Either<Failure, dynamic>> referalResponse() async {
    return _accRepository.referalResponse();
  }

  Future<Either<Failure, dynamic>> invoiceDownloadUser(
      {required String journeyId}) async {
    return _accRepository.invoiceDownloadUser(journeyId: journeyId);
  }

  Future<Either<Failure, PromoCodeListModel>> getPromoCodeList() async {
    return _accRepository.getPromoCodeLists();
  }

  Future<Either<Failure, dynamic>> promoCodeRedeem({
    required String code,
  }) async {
    return _accRepository.promoCodeRedeem(
      code: code,
    );
  }

  Future<Either<Failure, PromoCodeClearModel>> promoCodeClear() async {
    return _accRepository.promoCodeClear();
  }
}
