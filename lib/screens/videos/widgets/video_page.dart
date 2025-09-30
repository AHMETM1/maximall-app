import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/extensions/color_extension.dart';

import '../models/video.dart';
import 'video_detail/video_detail_style_1/video_detail_style_1.dart';
import 'video_detail/video_detail_style_2/video_detail_style_2.dart';
import 'video_detail/video_detail_style_3/video_detail_style_3.dart';
import 'video_detail/video_detail_style_4/video_detail_style_4.dart';
import 'video_detail/video_detail_style_5/video_detail_style_5.dart';
import 'video_detail/video_detail_style_6/video_detail_style_6.dart';
import 'video_detail/video_detail_style_7/video_detail_style_7.dart';
import 'video_detail/video_detail_style_8/video_detail_style_8.dart';
import 'video_detail/video_detail_style_9/video_detail_style_9.dart';
import 'video_player_widget.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({
    super.key,
    required this.video,
    this.onFinish,
    this.styleVersion,
  });

  final Video video;
  final void Function()? onFinish;
  final String? styleVersion;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(
      url: widget.video.videoUrl ?? '',
      onFinish: widget.onFinish,
      renderButtonPlay: (bool isPlaying) {
        if (isPlaying) {
          return const SizedBox();
        }

        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.black.withValueOpacity(0.1),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Icon(
              CupertinoIcons.play_arrow_solid,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
      content: Positioned(
        left: 0,
        bottom: 0,
        right: 0,
        child: _renderVideoDetails(),
      ),
    );
  }

  Widget _renderVideoDetails() {
    switch (widget.styleVersion) {
      case '2':
        return VideoDetailStyle2(video: widget.video);
      case '3':
        return VideoDetailStyle3(video: widget.video);
      case '4':
        return VideoDetailStyle4(video: widget.video);
      case '5':
        return VideoDetailStyle5(video: widget.video);
      case '6':
        return VideoDetailStyle6(video: widget.video);
      case '7':
        return VideoDetailStyle7(video: widget.video);
      case '8':
        return VideoDetailStyle8(video: widget.video);
      case '9':
        return VideoDetailStyle9(video: widget.video);
      case '1':
      default:
        return VideoDetailStyle1(video: widget.video);
    }
  }
}
