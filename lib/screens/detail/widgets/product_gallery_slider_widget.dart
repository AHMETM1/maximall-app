import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/widgets/keep_alive_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../common/config.dart';
import '../../../common/config/models/index.dart';
import '../../../common/constants.dart';
import '../../../common/extensions/extensions.dart';
import '../../../common/tools/image_tools.dart';
import '../../../models/entities/index.dart';
import '../../../models/product_model.dart';
import '../../../services/services.dart';
import 'product_image_thumbnail_full_width.dart';
import 'video_feature.dart';

class ProductGallerrySliderWidget extends StatefulWidget {
  final Product product;
  final Function(int index)? onChange;
  final EdgeInsets padding;

  const ProductGallerrySliderWidget({
    super.key,
    required this.product,
    this.onChange,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0),
  });

  @override
  State<ProductGallerrySliderWidget> createState() =>
      _ProductGallerrySliderWidgetState();
}

class _ProductGallerrySliderWidgetState
    extends State<ProductGallerrySliderWidget> {
  static const String heroTagPrefix = 'product_gallery_slider_hero_tag';
  Timer? _timer;
  StreamSubscription? _subChangeSelectedVariation;
  final List<String> _images = [];
  final List<String> _variationImages = [];
  final PageController _pageController = PageController();
  final _videoController = FeatureVideoController();

  int _lastInteraction = 0;
  bool _initialized = false;
  bool _isPauseTimer = false;
  bool _variationLoaded = false;

  String? get _videoUrl => widget.product.videoUrl;
  bool get _hasVideo => widget.product.hasVideo && kProductDetail.showVideo;
  List<String> get imagesList => {..._images, ..._variationImages}.toList();
  List<String> get itemList => {
        if (_hasVideo) '$_videoUrl',
        ..._images,
        ..._variationImages,
      }.toList();

  Future<void> nextImage() async {
    if (!mounted || !_pageController.hasClients) {
      return;
    }

    /// Cancel if user has touched the gallery within 3 seconds.
    if (DateTime.now().millisecondsSinceEpoch - 3000 <= _lastInteraction ||
        _isPauseTimer) {
      return;
    }

    /// Cancel if video is playing.
    if (_hasVideo && _pageController.page?.round() == 0) {
      return;
    }

    var prePage = _pageController.page?.round() ?? 0;

    /// Next page if not ends..
    final nextPage = prePage + 1;
    if (nextPage < itemList.length) {
      return _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }

    /// Go to first page.
    prePage = 0;
    return _pageController.animateTo(
      prePage.toDouble(),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _updateVariationImages(List<String> newImages) {
    if (!widget.product.isVariableProduct ||
        _variationImages.isNotEmpty ||
        newImages.isEmpty ||
        newImages.length == _variationImages.length) {
      return;
    }
    for (var url in newImages) {
      if (!_variationImages.contains(url)) {
        _variationImages.add(url);
      }
    }
    _initialized = true;
    if (!mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        afterFirstLayout(context);
      }
    });
    _images.addAll(widget.product.images);

    if (kProductDetail.showSelectedImageVariant) {
      _subChangeSelectedVariation =
          eventBus.on<EventChangeSelectedVariation>().listen((event) {
        if (!mounted) {
          return;
        }

        /// Skip first time when variation loaded.
        if (!_variationLoaded) {
          _variationLoaded = true;
          return;
        }

        final image = event.productVariation?.imageFeature;
        if (image != null) {
          _lastInteraction = DateTime.now().millisecondsSinceEpoch;
          _pageController.jumpToPage(itemList.indexOf(image));
        }
      });
    }
  }

  void _startTimer() {
    if (_timer?.isActive ?? false) {
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        nextImage();
      },
    );
  }

  void _cancelTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  void afterFirstLayout(BuildContext context) {
    if (widget.product.isVariableProduct) {
      _updateVariationImages(
          context.read<ProductModel>().variationsFeatureImages);
    }
    if (kProductDetail.autoPlayGallery) {
      _startTimer();
    }
  }

  void _pauseTimer([_]) {
    _isPauseTimer = true;
  }

  void _resumeTimer([_]) {
    _isPauseTimer = false;
    _lastInteraction = DateTime.now().millisecondsSinceEpoch;
  }

  void _onShowGallery(BuildContext context, [index = 0]) {
    if (_hasVideo && index == 0) {
      _videoController.togglePlayPause?.call();
      return;
    }

    context.openImageGallery(
      isDialog: false,
      images: imagesList,
      index: _hasVideo ? index - 1 : index,
      heroTagPrefix: heroTagPrefix,
      onChanged: _pageController.jumpToPage,
    );
  }

  @override
  void didUpdateWidget(ProductGallerrySliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kProductDetail.autoPlayGallery) {
      _startTimer();
    } else {
      _cancelTimer();
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    _subChangeSelectedVariation?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _updateVariationImages(context.select(
          (ProductModel productModel) => productModel.variationsFeatureImages));
    }

    if (itemList.isEmpty) {
      return const SizedBox();
    }

    final sizeScreen = MediaQuery.sizeOf(context);
    final carouselView = PageView(
      controller: _pageController,
      children: List<Widget>.generate(
        itemList.length,
        (index) {
          final item = itemList[index];
          if (_hasVideo && index == 0) {
            return Padding(
              padding: widget.padding,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: KeepAliveWidget(
                  child: FeatureVideoPlayer(
                    item,
                    autoPlay: kProductDetail.autoPlayVideo,
                    isSoundOn: kProductDetail.isSoundOn,
                    controller: _videoController,
                    enableTimeIndicator: kProductDetail.enableTimeIndicator,
                    doubleTapToFullScreen: kProductDetail.doubleTapToFullScreen,
                    showFullScreenButton: true,
                    showVolumeButton: true,
                  ),
                ),
              ),
            );
          }
          return Hero(
            tag: '$heroTagPrefix${itemList[index]}',
            child: GestureDetector(
              onTap: () => _onShowGallery(context, index),
              child: KeepAliveWidget(
                child: Padding(
                  padding: widget.padding,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageResize(
                      url: itemList[index],
                      fit: ImageTools.boxFit(kProductDetail.boxFit),
                      size: kSize.large,
                      width: sizeScreen.width,
                      hidePlaceHolder: true,
                      forceWhiteBackground: kProductDetail.forceWhiteBackground,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    final hasClient = _pageController.hasClients;

    return Listener(
      onPointerDown: _pauseTimer,
      onPointerUp: _resumeTimer,
      onPointerHover: _pauseTimer,
      onPointerMove: _pauseTimer,
      child: VisibilityDetector(
        key: const Key('product-image-slider-no-background'),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 1 && _isPauseTimer) {
            _resumeTimer();
          } else if (visibility.visibleFraction == 0) {
            _pauseTimer();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    top: kProductDetail.marginTop,
                    child: carouselView,
                  ),
                  if (kProductDetail.sliderShowGoBackButton)
                    ListenableBuilder(
                        listenable: _pageController,
                        builder: (_, __) {
                          final page = hasClient
                              ? (_pageController.page?.round() ?? 0)
                              : 0;

                          return Positioned(
                            bottom: 4.0,
                            left: 4.0,
                            child: GestureDetector(
                              onTap: () {
                                if (page != 0) {
                                  _pageController.jumpTo(0);
                                  widget.onChange?.call(0);
                                }
                              },
                              child: Padding(
                                padding: widget.padding.copyWith(
                                  bottom: 6,
                                  left: widget.padding.left + 8,
                                  right: widget.padding.right + 8,
                                  top: 6,
                                ),
                                child: Icon(
                                  CupertinoIcons.arrow_left_square_fill,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValueOpacity(page == 0 ? 0.3 : 1),
                                  size: 25,
                                ),
                              ),
                            ),
                          );
                        }),
                  if (kProductDetail.sliderIndicatorType ==
                          SliderIndicatorType.number &&
                      hasClient) ...[
                    ListenableBuilder(
                        listenable: _pageController,
                        builder: (_, __) {
                          return Positioned(
                            bottom: 16.0,
                            right: 16.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              padding: widget.padding.copyWith(
                                left: widget.padding.left,
                                right: widget.padding.right,
                              ),
                              child: Text(
                                '${(_pageController.page?.round() ?? 0) + 1}/${itemList.length}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                  if (kProductDetail.sliderIndicatorType ==
                          SliderIndicatorType.dot &&
                      hasClient)
                    ListenableBuilder(
                      listenable: _pageController,
                      builder: (_, __) {
                        return Positioned.fill(
                          bottom: 16.0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedSmoothIndicator(
                              activeIndex: _pageController.page?.round() ?? 0,
                              count: itemList.length,
                              effect: const ScrollingDotsEffect(
                                dotWidth: 5.0,
                                dotHeight: 5.0,
                                spacing: 15.0,
                                fixedCenter: false,
                                dotColor: Colors.black45,
                                activeDotColor: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ...Services().renderProductBadges(
                    context,
                    widget.product,
                    isDetail: true,
                    padding: widget.padding,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (hasClient)
              ListenableBuilder(
                listenable: _pageController,
                builder: (_, __) {
                  return Padding(
                    padding: widget.padding,
                    child: ProductImageThumbnailFullWidth(
                      key: const ValueKey('key-slider-product-image-thumb'),
                      itemList: itemList,
                      hasVideo: _hasVideo,
                      onSelect: ({required int index, bool? fullScreen}) {
                        _pageController.jumpToPage(index);
                      },
                      selectIndex: _pageController.page?.round() ?? 0,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
