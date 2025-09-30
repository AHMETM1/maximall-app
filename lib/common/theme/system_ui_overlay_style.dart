import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SystemUiOverlayStyle get kSystemOverlayStyleDark =>
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    );

SystemUiOverlayStyle get kSystemOverlayStyleLight =>
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

SystemUiOverlayStyle getSystemUiOverlay(bool isDarkTheme) =>
    isDarkTheme ? kSystemOverlayStyleDark : kSystemOverlayStyleLight;

/// {@template common.theme.system_ui_overlay_style.setSystemUiOverlay}
/// Can be overridden by systemOverlayStyle in each theme
/// But sometimes needed for SliverAppBar
/// {@endtemplate}
void setSystemUiOverlay(bool isDarkTheme) {
  SystemChrome.setSystemUIOverlayStyle(getSystemUiOverlay(isDarkTheme));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
}

extension SystemUiOverlayStyleExtensionBuildContext on BuildContext {
  /// {@macro common.theme.system_ui_overlay_style.setSystemUiOverlay}
  void updateSystemUiOverlay([bool? isDarkTheme]) {
    final isDark = isDarkTheme ?? Theme.of(this).brightness == Brightness.dark;
    setSystemUiOverlay(isDark);
  }
}
