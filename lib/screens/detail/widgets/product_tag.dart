import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

import '../../../common/config.dart';
import '../../../models/entities/index.dart' show Product;
import '../../../models/index.dart' show ProductModel;
import '../../../widgets/common/expansion_info.dart';

class ProductTag extends StatelessWidget {
  final Product? product;

  const ProductTag(this.product);

  @override
  Widget build(BuildContext context) {
    if (product?.tags.isEmpty ?? true) {
      return const SizedBox();
    }

    final tags = product!.tags.map((tag) => tag).toList();
    tags.removeWhere((tag) => tag.name?.isEmpty ?? true);

    return ExpansionInfo(
      expand: kProductDetail.expandTags,
      title: S.of(context).tags,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 10),
          child: Wrap(
            children: List.generate(tags.length, (index) {
              final tag = tags[index];
              return TextButton(
                onPressed: () {
                  ProductModel.showList(
                    tag: tag.id,
                    context: context,
                  );
                },
                child: Text(
                  ' #${tag.name!.toUpperCase()} ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
