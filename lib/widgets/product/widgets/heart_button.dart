import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/extensions/color_extension.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show Product, ProductWishListModel;

class HeartButton extends StatelessWidget {
  final Product product;
  final double? size;
  final Color? color;

  const HeartButton({super.key, required this.product, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProductWishListModel>();
    return Selector<ProductWishListModel, bool>(
      selector: (_, model) => model.isWishList(product),
      builder: (BuildContext context, isExist, child) {
        // Default is toggle off
        var icon = CircleAvatar(
          backgroundColor: Colors.grey.withValueOpacity(0.5),
          child: Icon(
            CupertinoIcons.heart,
            color: Colors.white,
            size: size ?? 16.0,
          ),
        );
        if (isExist) {
          icon = CircleAvatar(
            backgroundColor: Colors.pink.withValueOpacity(0.1),
            child: Icon(
              CupertinoIcons.heart_fill,
              color: Colors.pink,
              size: size ?? 16.0,
            ),
          );
        }
        return IconButton(
          onPressed: () => model.toggleWishlist(product),
          icon: icon,
        );
      },
    );
  }
}
