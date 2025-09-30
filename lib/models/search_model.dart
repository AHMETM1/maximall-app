import 'package:flutter/material.dart';

import '../data/boxes.dart';
import '../services/service_config.dart';
import 'mixins/language_mixin.dart';

class SearchModel extends ChangeNotifier with LanguageMixin {
  static const _searchPrefix = 'search_';
  static const _productKey = '${_searchPrefix}product';
  static const _listingKey = '${_searchPrefix}listing';

  SearchModel() {
    _getKeywords(true);
  }

  List<String> keywords = [];
  bool? _lastType;

  bool get _isListingOnly => ServerConfig().isListingSingleApp;
  bool get _isListeoWithDokan =>
      ServerConfig().isListeoType && ServerConfig().multiVendorType == 'dokan';

  String _getKeyByPlatform(bool? productType) {
    if (_isListingOnly) return _listingKey;
    if (_isListeoWithDokan) {
      return (productType ?? true) ? _productKey : _listingKey;
    }
    return _productKey;
  }

  void updateKeywords(String keyword, {bool? productType}) {
    if (keywords.contains(keyword)) {
      keywords.remove(keyword);
    }
    keywords.insert(0, keyword);
    _saveKeywords(keywords, productType);
    notifyListeners();
  }

  void clearKeywords({bool? productType}) {
    keywords = [];
    _saveKeywords(keywords, productType);
    notifyListeners();
  }

  void _saveKeywords(List<String> keywords, bool? productType) {
    final key = _getKeyByPlatform(productType);
    UserBox().box.put(key, keywords);
  }

  void _getKeywords(bool? productType) {
    if (_lastType == productType) return;

    final key = _getKeyByPlatform(productType);
    final type = _isListingOnly ? false : (productType ?? true);

    keywords =
        List<String>.from(UserBox().box.get(key, defaultValue: <String>[]));
    _lastType = type;
  }

  List<String> getKeywordsByType(bool? productType) {
    _getKeywords(productType);
    return keywords;
  }
}
