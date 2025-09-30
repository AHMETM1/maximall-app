import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../../models/entities/brand.dart';

class BrandItem extends StatelessWidget {
  final Brand? brand;
  final void Function()? onTap;
  final bool isBrandNameShown;
  final bool isLogoCornerRounded;

  const BrandItem({
    this.brand,
    this.onTap,
    this.isBrandNameShown = true,
    this.isLogoCornerRounded = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            brand?.image != null
                ? ClipRRect(
                    borderRadius: isLogoCornerRounded
                        ? const BorderRadius.all(
                            Radius.circular(15.0),
                          )
                        : BorderRadius.zero,
                    child: FluxImage(
                      imageUrl: brand?.image ?? '',
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(height: 60.0),
            const SizedBox(height: 5),
            isBrandNameShown
                ? Expanded(
                    child: Text(
                      brand?.name ?? '',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
