part of '../config.dart';

class Configurations {
  static String _environment = DefaultConfig.environment;
  static String _baseUrl = DefaultConfig.baseUrl;
  static String _webProxy = DefaultConfig.webProxy;
  static String _appName = DefaultConfig.appName;
  static bool _enableCrashAnalytics = DefaultConfig.enableCrashAnalytics;
  static bool _enableRemoteConfigFirebase =
      DefaultConfig.enableRemoteConfigFirebase;
  static Map _firebaseAnalyticsConfig = DefaultConfig.firebaseAnalyticsConfig;
  static bool _enableFacebookAppEvents = DefaultConfig.enableFacebookAppEvents;
  static String _defaultLanguage = DefaultConfig.defaultLanguage;
  static Map serverConfig = DefaultConfig.serverConfig;
  static String _appConfig = DefaultConfig.appConfig;
  static bool _defaultDarkTheme = DefaultConfig.defaultDarkTheme;
  static String _countryCodeDefault = DefaultConfig.countryCodeDefault;
  static String _dialCodeDefault = DefaultConfig.dialCodeDefault;
  static String _nameDefault = DefaultConfig.nameDefault;
  static Map _advanceConfig = DefaultConfig.advanceConfig;
  static AppRatingConfig _appRatingConfig =
      AppRatingConfig.fromMap(DefaultConfig.appRatingConfig);
  static List _defaultSettings = DefaultConfig.defaultSettings;
  static Map _loginSetting = DefaultConfig.loginSetting;
  static Map _pointsOfflineStoreConfig = DefaultConfig.pointsOfflineStoreConfig;
  static Map _loyaltyConfig = DefaultConfig.loyaltyConfig;
  static Map _defaultDrawer = DefaultConfig.defaultDrawer;
  static Map _oneSignalKey = DefaultConfig.oneSignalKey;
  static Map _onBoardingConfig = DefaultConfig.onBoardingConfig;
  static Map _wishListConfig = DefaultConfig.wishListConfig;
  static List _vendorOnBoardingData = DefaultConfig.vendorOnBoardingData;
  static Map _productDetail = DefaultConfig.productDetail;
  static Map _blogDetail = DefaultConfig.blogDetail;
  static Map _productVariantLayout = DefaultConfig.productVariantLayout;
  static Map _adConfig = DefaultConfig.adConfig;
  static List<Map> _languagesInfo = DefaultConfig.languagesInfo;
  static Map _paymentConfig = DefaultConfig.paymentConfig;
  static Map _payments = DefaultConfig.payments;
  static Map _stripeConfig = DefaultConfig.stripeConfig;
  static Map _paypalConfig = DefaultConfig.paypalConfig;
  static Map _paypalExpressConfig = DefaultConfig.paypalExpressConfig;
  static Map _razorpayConfig = DefaultConfig.razorpayConfig;
  static Map _tapConfig = DefaultConfig.tapConfig;
  static Map _payTmConfig = DefaultConfig.payTmConfig;
  static Map _payStackConfig = DefaultConfig.payStackConfig;
  static Map _flutterwaveConfig = DefaultConfig.flutterwaveConfig;
  static Map _myFatoorahConfig = DefaultConfig.myFatoorahConfig;
  static Map _mercadoPagoConfig = DefaultConfig.mercadoPagoConfig;
  static Map _midtransConfig = DefaultConfig.midtransConfig;
  static Map _inAppPurchaseConfig = DefaultConfig.inAppPurchaseConfig;
  static Map _xenditConfig = DefaultConfig.xenditConfig;
  static Map _expressPayConfig = DefaultConfig.expressPayConfig;
  static Map _thaiPromptPayConfig = DefaultConfig.thaiPromptPayConfig;
  static Map _fibConfig = DefaultConfig.fibConfig;
  static Map _thawaniConfig = DefaultConfig.thawaniConfig;
  static Map _phonepeConfig = DefaultConfig.phonepeConfig;
  static Map _bankTransferConfig = DefaultConfig.bankTransferConfig;
  static Map _cashOnDeliveryConfig = DefaultConfig.cashOnDeliveryConfig;
  static Map _afterShip = DefaultConfig.afterShip;
  static Map _productAddons = DefaultConfig.productAddons;
  static Map _cartDetail = DefaultConfig.cartDetail;
  static Map _productVariantLanguage = DefaultConfig.productVariantLanguage;
  static Map _saleOffProduct = DefaultConfig.saleOffProduct;
  static String? _excludedCategoryIDs = DefaultConfig.excludedCategoryIDs;
  static String? _excludedProductIDs = DefaultConfig.excludedProductIDs;
  static bool _notStrictVisibleVariant = DefaultConfig.notStrictVisibleVariant;
  static ConfigChat _configChat = ConfigChat.fromJson(DefaultConfig.configChat);
  static List<Map> _smartChat = DefaultConfig.smartChat;
  static VendorConfig _vendorConfig =
      VendorConfig.fromJson(DefaultConfig.vendorConfig);
  static List<AddressFieldConfig> _addressFields = DefaultConfig.addressFields;
  static List _defaultCountryShipping = DefaultConfig.defaultCountryShipping;
  static Map? _loadingIcon = DefaultConfig.loadingIcon;
  static Map _productCard = DefaultConfig.productCard;
  static Map _loginSMSConstants = DefaultConfig.loginSMSConstants;
  static PhoneNumberConfig _phoneNumberConfig =
      PhoneNumberConfig.fromJson(DefaultConfig.phoneNumberConfig);
  static Map _darkConfig = DefaultConfig.darkConfig;
  static Map _lightConfig = DefaultConfig.lightConfig;
  static String _version = DefaultConfig.version;
  static Map _subGeneralSetting = DefaultConfig.subGeneralSetting;
  static Map _splashScreen = DefaultConfig.splashScreen;
  static Map _colorOverrideConfig = DefaultConfig.colorOverrideConfig;
  static GoogleApiKeyConfig _googleApiKey = DefaultConfig.googleApiKey;
  static OrderConfig _orderConfig = DefaultConfig.orderConfig;
  static Map? _managerConfig;
  static Map? _deliveryConfig;
  static Map? _salesiqConfig;
  static Map? _shopifyPaymentConfig;
  static ShopifyCustomerAccountConfig _shopifyCustomerAccountConfig =
      DefaultConfig.shopifyCustomerAccountConfig;
  static Map? _openAIConfig;
  static Map? _notificationRequestScreen;
  static Map? _reviewConfig;
  static List<MultiSiteConfig>? _multiSiteConfigs;
  static Map? _boostEngine;
  static Map? _branchConfig;
  static double? _maxTextScale;
  static Map? _outsideService;
  static DynamicLinkConfig _dynamicLinkConfig = DefaultConfig.dynamicLinkConfig;

  /// only support firebase remote config
  static Map<String, dynamic>? _layoutDesign;

  static String get environments => _environment;

  static String get version => _version;

  static String get baseUrl => _baseUrl;

  static String get webProxy => _webProxy;

  static String get appName => _appName;

  static bool get enableCrashAnalytics => _enableCrashAnalytics;

  static bool get enableRemoteConfigFirebase => _enableRemoteConfigFirebase;

  static Map get firebaseAnalyticsConfig => _firebaseAnalyticsConfig;

  static bool get enableFacebookAppEvents => _enableFacebookAppEvents;

  static String get defaultLanguage => _defaultLanguage;

  static String get appConfig => _appConfig;

  static bool get defaultDarkTheme => _defaultDarkTheme;

  static String get countryCodeDefault => _countryCodeDefault;

  static String get dialCodeDefault => _dialCodeDefault;

  static String get nameDefault => _nameDefault;

  static Map get advanceConfig => _advanceConfig;

  static AppRatingConfig get appRatingConfig => _appRatingConfig;

  static List get defaultSettings => _defaultSettings;

  static Map get loginSetting => _loginSetting;

  static Map get pointsOfflineStoreConfig => _pointsOfflineStoreConfig;

  static Map get loyaltyConfig => _loyaltyConfig;

  static Map get defaultDrawer => _defaultDrawer;

  static Map get oneSignalKey => _oneSignalKey;

  static Map get onBoardingConfig => _onBoardingConfig;

  static Map get wishListConfig => _wishListConfig;

  static List get vendorOnBoardingData => _vendorOnBoardingData;

  static Map get productDetail => _productDetail;

  static Map get blogDetail => _blogDetail;

  static Map get productVariantLayout => _productVariantLayout;

  static Map get adConfig => _adConfig;

  static List<Map> get languagesInfo => _languagesInfo;

  static Map get paymentConfig => _paymentConfig;

  static Map get payments => _payments;

  static Map get stripeConfig => _stripeConfig;

  static Map get paypalConfig => _paypalConfig;

  static Map get paypalExpressConfig => _paypalExpressConfig;

  static Map get razorpayConfig => _razorpayConfig;

  static Map get tapConfig => _tapConfig;

  static Map get payTmConfig => _payTmConfig;

  static Map get payStackConfig => _payStackConfig;

  static Map get flutterwaveConfig => _flutterwaveConfig;

  static Map get myFatoorahConfig => _myFatoorahConfig;

  static Map get mercadoPagoConfig => _mercadoPagoConfig;

  static Map get midtransConfig => _midtransConfig;

  static Map get inAppPurchaseConfig => _inAppPurchaseConfig;

  static Map get xenditConfig => _xenditConfig;

  static Map get expressPayConfig => _expressPayConfig;

  static Map get thaiPromptPayConfig => _thaiPromptPayConfig;

  static Map get fibConfig => _fibConfig;

  static Map get thawaniConfig => _thawaniConfig;

  static Map get phonepeConfig => _phonepeConfig;

  static Map get bankTransferConfig => _bankTransferConfig;

  static Map get cashOnDeliveryConfig => _cashOnDeliveryConfig;

  static Map get afterShip => _afterShip;

  static Map get productAddons => _productAddons;

  static Map get cartDetail => _cartDetail;

  static Map get productVariantLanguage => _productVariantLanguage;

  static Map get saleOffProduct => _saleOffProduct;

  static String? get excludedCategoryIDs => _excludedCategoryIDs;

  static String? get excludedProductIDs => _excludedProductIDs;

  static bool get notStrictVisibleVariant => _notStrictVisibleVariant;

  static ConfigChat get configChat => _configChat;

  static List<Map> get smartChat => _smartChat;

  static VendorConfig get vendorConfig => _vendorConfig;

  static List<AddressFieldConfig> get addressFields => _addressFields;

  static List get defaultCountryShipping => _defaultCountryShipping;

  static Map? get loadingIcon => _loadingIcon;

  static Map get productCard => _productCard;

  static Map get loginSMSConstants => _loginSMSConstants;

  static PhoneNumberConfig get phoneNumberConfig => _phoneNumberConfig;

  static Map get darkConfig => _darkConfig;

  static Map get lightConfig => _lightConfig;

  static Map get subGeneralSetting => _subGeneralSetting;

  static Map get splashScreen => _splashScreen;

  static Map get colorOverrideConfig => _colorOverrideConfig;

  static GoogleApiKeyConfig get googleApiKey => _googleApiKey;

  static Map<String, dynamic>? get layoutDesign => _layoutDesign;

  static Map? get managerConfig => _managerConfig;

  static Map? get deliveryConfig => _deliveryConfig;

  static Map? get salesiqConfig => _salesiqConfig;

  static Map? get shopifyPaymentConfig => _shopifyPaymentConfig;

  static ShopifyCustomerAccountConfig get shopifyCustomerAccountConfig =>
      _shopifyCustomerAccountConfig;

  static Map? get openAIConfig => _openAIConfig;

  static Map? get notificationRequestScreen => _notificationRequestScreen;

  static Map? get reviewConfig => _reviewConfig;

  static Map? get boostEngine => _boostEngine;

  static Map? get branchConfig => _branchConfig;

  static double? get maxTextScale => _maxTextScale;

  static OrderConfig get orderConfig => _orderConfig;

  static List<MultiSiteConfig>? get multiSiteConfigs => _multiSiteConfigs;

  static String? get mainSiteUrl {
    if (_multiSiteConfigs?.isNotEmpty ?? false) {
      return _multiSiteConfigs?.first.serverConfig?['url'];
    }
    return serverConfig['url'];
  }

  static Map? get outsideService => _outsideService;

  static DynamicLinkConfig get dynamicLinkConfig => _dynamicLinkConfig;

  void setConfigurationValues(Map<String, dynamic> value) {
    _environment = value['environment'] ?? DefaultConfig.environment;
    _baseUrl = value['baseUrl'] ?? DefaultConfig.baseUrl;
    _webProxy = value['webProxy'] ?? DefaultConfig.webProxy;
    _appName = value['app_name'] ?? DefaultConfig.appName;
    _maxTextScale = num.tryParse('${value['maxTextScale']}')?.toDouble() ??
        DefaultConfig.maxTextScale;
    _enableCrashAnalytics =
        value['enableCrashAnalytics'] ?? DefaultConfig.enableCrashAnalytics;
    _enableRemoteConfigFirebase = value['enableRemoteConfigFirebase'] ??
        DefaultConfig.enableRemoteConfigFirebase;
    _firebaseAnalyticsConfig = value['firebaseAnalyticsConfig'] ??
        DefaultConfig.firebaseAnalyticsConfig;
    if (value['firebaseAnalyticsConfig'] == null &&
        value['enableFirebaseAnalytics'] != null) {
      _firebaseAnalyticsConfig['enableFirebaseAnalytics'] =
          value['enableFirebaseAnalytics'];
    }
    _enableFacebookAppEvents = value['enableFacebookAppEvents'] ??
        DefaultConfig.enableFacebookAppEvents;
    _defaultLanguage =
        value['defaultLanguage'] ?? DefaultConfig.defaultLanguage;
    _appConfig = value['appConfig'] ?? DefaultConfig.appConfig;
    serverConfig = value['serverConfig'] ?? DefaultConfig.serverConfig;
    _defaultDarkTheme =
        value['defaultDarkTheme'] ?? DefaultConfig.defaultDarkTheme;
    _appRatingConfig = AppRatingConfig.fromMap(value['appRatingConfig'] ??
        value['storeIdentifier'] ??
        DefaultConfig.appRatingConfig);
    _advanceConfig = value['advanceConfig'] != null
        ? Map.from(value['advanceConfig'])
        : DefaultConfig.advanceConfig;
    _countryCodeDefault = DefaultConfig.countryCodeDefault;
    _dialCodeDefault = DefaultConfig.dialCodeDefault;
    _nameDefault = DefaultConfig.nameDefault;
    _defaultSettings =
        value['defaultSettings'] ?? DefaultConfig.defaultSettings;
    _loginSetting = value['loginSetting'] ?? DefaultConfig.loginSetting;
    _pointsOfflineStoreConfig = value['pointsOfflineStoreConfig'] ??
        DefaultConfig.pointsOfflineStoreConfig;
    _loyaltyConfig = value['loyaltyConfig'] ?? DefaultConfig.loyaltyConfig;
    _defaultDrawer = value['defaultDrawer'] ?? DefaultConfig.defaultDrawer;
    _oneSignalKey = value['oneSignalKey'] ?? DefaultConfig.oneSignalKey;

    if (value['onBoardingConfig'] != null) {
      _onBoardingConfig = value['onBoardingConfig'];
    } else {
      // Support the old config
      if (value['onBoardingData'] == null) {
        _onBoardingConfig = DefaultConfig.onBoardingConfig;
      } else {
        _onBoardingConfig = {
          'enableOnBoarding': true,
          'version': 1,
          'data': value['onBoardingData'],
        };
      }

      if (value['enableOnBoarding'] != null) {
        _onBoardingConfig['enableOnBoarding'] =
            value['enableOnBoarding'] == true;
      }

      if (value['advanceConfig']?['OnBoardOnlyShowFirstTime'] != null) {
        _onBoardingConfig['isOnlyShowOnFirstTime'] =
            value['advanceConfig']?['OnBoardOnlyShowFirstTime'] == true;
      }
    }

    _wishListConfig = value['wishListConfig'] ?? DefaultConfig.wishListConfig;

    _vendorOnBoardingData =
        value['vendorOnBoardingData'] ?? DefaultConfig.vendorOnBoardingData;
    _productDetail = value['productDetail'] ?? DefaultConfig.productDetail;
    _blogDetail = value['blogDetail'] ?? DefaultConfig.blogDetail;
    _productVariantLayout =
        value['productVariantLayout'] ?? DefaultConfig.productVariantLayout;
    _adConfig = value['adConfig'] ?? DefaultConfig.adConfig;
    _languagesInfo =
        List<Map>.from(value['languagesInfo'] ?? DefaultConfig.languagesInfo);
    _paymentConfig = value['paymentConfig'] ?? DefaultConfig.paymentConfig;
    _payments = value['payments'] ?? DefaultConfig.payments;
    if (value['stripeConfig'] != null) {
      _stripeConfig = value['stripeConfig'];
      _stripeConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_stripeConfig['paymentMethodId'] != null) {
        _stripeConfig['paymentMethodIds'] = [
          ..._stripeConfig.getValueList('paymentMethodIds'),
          _stripeConfig['paymentMethodId']
        ];
      }
    } else {
      _stripeConfig = DefaultConfig.stripeConfig;
      _stripeConfig['paymentMethodIds'] ??= [];
    }

    if (value['paypalConfig'] != null) {
      _paypalConfig = value['paypalConfig'];
      _paypalConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_paypalConfig['paymentMethodId'] != null) {
        _paypalConfig['paymentMethodIds'] = [
          ..._paypalConfig.getValueList('paymentMethodIds'),
          _paypalConfig['paymentMethodId']
        ];
      }
    } else {
      _paypalConfig = DefaultConfig.paypalConfig;
      _paypalConfig['paymentMethodIds'] ??= [];
    }

    if (value['paypalExpressConfig'] != null) {
      _paypalExpressConfig = value['paypalExpressConfig'];
      _paypalExpressConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_paypalExpressConfig['paymentMethodId'] != null) {
        _paypalExpressConfig['paymentMethodIds'] = [
          ..._paypalExpressConfig.getValueList('paymentMethodIds'),
          _paypalExpressConfig['paymentMethodId']
        ];
      }
    } else {
      _paypalExpressConfig = DefaultConfig.paypalExpressConfig;
      _paypalExpressConfig['paymentMethodIds'] ??= [];
    }

    if (value['razorpayConfig'] != null) {
      _razorpayConfig = value['razorpayConfig'];
      _razorpayConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_razorpayConfig['paymentMethodId'] != null) {
        _razorpayConfig['paymentMethodIds'] = [
          ..._razorpayConfig.getValueList('paymentMethodIds'),
          _razorpayConfig['paymentMethodId']
        ];
      }
    } else {
      _razorpayConfig = DefaultConfig.razorpayConfig;
      _razorpayConfig['paymentMethodIds'] ??= [];
    }

    if (value['tapConfig'] != null) {
      _tapConfig = value['tapConfig'];
      _tapConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_tapConfig['paymentMethodId'] != null) {
        _tapConfig['paymentMethodIds'] = [
          ..._tapConfig.getValueList('paymentMethodIds'),
          _tapConfig['paymentMethodId']
        ];
      }
    } else {
      _tapConfig = DefaultConfig.tapConfig;
      _tapConfig['paymentMethodIds'] ??= [];
    }

    if (value['payTmConfig'] != null) {
      _payTmConfig = value['payTmConfig'];
      _payTmConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_payTmConfig['paymentMethodId'] != null) {
        _payTmConfig['paymentMethodIds'] = [
          ..._payTmConfig.getValueList('paymentMethodIds'),
          _payTmConfig['paymentMethodId']
        ];
      }
    } else {
      _payTmConfig = DefaultConfig.payTmConfig;
      _payTmConfig['paymentMethodIds'] ??= [];
    }

    if (value['payStackConfig'] != null) {
      _payStackConfig = value['payStackConfig'];
      _payStackConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_payStackConfig['paymentMethodId'] != null) {
        _payStackConfig['paymentMethodIds'] = [
          ..._payStackConfig.getValueList('paymentMethodIds'),
          _payStackConfig['paymentMethodId']
        ];
      }
    } else {
      _payStackConfig = DefaultConfig.payStackConfig;
      _payStackConfig['paymentMethodIds'] ??= [];
    }

    if (value['flutterwaveConfig'] != null) {
      _flutterwaveConfig = value['flutterwaveConfig'];
      _flutterwaveConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_flutterwaveConfig['paymentMethodId'] != null) {
        _flutterwaveConfig['paymentMethodIds'] = [
          ..._flutterwaveConfig.getValueList('paymentMethodIds'),
          _flutterwaveConfig['paymentMethodId']
        ];
      }
    } else {
      _flutterwaveConfig = DefaultConfig.flutterwaveConfig;
      _flutterwaveConfig['paymentMethodIds'] ??= [];
    }

    if (value['myFatoorahConfig'] != null) {
      _myFatoorahConfig = value['myFatoorahConfig'];
      _myFatoorahConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_myFatoorahConfig['paymentMethodId'] != null) {
        _myFatoorahConfig['paymentMethodIds'] = [
          ..._myFatoorahConfig.getValueList('paymentMethodIds'),
          _myFatoorahConfig['paymentMethodId']
        ];
      }
    } else {
      _myFatoorahConfig = DefaultConfig.myFatoorahConfig;
      _myFatoorahConfig['paymentMethodIds'] ??= [];
    }

    if (value['mercadoPagoConfig'] != null) {
      _mercadoPagoConfig = value['mercadoPagoConfig'];
      _mercadoPagoConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_mercadoPagoConfig['paymentMethodId'] != null) {
        _mercadoPagoConfig['paymentMethodIds'] = [
          ..._mercadoPagoConfig.getValueList('paymentMethodIds'),
          _mercadoPagoConfig['paymentMethodId']
        ];
      }
    } else {
      _mercadoPagoConfig = DefaultConfig.mercadoPagoConfig;
      _mercadoPagoConfig['paymentMethodIds'] ??= [];
    }

    if (value['midtransConfig'] != null) {
      _midtransConfig = value['midtransConfig'];
      _midtransConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_midtransConfig['paymentMethodId'] != null) {
        _midtransConfig['paymentMethodIds'] = [
          ..._midtransConfig.getValueList('paymentMethodIds'),
          _midtransConfig['paymentMethodId']
        ];
      }
    } else {
      _midtransConfig = DefaultConfig.midtransConfig;
      _midtransConfig['paymentMethodIds'] ??= [];
    }

    _inAppPurchaseConfig =
        value['inAppPurchaseConfig'] ?? DefaultConfig.inAppPurchaseConfig;

    if (value['xenditConfig'] != null) {
      _xenditConfig = value['xenditConfig'];
      _xenditConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_xenditConfig['paymentMethodId'] != null) {
        _xenditConfig['paymentMethodIds'] = [
          ..._xenditConfig.getValueList('paymentMethodIds'),
          _xenditConfig['paymentMethodId']
        ];
      }
    } else {
      _xenditConfig = DefaultConfig.xenditConfig;
      _xenditConfig['paymentMethodIds'] ??= [];
    }

    if (value['expressPayConfig'] != null) {
      _expressPayConfig = value['expressPayConfig'];
      _expressPayConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_expressPayConfig['paymentMethodId'] != null) {
        _expressPayConfig['paymentMethodIds'] = [
          ..._expressPayConfig.getValueList('paymentMethodIds'),
          _expressPayConfig['paymentMethodId']
        ];
      }
    } else {
      _expressPayConfig = DefaultConfig.expressPayConfig;
      _expressPayConfig['paymentMethodIds'] ??= [];
    }

    if (value['thaiPromptPayConfig'] != null) {
      _thaiPromptPayConfig = value['thaiPromptPayConfig'];
      _thaiPromptPayConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_thaiPromptPayConfig['paymentMethodId'] != null) {
        _thaiPromptPayConfig['paymentMethodIds'] = [
          ..._thaiPromptPayConfig.getValueList('paymentMethodIds'),
          _thaiPromptPayConfig['paymentMethodId']
        ];
      }
    } else {
      _thaiPromptPayConfig = DefaultConfig.thaiPromptPayConfig;
      _thaiPromptPayConfig['paymentMethodIds'] ??= [];
    }

    if (value['fibConfig'] != null) {
      _fibConfig = value['fibConfig'];
      _fibConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_fibConfig['paymentMethodId'] != null) {
        _fibConfig['paymentMethodIds'] = [
          ..._fibConfig.getValueList('paymentMethodIds'),
          _fibConfig['paymentMethodId']
        ];
      }
    } else {
      _fibConfig = DefaultConfig.fibConfig;
      _fibConfig['paymentMethodIds'] ??= [];
    }

    if (value['thawaniConfig'] != null) {
      _thawaniConfig = value['thawaniConfig'];
      _thawaniConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_thawaniConfig['paymentMethodId'] != null) {
        _thawaniConfig['paymentMethodIds'] = [
          ..._thawaniConfig.getValueList('paymentMethodIds'),
          _thawaniConfig['paymentMethodId']
        ];
      }
    } else {
      _thawaniConfig = DefaultConfig.thawaniConfig;
      _thawaniConfig['paymentMethodIds'] ??= [];
    }

    if (value['phonepeConfig'] != null) {
      _phonepeConfig = value['phonepeConfig'];
      _phonepeConfig['paymentMethodIds'] ??= [];

      /// To support old paymentMethodId param
      if (_phonepeConfig['paymentMethodId'] != null) {
        _phonepeConfig['paymentMethodIds'] = [
          ..._phonepeConfig.getValueList('paymentMethodIds'),
          _phonepeConfig['paymentMethodId']
        ];
      }
    } else {
      _phonepeConfig = DefaultConfig.phonepeConfig;
      _phonepeConfig['paymentMethodIds'] ??= [];
    }

    _bankTransferConfig =
        value['bankTransferConfig'] ?? DefaultConfig.bankTransferConfig;
    if (_bankTransferConfig['paymentMethodIds'] is! List) {
      _bankTransferConfig['paymentMethodIds'] = [];
    }

    _cashOnDeliveryConfig =
        value['cashOnDeliveryConfig'] ?? DefaultConfig.cashOnDeliveryConfig;

    if (_cashOnDeliveryConfig['paymentMethodIds'] is! List) {
      _cashOnDeliveryConfig['paymentMethodIds'] = [];
    }

    _afterShip = value['afterShip'] ?? DefaultConfig.afterShip;
    _productAddons = value['productAddons'] ?? DefaultConfig.productAddons;
    _cartDetail = value['cartDetail'] ?? DefaultConfig.cartDetail;
    _productVariantLanguage =
        value['productVariantLanguage'] ?? DefaultConfig.productVariantLanguage;
    _saleOffProduct = value['saleOffProduct'] ?? DefaultConfig.saleOffProduct;
    _excludedCategoryIDs = value['excludedCategoryIDs']?.toString() ??
        value['excludedCategory']?.toString();
    _excludedProductIDs = value['excludedProductIDs']?.toString();
    _notStrictVisibleVariant = value['notStrictVisibleVariant'] ??
        DefaultConfig.notStrictVisibleVariant;

    var realtimeChatConfig;
    if (value['configChat']?['realtimeChatConfig'] != null) {
      realtimeChatConfig = RealtimeChatConfig.fromJson(
          value['configChat']?['realtimeChatConfig']);
    } else {
      // Adapt for old version
      realtimeChatConfig = RealtimeChatConfig(
        adminEmail: value['adminEmail'] ?? '',
        adminName: value['adminName'] ?? '',
        enable: value['configChat']?['UseRealtimeChat'] ?? false,
      );
    }
    _configChat =
        ConfigChat.fromJson(value['configChat'] ?? DefaultConfig.configChat)
            .copyWith(realtimeChatConfig: realtimeChatConfig);

    _smartChat = ConfigurationUtils.loadSmartChat(
        List<Map>.from(value['smartChat'] ?? DefaultConfig.smartChat));
    _vendorConfig = VendorConfig.fromJson(
        value['vendorConfig'] ?? DefaultConfig.vendorConfig);
    final addressFieldsData = value['addressFields'];
    if (addressFieldsData is List && addressFieldsData.isNotEmpty) {
      _addressFields = [];
      for (var item in addressFieldsData) {
        final addressFieldConfig = AddressFieldConfig.fromMap(item);
        if (addressFieldConfig.type == AddressFieldType.unknown) {
          continue;
        }
        _addressFields.add(addressFieldConfig);
      }
      _addressFields.sort((a, b) => a.position.compareTo(b.position));
    } else {
      _addressFields = List.from(
        DefaultConfig.addressFields,
      );
    }
    _defaultCountryShipping =
        value['defaultCountryShipping'] ?? DefaultConfig.defaultCountryShipping;

    _loadingIcon = value['loadingIcon'] ?? DefaultConfig.loadingIcon;
    _productCard = value['productCard'] ?? DefaultConfig.productCard;
    _loginSMSConstants =
        value['loginSMSConstants'] ?? DefaultConfig.loginSMSConstants;
    _phoneNumberConfig = PhoneNumberConfig.fromJson(
        value['phoneNumberConfig'] ?? DefaultConfig.phoneNumberConfig);
    _darkConfig = value['darkConfig'] ?? DefaultConfig.darkConfig;
    _lightConfig = value['lightConfig'] ?? DefaultConfig.lightConfig;
    _version = value['version']?.toString() ?? DefaultConfig.version;
    _subGeneralSetting = ConfigurationUtils.loadSubGeneralSetting(
        value['subGeneralSetting'] ?? DefaultConfig.subGeneralSetting);
    _splashScreen = value['splashScreen'] ?? DefaultConfig.splashScreen;
    _colorOverrideConfig =
        value['colorOverrideConfig'] ?? DefaultConfig.colorOverrideConfig;

    _googleApiKey = value['googleApiKey'] == null
        ? DefaultConfig.googleApiKey
        : GoogleApiKeyConfig.fromMap(value['googleApiKey']);

    _managerConfig = value['managerConfig'];
    _deliveryConfig = value['deliveryConfig'];
    _salesiqConfig = value['salesiqConfig'];
    _shopifyPaymentConfig = value['shopifyPaymentConfig'];
    _shopifyCustomerAccountConfig = ShopifyCustomerAccountConfig.fromJson(
        value['shopifyCustomerAccountConfig'] ?? {});
    _openAIConfig = value['openAIConfig'];
    _notificationRequestScreen = value['notificationRequestScreen'];
    _reviewConfig = value['reviewConfig'];
    _boostEngine = value['boostEngine'];
    _multiSiteConfigs =
        value['multiSiteConfigs'] != null && value['multiSiteConfigs'] is List
            ? List.from(value['multiSiteConfigs'])
                .map((e) => MultiSiteConfig.fromJson(e))
                .toList()
            : null;
    _branchConfig = value['branchConfig'];
    _orderConfig = value['orderConfig'] != null
        ? OrderConfig.fromJson(value['orderConfig'])
        : _orderConfig;
    _outsideService = value['outsideService'];
    _dynamicLinkConfig = DynamicLinkConfig.fromJson({
      ...?value['dynamicLinkConfig'],
      'firebaseDynamicLinkConfig': value['firebaseDynamicLinkConfig']
    });
  }

  void setAlwaysShowTabBar(bool value) {
    _advanceConfig['AlwaysShowTabBar'] = value;
  }

  void _mergeWithMap(Map<String, dynamic> value) {
    try {
      _environment = value['environment'] ?? _environment;
      _baseUrl = value['baseUrl'] ?? _baseUrl;
      _webProxy = value['webProxy'] ?? _webProxy;
      _appName = value['app_name'] ?? _appName;
      _maxTextScale =
          num.tryParse('${value['maxTextScale']}')?.toDouble() ?? _maxTextScale;
      _enableCrashAnalytics =
          value['enableCrashAnalytics'] ?? _enableCrashAnalytics;
      _enableRemoteConfigFirebase =
          value['enableRemoteConfigFirebase'] ?? _enableRemoteConfigFirebase;
      _firebaseAnalyticsConfig =
          value['firebaseAnalyticsConfig'] ?? _firebaseAnalyticsConfig;
      if (value['firebaseAnalyticsConfig'] == null &&
          value['enableFirebaseAnalytics'] != null) {
        _firebaseAnalyticsConfig['enableFirebaseAnalytics'] =
            value['enableFirebaseAnalytics'];
      }
      _enableFacebookAppEvents =
          value['enableFacebookAppEvents'] ?? enableFacebookAppEvents;
      _defaultLanguage = value['defaultLanguage'] ?? _defaultLanguage;
      _appConfig = value['appConfig'] ?? _appConfig;
      serverConfig = value['serverConfig'] ?? serverConfig;
      _defaultDarkTheme = value['defaultDarkTheme'] ?? _defaultDarkTheme;
      _appRatingConfig = value['appRatingConfig'] is Map
          ? AppRatingConfig.fromMap(value['appRatingConfig'])
          : value['storeIdentifier'] is Map
              ? AppRatingConfig.fromMap(value['storeIdentifier'])
              : _appRatingConfig;
      _advanceConfig = value['advanceConfig'] != null
          ? Map.from(value['advanceConfig'])
          : _advanceConfig;
      _defaultSettings = value['defaultSettings'] ?? _defaultSettings;
      _loginSetting = value['loginSetting'] ?? _loginSetting;
      _defaultDrawer = value['defaultDrawer'] ?? _defaultDrawer;
      _pointsOfflineStoreConfig =
          value['pointsOfflineStoreConfig'] ?? _pointsOfflineStoreConfig;
      _loyaltyConfig = value['loyaltyConfig'] ?? _loyaltyConfig;
      _oneSignalKey = value['oneSignalKey'] ?? _oneSignalKey;
      _onBoardingConfig = value['onBoardingConfig'] ?? _onBoardingConfig;
      _wishListConfig = value['wishListConfig'] ?? _wishListConfig;
      _vendorOnBoardingData =
          value['vendorOnBoardingData'] ?? _vendorOnBoardingData;
      _productDetail = value['productDetail'] ?? _productDetail;
      _blogDetail = value['blogDetail'] ?? _blogDetail;
      _productVariantLayout =
          value['productVariantLayout'] ?? _productVariantLayout;
      _adConfig = value['adConfig'] ?? _adConfig;
      _languagesInfo = List<Map>.from(value['languagesInfo'] ?? _languagesInfo);
      _paymentConfig = value['paymentConfig'] ?? _paymentConfig;
      _payments = value['payments'] ?? _payments;
      if (value['stripeConfig'] != null) {
        _stripeConfig = value['stripeConfig'];

        /// To support old paymentMethodId param
        if (_stripeConfig['paymentMethodId'] != null) {
          _stripeConfig['paymentMethodIds'] = [
            ...(_stripeConfig['paymentMethodIds'] ?? []),
            _stripeConfig['paymentMethodId']
          ];
        }
      }
      if (value['paypalConfig'] != null) {
        _paypalConfig = value['paypalConfig'];

        /// To support old paymentMethodId param
        if (_paypalConfig['paymentMethodId'] != null) {
          _paypalConfig['paymentMethodIds'] = [
            ...(_paypalConfig['paymentMethodIds'] ?? []),
            _paypalConfig['paymentMethodId']
          ];
        }
      }
      if (value['paypalExpressConfig'] != null) {
        _paypalExpressConfig = value['paypalExpressConfig'];

        /// To support old paymentMethodId param
        if (_paypalExpressConfig['paymentMethodId'] != null) {
          _paypalExpressConfig['paymentMethodIds'] = [
            ...(_paypalExpressConfig['paymentMethodIds'] ?? []),
            _paypalExpressConfig['paymentMethodId']
          ];
        }
      }
      if (value['razorpayConfig'] != null) {
        _razorpayConfig = value['razorpayConfig'];

        /// To support old paymentMethodId param
        if (_razorpayConfig['paymentMethodId'] != null) {
          _razorpayConfig['paymentMethodIds'] = [
            ...(_razorpayConfig['paymentMethodIds'] ?? []),
            _razorpayConfig['paymentMethodId']
          ];
        }
      }
      if (value['tapConfig'] != null) {
        _tapConfig = value['tapConfig'];

        /// To support old paymentMethodId param
        if (_tapConfig['paymentMethodId'] != null) {
          _tapConfig['paymentMethodIds'] = [
            ...(_tapConfig['paymentMethodIds'] ?? []),
            _tapConfig['paymentMethodId']
          ];
        }
      }
      if (value['payTmConfig'] != null) {
        _payTmConfig = value['payTmConfig'];

        /// To support old paymentMethodId param
        if (_payTmConfig['paymentMethodId'] != null) {
          _payTmConfig['paymentMethodIds'] = [
            ...(_payTmConfig['paymentMethodIds'] ?? []),
            _payTmConfig['paymentMethodId']
          ];
        }
      }
      if (value['payStackConfig'] != null) {
        _payStackConfig = value['payStackConfig'];

        /// To support old paymentMethodId param
        if (_payStackConfig['paymentMethodId'] != null) {
          _payStackConfig['paymentMethodIds'] = [
            ...(_payStackConfig['paymentMethodIds'] ?? []),
            _payStackConfig['paymentMethodId']
          ];
        }
      }
      if (value['flutterwaveConfig'] != null) {
        _flutterwaveConfig = value['flutterwaveConfig'];

        /// To support old paymentMethodId param
        if (_flutterwaveConfig['paymentMethodId'] != null) {
          _flutterwaveConfig['paymentMethodIds'] = [
            ...(_flutterwaveConfig['paymentMethodIds'] ?? []),
            _flutterwaveConfig['paymentMethodId']
          ];
        }
      }
      if (value['myFatoorahConfig'] != null) {
        _myFatoorahConfig = value['myFatoorahConfig'];

        /// To support old paymentMethodId param
        if (_myFatoorahConfig['paymentMethodId'] != null) {
          _myFatoorahConfig['paymentMethodIds'] = [
            ...(_myFatoorahConfig['paymentMethodIds'] ?? []),
            _myFatoorahConfig['paymentMethodId']
          ];
        }
      }
      if (value['midtransConfig'] != null) {
        _midtransConfig = value['midtransConfig'];

        /// To support old paymentMethodId param
        if (_midtransConfig['paymentMethodId'] != null) {
          _midtransConfig['paymentMethodIds'] = [
            ...(_midtransConfig['paymentMethodIds'] ?? []),
            _midtransConfig['paymentMethodId']
          ];
        }
      }
      if (value['xenditConfig'] != null) {
        _xenditConfig = value['xenditConfig'];

        /// To support old paymentMethodId param
        if (_xenditConfig['paymentMethodId'] != null) {
          _xenditConfig['paymentMethodIds'] = [
            ...(_xenditConfig['paymentMethodIds'] ?? []),
            _xenditConfig['paymentMethodId']
          ];
        }
      }
      if (value['expressPayConfig'] != null) {
        _expressPayConfig = value['expressPayConfig'];

        /// To support old paymentMethodId param
        if (_expressPayConfig['paymentMethodId'] != null) {
          _expressPayConfig['paymentMethodIds'] = [
            ...(_expressPayConfig['paymentMethodIds'] ?? []),
            _expressPayConfig['paymentMethodId']
          ];
        }
      }
      if (value['thaiPromptPayConfig'] != null) {
        _thaiPromptPayConfig = value['thaiPromptPayConfig'];

        /// To support old paymentMethodId param
        if (_thaiPromptPayConfig['paymentMethodId'] != null) {
          _thaiPromptPayConfig['paymentMethodIds'] = [
            ...(_thaiPromptPayConfig['paymentMethodIds'] ?? []),
            _thaiPromptPayConfig['paymentMethodId']
          ];
        }
      }
      if (value['fibConfig'] != null) {
        _fibConfig = value['fibConfig'];

        /// To support old paymentMethodId param
        if (_fibConfig['paymentMethodId'] != null) {
          _fibConfig['paymentMethodIds'] = [
            ...(_fibConfig['paymentMethodIds'] ?? []),
            _fibConfig['paymentMethodId']
          ];
        }
      }
      if (value['thawaniConfig'] != null) {
        _thawaniConfig = value['thawaniConfig'];

        /// To support old paymentMethodId param
        if (_thawaniConfig['paymentMethodId'] != null) {
          _thawaniConfig['paymentMethodIds'] = [
            ...(_thawaniConfig['paymentMethodIds'] ?? []),
            _thawaniConfig['paymentMethodId']
          ];
        }
      }

      if (value['phonepeConfig'] != null) {
        _phonepeConfig = value['phonepeConfig'];

        /// To support old paymentMethodId param
        if (_phonepeConfig['paymentMethodId'] != null) {
          _phonepeConfig['paymentMethodIds'] = [
            ...(_phonepeConfig['paymentMethodIds'] ?? []),
            _phonepeConfig['paymentMethodId']
          ];
        }
      }

      if (value['mercadoPagoConfig'] != null) {
        _mercadoPagoConfig = value['mercadoPagoConfig'];

        /// To support old paymentMethodId param
        if (_mercadoPagoConfig['paymentMethodId'] != null) {
          _mercadoPagoConfig['paymentMethodIds'] = [
            ...(_mercadoPagoConfig['paymentMethodIds'] ?? []),
            _mercadoPagoConfig['paymentMethodId']
          ];
        }
      }
      _bankTransferConfig = value['bankTransferConfig'] ?? bankTransferConfig;
      if (_bankTransferConfig['paymentMethodIds'] is! List) {
        _bankTransferConfig['paymentMethodIds'] = [];
      }

      _cashOnDeliveryConfig =
          value['cashOnDeliveryConfig'] ?? cashOnDeliveryConfig;
      if (_cashOnDeliveryConfig['paymentMethodIds'] is! List) {
        _cashOnDeliveryConfig['paymentMethodIds'] = [];
      }

      _afterShip = value['afterShip'] ?? _afterShip;
      _productAddons = value['productAddons'] ?? _productAddons;
      _cartDetail = value['cartDetail'] ?? _cartDetail;
      _productVariantLanguage =
          value['productVariantLanguage'] ?? _productVariantLanguage;
      _saleOffProduct = value['saleOffProduct'] ?? _saleOffProduct;
      _excludedCategoryIDs = value['excludedCategoryIDs']?.toString() ??
          value['excludedCategory']?.toString();
      _excludedProductIDs = value['excludedProductIDs']?.toString();
      _notStrictVisibleVariant =
          value['notStrictVisibleVariant'] ?? _notStrictVisibleVariant;
      _configChat = value['configChat'] is Map
          ? ConfigChat.fromJson(value['configChat'])
          : _configChat;
      _smartChat = value['smartChat'] is List
          ? ConfigurationUtils.loadSmartChat(List<Map>.from(value['smartChat']))
          : _smartChat;
      _vendorConfig = value['vendorConfig'] is Map
          ? VendorConfig.fromJson(value['vendorConfig'])
          : _vendorConfig;
      final addressFieldsData = value['addressFields'];
      if (addressFieldsData is List && addressFieldsData.isNotEmpty) {
        _addressFields = [];
        for (var item in addressFieldsData) {
          final addressFieldConfig = AddressFieldConfig.fromMap(item);
          if (addressFieldConfig.type == AddressFieldType.unknown) {
            continue;
          }
          _addressFields.add(addressFieldConfig);
        }
        _addressFields.sort((a, b) => a.position.compareTo(b.position));
      }
      _defaultCountryShipping =
          value['defaultCountryShipping'] ?? _defaultCountryShipping;

      _loadingIcon = value['loadingIcon'] ?? _loadingIcon;
      _productCard = value['productCard'] ?? _productCard;
      _loginSMSConstants = value['loginSMSConstants'] ?? _loginSMSConstants;
      _phoneNumberConfig = value['phoneNumberConfig'] is Map
          ? PhoneNumberConfig.fromJson(value['phoneNumberConfig'])
          : _phoneNumberConfig;
      _darkConfig = value['darkConfig'] ?? _darkConfig;
      _lightConfig = value['lightConfig'] ?? _lightConfig;
      _version = value['version']?.toString() ?? _version;
      _subGeneralSetting = value['subGeneralSetting'] is Map
          ? ConfigurationUtils.loadSubGeneralSetting(value['subGeneralSetting'])
          : _subGeneralSetting;
      _splashScreen = value['splashScreen'] ?? _splashScreen;
      _colorOverrideConfig =
          value['colorOverrideConfig'] ?? _colorOverrideConfig;

      _googleApiKey = value['googleApiKey'] is Map
          ? GoogleApiKeyConfig.fromMap(value['googleApiKey'])
          : _googleApiKey;
      _managerConfig = value['managerConfig'] ?? _managerConfig;
      _deliveryConfig = value['deliveryConfig'] ?? _deliveryConfig;
      _salesiqConfig = value['salesiqConfig'] ?? _salesiqConfig;
      _openAIConfig = value['_openAIConfig'] ?? _openAIConfig;
      _shopifyPaymentConfig =
          value['shopifyPaymentConfig'] ?? _shopifyPaymentConfig;
      _notificationRequestScreen =
          value['notificationRequestScreen'] ?? _notificationRequestScreen;
      _reviewConfig = value['reviewConfig'] ?? _reviewConfig;
      _boostEngine = value['boostEngine'] ?? _boostEngine;
      _multiSiteConfigs =
          value['multiSiteConfigs'] != null && value['multiSiteConfigs'] is List
              ? List.from(value['multiSiteConfigs'])
                  .map((e) => MultiSiteConfig.fromJson(e))
                  .toList()
              : _multiSiteConfigs;
      if (_multiSiteConfigs?.isNotEmpty ?? false) {
        serverConfig = _multiSiteConfigs!.first.serverConfig!;
      }
      _orderConfig = value['orderConfig'] != null
          ? OrderConfig.fromJson(value['orderConfig'])
          : _orderConfig;
      _outsideService = value['outsideService'] ?? _outsideService;

      final configRemoteDynamicLink = value['dynamicLinkConfig'];
      final configRemoteFirebaseDynamicLink =
          value['firebaseDynamicLinkConfig'];

      if (configRemoteDynamicLink?.isNotEmpty ?? false) {
        _dynamicLinkConfig = DynamicLinkConfig.fromJson({
          ...configRemoteDynamicLink,
          'firebaseDynamicLinkConfig': configRemoteFirebaseDynamicLink,
        });
      } else if (configRemoteFirebaseDynamicLink?.isNotEmpty ?? false) {
        final firebaseConfig = FirebaseDynamicLinkServiceConfig.fromJson(
            configRemoteFirebaseDynamicLink);

        final isFirebaseExist =
            _dynamicLinkConfig.serviceConfigs.keys.any((e) => e.isFirebase);

        if (isFirebaseExist == false) {
          _dynamicLinkConfig.serviceConfigs.addAll({
            DynamicLinkType.firebase: firebaseConfig,
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  void _loadDesignConfig() {
    final data = Services().firebase.getRemoteConfigString('layout_design');
    if (data.isNotEmpty) {
      _layoutDesign = Map<String, dynamic>.from(jsonDecode(data));
    }
  }
}

extension ConfigurationsFireBaseRemoteConfig on Configurations {
  Future<void> loadRemoteConfig() async {
    if (Configurations.enableRemoteConfigFirebase) {
      final isAvailable = await Services().firebase.loadRemoteConfig();
      if (isAvailable) {
        _loadDesignConfig();
        var configurations = <String, dynamic>{};
        var keys = await Services().firebase.getRemoteKeys();
        for (var item in keys) {
          var data = Services().firebase.getRemoteConfigString(item);
          if (data.isNotEmpty) {
            var dataJson;
            try {
              dataJson = jsonDecode(data);
            } catch (e) {
              dataJson = data;
            }
            configurations[item] = dataJson;
          }
        }
        _mergeWithMap(configurations);
      }
    }
  }
}

extension ConfigurationsMultiSite on Configurations {
  void loadConfigBySite(Map<String, dynamic> configurations) {
    var mergedKeys = [
      'advanceConfig',
      'loginSetting',
      'paymentConfig',
      'productDetail',
      'blogDetail',
      'vendorConfig',
      'reviewConfig',
    ];
    for (var key in mergedKeys) {
      if (configurations[key] != null) {
        configurations = {
          ...configurations,
          key: <String, dynamic>{
            ...environment[key] ?? {},
            ...configurations[key]
          }
        };
      }
    }

    _mergeWithMap(configurations);

    // Notify review configuration changes
    eventBus.fire(const EventReviewConfigChanged());
  }
}
