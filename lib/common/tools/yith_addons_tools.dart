import '../../models/cart/cart_base.dart';
import '../../models/entities/yith_product_addons.dart';
import 'price_tools.dart';

class YithAddonsTools {
  static double getYithOptionPrice(double basePrice, YithAddonsOption option,
      {bool isOnSale = true}) {
    var price = double.tryParse(
            isOnSale && (option.salePrice?.isNotEmpty ?? false)
                ? option.salePrice!
                : (option.price ?? '')) ??
        0.0;

    if (option.priceMethod == YithAddonsPriceMethod.free) {
      return 0.0;
    } else {
      var optionPrice = 0.0;
      if (option.priceType == YithAddonsPriceType.percentage) {
        optionPrice = (basePrice * price) / 100;
      } else if (option.priceType == YithAddonsPriceType.fixed) {
        optionPrice = price;
      }

      if (option.priceMethod == YithAddonsPriceMethod.increase) {
        return optionPrice;
      } else if (option.priceMethod == YithAddonsPriceMethod.decrease) {
        return optionPrice * -1;
      }
      return 0.0;
    }
  }

  static double getSelectedYithOptionsPrice(
      double basePrice,
      Map<String, Map<String, YithAddonsOption>> selectedOptions,
      int quantity) {
    var price = 0.0;
    final options = <YithAddonsOption>[];
    for (var addOns in selectedOptions.values) {
      options.addAll(addOns.values);
    }
    if (selectedOptions.isEmpty) {
      return price;
    }

    for (var option in options) {
      var optionPrice = YithAddonsTools.getYithOptionPrice(basePrice, option);
      price += optionPrice * quantity;
    }
    return price;
  }

  static String getPriceValueByOption(
      CartModel model, double basePrice, YithAddonsOption? option) {
    final rates = model.currencyRates;
    final currency = model.currencyCode;

    if (option == null) {
      return '';
    }
    var optionPrice = YithAddonsTools.getYithOptionPrice(basePrice, option);
    if (optionPrice > 0) {
      return '(+${PriceTools.getCurrencyFormatted(
        optionPrice,
        rates,
        currency: currency,
      )})';
    } else if (optionPrice < 0) {
      return '(-${PriceTools.getCurrencyFormatted(
        optionPrice * (-1),
        rates,
        currency: currency,
      )})';
    }
    return '';
  }
}
