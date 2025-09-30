import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/extensions/extensions.dart';
import '../../../screens/common/app_bar_mixin.dart';

abstract class WebviewInterface extends StatefulWidget {
  final String? url;
  final String? data; // html code
  final String? title;
  final AppBar? appBar;
  final bool enableForward;
  final bool enableBackward;
  final bool enableClose;
  final Future<bool> Function(String url)? shouldPreventNavigator;
  final void Function(
    String?,
    Future<void> Function(String url)? redirectLink,
    Future<String?> Function()? getHtml,
  )? onRedirectUrl;
  final Function(String url)? onPageFinished;
  final Function? onClosed;
  final String script;
  final Map<String, String>? headers;
  final String? routeName;
  final bool hideNewAppBar;
  final bool showAppBar;
  final bool showLoading;

  const WebviewInterface({
    super.key,
    this.title,
    this.url,
    this.data,
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
    this.onRedirectUrl,
  }) : assert(
          !(!showAppBar && (enableForward || enableBackward || enableClose)),
          'Cannot hide app bar if one of the following options EnableForward or EnableBackward or EnableClose is enabled',
        );
}

abstract class StateWebviewInterface<T extends WebviewInterface>
    extends State<T> with AppBarMixin {
  String? get url {
    var value = widget.url;
    final uri = value?.toUri();
    if (uri != null && uri.scheme.isEmpty) {
      value = 'https://$value';
    }
    if (kAdvanceConfig.alwaysClearWebViewCache) {
      value = value?.addUrlQuery(
        'dummy=${DateTime.now().millisecondsSinceEpoch}',
      );
    }
    return value;
  }

  void onTapBackButton(BuildContext buildContext);

  void onTapForwardButton(BuildContext buildContext);

  void onTapCloseButton();

  Widget renderWebview();

  @override
  Widget build(BuildContext context) {
    return renderScaffold(
      routeName: widget.routeName ?? RouteList.webview,
      hideNewAppBar: widget.hideNewAppBar,
      secondAppBar: !widget.showAppBar
          ? null
          : widget.appBar ??
              AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0.0,
                centerTitle: true,
                title: Text(
                  widget.title ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                leadingWidth: 100,
                actions: [
                  if (widget.enableClose)
                    IconButton(
                      onPressed: onTapCloseButton,
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  const SizedBox(width: 10),
                ],
                leading: Builder(
                  builder: (buildContext) {
                    return Row(
                      children: [
                        if (widget.enableBackward)
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () => onTapBackButton(buildContext),
                          ),
                        if (widget.enableForward)
                          IconButton(
                            onPressed: () => onTapForwardButton(buildContext),
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                          ),
                      ],
                    );
                  },
                ),
              ),
      child: renderWebview(),
    );
  }
}
