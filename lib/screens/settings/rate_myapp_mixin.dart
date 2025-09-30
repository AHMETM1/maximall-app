import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../common/config.dart';
import '../../common/constants.dart';

mixin RateMyAppMixin<T extends StatefulWidget> on State<T> {
  final _rateMyApp = RateMyApp(
    // rate app on store
    minDays: kAppRatingConfig.minDays,
    minLaunches: kAppRatingConfig.minLaunches,
    remindDays: kAppRatingConfig.remindDays,
    remindLaunches: kAppRatingConfig.remindLaunches,
    googlePlayIdentifier: kAppRatingConfig.googlePlayIdentifier,
    appStoreIdentifier: kAppRatingConfig.appStoreIdentifier,
  );

  void showRateMyApp() async {
    await _rateMyApp.init();
    await _rateMyApp.showRateDialog(
      context,
      title: S.of(context).rateTheApp,
      // The dialog title.
      message: S.of(context).rateThisAppDescription,
      // The dialog message.
      rateButton: S.of(context).rate.toUpperCase(),
      // The dialog 'rate' button text.
      noButton: S.of(context).noThanks.toUpperCase(),
      // The dialog 'no' button text.
      laterButton: S.of(context).maybeLater.toUpperCase(),
      // The dialog 'later' button text.
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            break;
          case RateMyAppDialogButton.later:
            break;
          case RateMyAppDialogButton.no:
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      // DON'T use native popup on Android. Set to false if you want to show the
      // native Apple app rating dialog on iOS.
      ignoreNativeDialog: isAndroid,
      // Called when the user dismissed the dialog (either by taping outside
      // or by pressing the "back" button).
      onDismissed: () => _rateMyApp.callEvent(
        RateMyAppEventType.laterButtonPressed,
      ),
    );
  }

  /// Only use after show dashboard
  void showRatingOnOpen() async {
    if (mounted) {
      await _rateMyApp.init();

      if (isMobile && kAppRatingConfig.showOnOpen) {
        if (_rateMyApp.shouldOpenDialog) {
          await Future.delayed(const Duration(seconds: 1));
          showRateMyApp();
        }
      }
    }
  }
}
