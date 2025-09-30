import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/extensions/color_extension.dart';
import 'package:inspireui/utils/colors.dart';

import '../../../common/config.dart';
import '../../../common/tools/image_tools.dart';

enum CategoryDisplayStyle {
  belowImage,
  overlayImage,
}

class ItemCategory extends StatelessWidget {
  final String? categoryId;
  final String categoryName;
  final String? categoryImage;
  final List<String>? selectedCategories;
  final Function(String?)? onTap;
  final CategoryDisplayStyle displayStyle;
  final BoxConstraints? constraints;

  const ItemCategory({
    super.key,
    this.categoryId,
    required this.categoryName,
    this.categoryImage,
    this.selectedCategories,
    this.onTap,
    this.displayStyle = CategoryDisplayStyle.belowImage,
    this.constraints,
  });

  Widget _buildBelowImageStyle(BuildContext context) {
    var highlightColor = (selectedCategories?.contains(categoryId) ?? false)
        ? Theme.of(context).colorScheme.secondary.withValueOpacity(0.2)
        : Colors.transparent;
    final imageBoxFit = ImageTools.boxFit(
      kAdvanceConfig.categoryImageBoxFit,
      defaultValue: BoxFit.contain,
    );
    return GestureDetector(
      onTap: () => onTap?.call(categoryId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: categoryImage != null ? 5 : 10,
          vertical: 4,
        ),
        margin: const EdgeInsets.only(left: 5, top: 10, bottom: 4),
        decoration: BoxDecoration(
          color: highlightColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: categoryImage != null
            ? Container(
                width: 70,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 55,
                        height: 50,
                        child: FluxImage(
                          imageUrl: categoryImage!,
                          fit: imageBoxFit,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      categoryName.toUpperCase(),
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                            fontWeight: FontWeight.w500,
                          )
                          .apply(
                            fontSizeFactor: 0.7,
                          ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  categoryName.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
      ),
    );
  }

  Widget _buildOverlayImageStyle(BuildContext context) {
    if (constraints == null) {
      return const SizedBox();
    }

    final itemHeight = constraints!.maxWidth / 4;
    final itemWidth = constraints!.maxWidth / 3;

    if (categoryImage == null) {
      return GestureDetector(
        onTap: () => onTap?.call(categoryId),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: Text(
            categoryName.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTap?.call(categoryId),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: <Widget>[
              FluxImage(
                imageUrl: categoryImage!,
                height: itemHeight,
                width: itemWidth,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: itemWidth,
                  height: itemHeight / 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        HexColor('#000').withAlpha(70),
                        HexColor('#000').withAlpha(80),
                        HexColor('#000').withAlpha(90),
                        HexColor('#000'),
                      ], // whitish to gray
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                width: itemWidth,
                child: Center(
                  child: Text(
                    categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return displayStyle == CategoryDisplayStyle.belowImage
        ? _buildBelowImageStyle(context)
        : _buildOverlayImageStyle(context);
  }
}
