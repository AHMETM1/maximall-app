import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../common/tools.dart';
import '../../models/index.dart' show Blog;
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../modules/dynamic_layout/index.dart';

class BlogCard extends StatelessWidget {
  final Blog? item;
  final width;
  final margin;
  final kSize size;
  final height;
  final VoidCallback onTap;
  final BlogConfig? config;

  const BlogCard({
    this.item,
    this.width,
    this.size = kSize.medium,
    this.height,
    this.margin = 5.0,
    required this.onTap,
    this.config,
  });

  bool get isCarouselView => config?.layout == Layout.carousel;
  bool get isFourColumn => config?.layout == Layout.fourColumn;

  double fontSizeSubTitle(bool isTablet) => isCarouselView
      ? (isTablet ? 14 : 9)
      : (!isTablet && isFourColumn)
          ? 10
          : (isTablet ? 14 : 12);

  Widget getImageFeature(double imageWidth, {double? imageHeight}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: ImageResize(
          url: item!.imageFeature,
          width: imageWidth,
          height: height ?? imageHeight ?? width * 0.60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget renderAuthor({bool isTablet = false}) {
    var authorText = Text(
      item!.author,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSizeSubTitle(isTablet),
        overflow: TextOverflow.ellipsis,
      ),
    );

    return Row(
      children: [
        if (isCarouselView)
          Expanded(child: authorText)
        else ...[
          const Icon(
            Icons.drive_file_rename_outline_outlined,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 2),
          authorText,
        ],
      ],
    );
  }

  Widget renderDateAuthorWidget(
    bool isSmallSize, {
    double? width,
    double? height,
    bool isTablet = false,
  }) {
    var textDate = Text(
      item!.date,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSizeSubTitle(isTablet),
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: 1,
    );

    var dateAuthorWidget = [
      if (isCarouselView)
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 2),
          child: textDate,
        )
      else
        Expanded(child: textDate),
      if (!isSmallSize) renderAuthor(isTablet: isTablet),
    ];

    if (isCarouselView) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: dateAuthorWidget,
      );
    }
    return Row(children: dateAuthorWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    final blogConfig = config ?? BlogConfig.empty();
    var titleFontSize = isTablet ? 20.0 : 14.0;
    var maxWidth = width;

    if (blogConfig.cardDesign == BlogCardType.background) {
      var maxTitleFontSize = 27.0;
      var maxlineTitle = 3;
      var fontSubTitle = isTablet ? 14.0 : 13.0;
      var sizeSubTitle = isTablet ? 50.0 : 32.0;

      if (isTablet && blogConfig.layout == Layout.twoColumn) {
        maxTitleFontSize = 35.0;
        maxlineTitle = 4;
        fontSubTitle = 18.0;
        sizeSubTitle = 90.0;
      }

      titleFontSize = min(titleFontSize * maxWidth / 150, maxTitleFontSize);
      var isSmallSize = titleFontSize < 14.0;
      if (isSmallSize) titleFontSize = 14.0;
      final horizontalPadding = isSmallSize ? 5.0 : 10.0;
      final verticalPadding = isSmallSize ? 5.0 : 20.0;

      if (isTablet == false && isFourColumn) {
        titleFontSize = 12.0;
      }

      Widget body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            item!.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                ),
            maxLines: maxlineTitle,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSmallSize) ...[
                  SizedBox(
                    height: sizeSubTitle,
                    child: Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: HtmlWidget(
                        item!.subTitle,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: fontSubTitle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 5 : 2),
                ],
                Flexible(
                  child: renderDateAuthorWidget(
                    isSmallSize,
                    width: maxWidth,
                    height: maxWidth,
                  ),
                ),
                if (isSmallSize) renderAuthor(),
              ],
            ),
          )
        ],
      );

      if (isCarouselView) {
        final contentMaxWith =
            maxWidth - (horizontalPadding * 2) - (blogConfig.hMargin * 2) - 10;
        body = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWith),
            child: body,
          ),
        );
      }

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: blogConfig.hMargin,
          vertical: blogConfig.vMargin,
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              getImageFeature(maxWidth, imageHeight: maxWidth),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValueOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: maxWidth,
                height: maxWidth,
              ),
              Container(
                width: maxWidth,
                height: maxWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: body,
              )
            ],
          ),
        ),
      );
    }
    Widget body = Container(
      width: maxWidth,
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item!.title,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            item!.date,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (isCarouselView) {
      body = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: body,
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: blogConfig.hMargin,
        vertical: blogConfig.vMargin,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getImageFeature(maxWidth),
          body,
        ],
      ),
    );
  }
}
