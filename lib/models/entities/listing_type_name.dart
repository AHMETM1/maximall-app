import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

import 'product.dart';

class ListingTypeName extends StatelessWidget {
  final Product product;
  final bool show;
  final TextStyle? style;

  const ListingTypeName({
    super.key,
    required this.product,
    required this.show,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || !product.isListing || (product.type?.isEmpty ?? true)) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        _getListingTypeName(context, product.type!),
        style: style ??
            TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _getListingTypeName(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'event':
        return S.of(context).event.toUpperCase();
      case 'rental':
        return S.of(context).rental.toUpperCase();
      case 'service':
        return S.of(context).service.toUpperCase();
      case 'classifieds':
        return S.of(context).classifieds.toUpperCase();
      default:
        return type.toUpperCase();
    }
  }
}
