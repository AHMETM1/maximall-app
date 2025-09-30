import 'package:flutter/material.dart';

import '../../../widgets/product/index.dart';
import '../widgets/buy_button_widget.dart';

mixin CornerCartMixin<T extends StatefulWidget> on State<T> {
  late AnimationController _hideController;
  bool get showBottomCornerCart;
  TickerProvider get vsync;
  bool _isVisibleBuyButton = true;
  bool get isVisibleBuyButton => _isVisibleBuyButton;

  void _onInitController(AnimationController controller) {
    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _isVisibleBuyButton = false;
        });
      } else if (status == AnimationStatus.reverse) {
        setState(() {
          _isVisibleBuyButton = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _hideController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _hideController.dispose();
    super.dispose();
  }

  Widget renderCornerCart({
    final Widget Function(int quantity)? builderThumnail,
    double? widthForCartIcon,
    double? cartHeight,
  }) {
    final box = context.findRenderObject();
    double topSize = 0;
    if (box is RenderBox) {
      final offset = box.localToGlobal(Offset.zero);
      if (offset.dy > 0) {
        topSize = offset.dy;
      }
    }
    return showBottomCornerCart
        ? AlignmentBuilder(
            topSize: topSize,
            alignment: AlignmentDirectional.bottomEnd,
            builder: (double? maxHeight) {
              return ExpandingBottomSheet(
                key: const ValueKey('ddd'),
                hideController: _hideController,
                onInitController: _onInitController,
                builderThumnail: builderThumnail,
                widthForCartIcon: widthForCartIcon,
                cartHeight: cartHeight,
                screenHeight: maxHeight,
              );
            },
          )
        : const SizedBox();
  }

  Widget renderFixedBuyButtonOnBottom(product) => _isVisibleBuyButton
      ? Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SafeArea(
            top: false,
            child: BuyButtonWidget(product: product),
          ),
        )
      : const SizedBox();
}

class AlignmentBuilder extends StatelessWidget {
  const AlignmentBuilder({
    this.alignment,
    required this.topSize,
    required this.builder,
    super.key,
  });
  final double topSize;
  final AlignmentGeometry? alignment;
  final Widget Function(double? maxHeight) builder;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: Builder(builder: (context) {
        final alignBox = context.findRenderObject();
        if (alignBox is RenderBox) {
          final offset = alignBox.localToGlobal(Offset.zero);
          final height = (alignBox.size.height + offset.dy) - topSize;
          return builder(height);
        }
        return builder(null);
      }),
    );
  }
}
