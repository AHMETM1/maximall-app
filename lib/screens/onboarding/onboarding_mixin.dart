import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/config/models/onboarding_config.dart';
import '../../common/constants.dart';
import '../../common/tools/image_tools.dart';
import '../../common/tools/navigate_tools.dart';
import '../../data/boxes.dart';
import '../../models/notification_model.dart';
import '../home/change_language_mixin.dart';

mixin OnBoardingMixin<T extends StatefulWidget> on ChangeLanguage<T> {
  OnBoardingConfig get config;

  final isRequiredLogin = kLoginSetting.isRequiredLogin;
  final isEnableRegister = kLoginSetting.enableRegister;
  final isEnableLogin = kLoginSetting.enable;

  int page = 0;

  NotificationModel get _notificationModel =>
      Provider.of<NotificationModel>(context, listen: false);

  bool get enableAuth =>
      Configurations.multiSiteConfigs?.isEmpty ?? true && isEnableLogin;

  bool get hasFinishedOnboarding => SettingsBox().hasFinishedOnboarding;

  void setHasSeen() {
    SettingsBox().hasFinishedOnboarding = true;
  }

  void onTapSignUp() => _onHandleFlowAction(
      (ct) => NavigateTools.navigateRegister(ct, replacement: true));

  void onTapSignIn() => _onHandleFlowAction(
      (ct) => NavigateTools.navigateToLogin(ct, replacement: true));

  void _onHandleFlowAction(void Function(BuildContext ct)? onFinish) {
    void actionFinish(BuildContext finishContext) {
      setHasSeen();
      onFinish?.call(finishContext);
    }

    if (kIsShowPermissionNotification) {
      Navigator.of(context).pushReplacementNamed(
        RouteList.notificationRequest,
        arguments: {
          'onFinish': (BuildContext ctParent) => _openPrivacyTerms(
                ctParent,
                (ct) => actionFinish(ct),
              )
        },
      );
      return;
    }

    _openPrivacyTerms(context, (ct) => actionFinish(ct));
  }

  void _openPrivacyTerms(
      BuildContext ctParent, void Function(BuildContext ct)? onFinish) {
    if (kIsShowRequestAgreedPrivacy) {
      Navigator.of(ctParent).pushReplacementNamed(
        RouteList.privacyTerms,
        arguments: {
          'onFinish': (BuildContext ct) => onFinish?.call(ct),
        },
      );

      return;
    }

    onFinish?.call(ctParent);
  }

  void onTapDone() async {
    setHasSeen();
    final isLoggedIn = UserBox().isLoggedIn;

    if (kIsShowPermissionNotification) {
      await Navigator.of(context)
          .pushReplacementNamed(RouteList.notificationRequest);
      return;
    }

    await _notificationModel.enableNotification();

    if (isRequiredLogin && !isLoggedIn && isEnableLogin) {
      await NavigateTools.navigateToLogin(
        context,
        replacement: true,
      );
      return;
    }

    if ((Configurations.multiSiteConfigs?.isNotEmpty ?? false) &&
        kAdvanceConfig.isRequiredSiteSelection) {
      await Navigator.of(context).pushNamed(RouteList.multiSiteSelection);
      SettingsBox().hasSelectedSite = true;
    }
    if (hasFinishedOnboarding) {
      await Navigator.pushReplacementNamed(context, RouteList.dashboard);
      return;
    }

    if (kIsShowRequestAgreedPrivacy) {
      await Navigator.of(context).pushReplacementNamed(
        RouteList.privacyTerms,
      );
    } else {
      await Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
    }
  }

  @override
  void initState() {
    super.initState();
    ImageTools.preLoadingListImagesInitState(
      config.items.map((e) => e.image).toList(),
      context,
    );
    if (config.showLanguagePopup && !hasFinishedOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          showLanguageSelector(context);
        });
      });
    }
  }
}
