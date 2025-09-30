import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../models/index.dart' show Product, RecentModel;
import '../../../models/user_model.dart';
import '../../../services/index.dart';
import '../config/product_config.dart';
import '../helper/helper.dart';
import 'product_empty.dart';

/// Keep the size of each product layout with key
final _listSize = <String, double>{};

/// Handle the product network request, caching and empty product
class ProductFutureBuilder extends StatefulWidget {
  final ProductConfig config;
  final Function child;
  final Widget? waiting;
  final bool cleanCache;

  const ProductFutureBuilder({
    required this.config,
    this.waiting,
    required this.child,
    this.cleanCache = false,
    super.key,
  });

  @override
  State<ProductFutureBuilder> createState() => _ProductListLayoutState();
}

class _ProductListLayoutState extends State<ProductFutureBuilder> {
  ValueNotifier<List<Product>?> productsNotifier = ValueNotifier(null);

  /// height of widget
  double? _height;

  /// key to store size of each product layout
  String _keySize = '';

  Future<List<Product>?> _getProductLayout(BuildContext context) async {
    if (widget.config.layout == Layout.recentView) {
      return context.read<RecentModel>().getRecentProduct();
    }
    if (widget.config.layout == Layout.saleOff) {
      /// Fetch only onSale products for saleOff layout.
      widget.config.onSale = true;
    }
    final userId = Provider.of<UserModel>(context, listen: false).user?.id;
    var jsonData = widget.config.jsonData;
    List<Product>? products;
    if (jsonData is Map && jsonData['data'] != null) {
      products = Services().api.productsFromJsonData(jsonData['data']);
    }
    products ??= await Services().api.fetchProductsLayout(
          config: widget.config.jsonData,
          userId: userId,
          refreshCache: widget.cleanCache,
        );
    return products;
  }

  void _getSizeWidget(BuildContext ct) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = ct.size;
      if (ct.size != null) {
        _listSize.addAll({_keySize: size!.height});
        _height = size.height;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _keySize = keyToMd5(jsonEncode(widget.config));
    if (productsNotifier.value != null) {
      return;
    }
    if (widget.config.layout == Layout.recentView) {
      context.read<RecentModel>().getRecentProduct();
      return;
    }
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        productsNotifier.value = await _getProductLayout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_listSize[_keySize] != null) {
      _height = _listSize[_keySize];
    }

    final recentProduct = Provider.of<RecentModel>(context).products;
    final isRecentLayout = widget.config.layout == Layout.recentView;
    final isSaleOffLayout = widget.config.layout == Layout.saleOff;
    if (isRecentLayout) {
      productsNotifier.value =
          context.select((RecentModel recentModel) => recentModel.products);
    }
    if (isRecentLayout && recentProduct.length < 3) return const SizedBox();

    return ValueListenableBuilder<List<Product>?>(
      valueListenable: productsNotifier,
      builder: (context, products, child) {
        return LayoutBuilder(
          builder: (ctL, constraint) {
            var maxWidth = Layout.isDisplayDesktop(ctL)
                ? constraint.maxWidth
                : constraint.maxWidth;

            //Do not include HeaderView height
            var maxHeight = constraint.maxHeight - 50;

            if (products == null) {
              if (widget.waiting != null) return widget.waiting!;

              return SizedBox(
                height: _height,
                child: widget.config.layout == Layout.listTile
                    ? EmptyProductTile(maxWidth: maxWidth)
                    : widget.config.rows > 1
                        ? EmptyProductGrid(
                            config: widget.config,
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                          )
                        : widget.child(
                            maxWidth: maxWidth,
                            maxHeight: maxHeight,
                            products: List.generate(
                                3, (index) => Product.empty(index.toString())),
                          ),
              );
            }

            /// Hide sale off layout when product list is empty.
            if (products.isEmpty &&
                isSaleOffLayout &&
                kSaleOffProduct.hideEmptySaleOffLayout) {
              return SizedBox(
                height: _height,
              );
            }

            /// Hide section if product list is empty.
            if (widget.config.hideEmptyProductLayout && products.isEmpty) {
              return SizedBox(
                height: _height,
              );
            }

            // Get size of widget
            _getSizeWidget(context);

            return SizedBox(
              child: widget.child(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                products: products,
              ),
              height: _height,
            );
          },
        );
      },
    );
  }
}
