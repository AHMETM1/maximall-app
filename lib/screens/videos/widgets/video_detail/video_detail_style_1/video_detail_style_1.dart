import 'package:flutter/material.dart';

import '../../../../../modules/dynamic_layout/config/product_config.dart';
import '../../../../../services/service_config.dart';
import '../../../models/video.dart';
import 'video_buttons.dart';
import 'video_info.dart';

class VideoDetailStyle1 extends StatelessWidget {
  const VideoDetailStyle1({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            const Color(0xFF000000).withValues(alpha: 0.6),
            const Color(0xFF000000).withValues(alpha: 0.3),
            Colors.transparent
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: VideoInfo(product: video.product),
            ),
          ),
          // Listing single app does not have a buy button and does not use shares
          if (!(ServerConfig().isListingType) || ServerConfig().isVendorType())
            VideoButtons(
              video: video,
              config: ProductConfig.empty(),
            ),
        ],
      ),
    );
  }
}
