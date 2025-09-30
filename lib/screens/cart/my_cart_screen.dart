import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show printLog;
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/index.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../widgets/product/cart_item/cart_item_state_ui.dart';
import 'my_cart_layout/my_cart_normal_layout.dart';
import 'my_cart_layout/my_cart_normal_layout_web.dart';
import 'my_cart_layout/my_cart_style01_layout.dart';

class MyCart extends StatefulWidget {
  final bool? isModal;
  final bool? isBuyNow;
  final bool hasNewAppBar;
  final bool enabledTextBoxQuantity;
  final ScrollController? scrollController;

  const MyCart({
    this.isModal,
    this.isBuyNow = false,
    this.hasNewAppBar = false,
    this.enabledTextBoxQuantity = true,
    this.scrollController,
  });

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    printLog('[Cart] build');
    Widget body = const SizedBox();

    if (Layout.isDisplayDesktop(context)) {
      body = MyCartNormalLayoutWeb(
        hasNewAppBar: widget.hasNewAppBar,
        enabledTextBoxQuantity: widget.enabledTextBoxQuantity,
        isModal: widget.isModal,
        isBuyNow: widget.isBuyNow,
        scrollController: widget.scrollController,
      );
    } else {
      final cartStyle = kCartDetail['style'].toString().toCartStyle();
      switch (cartStyle) {
        case CartStyle.style01:
          body = MyCartStyle01Layout(
            hasNewAppBar: widget.hasNewAppBar,
            isModal: widget.isModal,
            isBuyNow: widget.isBuyNow,
            scrollController: widget.scrollController,
            enabledTextBoxQuantity: widget.enabledTextBoxQuantity,
          );
        case CartStyle.normal:
        default:
          body = MyCartNormalLayout(
            hasNewAppBar: widget.hasNewAppBar,
            enabledTextBoxQuantity: widget.enabledTextBoxQuantity,
            isModal: widget.isModal,
            isBuyNow: widget.isBuyNow,
            scrollController: widget.scrollController,
          );
      }
    }

    return VisibilityDetector(
      key: Key('cart_${widget.isModal}_${widget.isBuyNow}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0) {
          // Because on the payment page, when selecting the "Pay by wallet"
          // checkbox, the walletAmount value will be set (Using "Pay by wallet"
          // will not be kept for the next payment) . But when the user
          // backs out or closes the app, this value is not updated.
          // This leads to the fact that when opening the mycart page, the
          // total value has the walletAmount value attached.
          // Therefore, it is necessary to reset the walletAmount value when
          // opening the mycart page.
          context.read<CartModel>().setWalletAmount(0);
        }
      },
      child: body,
    );
  }
}
