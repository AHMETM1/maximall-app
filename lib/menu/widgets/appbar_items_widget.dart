import 'package:flutter/cupertino.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../models/app_model.dart';
import '../../modules/dynamic_layout/config/app_config.dart';
import '../../modules/multi_site/multi_site_factory.dart';
import 'appbar_item_widget.dart';

class AppBarItemsWidget extends StatelessWidget with MultiSiteMixin {
  const AppBarItemsWidget({
    super.key,
    this.items,
    this.showBottom = true,
    this.popButton,
    this.showSiteSelection = false,
  });

  final List<AppBarItemConfig>? items;
  final bool showBottom;
  final Widget? popButton;
  final bool showSiteSelection;

  @override
  Widget build(BuildContext context) {
    var widgets = items?.map<Widget>(
          (AppBarItemConfig item) {
            return AppBarItemWidget(
              item: item,
              showBottom: showBottom,
            );
          },
        ).toList() ??
        <Widget>[];

    var popBtn =
        popButton != null && Navigator.canPop(context) ? popButton : null;
    if (popBtn != null) {
      widgets.add(popBtn);
    }

    var enableMultiSite = Configurations.multiSiteConfigs?.isNotEmpty ?? false;
    final multiSiteConfig = Provider.of<AppModel>(context).multiSiteConfig;
    var multiSiteIcon = multiSiteConfig?.icon;
    var showSwitcherSite = multiSiteConfig?.showAppBarSwitcherSite ?? true;

    if (enableMultiSite && showSiteSelection && showSwitcherSite) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(right: 15),
        child: GestureDetector(
          onTap: () =>
              MultiSiteFactory.instance.startShowMultiSiteSelection(context),
          child: multiSiteIcon?.isEmpty ?? true
              ? const Icon(CupertinoIcons.globe)
              : FluxImage(
                  imageUrl: multiSiteIcon!,
                  width: 25,
                  height: 20,
                  fit: BoxFit.cover,
                ),
        ),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgets,
    );
  }
}
