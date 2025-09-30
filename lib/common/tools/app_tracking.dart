import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/boxes.dart';
import '../../models/entities/app_tracking_transparency_status.dart';
import '../../widgets/common/flux_alert.dart';
import '../config.dart';
import '../constants.dart';

class AppTracking {
  static Completer? _completer;
  static void _updateStatus(AppTrackingTransparencyStatus status) {
    SettingsBox().appTrackingTransparencyStatus = status;
  }

  static void _completed() {
    _completer?.complete();
    _completer = null;
  }

  /// Because the app_tracking_transparency library only supports iOS,
  /// so for other platforms it will return true by default.
  static Future<bool> requestAuthorization() async {
    if (!isIos || SettingsBox().appTrackingTransparencyStatus.isAuthorized) {
      _updateStatus(AppTrackingTransparencyStatus.authorized);
      return true;
    }

    try {
      _completer = Completer();
      var status = await AppTrackingTransparency.trackingAuthorizationStatus;

      // Because on iOS 18+ there is an issue where permission popups conflict,
      // this makes some requests unable to open. Temporarily fix by repeating
      // the permission request until
      // status != TrackingStatus.notDetermined (Delay 1s between requests)
      // Related: https://github.com/deniza/app_tracking_transparency/issues/59#issuecomment-2553510496
      while (status == TrackingStatus.notDetermined) {
        _updateStatus(AppTrackingTransparencyStatus.requesting);

        // Request system's tracking authorization dialog
        status = await AppTrackingTransparency.requestTrackingAuthorization();

        if (status != TrackingStatus.notDetermined) {
          break;
        }

        await Future.delayed(const Duration(seconds: 1));
      }

      if (status == TrackingStatus.authorized) {
        _updateStatus(AppTrackingTransparencyStatus.authorized);
        _completed();
        return true;
      }

      printLog(':::::::::[AppTrackingTransparency] Tracking not authorized');
      var statusTracking =
          [TrackingStatus.denied, TrackingStatus.notSupported].contains(status)
              ? AppTrackingTransparencyStatus.deniend
              : AppTrackingTransparencyStatus.canRequest;

      _updateStatus(statusTracking);
      _completed();
      return false;
    } catch (e) {
      if (SettingsBox().appTrackingTransparencyStatus.isFirstTime) {
        _updateStatus(AppTrackingTransparencyStatus.canRequest);
      }

      _completed();
      return false;
    }
  }

  static Future<void> recheck(BuildContext context) async {
    if (kAdvanceConfig.enableManualAppTrackingTransparency == false) {
      return;
    }

    if (_completer != null) {
      await _completer!.future;
    }

    final appTrackingTransparencyStatus =
        SettingsBox().appTrackingTransparencyStatus;

    if (appTrackingTransparencyStatus.isCanRequest) {
      return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FluxAlert.text(
                title: S.of(context).appTrackingTransparency,
                body: S.of(context).appTrackingRequest,
                primaryAction: S.of(context).openSettings,
                secondaryAction: S.of(context).cancel,
                onPrimaryPressed: openAppSettings,
                onSecondaryPressed: Navigator.of(context).pop,
              ),
            ),
          );
        },
      );
    }
  }
}
