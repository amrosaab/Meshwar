import 'dart:convert';

WalletResponseModel walletResponseModelFromJson(String str) =>
    WalletResponseModel.fromJson(json.decode(str));

class WalletResponseModel {
  bool success;
  String message;
  String walletBalance;
  String defaultCardId;
  String currencyCode;
  String currencySymbol;
  dynamic walletHistory;
  bool braintreeTree;
  bool mercadopago;
  bool stripe;
  bool razorPay;
  bool paystack;
  bool khaltiPay;
  bool cashFree;
  bool flutterWave;
  bool paymob;
  bool bankInfoExists;
  String stripeEnvironment;
  String stripeTestPublishableKey;
  String stripeLivePublishableKey;
  String razorPayEnvironment;
  String razorpayTestApiKey;
  String razorpayLiveApiKey;
  String paystackEnvironment;
  String khaltiPayEnvironment;
  String khaltiTestApiKey;
  String khaltiLiveApiKey;
  String paystackTestPublishableKey;
  String paystackLivePublishableKey;
  String flutterwaveEnvironment;
  String flutterWaveTestSecretKey;
  String flutterWaveLiveSecretKey;
  String cashfreeEnvironment;
  String cashfreeTestAppId;
  String cashfreeLiveAppId;
  List<PaymentGateway> paymentGateways;
  String minimumAmountAddedToWallet;
  bool enableSaveCard;

  WalletResponseModel(
      {required this.success,
      required this.message,
      required this.walletBalance,
      required this.defaultCardId,
      required this.currencyCode,
      required this.currencySymbol,
      required this.walletHistory,
      required this.braintreeTree,
      required this.mercadopago,
      required this.stripe,
      required this.razorPay,
      required this.paystack,
      required this.khaltiPay,
      required this.cashFree,
      required this.flutterWave,
      required this.paymob,
      required this.bankInfoExists,
      required this.stripeEnvironment,
      required this.stripeTestPublishableKey,
      required this.stripeLivePublishableKey,
      required this.razorPayEnvironment,
      required this.razorpayTestApiKey,
      required this.razorpayLiveApiKey,
      required this.paystackEnvironment,
      required this.khaltiPayEnvironment,
      required this.khaltiTestApiKey,
      required this.khaltiLiveApiKey,
      required this.paystackTestPublishableKey,
      required this.paystackLivePublishableKey,
      required this.flutterwaveEnvironment,
      required this.flutterWaveTestSecretKey,
      required this.flutterWaveLiveSecretKey,
      required this.cashfreeEnvironment,
      required this.cashfreeTestAppId,
      required this.cashfreeLiveAppId,
      required this.paymentGateways,
      required this.minimumAmountAddedToWallet,
      required this.enableSaveCard});

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        walletBalance: json["wallet_balance"] ?? '',
        defaultCardId: json["default_card_id"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencySymbol: json["currency_symbol"] ?? '',
        walletHistory: (json["wallet_history"] != null)
            ? WalletHistory.fromJson(json["wallet_history"])
            : null,
        braintreeTree: json["braintree_tree"] ?? false,
        mercadopago: json["mercadopago"] ?? false,
        stripe: json["stripe"] ?? false,
        razorPay: json["razor_pay"] ?? false,
        paystack: json["paystack"] ?? false,
        khaltiPay: json["khalti_pay"] ?? false,
        cashFree: json["cash_free"] ?? false,
        flutterWave: json["flutter_wave"] ?? false,
        paymob: json["paymob"] ?? false,
        bankInfoExists: json["bank_info_exists"] ?? false,
        stripeEnvironment: json["stripe_environment"] ?? '',
        stripeTestPublishableKey: json["stripe_test_publishable_key"] ?? '',
        stripeLivePublishableKey: json["stripe_live_publishable_key"] ?? '',
        razorPayEnvironment: json["razor_pay_environment"] ?? '',
        razorpayTestApiKey: json["razorpay_test_api_key"] ?? '',
        razorpayLiveApiKey: json["razorpay_live_api_key"] ?? '',
        paystackEnvironment: json["paystack_environment"] ?? '',
        khaltiPayEnvironment: json["khalti_pay_environment"] ?? '',
        khaltiTestApiKey: json["khalti_test_api_key"] ?? '',
        khaltiLiveApiKey: json["khalti_live_api_key"] ?? '',
        paystackTestPublishableKey: json["paystack_test_publishable_key"] ?? '',
        paystackLivePublishableKey: json["paystack_live_publishable_key"] ?? '',
        flutterwaveEnvironment: json["flutterwave_environment"] ?? '',
        flutterWaveTestSecretKey: json["flutter_wave_test_secret_key"] ?? '',
        flutterWaveLiveSecretKey: json["flutter_wave_live_secret_key"] ?? '',
        cashfreeEnvironment: json["cashfree_environment"] ?? '',
        cashfreeTestAppId: json["cashfree_test_app_id"] ?? '',
        cashfreeLiveAppId: json["cashfree_live_app_id"] ?? '',
        paymentGateways: json["payment_gateways"] != null
            ? List<PaymentGateway>.from(
                json["payment_gateways"].map((x) => PaymentGateway.fromJson(x)))
            : [],
        minimumAmountAddedToWallet:
            json['minimum_amount_added_to_wallet'] ?? '0',
        enableSaveCard: json['enable_save_card'] ?? false);
  }
}

class PaymentGateway {
  String gateway;
  bool enabled;
  bool isCard;
  String image;
  String url;

  PaymentGateway({
    required this.gateway,
    required this.enabled,
    required this.image,
    required this.url,
    required this.isCard,
  });

  factory PaymentGateway.fromJson(Map<String, dynamic> json) => PaymentGateway(
        gateway: json["gateway"]?.toString() ?? '',
        enabled: json["enabled"] ?? false,
        image: json["image"] ?? '',
        url: json["url"] ?? '',
        isCard: json["is_card"] ?? false,
      );
}

class WalletHistory {
  List<WalletHistoryData> data;
  WalletPagination? meta;

  WalletHistory({
    required this.data,
    required this.meta,
  });

  factory WalletHistory.fromJson(Map<String, dynamic> json) => WalletHistory(
        data: List<WalletHistoryData>.from(
            json["data"].map((x) => WalletHistoryData.fromJson(x))),
        meta: WalletPagination.fromJson(json["meta"]),
      );
}

class WalletHistoryData {
  String id;
  int userId;
  dynamic cardId;
  String? transactionId;
  double amount;
  dynamic conversion;
  dynamic merchant;
  String remarks;
  int isCredit;
  String createdAt;
  String updatedAt;
  String currencyCode;
  String currencySymbol;

  WalletHistoryData({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.transactionId,
    required this.amount,
    required this.conversion,
    required this.merchant,
    required this.remarks,
    required this.isCredit,
    required this.createdAt,
    required this.updatedAt,
    required this.currencyCode,
    required this.currencySymbol,
  });

  factory WalletHistoryData.fromJson(Map<String, dynamic> json) =>
      WalletHistoryData(
        id: json["id"] ?? '',
        userId: json["user_id"] ?? 0,
        cardId: json["card_id"] ?? '',
        transactionId: json["transaction_id"] ?? '',
        amount: double.parse(json["amount"].toString()),
        conversion: json["conversion"] ?? '',
        merchant: json["merchant"] ?? '',
        remarks: json["remarks"] ?? '',
        isCredit: json["is_credit"] ?? 0,
        createdAt: json["created_at"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencySymbol: json["currency_symbol"] ?? '',
      );
}

class WalletPagination {
  Pagination pagination;

  WalletPagination({
    required this.pagination,
  });

  factory WalletPagination.fromJson(Map<String, dynamic> json) =>
      WalletPagination(
        pagination: Pagination.fromJson(json["pagination"]),
      );
}

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;
  dynamic links;

  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.links,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"] ?? 0,
        count: json["count"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
        links: (json["links"] != null) ? Links.fromJson(json["links"]) : null,
      );
}

class Links {
  String next;

  Links({
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        next: json["next"] ?? '',
      );
}
