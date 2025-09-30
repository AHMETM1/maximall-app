import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../common/config/models/general_setting_item.dart';
import '../../../../common/constants.dart';
import '../../../../common/extensions/extensions.dart';
import '../../../../models/app_model.dart';
import '../../../../models/entities/user.dart';
import '../../../../modules/dynamic_layout/helper/helper.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../services/service_config.dart';
import '../../../../widgets/common/webview.dart';
import '../../../posts/post_screen.dart';

mixin SettingActionMixin {
  bool _isDesktop(BuildContext context) => Layout.isDisplayDesktop(context);

  void onTapOpenPrivacy(BuildContext context, {GeneralSettingItem? privacy}) {
    final appConfig = Provider.of<AppModel>(context, listen: false).appConfig;

    // Need to check [privacy?.webUrl] here because we want to prioritize
    // loading data from [privacy]. If [privacy] is null, then load data from
    // [appConfig] and [kAdvanceConfig].
    final pageId = privacy?.pageId ??
        (privacy?.webUrl == null
            ? appConfig?.privacyPoliciesPageId ??
                kAdvanceConfig.privacyPoliciesPageId
            : null);

    String? pageUrl = privacy?.webUrl ??
        appConfig?.privacyPoliciesPageUrl ??
        kAdvanceConfig.privacyPoliciesPageUrl;

    if (pageId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(
            pageId: pageId,
            pageTitle: S.of(context).agreeWithPrivacy,
          ),
        ),
      );
      return;
    }

    if (pageUrl.isNotEmpty) {
      if (ServerConfig().isWooType || ServerConfig().isWordPress) {
        // Display in multiple languages
        var locale = Provider.of<AppModel>(context, listen: false).langCode;
        pageUrl = pageUrl.addUrlQuery('lang=$locale');
      }

      if (kIsWeb) {
        Tools.launchURL(pageUrl);
        return;
      }

      final pageRoute = MaterialPageRoute(
        builder: (context) => WebView(
          '$pageUrl',
          title: S.of(context).agreeWithPrivacy,
        ),
      );

      if (_isDesktop(context)) {
        Navigator.of(context).push(pageRoute);
        return;
      }

      FluxNavigate.push(
        pageRoute,
        context: context,
      );
    }
  }

  void openAboutUS(BuildContext context, {GeneralSettingItem? about}) {
    final pageId = about?.pageId;

    String? pageUrl = about?.webUrl ?? kAdvanceConfig.aboutUSPageUrl;

    if (pageId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(
            pageId: pageId,
            pageTitle: S.of(context).aboutUs,
          ),
        ),
      );
      return;
    }

    if (pageUrl.isNotEmpty) {
      if (ServerConfig().isWooType || ServerConfig().isWordPress) {
        // Display in multiple languages
        var locale = Provider.of<AppModel>(context, listen: false).langCode;
        pageUrl = pageUrl.addUrlQuery('lang=$locale');
      }

      if (kIsWeb) {
        Tools.launchURL(pageUrl);
        return;
      }

      final pageRoute = MaterialPageRoute(
        builder: (context) => WebView(
          '$pageUrl',
          title: S.of(context).aboutUs,
        ),
      );

      if (_isDesktop(context)) {
        Navigator.of(context).push(pageRoute);
        return;
      }

      FluxNavigate.push(
        pageRoute,
        context: context,
      );
    }
  }

  void openProfile(BuildContext context) {
    if (_isDesktop(context)) {
      Navigator.of(context).pushNamed(RouteList.updateUser);
      return;
    }

    FluxNavigate.pushNamed(
      RouteList.updateUser,
      context: context,
    );
  }

  void openMyOrder(BuildContext context, User user) {
    if (_isDesktop(context)) {
      Navigator.of(context).pushNamed(
        RouteList.orders,
        arguments: user,
      );
      return;
    }

    FluxNavigate.pushNamed(
      RouteList.orders,
      arguments: user,
      context: context,
    );
    return;
  }

  void openMyRating(
    BuildContext context, {
    required User user,
  }) {
    if (_isDesktop(context)) {
      Navigator.of(context).pushNamed(
        RouteList.myRating,
        arguments: user,
      );
      return;
    }

    FluxNavigate.pushNamed(
      RouteList.myRating,
      arguments: user,
      context: context,
    );
    return;
  }
}
