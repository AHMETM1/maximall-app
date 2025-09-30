import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../common/tools.dart';
import '../../../widgets/thumbnail_video_widget.dart';

const _imagePaddingRight = 10.0;

class ProductImageThumbnailFullWidth extends StatefulWidget {
  final List<String> itemList;
  final bool hasVideo;
  final Function({required int index, bool? fullScreen}) onSelect;
  final int selectIndex;

  const ProductImageThumbnailFullWidth({
    super.key,
    required this.itemList,
    this.hasVideo = false,
    required this.onSelect,
    this.selectIndex = 0,
  });

  @override
  State<ProductImageThumbnailFullWidth> createState() =>
      _ProductImageThumbnailFullWidthState();
}

class _ProductImageThumbnailFullWidthState
    extends State<ProductImageThumbnailFullWidth> {
  final itemScrollController = ItemScrollController();
  late int _indexSelected = widget.selectIndex;

  @override
  void didUpdateWidget(covariant ProductImageThumbnailFullWidth oldWidget) {
    if (_indexSelected != widget.selectIndex) {
      _indexSelected = widget.selectIndex;
      itemScrollController.scrollTo(
        index: _indexSelected,
        duration: const Duration(milliseconds: 200),
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var widthImage = (widthScreen - _imagePaddingRight * 6.5) / 4;

    if (widget.itemList.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: widthImage,
      width: widthScreen,
      child: ScrollablePositionedList.separated(
        separatorBuilder: (_, __) => const SizedBox(width: _imagePaddingRight),
        scrollDirection: Axis.horizontal,
        itemCount: widget.itemList.length,
        itemScrollController: itemScrollController,
        itemBuilder: (context, i) {
          Widget body = const SizedBox();
          final decoration = BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).colorScheme.surface,
            border: _indexSelected == i
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          );

          if ((widget.hasVideo && i == 0)) {
            body = Container(
              decoration: decoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ThumbnailVideoWidget(
                  widget.itemList[i],
                  maxHeight: widthImage,
                  maxWidth: widthImage,
                  duration: const Duration(milliseconds: 200),
                ),
              ),
            );
          } else {
            body = AnimatedContainer(
              clipBehavior: Clip.antiAlias,
              duration: const Duration(milliseconds: 200),
              decoration: decoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ImageResize(
                  url: widget.itemList[i],
                  height: widthImage,
                  width: widthImage,
                  isResize: true,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }

          return GestureDetector(
            onDoubleTap: () => widget.onSelect(index: i, fullScreen: true),
            onLongPress: () => widget.onSelect(index: i, fullScreen: true),
            onTap: () => widget.onSelect(index: i),
            child: body,
          );
        },
      ),
    );
  }
}
