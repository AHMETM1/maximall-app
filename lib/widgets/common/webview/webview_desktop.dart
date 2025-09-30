import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/config.dart';
import 'webview_interface.dart';

class WebViewDesktop extends WebviewInterface {
  const WebViewDesktop({
    super.key,
    super.url,
    super.data,
    super.title,
    super.script,
    super.onClosed,
    super.headers,
    super.enableBackward,
    super.enableForward,
    super.enableClose,
    super.appBar,
    super.showAppBar,
    super.showLoading,
    super.hideNewAppBar,
  });

  @override
  State<WebViewDesktop> createState() => WebViewDesktopState();
}

class WebViewDesktopState extends StateWebviewInterface<WebViewDesktop> {
  final GlobalKey webViewKey = GlobalKey();

  int selectedIndex = 1;

  InAppWebViewController? webViewController;

  final InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    transparentBackground: true,
    mediaPlaybackRequiresUserGesture: false,
    useOnDownloadStart: true,
    useHybridComposition: true,
    allowsInlineMediaPlayback: true,
    geolocationEnabled: true,
    useWideViewPort: true,
  );

  bool get _canPop =>
      ModalRoute.of(context)?.canPop ?? Navigator.of(context).canPop();

  URLRequest? get initialUrlRequest {
    final webUrl = url;
    if (webUrl != null) {
      return URLRequest(
        url: WebUri(webUrl),
        headers: widget.headers,
      );
    }
    return null;
  }

  InAppWebViewInitialData? get initialData {
    final html = widget.data;
    if (html != null && html.isNotEmpty) {
      return InAppWebViewInitialData(
        data: html,
      );
    }
    return null;
  }

  @override
  void onTapBackButton(BuildContext buildContext) async {
    final value = await webViewController?.canGoBack();
    if (value == true) {
      await webViewController?.goBack();
    } else if (!widget.enableClose && _canPop) {
      widget.onClosed?.call();
      Navigator.of(context).pop();
    }
  }

  @override
  void onTapForwardButton(BuildContext buildContext) {
    webViewController?.goForward();
  }

  @override
  void onTapCloseButton() async {
    widget.onClosed?.call();

    if (_canPop) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    if (kAdvanceConfig.alwaysClearWebViewCache) {
      InAppWebViewController.clearAllCache();
    }
    super.dispose();
  }

  @override
  Widget renderWebview() {
    return IndexedStack(
      index: selectedIndex,
      children: [
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: initialUrlRequest,
          initialData: initialData,
          initialUserScripts: UnmodifiableListView<UserScript>([
            /// Demo the Javascript Style override
            UserScript(
              source: widget.script,
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
            ),
          ]),
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return NavigationActionPolicy.ALLOW;
          },
          gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{}..add(
              const Factory<VerticalDragGestureRecognizer>(
                  VerticalDragGestureRecognizer.new),
            ),
          initialSettings: settings,
          onWebViewCreated: (controller) {
            webViewController = controller;
            InAppWebViewController.clearAllCache();
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          onGeolocationPermissionsShowPrompt:
              (InAppWebViewController controller, String origin) async {
            var status = await Permission.locationWhenInUse.status;

            if (status.isDenied) {
              // For the first time if user have never asked for permission yet,
              // this status will return [PermissionStatus.denied].
              status = await Permission.locationWhenInUse.request();
            } else if (status.isPermanentlyDenied) {
              // For the next time if user already denied permission, they
              // must go to app settings to allow permission manually again.
              await openAppSettings();
            }

            return GeolocationPermissionShowPromptResponse(
              origin: origin,
              allow: status.isGranted,
              retain: true,
            );
          },
          onLoadStop: (_, __) {
            setState(() {
              selectedIndex = 0;
            });
          },
          onDownloadStartRequest: (_, request) async {
            await launchUrl(request.url);
          },
        ),
        if (widget.showLoading)
          Center(
            child: kLoadingWidget(context),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
