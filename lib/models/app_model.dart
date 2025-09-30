import 'dart:async';
import 'dart:convert' as convert;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../common/config.dart';
import '../common/config/models/index.dart';
import '../common/constants.dart';
import '../data/boxes.dart';
import '../menu/maintab_delegate.dart';
import '../modules/dynamic_layout/config/app_config.dart';
import '../services/index.dart';
import '../services/review_manager.dart';
import 'advertisement/index.dart' show AdvertisementConfig;
import 'cart/cart_model.dart';
import 'category/category_model.dart';
import 'filter_attribute_model.dart';
import 'product_wish_list_model.dart';
import 'recent_product_model.dart';
import 'user_model.dart';

class AppModel with ChangeNotifier {
  MultiSiteConfig? multiSiteConfig;
  AppConfig? appConfig;
  AdvertisementConfig advertisement = const AdvertisementConfig();
  Map? deeplink;
  late bool isMultiVendor;

  /// Loading State setting
  bool isLoading = true;
  bool isInit = false;
  bool isOpenFloatMenu = false;

  /// Current and Payment settings
  String? currency;
  String? currencyCode;
  Map<String, dynamic> currencyRate = <String, dynamic>{};

  /// Language Code
  String _langCode = kAdvanceConfig.defaultLanguage;

  String get langCode => _langCode;

  /// Theming values for light or dark theme mode
  ThemeMode? themeMode;

  bool get darkTheme => themeMode == ThemeMode.dark;

  set darkTheme(bool value) =>
      themeMode = value ? ThemeMode.dark : ThemeMode.light;

  ThemeConfig get themeConfig => darkTheme ? kDarkConfig : kLightConfig;

  /// The app will use mainColor from env.dart,
  /// or override it with mainColor from config JSON if found.
  String get mainColor {
    final configJsonMainColor = appConfig?.settings.mainColor;
    if (configJsonMainColor != null && configJsonMainColor.isNotEmpty) {
      return configJsonMainColor;
    }
    return themeConfig.mainColor;
  }

  /// Product and Category Layout setting
  List<String>? categories;
  List<Map>? remapCategories;
  Map? categoriesIcons;
  String categoryLayout = '';
  String vendorLayout = '';

  String get productListLayout => appConfig!.settings.productListLayout;

  double get ratioProductImage =>
      appConfig!.settings.ratioProductImage ??
      (kAdvanceConfig.ratioProductImage * 1.0);

  String get productDetailLayout =>
      appConfig!.settings.productDetail ?? kProductDetail.layout;

  kBlogLayout get blogDetailLayout => appConfig!.settings.blogDetail != null
      ? kBlogLayout.values.byName(appConfig!.settings.blogDetail!)
      : kAdvanceConfig.detailedBlogLayout;

  String? get countryCode => SettingsBox().countryCode;

  /// App Model Constructor
  AppModel([String? lang]) {
    _langCode = lang ?? _langCode;

    var selectedLanguage = getLanguageByCode(_langCode);

    // Check if init/current language is not supported
    if (selectedLanguage == null) {
      // Get default language from default config, if not supported then use
      // first language from supported languages
      selectedLanguage = getLanguageByCode(kAdvanceConfig.defaultLanguage) ??
          getLanguages().firstOrNull;
      _langCode = selectedLanguage?['code'] ?? _langCode;
    }

    advertisement = AdvertisementConfig.fromJson(adConfig: kAdConfig);
    isMultiVendor = ServerConfig().isVendorType();
  }

  void _updateAndSaveDefaultLanguage(String? lang) {
    final prefLang = SettingsBox().languageCode;
    _langCode = prefLang != null && prefLang.isNotEmpty
        ? prefLang
        : (lang ?? _langCode);
    SettingsBox().languageCode = _langCode.split('-').first.toLowerCase();
  }

  /// Update currency and country based on site config
  Future<void> _updateCurrencyForSite(
      BuildContext context, MultiSiteConfig? config) async {
    try {
      // Get currencyCode and countryCode from site config
      final siteCurrencyCode = config?.currencyCode;
      final siteCountryCode = config?.countryCode;

      if (siteCurrencyCode?.isNotEmpty ?? false) {
        // Find Currency object from currencies list in advanceConfig
        final targetCurrency = _findCurrencyByCurrencyCode(siteCurrencyCode!);

        if (targetCurrency != null) {
          // Update countryCode if available from site config
          final updatedCurrency = Currency(
            symbol: targetCurrency.symbol,
            decimalDigits: targetCurrency.decimalDigits,
            currencyDisplay: targetCurrency.currencyDisplay,
            currencyCode: targetCurrency.currencyCode,
            symbolBeforeTheNumber: targetCurrency.symbolBeforeTheNumber,
            countryCode: siteCountryCode ?? targetCurrency.countryCode,
          );

          await changeCurrency(context, updatedCurrency);
          printLog(
              '✅ Updated currency to $siteCurrencyCode for site ${config?.name}');
        } else {
          // Fallback to default currency if not found
          final defaultCurrency = kAdvanceConfig.defaultCurrency;
          if (defaultCurrency != null) {
            await changeCurrency(context, defaultCurrency);
            printLog(
                '⚠️ Currency $siteCurrencyCode not found, using default currency');
          }
        }
      } else {
        // Use default currency if site has no currencyCode
        final defaultCurrency = kAdvanceConfig.defaultCurrency;
        if (defaultCurrency != null) {
          await changeCurrency(context, defaultCurrency);
        }
      }
    } catch (e) {
      printLog('❌ Error updating currency for site: $e');
    }
  }

  /// Find Currency object from currencyCode in currencies list
  Currency? _findCurrencyByCurrencyCode(String currencyCode) {
    try {
      final currencies = kAdvanceConfig.currencies;
      return currencies.firstWhereOrNull(
        (currency) =>
            currency.currencyCode.toUpperCase() == currencyCode.toUpperCase(),
      );
    } catch (e) {
      printLog('❌ Lỗi khi tìm currency: $e');
      return null;
    }
  }

  /// Get persist config from Share Preference
  Future<bool> getPrefConfig({String? lang}) async {
    try {
      if (multiSiteConfig?.languageCode?.isEmpty ?? true) {
        _updateAndSaveDefaultLanguage(lang);
      }

      // Prioritize using currency from site config if available
      Currency? siteCurrency;
      if (multiSiteConfig?.currencyCode?.isNotEmpty ?? false) {
        siteCurrency =
            _findCurrencyByCurrencyCode(multiSiteConfig!.currencyCode!);
        if (siteCurrency != null &&
            (multiSiteConfig?.countryCode?.isNotEmpty ?? false)) {
          // Update countryCode from site config
          siteCurrency = Currency(
            symbol: siteCurrency.symbol,
            decimalDigits: siteCurrency.decimalDigits,
            currencyDisplay: siteCurrency.currencyDisplay,
            currencyCode: siteCurrency.currencyCode,
            symbolBeforeTheNumber: siteCurrency.symbolBeforeTheNumber,
            countryCode: multiSiteConfig!.countryCode!,
          );
        }
      }

      final effectiveCurrency = siteCurrency ?? kAdvanceConfig.defaultCurrency;

      darkTheme = SettingsBox().isDarkTheme ?? kDefaultDarkTheme;
      currency = SettingsBox().currency ?? effectiveCurrency?.currencyDisplay;
      currencyCode =
          SettingsBox().currencyCode ?? effectiveCurrency?.currencyCode;
      if (SettingsBox().countryCode == null) {
        SettingsBox().countryCode = effectiveCurrency?.countryCode;
      }

      isInit = true;
      await updateTheme(darkTheme);

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> changeLanguage(String languageCode, BuildContext context) async {
    try {
      _langCode = languageCode;
      SettingsBox().languageCode = _langCode;

      await loadAppConfig();
      eventBus.fire(const EventChangeLanguage());
      unawaited(loadCurrency());

      final categoryModel = Provider.of<CategoryModel>(context, listen: false);
      categoryModel.refreshCategoryList();
      unawaited(categoryModel.getCategories(
        sortingList: categories,
        categoryLayout: categoryLayout,
        remapCategories: remapCategories,
      ));
      unawaited(Provider.of<FilterAttributeModel>(context, listen: false)
          .getFilterAttributes());

      return true;
    } catch (err) {
      return false;
    }
  }

  Future<void> changeCurrency(
      BuildContext context, Currency newCurrency) async {
    try {
      final cartModel = Provider.of<CartModel>(context, listen: false);

      currency = newCurrency.currencyDisplay;
      currencyCode = newCurrency.currencyCode;
      SettingsBox().currencyCode = currencyCode;
      SettingsBox().currency = currency;
      SettingsBox().countryCode = newCurrency.countryCode;

      cartModel.changeCurrency(newCurrency.currencyCode);
      cartModel.updatePriceWhenCurrencyChanged(context);
      // Reload app config to apply new currency
      await loadAppConfig();
    } catch (error) {
      printLog('[changeCurrency] error: ${error.toString()}');
    }
  }

  Future<void> updateTheme(bool theme) async {
    try {
      darkTheme = theme;
      SettingsBox().isDarkTheme = theme;
      notifyListeners();
    } catch (error) {
      printLog('[updateTheme] error: ${error.toString()}');
    }
  }

  void loadStreamConfig(config) {
    appConfig = AppConfig.fromJson(config);
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCloudAppConfig(String url) async {
    /// Do not enable cache here because we need to get the latest config JSON.
    final appJson = await http.get(
      Uri.encodeFull(url).toUri()!,
      headers: {
        'Accept': 'application/json',
      },
    );
    appConfig = AppConfig.fromJson(
      convert.jsonDecode(
        convert.utf8.decode(appJson.bodyBytes),
      ),
    );
  }

  Future applyAppCaching() async {
    /// apply App Caching if isCaching is enable
    /// not use for Fluxbuilder
    if (!ServerConfig().isBuilder) {
      await Services().widget.onLoadedAppConfig(langCode, (configCache) {
        appConfig = AppConfig.fromJson(configCache);
      });
    }
  }

  void handleCategoryTab(TabBarMenuConfig categoryTab) {
    if (categoryTab.categories != null) {
      categories = List<String>.from(categoryTab.categories ?? []);
      if (ServerConfig().isShopify) {
        /// Support old type category (base64) work with new API
        /// Old type is base64, new type is url like gid://shopify/Collection/123456789
        categories = categories?.map(_parseShopifyCategories).toList();
      }
    }
    if (categoryTab.images != null) {
      categoriesIcons =
          categoryTab.images is Map ? Map.from(categoryTab.images) : null;
    }
    if (categoryTab.remapCategories != null) {
      remapCategories = categoryTab.remapCategories;

      /// Support old type category (base64) work with new API
      /// Old type is base64, new type is url like gid://shopify/Collection/123456789
      if (ServerConfig().isShopify) {
        remapCategories = remapCategories?.map((e) {
          for (var key in ['parent', 'category']) {
            if (e[key] != null) {
              e[key] = _parseShopifyCategories(e[key]);
            }
          }
          return e;
        }).toList();
      }
    }
    categoryLayout = categoryTab.categoryLayout;
  }

  Future<AppConfig?> loadAppConfig({Map<String, dynamic>? config}) async {
    isLoading = true;
    notifyListeners();

    var startTime = DateTime.now();

    try {
      if (!isInit) {
        await getPrefConfig();
      }

      if (config != null) {
        appConfig = AppConfig.fromJson(config);
      } else {
        /// load config from Notion
        if (ServerConfig().type == ConfigType.notion) {
          final appCfg = await Services().widget.onGetAppConfig(langCode);

          if (appCfg != null) {
            appConfig = appCfg;
          }
        }

        await _loadConfigJson();
      }

      await applyAppCaching();

      /// Load categories config for the Tabbar menu
      /// User to sort the category Setting
      /// Prefer loading category configuration from the first vendor tab

      final vendorTab = appConfig!.tabBar
          .toList()
          .firstWhereOrNull((e) => e.layout == 'vendor-list');

      final vendorCategoryTab = appConfig!.tabBar
          .toList()
          .firstWhereOrNull((e) => e.layout == 'vendors');

      final categoryTab = appConfig!.tabBar
          .toList()
          .firstWhereOrNull((e) => e.layout == 'category');

      if (vendorTab != null) {
        vendorLayout = vendorTab.vendorLayout;
      }
      if (vendorCategoryTab != null) {
        handleCategoryTab(vendorCategoryTab);
        vendorLayout = vendorCategoryTab.vendorLayout;
      } else if (categoryTab != null) {
        handleCategoryTab(categoryTab);
      }

      if (appConfig?.settings.tabBarConfig.alwaysShowTabBar != null) {
        Configurations().setAlwaysShowTabBar(
            appConfig?.settings.tabBarConfig.alwaysShowTabBar ?? false);
      }
      isLoading = false;

      notifyListeners();
      printLog('[Debug] Finish Load AppConfig', startTime);
      MainTabControlDelegate.getInstance().index =
          0; //Fix to show Home screen when switch Store in FluxStore MAX
      eventBus.fire(const EventLoadedAppConfig());
      return appConfig;
    } catch (err, trace) {
      printLog('🔴 AppConfig JSON loading error');
      printError(err, trace);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> loadCurrency() async {
    try {
      /// Load the Rate for Product Currency
      final rates = await Services().api.getCurrencyRate();
      if (rates != null) {
        currencyRate = rates;
        return rates;
      }
    } catch (_) {}
    return null;
  }

  void updateProductListLayout(layout) {
    if (appConfig == null || appConfig?.settings.productListLayout == layout) {
      return;
    }

    appConfig!.settings =
        appConfig!.settings.copyWith(productListLayout: layout);
    notifyListeners();
  }

  void raiseNotify() {
    notifyListeners();
  }

  String _parseShopifyCategories(String categoryId) {
    try {
      return EncodeUtils.decode(categoryId);
    } on FormatException catch (_) {
      return categoryId;
    }
  }

  void setMainSiteConfig() {
    if (SettingsBox().isSelectedSiteConfig?.isNotEmpty ?? false) {
      multiSiteConfig = Configurations.multiSiteConfigs?.firstWhereOrNull(
          (e) => e.serverConfig?['url'] == SettingsBox().isSelectedSiteConfig);
    }

    multiSiteConfig ??= (Configurations.multiSiteConfigs?.isNotEmpty ?? false)
        ? Configurations.multiSiteConfigs!.first
        : null;
    SettingsBox().selectedSiteConfig = multiSiteConfig?.serverConfig?['url'];
    Configurations.serverConfig =
        multiSiteConfig?.serverConfig ?? Configurations.serverConfig;
    Services().setAppConfig(serverConfig);
    isMultiVendor = ServerConfig().isVendorType();
    if (Configurations.mainSiteUrl?.isNotEmpty ?? false) {
      MultiSite.mainSiteUrl = Uri.tryParse('${Configurations.mainSiteUrl}');
    }
    if (multiSiteConfig?.configurations != null) {
      Configurations().loadConfigBySite(multiSiteConfig!.configurations!);
    }

    // Initialize ReviewManager with current site configuration
    try {
      final reviewManager = injector.get<ReviewManager>();
      reviewManager.updateSite(multiSiteConfig);
    } catch (e) {
      printLog('❌ Error initializing ReviewManager: $e');
    }

    _updateAndSaveDefaultLanguage(kAdvanceConfig.defaultLanguage);
  }

  Future changeSiteConfig(BuildContext context, MultiSiteConfig? config) async {
    if (multiSiteConfig?.name != config?.name) {
      try {
        if (config?.configurations != null) {
          Configurations().loadConfigBySite(config!.configurations!);
        }
        await Provider.of<UserModel>(context, listen: false).logout();
        await Provider.of<CartModel>(context, listen: false)
            .clearCart(isSaveRemote: false);
        await Provider.of<ProductWishListModel>(context, listen: false)
            .clearWishList();
        Provider.of<RecentModel>(context, listen: false).cleanRecentProducts();
        UserBox().orders = []; //clear local orders when change site

        multiSiteConfig = config;
        SettingsBox().selectedSiteConfig =
            multiSiteConfig?.serverConfig?['url'];
        Configurations.serverConfig =
            multiSiteConfig?.serverConfig ?? Configurations.serverConfig;
        Services().setAppConfig(serverConfig);

        // Update currency and country code based on site config
        await _updateCurrencyForSite(context, config);

        if (config?.configurations?['defaultDarkTheme'] != null) {
          await updateTheme(kDefaultDarkTheme);
        }
        isMultiVendor = ServerConfig().isVendorType();

        // Update ReviewManager with new site configuration
        try {
          final reviewManager = injector.get<ReviewManager>();
          reviewManager.updateSite(config);
        } catch (e) {
          printLog('❌ Error updating ReviewManager: $e');
        }

        await changeLanguage(config?.languageCode ?? _langCode, context);
      } catch (e) {
        rethrow;
      }
    }
  }

  Map? get overrideTranslation {
    final overrideLocale =
        appConfig?.overrideTranslation?['@@locale']?.toString() ?? '';
    if (overrideLocale.isEmpty ||
        overrideLocale.toLowerCase() != langCode.toLowerCase()) {
      return null;
    }

    return appConfig?.overrideTranslation;
  }

  Future _loadConfigJson() async {
    try {
      var configFolderPath = multiSiteConfig?.configFolder;

      if (kAppConfig.contains('http')) {
        // load on cloud config and update on air
        var path = kAppConfig;
        if (path.contains('.json')) {
          path = path.substring(0, path.lastIndexOf('/'));
          if (configFolderPath?.isNotEmpty ?? false) {
            path += '/$configFolderPath';
          }
          path += '/config_$langCode.json';
        }
        try {
          await fetchCloudAppConfig(path);
        } catch (_) {
          /// In case config_$langCode.json is not found,
          /// load user's original config URL.
          printLog(
              '🚑 Config at $path not found. Loading from $kAppConfig instead.');
          await fetchCloudAppConfig(kAppConfig);
        }
      } else {
        // load local config
        var path = (configFolderPath?.isNotEmpty ?? false)
            ? 'lib/config/$configFolderPath/config_$langCode.json'
            : 'lib/config/config_$langCode.json';

        try {
          final appJson = await rootBundle.loadString(path);
          appConfig = AppConfig.fromJson(convert.jsonDecode(appJson));
        } catch (e) {
          printLog(e);
          var path = kAppConfig;
          //load default template for site if config_xx.json is not existed in configFolderPath for multi sites
          if (configFolderPath?.isNotEmpty ?? false) {
            path =
                'lib/config/$configFolderPath/config_${kAdvanceConfig.defaultLanguage}.json';
          }
          final appJson = await rootBundle.loadString(path);
          appConfig = AppConfig.fromJson(convert.jsonDecode(appJson));
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
