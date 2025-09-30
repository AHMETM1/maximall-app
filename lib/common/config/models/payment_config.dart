import '../../config.dart';

class PaymentConfig {
  String? defaultCountryISOCode;
  String? defaultStateISOCode;
  bool enableOrderDetailSuccessful = true;
  bool enableShipping = false;
  bool enableAddress = false;
  bool enableCustomerNote = false;
  bool enableAddressLocationNote = false;
  bool enableAlphanumericZipCode = false;
  bool enableReview = false;
  bool allowSearchingAddress = false;
  String googleApiKey = '';
  bool _guestCheckout = false;
  bool enableWebviewCheckout = false;

  /// Enable to show native thank you screen after successful checkout using
  /// webview, disable to show successful checkout page in webview (thank you
  /// page on user's web). Only work when `enableWebviewCheckout` is true.
  /// Default: true
  bool showNativeCheckoutSuccessScreenForWebview = true;
  bool enableNativeCheckout = false;
  Map checkoutPageSlug = {'en': 'checkout'};
  bool enableCreditCard = false;
  bool updateOrderStatus = false;
  bool showOrderNotes = false;
  bool enableRefundCancel = false;
  num? refundPeriod;
  SmartCODConfig? smartCOD;
  List<String> excludedPaymentIds = <String>[];
  List<String> webPaymentIds = <String>[];
  bool showTransactionDetails = true;
  List<String> paymentListAllowsCancelAndRefund = <String>[];

  /// Show Download button in Order History Detail for Digital/Downloadable Products
  bool enableDownloadProduct = false;

  ///Require enable guestCheckout option when disable login
  bool get guestCheckout => kLoginSetting.enable ? _guestCheckout : true;

  PaymentConfig.fromJson(dynamic json) {
    defaultCountryISOCode = json['DefaultCountryISOCode'];
    defaultStateISOCode = json['DefaultStateISOCode'];
    enableOrderDetailSuccessful = json['enableOrderDetailSuccessful'] ?? true;
    enableShipping = json['EnableShipping'] ?? false;
    enableAddress = json['EnableAddress'] ?? false;
    enableCustomerNote = json['EnableCustomerNote'] ?? false;
    enableAddressLocationNote = json['EnableAddressLocationNote'] ?? false;
    enableAlphanumericZipCode = json['EnableAlphanumericZipCode'] ?? false;
    enableReview = json['EnableReview'] ?? false;
    allowSearchingAddress = json['allowSearchingAddress'] ?? false;
    googleApiKey = json['GoogleApiKey'] ?? '';
    _guestCheckout = json['GuestCheckout'] ?? false;
    enableWebviewCheckout =
        json['EnableWebviewCheckout'] ?? json['EnableOnePageCheckout'] ?? false;
    showNativeCheckoutSuccessScreenForWebview =
        json['ShowNativeCheckoutSuccessScreenForWebview'] ??
            json['ShowWebviewCheckoutSuccessScreen'] ??
            true;
    enableNativeCheckout =
        json['EnableNativeCheckout'] ?? json['NativeOnePageCheckout'] ?? false;
    checkoutPageSlug =
        (json['CheckoutPageSlug'] is Map && json['CheckoutPageSlug'].isNotEmpty)
            ? json['CheckoutPageSlug']
            : {'en': 'checkout'};
    enableCreditCard = json['EnableCreditCard'] ?? false;
    updateOrderStatus = json['UpdateOrderStatus'] ?? false;
    showOrderNotes = json['ShowOrderNotes'] ?? false;
    enableRefundCancel = json['EnableRefundCancel'] ?? false;
    refundPeriod = json['RefundPeriod'];
    smartCOD = json['SmartCOD'] != null
        ? SmartCODConfig.fromJson(json['SmartCOD'])
        : null;
    excludedPaymentIds = json['excludedPaymentIds'] is List
        ? List<String>.from(json['excludedPaymentIds'])
        : <String>[];
    webPaymentIds = json['webPaymentIds'] is List
        ? List<String>.from(json['webPaymentIds'])
        : <String>[];
    showTransactionDetails = json['ShowTransactionDetails'] ?? true;
    paymentListAllowsCancelAndRefund =
        json['PaymentListAllowsCancelAndRefund'] is List
            ? List<String>.from(json['PaymentListAllowsCancelAndRefund'])
            : <String>[];
    enableDownloadProduct = json['EnableDownloadProduct'] ?? false;
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['DefaultCountryISOCode'] = defaultCountryISOCode;
    map['DefaultStateISOCode'] = defaultStateISOCode;
    map['enableOrderDetailSuccessful'] = enableOrderDetailSuccessful;
    map['EnableShipping'] = enableShipping;
    map['EnableAddress'] = enableAddress;
    map['EnableCustomerNote'] = enableCustomerNote;
    map['EnableAddressLocationNote'] = enableAddressLocationNote;
    map['EnableAlphanumericZipCode'] = enableAlphanumericZipCode;
    map['EnableReview'] = enableReview;
    map['allowSearchingAddress'] = allowSearchingAddress;
    map['GoogleApiKey'] = googleApiKey;
    map['GuestCheckout'] = guestCheckout;
    map['EnableWebviewCheckout'] = enableWebviewCheckout;
    map['ShowNativeCheckoutSuccessScreenForWebview'] =
        showNativeCheckoutSuccessScreenForWebview;
    map['EnableNativeCheckout'] = enableNativeCheckout;
    map['CheckoutPageSlug'] = checkoutPageSlug;
    map['EnableCreditCard'] = enableCreditCard;
    map['UpdateOrderStatus'] = updateOrderStatus;
    map['ShowOrderNotes'] = showOrderNotes;
    map['EnableRefundCancel'] = enableRefundCancel;
    map['RefundPeriod'] = refundPeriod;
    map['SmartCOD'] = smartCOD?.toJson();
    map['excludedPaymentIds'] = excludedPaymentIds;
    map['webPaymentIds'] = webPaymentIds;
    map['ShowTransactionDetails'] = showTransactionDetails;
    map['PaymentListAllowsCancelAndRefund'] = paymentListAllowsCancelAndRefund;
    map['EnableDownloadProduct'] = enableDownloadProduct;
    return map;
  }
}

class SmartCODConfig {
  num? extraFee;
  num? amountStop;
  bool enabled = false;

  SmartCODConfig.fromJson(dynamic json) {
    extraFee = json['extraFee'];
    amountStop = json['amountStop'];
    enabled = json['enabled'] ?? false;
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['extraFee'] = extraFee;
    map['amountStop'] = amountStop;
    map['enabled'] = enabled;
    return map;
  }
}
