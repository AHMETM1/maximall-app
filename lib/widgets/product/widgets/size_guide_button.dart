import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../../../common/config.dart';
import '../../../../../common/config/models/product_detail_config.dart';
import '../../../../../routes/flux_navigate.dart';
import '../../../screens/common/app_bar_mixin.dart';
import '../../../services/services.dart';
import '../../common/webview.dart';

class SideGuideButtonWidget extends StatefulWidget {
  /// Attribute to show size guide
  final String? attribute;

  /// Show icon instead of text button
  final bool showIcon;

  /// Product id to get size guide
  final String? productId;

  const SideGuideButtonWidget({
    super.key,
    required this.attribute,
    this.showIcon = false,
    this.productId,
  });

  @override
  State<SideGuideButtonWidget> createState() => _SideGuideButtonWidgetState();
}

class _SideGuideButtonWidgetState extends State<SideGuideButtonWidget>
    with AppBarMixin {
  // HTML for size guide from API
  String? html;

  // Getter
  SizeGuideConfig get sizeGuideConfig => kProductDetail.sizeGuideConfig;

  List<String> get attributes => sizeGuideConfig.attributes;

  String? get sizeGuideUrl => sizeGuideConfig.url;

  bool get isHide =>
      (sizeGuideConfig.enable == false) ||
      (widget.attribute?.isEmpty ?? true) ||
      !attributes.contains(widget.attribute) ||
      ((sizeGuideUrl?.isEmpty ?? true) && (html?.isEmpty ?? true));

  void onTap(BuildContext context) {
    final html = this.html;
    if (html != null && html.isNotEmpty) {
      FluxNavigate.push(
        context: context,
        forceRootNavigator: true,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Container(
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                child: WebView.html(
                  html,
                  title: S.of(context).sizeGuide,
                  hideNewAppBar: true,
                  enableForward: false,
                  enableBackward: false,
                ),
              ),
            ),
          ),
        ),
      );
      return;
    }

    if (Tools.needToOpenExternalApp(sizeGuideUrl)) {
      Tools.launchURL(sizeGuideUrl);
      return;
    }

    FluxNavigate.push(
      context: context,
      forceRootNavigator: true,
      MaterialPageRoute(
        builder: (context) => WebView(
          '$sizeGuideUrl',
          title: S.of(context).sizeGuide,
          hideNewAppBar: true,
          enableForward: false,
          enableBackward: false,
        ),
      ),
    );
  }

  Services get services => Services();

  Future<String?> getSizeGuideHtml() async {
    final productId = widget.productId;
    if (productId == null) {
      return null;
    }
    return services.api.getSizeGuide(
      productId,
    );
  }

  @override
  void initState() {
    super.initState();
    if (sizeGuideConfig.enable) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        html = await getSizeGuideHtml();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isHide) {
      return const SizedBox.shrink();
    }

    if (widget.showIcon) {
      return GestureDetector(
        onTap: () => onTap(context),
        child: Tooltip(
          message: S.of(context).sizeGuide,
          child: const Icon(
            Icons.info_outline,
            size: 16,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => onTap(context),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          S.of(context).sizeGuide,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}
