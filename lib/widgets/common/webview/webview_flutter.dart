import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import 'webview_interface.dart';

class WebviewFlutter extends WebviewInterface {
  const WebviewFlutter({
    super.key,
    super.title,
    super.url,
    super.data,
    super.appBar,
    super.onPageFinished,
    super.shouldPreventNavigator,
    super.onClosed,
    super.script,
    super.headers,
    super.enableForward,
    super.enableBackward,
    super.enableClose,
    super.routeName,
    super.hideNewAppBar,
    super.showAppBar,
    super.showLoading,
  });

  @override
  StateWebviewFlutter createState() => StateWebviewFlutter();
}

class StateWebviewFlutter extends StateWebviewInterface<WebviewFlutter> {
  int selectedIndex = 1;
  bool isLoading = true;

  late final WebViewController _controller;
  late final PlatformWebViewControllerCreationParams params;

  void onFinishLoading() {
    setState(() {
      selectedIndex = 0;
    });
    _controller.runJavaScript(widget.script.isEmptyOrNull
        ? kAdvanceConfig.webViewScript
        : widget.script);
  }

  @override
  void onTapBackButton(BuildContext buildContext) async {
    var value = await _controller.canGoBack();
    if (value) {
      await _controller.goBack();
    } else if (!widget.enableClose && Navigator.canPop(context)) {
      widget.onClosed?.call();
      Navigator.of(context).pop();
    } else {
      Tools.showSnackBar(
        ScaffoldMessenger.of(buildContext),
        S.of(context).noBackHistoryItem,
      );
    }
  }

  @override
  void onTapForwardButton(BuildContext buildContext) async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    } else {
      Tools.showSnackBar(
        ScaffoldMessenger.of(buildContext),
        S.of(context).noForwardHistoryItem,
      );
    }
  }

  @override
  void onTapCloseButton() async {
    widget.onClosed?.call();
    Navigator.of(context).pop();
  }

  void _handleGeolocationPermissionListener() async {
    if (isAndroid) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      await androidController.setGeolocationPermissionsPromptCallbacks(
        onShowPrompt: (request) async {
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

          return GeolocationPermissionsResponse(
            allow: status.isGranted,
            retain: true,
          );
        },
      );
    }
  }

  void _addFileSelectionListener() async {
    if (isAndroid) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  // Return a list of Uris
  Future<List<String>> _androidFilePicker(
      final FileSelectorParams params) async {
    final files = await showModalBottomSheet(
      context: context,
      builder: (BuildContext _) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    final image = imagePicker(ImageSource.gallery);
                    Navigator.of(context).pop(image);
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  final image = imagePicker(ImageSource.camera);
                  Navigator.of(context).pop(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('File'),
                onTap: () {
                  final image = filePicker(params);
                  Navigator.of(context).pop(image);
                },
              ),
            ],
          ),
        );
      },
    );

    return files ?? [];
  }

  Future<List<String>> filePicker(final FileSelectorParams params) async {
    try {
      if (params.mode == FileSelectorMode.openMultiple) {
        final attachments =
            await FilePicker.platform.pickFiles(allowMultiple: true);
        if (attachments == null) return [];

        return attachments.files
            .where((element) => element.path != null)
            .map((e) => File(e.path!).uri.toString())
            .toList();
      } else {
        final attachment = await FilePicker.platform.pickFiles();
        if (attachment == null || attachment.files.single.path == null) {
          return [];
        }
        var file = File(attachment.files.single.path!);
        return [file.uri.toString()];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> imagePicker(ImageSource source) async {
    final photo = await ImageTools.pickImage(source: source);
    if (photo == null) {
      return [];
    }

    final imageData = await photo.readAsBytes();
    final decodedImage = image.decodeImage(imageData)!;
    final scaledImage = image.copyResize(decodedImage, width: 500);
    final jpg = image.encodeJpg(scaledImage, quality: 90);

    final filePath = (await getTemporaryDirectory()).uri.resolve(
          './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
        );
    final file = await File.fromUri(filePath).create(recursive: true);
    await file.writeAsBytes(jpg, flush: true);

    return [file.uri.toString()];
  }

  @override
  void initState() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));
    if (url?.isNotEmpty ?? false) {
      _controller
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (progress == 100) {
                onFinishLoading();
              }
            },
            onNavigationRequest: (NavigationRequest request) async {
              final prevent =
                  await widget.shouldPreventNavigator?.call(request.url) ??
                      false;
              if (prevent) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onUrlChange: (urlChange) {
              final url = urlChange.url;
              if (url != null) {
                widget.onPageFinished?.call(url);
              }
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(
          Uri.parse(url.toString()),
          headers: widget.headers ?? {},
        );
    } else if (widget.data?.isNotEmpty ?? false) {
      _controller
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (progress == 100) {
                onFinishLoading();
              }
            },
            onNavigationRequest: (NavigationRequest request) async {
              final prevent =
                  await widget.shouldPreventNavigator?.call(request.url) ??
                      false;
              if (prevent) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadHtmlString('${widget.data}');
    }

    // if (controller.platform is AndroidWebViewController) {
    //   AndroidWebViewController.enableDebugging(true);
    //   (controller.platform as AndroidWebViewController)
    //       .setMediaPlaybackRequiresUserGesture(false);
    // }

    _addFileSelectionListener();

    _handleGeolocationPermissionListener();

    super.initState();
  }

  @override
  void dispose() {
    if (kAdvanceConfig.alwaysClearWebViewCache) {
      _controller.clearCache();
    }
    if (kAdvanceConfig.alwaysClearWebViewCookie) {
      WebViewCookieManager().clearCookies();
    }
    super.dispose();
  }

  @override
  Widget renderWebview() {
    return IndexedStack(
      index: selectedIndex,
      children: [
        Builder(builder: (BuildContext context) {
          return WebViewWidget(
            controller: _controller,
            gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{}..add(
                const Factory<VerticalDragGestureRecognizer>(
                    VerticalDragGestureRecognizer.new),
              ),
          );
        }),
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
