import '../../../modules/dynamic_layout/helper/helper.dart';
import '../../constants.dart';

class ProductCardConfig {
  bool hidePrice = false;
  bool hideStore = false;
  bool hideTitle = false;
  num? borderRadius;
  bool enableRating = true;
  bool showCartButton = false;
  bool showCartIcon = true;
  bool showCartIconColor = false;

  // cart button quantity config
  bool showCartButtonWithQuantity = false;
  double cartButtonQuantitySize = 40.0;
  double cartIconRadius = 12.0;

  bool hideEmptyProductListRating = false;
  bool showHeart = false;
  bool showProductCardCategory = false;
  bool showListingType = true;
  Map? boxShadow;
  String boxFit = 'cover';
  String cardDesign = kCardDesign.name;
  int? titleLine;
  String? order;
  String? orderby;
  num vMargin = 0.0;
  num hMargin = 6.0;
  String? _defaultImage;

  bool openInWebview = false;

  String get defaultImage => _defaultImage ?? kDefaultImage;

  ProductCardConfig({
    this.hidePrice = false,
    this.hideStore = false,
    this.hideTitle = false,
    this.borderRadius,
    this.enableRating = true,
    this.showCartButton = false,
    this.showCartIcon = true,
    this.showCartIconColor = false,
    this.showCartButtonWithQuantity = false,
    this.hideEmptyProductListRating = false,
    this.showHeart = false,
    this.showProductCardCategory = false,
    this.showListingType = true,
    this.boxFit = 'cover',
    this.boxShadow,
    this.cardDesign = 'card',
    this.titleLine,
    this.order,
    this.orderby,
    this.vMargin = 0.0,
    this.hMargin = 6.0,
    this.cartButtonQuantitySize = 40.0,
    this.cartIconRadius = 40.0,
    String? defaultImage,
    this.openInWebview = false,
  }) : _defaultImage = defaultImage;

  ProductCardConfig.fromJson(dynamic json) {
    hidePrice = json['hidePrice'] ?? false;
    hideStore = json['hideStore'] ?? false;
    hideTitle = json['hideTitle'] ?? false;
    borderRadius = json['borderRadius'];
    enableRating = json['enableRating'] ?? true;
    showCartButton = json['showCartButton'] ?? false;
    showCartIcon = json['showCartIcon'] ?? true;
    showCartIconColor = json['showCartIconColor'] ?? false;
    showCartButtonWithQuantity = json['showCartButtonWithQuantity'] ?? false;
    hideEmptyProductListRating = json['hideEmptyProductListRating'] ?? false;
    showHeart = json['showHeart'] ?? false;
    showProductCardCategory = json['showProductCardCategory'] ?? false;
    showListingType = json['showListingType'] ?? true;
    boxShadow = json['boxShadow'];
    boxFit = json['boxFit'] ?? 'cover';
    cardDesign = json['cardDesign'] ?? kCardDesign.name;
    titleLine = Helper.formatInt(json['titleLine']);
    order = json['order'];
    orderby = json['orderby'];
    vMargin = json['vMargin'] ?? 0.0;
    hMargin = json['hMargin'] ?? 6.0;
    cartButtonQuantitySize =
        double.tryParse(json['cartButtonQuantitySize'].toString()) ?? 40.0;
    cartIconRadius = double.tryParse(json['cartIconRadius'].toString()) ?? 40.0;
    _defaultImage = json['defaultImage'];
    openInWebview = json['openInWebview'] ?? false;
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['hidePrice'] = hidePrice;
    map['hideStore'] = hideStore;
    map['hideTitle'] = hideTitle;
    map['borderRadius'] = borderRadius;
    map['enableRating'] = enableRating;
    map['showCartButton'] = showCartButton;
    map['showCartIcon'] = showCartIcon;
    map['showCartIconColor'] = showCartIconColor;
    map['showCartButtonWithQuantity'] = showCartButtonWithQuantity;
    map['cartButtonQuantitySize'] = cartButtonQuantitySize;
    map['cartIconRadius'] = cartIconRadius;
    map['hideEmptyProductListRating'] = hideEmptyProductListRating;
    map['showHeart'] = showHeart;
    map['showProductCardCategory'] = showProductCardCategory;
    map['showListingType'] = showListingType;
    map['boxShadow'] = boxShadow;
    map['boxFit'] = boxFit;
    map['cardDesign'] = cardDesign;
    map['titleLine'] = titleLine;
    map['order'] = order;
    map['orderby'] = orderby;
    map['vMargin'] = vMargin;
    map['hMargin'] = hMargin;
    map['defaultImage'] = _defaultImage;
    map['openInWebview'] = openInWebview;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
