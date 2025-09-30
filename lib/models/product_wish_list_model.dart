import 'dart:async';

import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/events.dart';
import '../common/extensions/collection_ext.dart';
import '../data/boxes.dart';
import '../modules/analytics/analytics.dart';
import 'entities/product.dart';

class ProductWishListModel extends ChangeNotifier {
  ProductWishListModel() {
    getLocalWishlist();
    _subscriptionEventScreenChanged =
        eventBus.on<EventScreenChanged>().listen((event) {
      _onScreenChanged();
    });
  }

  final Set<Product> _products = {};
  final Set<Product> _selectedProducts = {};
  late final StreamSubscription _subscriptionEventScreenChanged;

  var _isSelecting = false;

  List<Product> get products => _products.toList();

  bool get isSelecting => _isSelecting;

  Set<Product> get selectedProducts => _selectedProducts;

  List<Product> getWishList() => products;

  int get wishlistCount => _products.length;

  void toggleWishlist(Product product) {
    final isAdded = _products.toggle(product);
    if (isAdded) {
      Analytics.triggerAddToWishList(product);
    }
    saveWishlist(products);
    notifyListeners();
  }

  bool isWishList(Product product) {
    return _products.contains(product);
  }

  Future<void> saveWishlist(List<Product> products) async {
    try {
      UserBox().wishList = products;
    } catch (err, trace) {
      printError(err, trace, '[ProductWishListModel] saveWishlist error');
    }
  }

  void getLocalWishlist() {
    try {
      final wishList = UserBox().wishList;
      if (wishList.isNotEmpty) {
        _products.addAll(wishList);
      }
    } catch (err, trace) {
      printError(err, trace, '[ProductWishListModel] getLocalWishlist error');
    }
  }

  Future<void> clearWishList() async {
    _products.clear();
    await saveWishlist(products);
    notifyListeners();
  }

  void toggleSelectProduct(Product product) {
    _selectedProducts.toggle(product);
    notifyListeners();
  }

  void startSelecting() {
    _isSelecting = true;
    notifyListeners();
  }

  void stopSelecting() {
    _isSelecting = false;
    _selectedProducts.clear();
    notifyListeners();
  }

  bool isSelected(Product product) {
    return _selectedProducts.contains(product);
  }

  void removeSelectedProducts() {
    for (var product in _selectedProducts) {
      _products.remove(product);
    }
    saveWishlist(products);
    stopSelecting();
  }

  void _onScreenChanged() {
    if (_isSelecting) {
      stopSelecting();
    }
  }

  @override
  void dispose() {
    _subscriptionEventScreenChanged.cancel();
    super.dispose();
  }
}
