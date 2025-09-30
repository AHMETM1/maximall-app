import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../common/tools.dart';
import '../../../widgets/common/webview.dart';
import '../config/spacing/spacing_extension.dart';
import '../config/web_embed/web_embed_config.dart';

class WebEmbedLayout extends StatelessWidget {
  final WebEmbedConfig config;

  const WebEmbedLayout({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    var WebEmbedConfig(
      :type,
      :data,
      :script,
      :spacing,
      :height,
      :navigator,
    ) = config;
    final padding = spacing.padding;
    final enableNavigator = navigator?.isNotEmpty ?? false;

    if (height < 1) {
      final screenHeight = MediaQuery.of(context).size.height;

      height = height * screenHeight;
    }

    Widget child;

    switch (type) {
      case WebEmbedType.iframe:
        child = HtmlWidget(data);
        break;
      case WebEmbedType.url:
        child = WebView(
          data,
          enableForward: false,
          enableBackward: false,
          enableClose: false,
          hideNewAppBar: true,
          script: script ?? '',
          showAppBar: false,
          routeName: 'webview_layout',
          showLoading: false,
        );
        break;
      case WebEmbedType.html:
        child = WebView.html(
          data,
          enableForward: false,
          enableBackward: false,
          enableClose: false,
          hideNewAppBar: true,
          script: script ?? '',
          showAppBar: false,
          routeName: 'webview_layout',
          showLoading: false,
        );
        break;
    }

    return PrimaryScrollController(
      controller: ScrollController(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (enableNavigator) {
            NavigateTools.onTapNavigateOptions(
              context: context,
              config: navigator!,
            );
          }
        },
        child: IgnorePointer(
          ignoring: enableNavigator,
          child: Container(
            height: height,
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
