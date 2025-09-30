import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import 'webview/webview_desktop.dart';
import 'webview/webview_flutter.dart';
import 'webview/webview_inapp.dart';
import 'webview/webview_web.dart';

mixin WebviewMixin {
  /// Return true when overridden and the navigation in webview should stop.
  Future<bool> shouldPreventWebNavigation(String url) async {
    /// open the normal web link
    var isHttp = 'http';
    if (url.startsWith(isHttp)) {
      return false;
    }

    try {
      final newUrl = Tools.prepareURL(url);
      return await Tools.launchURL(
        newUrl,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (err, stack) {
      printError(err, stack);
      return false;
    }
  }
}

class WebView extends StatefulWidget {
  late final String data;
  late final bool isHTML;
  final String? title;
  final AppBar? appBar;
  final bool enableForward;
  final bool enableBackward;
  final bool enableClose;
  final Future<bool> Function(String url)? shouldPreventNavigator;
  final Function(String url)? onPageFinished;
  final Function? onClosed;
  final String script;
  final Map<String, String>? headers;
  final String? routeName;
  final bool hideNewAppBar;
  final bool showAppBar;
  final bool showLoading;

  WebView(
    String url, {
    super.key,
    this.title,
    this.appBar,
    this.shouldPreventNavigator,
    this.onPageFinished,
    this.onClosed,
    this.script = '',
    this.headers,
    this.enableForward = true,
    this.enableBackward = true,
    this.enableClose = true,
    this.routeName,
    this.hideNewAppBar = false,
    this.showAppBar = true,
    this.showLoading = true,
  }) {
    data = url;
    isHTML = false;
  }

  WebView.html(
    String html, {
    super.key,
    this.title,
    this.appBar,
    this.shouldPreventNavigator,
    this.onPageFinished,
    this.onClosed,
    this.script = '',
    this.headers,
    this.enableForward = true,
    this.enableBackward = true,
    this.enableClose = true,
    this.routeName,
    this.hideNewAppBar = false,
    this.showAppBar = true,
    this.showLoading = true,
  }) {
    data = html;
    isHTML = true;
  }

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> with WebviewMixin {
  String? get url => widget.isHTML ? null : widget.data;
  String? get data => widget.isHTML ? widget.data : null;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebviewWeb(
        url: url,
        data: data,
        title: widget.title,
        routeName: widget.routeName,
        enableForward: widget.enableForward,
        enableBackward: widget.enableBackward,
        enableClose: widget.enableClose,
        onClosed: widget.onClosed,
        appBar: widget.appBar,
        showLoading: widget.showLoading,
        showAppBar: widget.showAppBar,
        hideNewAppBar: widget.hideNewAppBar,
      );
    }

    if (isWindow || isMacOS) {
      return WebViewDesktop(
        url: url,
        data: data,
        title: widget.title,
        script: widget.script.isEmptyOrNull
            ? kAdvanceConfig.webViewScript
            : widget.script,
        headers: widget.headers,
        enableForward: widget.enableForward,
        enableBackward: widget.enableBackward,
        enableClose: widget.enableClose,
        onClosed: widget.onClosed,
        appBar: widget.appBar,
        showLoading: widget.showLoading,
        showAppBar: widget.showAppBar,
        hideNewAppBar: widget.hideNewAppBar,
      );
    }

    if (kAdvanceConfig.inAppWebView) {
      return WebViewInApp(
        url: url,
        data: data,
        shouldPreventNavigator:
            widget.shouldPreventNavigator ?? shouldPreventWebNavigation,
        routeName: widget.routeName,
        title: widget.title,
        script: widget.script.isEmptyOrNull
            ? kAdvanceConfig.webViewScript
            : widget.script,
        headers: widget.headers,
        enableForward: widget.enableForward,
        enableBackward: widget.enableBackward,
        enableClose: widget.enableClose,
        onClosed: widget.onClosed,
        onUrlChanged: (String? url, String? html, webViewController) {
          widget.onPageFinished?.call(url ?? '');
        },
        appBar: widget.appBar,
        showLoading: widget.showLoading,
        showAppBar: widget.showAppBar,
        hideNewAppBar: widget.hideNewAppBar,
      );
    }

    return WebviewFlutter(
      url: url,
      data: data,
      title: widget.title,
      shouldPreventNavigator:
          widget.shouldPreventNavigator ?? shouldPreventWebNavigation,
      routeName: widget.routeName,
      script: widget.script.isEmptyOrNull
          ? kAdvanceConfig.webViewScript
          : widget.script,
      headers: widget.headers,
      enableForward: widget.enableForward,
      enableBackward: widget.enableBackward,
      enableClose: widget.enableClose,
      onClosed: widget.onClosed,
      appBar: widget.appBar,
      showLoading: widget.showLoading,
      showAppBar: widget.showAppBar,
      hideNewAppBar: widget.hideNewAppBar,
      onPageFinished: widget.onPageFinished,
    );
  }
}
