import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

extension TranslateExt on BuildContext {
  String transCountProduct(int length) {
    if (length == 1) {
      return S.of(this).countProduct(length);
    }
    return S.of(this).countProducts(length);
  }

  String transCountItem(int count) {
    if (count == 1) {
      return S.of(this).countItem(count);
    }
    return S.of(this).countItems(count);
  }
}
