part of '../../boxes.dart';

extension GeneralSettings on SettingsBox {
  bool get hasFinishedOnboarding {
    return box.get(
      BoxKeys.hasFinishedOnboarding,
      defaultValue: false,
    );
  }

  set hasFinishedOnboarding(bool value) {
    box.put(BoxKeys.hasFinishedOnboarding, value);
  }

  bool get hasSelectedSite {
    return box.get(
      BoxKeys.hasSelectedSite,
      defaultValue: false,
    );
  }

  set hasSelectedSite(bool value) {
    box.put(BoxKeys.hasSelectedSite, value);
  }

  set selectedSiteConfig(String? value) {
    if (value == null) {
      box.delete(BoxKeys.selectedSiteConfig);
      return;
    }
    box.put(BoxKeys.selectedSiteConfig, value);
  }

  String? get isSelectedSiteConfig {
    return box.get(
      BoxKeys.selectedSiteConfig,
      defaultValue: null,
    );
  }

  bool? get isDarkTheme {
    return box.get(
      BoxKeys.isDarkTheme,
    );
  }

  set isDarkTheme(bool? value) {
    if (value == null) {
      box.delete(BoxKeys.isDarkTheme);
      return;
    }
    box.put(BoxKeys.isDarkTheme, value);
  }

  int get popupBannerLastUpdatedTime {
    return box.get(
      BoxKeys.popupBannerLastUpdatedTime,
      defaultValue: 0,
    );
  }

  set popupBannerLastUpdatedTime(int value) {
    box.put(BoxKeys.popupBannerLastUpdatedTime, value);
  }

  bool get hasShowPermissionNotification {
    return box.get(
      BoxKeys.hasShowPermissionNotification,
      defaultValue: false,
    );
  }

  set hasShowPermissionNotification(bool value) {
    box.put(BoxKeys.hasShowPermissionNotification, value);
  }

  bool get hasAgreedPrivacy {
    return box.get(
      BoxKeys.hasAgreedPrivacy,
      defaultValue: false,
    );
  }

  set hasAgreedPrivacy(bool value) {
    box.put(BoxKeys.hasAgreedPrivacy, value);
  }

  AppTrackingTransparencyStatus get appTrackingTransparencyStatus {
    return AppTrackingTransparencyStatus.fromString(
      box.get(
        BoxKeys.appTrackingTransparencyStatus,
        defaultValue: AppTrackingTransparencyStatus.firstTime.name,
      ),
    );
  }

  set appTrackingTransparencyStatus(AppTrackingTransparencyStatus value) {
    box.put(BoxKeys.appTrackingTransparencyStatus, value.name);
  }
}
