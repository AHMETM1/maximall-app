import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/config.dart';
import 'common/config/models/onboarding_config.dart';
import 'common/constants.dart';
import 'common/theme/index.dart';
import 'common/tools.dart';
import 'data/boxes.dart';
import 'models/brand_layout_model.dart';
import 'models/index.dart'
    show
        AppModel,
        BlogModel,
        CartModel,
        CategoryModel,
        FilterAttributeModel,
        ListingLocationModel,
        NotificationModel,
        ProductPriceModel,
        TagModel;
import 'modules/dynamic_layout/config/app_config.dart';
import 'modules/dynamic_layout/helper/helper.dart';
import 'screens/app_error.dart';
import 'screens/base_screen.dart';
import 'screens/blog/models/list_blog_model.dart';
import 'services/index.dart';
import 'widgets/common/splash_screen.dart';

class AppInit extends StatefulWidget {
  const AppInit();

  @override
  State<AppInit> createState() => _AppInitState();
}

class _AppInitState extends BaseScreen<AppInit> {
  bool isLoggedIn = false;

  /// It is true if the app is initialized
  bool hasLoadedData = false;
  bool hasLoadedSplash = false;

  late AppConfig? appConfig;

  AppModel get appModel => getModel<AppModel>();
  OnBoardingConfig get onBoardingConfig =>
      appModel.appConfig?.onBoardingConfig ?? kOnBoardingConfig;

  NotificationModel get _notificationModel =>
      Provider.of<NotificationModel>(context, listen: false);

  T getModel<T extends Object>() => context.read<T>();

  Future<void> loadInitData() async {
    try {
      printLog('[AppState] Init Data 💫');
      isLoggedIn = UserBox().isLoggedIn;

      /// set the server config at first loading
      if (ServerConfig().isBuilder) {
        Services().setAppConfig(serverConfig);
      }

      final appModel = getModel<AppModel>();
      final blogModel = getModel<BlogModel>();
      final brandModel = getModel<BrandLayoutModel>();
      final cartModel = getModel<CartModel>();
      final categoryModel = getModel<CategoryModel>();
      final filterAttributeModel = getModel<FilterAttributeModel>();
      final listBlogModel = getModel<ListBlogModel>();
      final listingLocationModel = ServerConfig().isListingType
          ? getModel<ListingLocationModel>()
          : null;
      final productPriceModel = getModel<ProductPriceModel>();
      final tagModel = getModel<TagModel>();

      /// Load layout config
      appConfig = await appModel.loadAppConfig(config: kLayoutConfig);

      hasLoadedData = true;

      if (hasLoadedSplash) {
        goToNextScreen();
      }

      Future.delayed(
        Duration.zero,
        () async {
          // High priority requests to show data as soon as possible in the home
          // or other screens in tabbars
          final highPriorityRequests = <Future>[
            appModel.loadCurrency().then((currencyRate) {
              if (currencyRate != null) {
                cartModel.changeCurrencyRates(currencyRate);
              }
            }),
            categoryModel.getCategories(
              sortingList: appModel.categories,
              categoryLayout: appModel.categoryLayout,
              remapCategories: appModel.remapCategories,
            ),
            brandModel.getBrands(),
            listBlogModel.getBlogs(),
          ];

          await Future.wait(highPriorityRequests);

          // Request data to display on commonly used screens
          final priorityRequests = <Future>[
            tagModel.getTags(),
            filterAttributeModel.getFilterAttributes(),
            productPriceModel.getMinMaxPrices(),
            if (listingLocationModel != null)
              listingLocationModel.getLocations(),
          ];

          await Future.wait(priorityRequests);

          // Request data to display on rarely used screens
          final lowPriorityRequests = <Future>[
            if (ServerConfig().isWordPress == false) ...[
              blogModel.getCategoryList(),
              blogModel.getTagList(),
            ],
            cartModel.getListCountries(),
          ];

          await Future.wait(lowPriorityRequests);
        },
      );

      printLog('[AppState] InitData Finish');
    } catch (err, trace) {
      printError(err, trace);
    }
  }

  void goToNextScreen() async {
    /// Update status bar color on Android
    if (isMobile) {
      context.updateSystemUiOverlay();
    }

    if (appConfig == null) {
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AppError(),
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
    final isOpenOnboarding = !SettingsBox().hasFinishedOnboarding;
    final isOpenPermissionNotification =
        Services().widget.isRequiredLogin && isOpenOnboarding;

    if (Layout.isDisplayDesktop(context)) {
      if (isOpenPermissionNotification) {
        await _notificationModel.enableNotification();
      }

      await Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
      return;
    }

    if (!kIsWeb && appConfig != null) {
      if (onBoardingConfig.enableOnBoarding &&
          (isOpenOnboarding || !onBoardingConfig.isOnlyShowOnFirstTime)) {
        await Navigator.of(context).pushReplacementNamed(RouteList.onBoarding);
        return;
      }

      if (isOpenOnboarding) {
        if (kIsShowPermissionNotification) {
          await Navigator.of(context)
              .pushReplacementNamed(RouteList.notificationRequest);
          return;
        }

        await _notificationModel.enableNotification();
        SettingsBox().hasFinishedOnboarding = true;
      }
    }

    if (kIsShowRequestAgreedPrivacy) {
      await Navigator.of(context).pushReplacementNamed(RouteList.privacyTerms);
      return;
    }

    if (!SettingsBox().hasSelectedSite &&
        (Configurations.multiSiteConfigs?.isNotEmpty ?? false) &&
        kAdvanceConfig.isRequiredSiteSelection) {
      await Navigator.of(context).pushNamed(RouteList.multiSiteSelection);
      SettingsBox().hasSelectedSite = true;
    }

    if (Services().widget.isRequiredLogin && !isLoggedIn) {
      await NavigateTools.navigateToLogin(
        context,
        replacement: true,
      );
      return;
    }

    await Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
  }

  void checkToShowNextScreen() {
    /// If the config was load complete then navigate to Dashboard
    hasLoadedSplash = true;
    if (hasLoadedData) {
      goToNextScreen();
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadInitData();
  }

  @override
  Widget build(BuildContext context) {
    var splashScreenType = kSplashScreen.type;
    dynamic splashScreenImage = kSplashScreen.image;
    var duration = kSplashScreen.duration;
    return SplashScreenIndex(
      imageUrl: splashScreenImage,
      splashScreenType: splashScreenType,
      actionDone: checkToShowNextScreen,
      duration: duration,
    );
  }
}
