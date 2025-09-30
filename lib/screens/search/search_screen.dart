import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../modules/dynamic_layout/index.dart';
import '../common/app_bar_mixin.dart';
import 'layouts/products_search_layout.dart';

class SearchScreen extends StatefulWidget {
  final bool autoFocusSearch;
  final bool? boostEngine;
  final bool? showQRCode;

  const SearchScreen({
    super.key,
    this.autoFocusSearch = true,
    this.boostEngine,
    this.showQRCode,
  });

  @override
  State<SearchScreen> createState() => _StateSearchScreen();
}

class _StateSearchScreen extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen>, AppBarMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    printLog('[SearchScreen] build');
    super.build(context);

    return ProductsSearchLayout(
      autoFocusSearch: widget.autoFocusSearch,
      config: ProductConfig.empty()
        ..layout = Layout.listTile
        ..boostEngine = widget.boostEngine,
      showQRCode: widget.showQRCode,
    );
  }
}
