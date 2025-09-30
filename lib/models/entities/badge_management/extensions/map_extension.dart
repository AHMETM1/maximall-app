import 'package:flutter/material.dart';

extension ConvertMapToPadding on Map {
  EdgeInsetsGeometry toPadding() {
    var padding = EdgeInsets.zero;
    if (this['top'] != null &&
        double.tryParse(this['top'].toString()) != null) {
      padding = padding.copyWith(top: double.parse(this['top'].toString()));
    }
    if (this['left'] != null &&
        double.tryParse(this['left'].toString()) != null) {
      padding = padding.copyWith(left: double.parse(this['left'].toString()));
    }
    if (this['bottom'] != null &&
        double.tryParse(this['bottom'].toString()) != null) {
      padding =
          padding.copyWith(bottom: double.parse(this['bottom'].toString()));
    }
    if (this['right'] != null &&
        double.tryParse(this['right'].toString()) != null) {
      padding = padding.copyWith(right: double.parse(this['right'].toString()));
    }

    return padding;
  }

  BorderRadius toBorderRadius() {
    var borderRadius = BorderRadius.zero;
    if (this['top-left'] != null && double.tryParse(this['top-left']) != null) {
      borderRadius = borderRadius.copyWith(
          topLeft: Radius.circular(double.parse(this['top-left'])));
    }
    if (this['top-right'] != null &&
        double.tryParse(this['top-right']) != null) {
      borderRadius = borderRadius.copyWith(
          topRight: Radius.circular(double.parse(this['top-right'])));
    }
    if (this['bottom-right'] != null &&
        double.tryParse(this['bottom-right']) != null) {
      borderRadius = borderRadius.copyWith(
          bottomRight: Radius.circular(double.parse(this['bottom-right'])));
    }
    if (this['bottom-left'] != null &&
        double.tryParse(this['bottom-left']) != null) {
      borderRadius = borderRadius.copyWith(
          bottomLeft: Radius.circular(double.parse(this['bottom-left'])));
    }

    return borderRadius;
  }
}
