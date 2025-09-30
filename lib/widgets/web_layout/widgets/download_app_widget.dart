import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../../common/config.dart';

class DownloadAppWidget extends StatelessWidget {
  final Function(String)? onTap;
  const DownloadAppWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () => onTap?.call(
              'https://play.google.com/store/apps/details?id=${kAppRatingConfig.googlePlayIdentifier}'),
          child: const FluxImage(
            height: 40,
            imageUrl: 'assets/images/google-play-badge.svg',
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () => onTap?.call(
              'https://apps.apple.com/vn/app/fluxstore/id${kAppRatingConfig.appStoreIdentifier}'),
          child: const FluxImage(
            height: 40,
            imageUrl: 'assets/images/apple-store-badge.svg',
          ),
        )
      ],
    );
  }
}
