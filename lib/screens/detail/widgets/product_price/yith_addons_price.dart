import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/tools/price_tools.dart';
import '../../../../common/tools/yith_addons_tools.dart';
import '../../../../models/index.dart';
import '../../../../models/product_variant_model.dart';
import '../../mixins/detail_product_price_mixin.dart';

class YithAddonsPrice extends StatefulWidget {
  final Product product;
  final DetailProductPriceStateUI? priceData;
  final Axis axisType;

  const YithAddonsPrice({
    required this.product,
    this.priceData,
    this.axisType = Axis.horizontal,
    super.key,
  });

  @override
  State<YithAddonsPrice> createState() => _YithAddonsPriceState();
}

class _YithAddonsPriceState extends State<YithAddonsPrice> {
  ProductVariantModel get model => context.read<ProductVariantModel>();

  Map<String, Map<String, YithAddonsOption>> get selectedOptions =>
      model.selectedYithOptions;

  double get basePrice =>
      model.productVariation?.valuePrice ?? widget.product.valuePrice;

  int get quantity => model.quantity;

  @override
  Widget build(BuildContext context) {
    final model = context.read<AppModel>();
    final rates = model.currencyRate;
    final currency = model.currency;
    var total = YithAddonsTools.getSelectedYithOptionsPrice(
            basePrice, selectedOptions, quantity) +
        basePrice * quantity;
    var prefix = '';
    if (total < 0) {
      prefix = '-';
      total = total.abs();
    }

    return Text(
      prefix +
          PriceTools.getCurrencyFormatted(
            total,
            rates,
            currency: currency,
          )!,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
