import 'package:flutter/material.dart';

import '../../../models/index.dart';

class CategoryName extends StatelessWidget {
  final Product product;
  final bool show;
  final TextStyle? style;

  const CategoryName({
    super.key,
    required this.product,
    this.style,
    required this.show,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || product.categories.isEmpty) {
      return const SizedBox();
    }
    final categoryNames =
        product.categories.map((category) => category.name).join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        categoryNames,
        style: style ??
            TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.6),
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
