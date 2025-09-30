import 'dart:convert';

import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../widgets/common/webview.dart';
import '../common/app_bar_mixin.dart';

class StaticSite extends StatefulWidget {
  final String? data;

  const StaticSite({this.data});

  @override
  State<StaticSite> createState() => _StaticSiteState();
}

class _StaticSiteState extends State<StaticSite> with AppBarMixin {
  String convertToHtml() {
    var value = widget.data ?? '';
    if (value.isEmpty) return '';
    try {
      return const Utf8Decoder().convert(base64Decode(value));
    } catch (e) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    const routeName = RouteList.html;

    final showNewAppBar = appBar?.shouldShowOn(routeName) ?? false;
    // Even though [WebView] also has `renderScaffold` inside it, we still use
    // `renderScaffold` here for [SafeArea] widget
    return renderScaffold(
      routeName: routeName,
      disableSafeArea: true,
      child: SafeArea(
        // Use [SafeArea] in case there is no app bar
        top: showNewAppBar == false,
        child: WebView.html(
          convertToHtml(),
          enableForward: false,
          enableBackward: false,
          enableClose: false,
          hideNewAppBar: true,
          showAppBar: false,
          routeName: routeName,
          shouldPreventNavigator: (String url) async {
            if (url.startsWith('https://www.youtube.com/')) {
              return true;
            }
            return false;
          },
        ),
      ),
    );
  }
}
