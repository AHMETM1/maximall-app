import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../common/tools.dart';
import '../../../screens/detail/widgets/video_feature.dart';
import '../../../widgets/common/parallax_image.dart';
import '../config/banner_config.dart';

class BannerItemWidget extends StatelessWidget {
  final BannerItemConfig config;
  final double? width;
  final double padding;
  final BoxFit? boxFit;
  final double radius;
  final double? height;
  final Function onTap;
  final bool enableParallax;
  final double parallaxImageRatio;
  final bool isSoundOn,
      autoPlayVideo,
      enableTimeIndicator,
      doubleTapToFullScreen;

  /// The controller for the animated stack container
  final AnimatedStackContainerController? animatedController;

  const BannerItemWidget({
    super.key,
    required this.config,
    required this.padding,
    this.width,
    this.boxFit,
    required this.radius,
    this.height,
    required this.onTap,
    this.enableParallax = false,
    this.parallaxImageRatio = 1.2,
    this.isSoundOn = false,
    this.autoPlayVideo = false,
    this.enableTimeIndicator = true,
    this.doubleTapToFullScreen = false,
    this.animatedController,
  });

  @override
  Widget build(BuildContext context) {
    switch (config.type) {
      case BannerType.animated:
        return AnimatedStackContainer(
          animatedConfig:
              config.animatedConfig ?? AnimatedStackContainerData.fromJson({}),
          controller: animatedController,
          onTapHandler: (context, config) {
            if (config != null) {
              NavigateTools.onTapNavigateOptions(
                context: context,
                config: config,
              );
            }
          },
        );

      case BannerType.video:
        return BannerVideoItem(
          config: config,
          padding: padding,
          isSoundOn: isSoundOn,
          autoPlayVideo: autoPlayVideo,
          enableTimeIndicator: enableTimeIndicator,
          doubleTapToFullScreen: doubleTapToFullScreen,
        );

      case BannerType.image:
        return BannerImageItem(
          config: config,
          padding: padding,
          width: width,
          boxFit: boxFit,
          radius: radius,
          height: height,
          onTap: onTap,
          enableParallax: enableParallax,
          parallaxImageRatio: parallaxImageRatio,
        );
    }
  }
}

/// The Banner type to display the image
class BannerImageItem extends StatelessWidget {
  final BannerItemConfig config;
  final double? width;
  final double padding;
  final BoxFit? boxFit;
  final double radius;
  final double? height;
  final Function onTap;
  final bool enableParallax;
  final double parallaxImageRatio;
  final BoxShadowConfig? boxShadowConfig;

  const BannerImageItem({
    super.key,
    required this.config,
    required this.padding,
    this.width,
    this.boxFit,
    required this.radius,
    this.height,
    required this.onTap,
    this.enableParallax = false,
    this.parallaxImageRatio = 1.2,
    this.boxShadowConfig,
  });

  @override
  Widget build(BuildContext context) {
    final paddingVal = config.padding ?? padding;
    final radiusVal = config.radius ?? radius;

    final screenSize = MediaQuery.of(context).size;
    final itemWidth = width ?? screenSize.width;
    final boxShadow = boxShadowConfig ?? BoxShadowConfig.empty();

    final buttonConfig = config.button;
    final titleConfig = config.title;
    final descriptionConfig = config.description;

    final buttonTextTheme = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: HexColor(buttonConfig?.textColor),
          fontFamily: buttonConfig?.fontFamily,
          fontSize: buttonConfig?.fontSize,
        );

    final descriptionTextTheme =
        Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: HexColor(descriptionConfig?.color),
      fontSize: descriptionConfig?.fontSize,
      fontFamily: descriptionConfig?.fontFamily,
      shadows: <Shadow>[
        if (descriptionConfig?.enableShadow ?? false)
          const Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Colors.black,
          ),
      ],
    );

    final titleTextTheme = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: HexColor(titleConfig?.color),
      fontSize: titleConfig?.fontSize,
      fontFamily: titleConfig?.fontFamily,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        if (titleConfig?.enableShadow ?? false)
          const Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Colors.black,
          ),
      ],
    );

    return GestureDetector(
      onTap: () => buttonConfig == null ? onTap(config.jsonData) : null,
      child: Container(
        width: itemWidth,
        height: height,
        constraints: const BoxConstraints(minHeight: 10.0),
        child: Stack(
          children: [
            if (enableParallax)
              ParallaxImage(
                image: config.image.toString(),
                ratio: parallaxImageRatio,
              )
            else
              Container(
                margin: EdgeInsets.symmetric(horizontal: paddingVal),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValueOpacity(boxShadow.colorOpacity),
                      blurRadius: boxShadow.blurRadius,
                      spreadRadius: boxShadow.spreadRadius,
                      offset: Offset(
                        boxShadow.x,
                        boxShadow.y,
                      ),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radiusVal),
                  child: FluxImage(
                    imageUrl: config.image,
                    fit: boxFit ?? BoxFit.fitWidth,
                    width: itemWidth,
                    height: height,
                  ),
                ),
              ),
            if (descriptionConfig != null)
              Align(
                alignment: descriptionConfig.alignment,
                child: Text(
                  descriptionConfig.text,
                  style: ThemeHelper.getFont(
                    descriptionConfig.fontFamily,
                    textStyle: descriptionTextTheme,
                  ),
                ),
              ),
            if (titleConfig != null)
              Align(
                alignment: titleConfig.alignment,
                child: Text(
                  titleConfig.text,
                  style: ThemeHelper.getFont(
                    titleConfig.fontFamily,
                    textStyle: titleTextTheme,
                  ),
                ),
              ),
            if (buttonConfig != null)
              Align(
                alignment: buttonConfig.alignment,
                child: InkWell(
                  onTap: () => onTap(config.jsonData),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: HexColor(buttonConfig.backgroundColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      buttonConfig.text,
                      style: ThemeHelper.getFont(
                        buttonConfig.fontFamily,
                        textStyle: buttonTextTheme,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BannerVideoItem extends StatelessWidget {
  final BannerItemConfig config;
  final bool isSoundOn,
      autoPlayVideo,
      enableTimeIndicator,
      doubleTapToFullScreen;
  final double padding;

  const BannerVideoItem({
    super.key,
    required this.config,
    this.isSoundOn = false,
    this.autoPlayVideo = false,
    this.enableTimeIndicator = true,
    this.doubleTapToFullScreen = false,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    var paddingVal = config.padding ?? padding;

    return Padding(
      padding: EdgeInsets.only(left: paddingVal, right: paddingVal),
      child: FeatureVideoPlayer(
        config.video ?? '',
        autoPlay: autoPlayVideo,
        isSoundOn: isSoundOn,
        enableTimeIndicator: enableTimeIndicator,
        aspectRatio: 16 / 9,
        doubleTapToFullScreen: doubleTapToFullScreen,
        showFullScreenButton: true,
        showVolumeButton: true,
      ),
    );
  }
}
