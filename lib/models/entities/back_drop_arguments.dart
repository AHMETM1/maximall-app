import 'product_category_menu_style.dart';

class BackDropArguments {
  final String? cateId;
  final String? cateName;
  final String? tag;
  final List? data;
  final Map? config;
  final String? brandId;
  final String? brandName;
  final String? brandImg;
  final bool showCountdown;
  final bool? allowFilterMultipleCategory;
  final ProductCategoryMenuStyle? categoryMenuStyle;

  Duration countdownDuration = Duration.zero;

  BackDropArguments({
    this.cateId,
    this.cateName,
    this.tag,
    this.data,
    this.config,
    this.brandId,
    this.brandName,
    this.brandImg,
    this.categoryMenuStyle,
    this.showCountdown = false,
    this.allowFilterMultipleCategory,
    this.countdownDuration = Duration.zero,
  });
}
