import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../common/constants.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../routes/flux_navigate.dart';
import '../common/webview.dart';

mixin WebLayoutMixin {
  void onTapOpenUrl(BuildContext context, String? urlWeb) {
    if (urlWeb?.isEmpty ?? true) {
      return;
    }

    if (kIsWeb || Layout.isDisplayDesktop(context)) {
      Tools.launchURL(urlWeb);
      return;
    }

    FluxNavigate.push(
      MaterialPageRoute(
        builder: (context) => WebView(
          '$urlWeb',
          title: S.of(context).support,
        ),
      ),
      forceRootNavigator: true,
      context: context,
    );
  }
}
