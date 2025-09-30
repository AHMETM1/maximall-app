import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../models/entities/back_drop_arguments.dart';
import '../../../routes/flux_navigate.dart';
import '../config/banner_config.dart';
import '../helper/helper.dart';
import 'banner_items.dart';

/// The Banner Group type to display the image as multi columns
class BannerSlider extends StatefulWidget {
  final BannerConfig config;
  final Function onTap;

  const BannerSlider({required this.config, required this.onTap, super.key});

  @override
  State<BannerSlider> createState() => _StateBannerSlider();
}

class _StateBannerSlider extends State<BannerSlider> {
  final ValueNotifier<int> _positionNotifier = ValueNotifier<int>(0);

  int get position => _positionNotifier.value;

  set position(int value) => _positionNotifier.value = value;

  BannerConfig get config => widget.config;

  late final PageController _controller;

  final Map<String, AnimatedStackContainerController> _animatedController = {};

  late bool autoPlay;
  Timer? timer;
  late final int intervalTime;

  @override
  void initState() {
    autoPlay = widget.config.autoPlay;
    _controller = PageController(viewportFraction: 1.0);
    intervalTime = widget.config.intervalTime ?? 3;
    for (var i = 0; i < widget.config.items.length; i++) {
      final item = widget.config.items[i];
      if (item.type.isAnimated) {
        _animatedController['animated-$i'] = AnimatedStackContainerController();
      }
    }
    autoPlayBanner();

    super.initState();
  }

  void autoPlayBanner() {
    List? items = widget.config.items;
    timer = Timer.periodic(Duration(seconds: intervalTime), (callback) {
      if (widget.config.design != 'default' || !autoPlay) {
        timer!.cancel();
      } else if (widget.config.design == 'default' && autoPlay) {
        final animatedController = _animatedController['animated-$position'];
        if (animatedController?.isCompletedAnimation ?? false) {
          return;
        }

        if (position >= items.length - 1 && _controller.hasClients) {
          _controller.jumpToPage(0);
        } else {
          if (_controller.hasClients) {
            _controller.animateToPage(position + 1,
                duration: const Duration(seconds: 1), curve: Curves.easeInOut);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }

    _controller.dispose();
    _positionNotifier.dispose();
    super.dispose();
  }

  Widget getBannerPageView(width) {
    final items = config.items;
    final isCirclePageIndicator = config.pageIndicatorType?.isCircle == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              position = index;
            },
            children: List.generate(
              items.length,
              (index) {
                return renderBannerItem(
                  config: items[index],
                  width: width,
                  isPage: true,
                  indexItem: index,
                );
              },
            ),
          ),
          if (config.showIndicator && items.length > 1)
            Align(
              alignment: config.indicatorAlignment,
              child: Padding(
                padding: config.indicatorPadding,
                child: SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: items.length,
                  effect: SlideEffect(
                    spacing: 8.0,
                    radius: 5.0,
                    dotWidth: isCirclePageIndicator ? 6.0 : 24.0,
                    dotHeight: isCirclePageIndicator ? 6.0 : 2.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.black12,
                    activeDotColor: Colors.black87,
                  ),
                ),
              ),
            ),
          if (config.showNumber && items.length > 1)
            Align(
              alignment: config.numberAlignment,
              child: Padding(
                padding: config.numberPadding,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValueOpacity(0.6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _positionNotifier,
                      builder: (context, value, child) {
                        return Text(
                          '${position + 1}/${items.length}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget renderBannerItem({
    required BannerItemConfig config,
    double? width,
    bool isPage = false,
    required int indexItem,
  }) {
    return BannerItemWidget(
      config: config,
      width: width,
      boxFit: widget.config.fit,
      radius: widget.config.radius,
      padding: widget.config.padding,
      onTap: widget.onTap,
      animatedController: _animatedController['animated-$indexItem'],
      isSoundOn: isPage ? widget.config.isSoundOn ?? false : false,
      enableTimeIndicator:
          isPage ? widget.config.enableTimeIndicator ?? true : true,
      autoPlayVideo: isPage ? widget.config.autoPlayVideo ?? false : false,
      doubleTapToFullScreen:
          isPage ? widget.config.doubleTapToFullScreen ?? false : false,
    );
  }

  Widget renderBanner(width) {
    List? items = widget.config.items;

    switch (widget.config.design) {
      case 'swiper':
        return Swiper(
          onIndexChanged: (index) {
            position = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(
              config: items[index],
              width: width,
              indexItem: index,
            );
          },
          itemCount: items.length,
          viewportFraction:
              Tools.isTablet(MediaQuery.of(context)) ? 0.55 : 0.85,
          scale: 0.9,
          duration: intervalTime * 100,
        );
      case 'tinder':
        return Swiper(
          onIndexChanged: (index) {
            position = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(
              config: items[index],
              width: width,
              indexItem: index,
            );
          },
          itemCount: items.length,
          itemWidth: width,
          itemHeight: width * 1.2,
          layout: SwiperLayout.TINDER,
          duration: intervalTime * 100,
        );
      case 'stack':
        return Swiper(
          onIndexChanged: (index) {
            position = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(
              config: items[index],
              width: width,
              indexItem: index,
            );
          },
          itemCount: items.length,
          itemWidth: width - 40,
          layout: SwiperLayout.STACK,
          duration: intervalTime * 100,
        );
      case 'custom':
        return Swiper(
          onIndexChanged: (index) {
            position = index;
          },
          autoplay: autoPlay,
          itemBuilder: (BuildContext context, int index) {
            return renderBannerItem(
              config: items[index],
              width: width,
              indexItem: index,
            );
          },
          itemCount: items.length,
          itemWidth: width - 40,
          itemHeight: width + 100,
          duration: intervalTime * 100,
          layout: SwiperLayout.CUSTOM,
          customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
              .addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate(
            [
              const Offset(-370.0, -40.0),
              const Offset(0.0, 0.0),
              const Offset(370.0, -40.0)
            ],
          ),
        );
      case 'default':
      default:
        return getBannerPageView(width);
    }
  }

  double? bannerPercent(width) {
    final screenSize = MediaQuery.sizeOf(context);
    return Helper.formatDouble(
        widget.config.height ?? 0.5 / (screenSize.height / width));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    var isBlur = widget.config.isBlur;

    List? items = widget.config.items;
    var bannerExtraHeight =
        screenSize.height * (widget.config.title != null ? 0.12 : 0.0);
    var upHeight = Helper.formatDouble(widget.config.upHeight);

    //Set autoplay for default template
    autoPlay = widget.config.autoPlay;
    if (widget.config.design == 'default' && timer != null) {
      if (!autoPlay) {
        if (timer!.isActive) {
          timer!.cancel();
        }
      } else {
        if (!timer!.isActive) {
          Future.delayed(Duration(seconds: intervalTime), () => autoPlayBanner);
        }
      }
    }

    return BackgroundColorWidget(
      enable: widget.config.enableBackground,
      child: LayoutBuilder(
        builder: (context, constraint) {
          var bannerPercentWidth = widget.config.overrideBannerPercentWidth ??
              bannerPercent(constraint.maxWidth)!;
          var height = screenSize.height * bannerPercentWidth +
              bannerExtraHeight +
              upHeight!;
          if (items.isEmpty) {
            return widget.config.title != null
                ? HeaderText(
                    config: widget.config.title!,
                    getReplacedParams: (String? value) =>
                        value.getReplacedParams(context),
                    onSearch: () => FluxNavigate.pushNamed(
                      RouteList.homeSearch,
                      arguments: BackDropArguments(
                          config: widget.config.title!.toJson()),
                      context: context,
                    ),
                  )
                : const SizedBox();
          }

          return FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              margin: EdgeInsets.only(
                left: widget.config.marginLeft,
                right: widget.config.marginRight,
                top: widget.config.marginTop,
                bottom: widget.config.marginBottom,
              ),
              child: Stack(
                children: <Widget>[
                  if (widget.config.showBackground)
                    SizedBox(
                      height: height,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ValueListenableBuilder<int>(
                          valueListenable: _positionNotifier,
                          builder: (context, position, child) {
                            BannerItemConfig item = items[position];
                            return ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.elliptical(100, 6),
                              ),
                              child: isBlur
                                  ? ImageFiltered(
                                      imageFilter: ImageFilter.blur(
                                        sigmaX: 5.0,
                                        sigmaY: 5.0,
                                      ),
                                      child: Transform.scale(
                                        scale: 3,
                                        child: FluxImage(
                                          imageUrl:
                                              item.background ?? item.image,
                                          fit: BoxFit.fill,
                                          width: screenSize.width + upHeight,
                                        ),
                                      ),
                                    )
                                  : FluxImage(
                                      imageUrl: item.background ?? item.image,
                                      fit: BoxFit.fill,
                                      width: constraint.maxWidth,
                                      height: screenSize.height *
                                              bannerPercentWidth +
                                          bannerExtraHeight +
                                          upHeight,
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                  Column(
                    children: [
                      if (widget.config.title != null)
                        HeaderText(
                          config: widget.config.title!,
                          getReplacedParams: (String? value) =>
                              value.getReplacedParams(context),
                          onSearch: () => FluxNavigate.pushNamed(
                            RouteList.homeSearch,
                            arguments: BackDropArguments(
                                config: widget.config.title!.toJson()),
                            context: context,
                          ),
                        ),
                      SizedBox(
                        height: screenSize.height * bannerPercentWidth,
                        child: renderBanner(constraint.maxWidth),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
