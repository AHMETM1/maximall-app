import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' hide kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/entities/cookie_data.dart';
import 'webview_interface.dart';

class WebViewInApp extends WebviewInterface {
  final Function(String?, String?, InAppWebViewController?)? onUrlChanged;
  final List<CookieData>? cookies;

  const WebViewInApp({
    super.key,
    super.url,
    super.data,
    super.title,
    super.script,
    this.onUrlChanged,
    super.onClosed,
    super.headers,
    super.enableBackward,
    super.enableForward,
    super.enableClose,
    super.shouldPreventNavigator,
    super.onRedirectUrl,
    super.appBar,
    super.routeName,
    super.hideNewAppBar,
    super.showAppBar,
    super.showLoading,
    this.cookies,
  });

  @override
  State<WebViewInApp> createState() => WebViewInAppState();
}

class WebViewInAppState extends StateWebviewInterface<WebViewInApp> {
  final GlobalKey webViewKey = GlobalKey();

  int selectedIndex = 1;

  InAppWebViewController? webViewController;

  final _cookieManager = CookieManager.instance();

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

  late PullToRefreshController pullToRefreshController;

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
    if (kAdvanceConfig.alwaysClearWebViewCookie) {
      _cookieManager.deleteAllCookies();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.cookies?.isNotEmpty ?? false) {
      if (widget.url?.isEmpty ?? true) {
        return;
      }
      for (var cookie in widget.cookies!) {
        if (cookie.valid) {
          _cookieManager.setCookie(
            url: WebUri('${widget.url}'),
            name: cookie.name,
            value: cookie.value,
            isSecure: true,
          );
        }
      }
    }

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.black45,
      ),
      onRefresh: () async {
        printLog('[WebView InApp] Pull to Refresh');
        if (isAndroid) {
          await webViewController?.reload();
        } else if (isIos) {
          await webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  Future<void> _onUrlChange(WebUri? uri) async {
    if (widget.onUrlChanged != null) {
      final html = await webViewController?.getHtml();
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          widget.onUrlChanged?.call(uri?.toString(), html, webViewController));
    }
  }

  void _onRedirectUrl(String url, InAppWebViewController controller) {
    widget.onRedirectUrl?.call(
      url,
      (url) async {
        await controller.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
      },
      () async {
        final html = await controller.getHtml();
        return html;
      },
    );
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
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url.toString();
            printLog('[WebViewInApp] should prevent navigator: $url');

            // handle redirect url
            _onRedirectUrl(url, controller);

            final prevent =
                await widget.shouldPreventNavigator?.call(url) ?? false;
            if (prevent) {
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
          initialUserScripts: UnmodifiableListView<UserScript>([
            /// Demo the Javascript Style override
            UserScript(
              source: widget.script,
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
            ),
          ]),
          gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{}..add(
              const Factory<VerticalDragGestureRecognizer>(
                  VerticalDragGestureRecognizer.new),
            ),
          initialSettings: settings,
          pullToRefreshController: pullToRefreshController,
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
          onReceivedError: (controller, request, error) {
            pullToRefreshController.endRefreshing();
          },
          onLoadStop: (androidIsReload, uri) {
            setState(() {
              selectedIndex = 0;
            });
            if (isAndroid) {
              _onUrlChange(uri);
            }
          },
          onProgressChanged: (_, progress) {
            if (progress == 100) {
              pullToRefreshController.endRefreshing();
            }
          },
          onUpdateVisitedHistory: (ctrl, uri, androidIsReload) {
            if (isAndroid == false) {
              _onUrlChange(uri);
            }
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
