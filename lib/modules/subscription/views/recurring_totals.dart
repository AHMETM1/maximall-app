import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/tools.dart';
import '../../../models/app_model.dart';
import '../../../models/cart/cart_model.dart';
import '../../../models/entities/product.dart';

class RecurringTotal extends StatelessWidget {
  const RecurringTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(builder: (context, model, child) {
      // Find key of product subscription in cart
      var productKey = model.productsInCart.keys.firstWhereOrNull((key) {
        var productId = Product.cleanProductID(key);
        var product = model.item[productId];
        return product?.type == 'variable-subscription' ||
            product?.type == 'subscription';
      });

      if (productKey == null) {
        return const SizedBox();
      }

      var productId = Product.cleanProductID(productKey);
      var product = model.item[productId];

      if (product == null) {
        return const SizedBox();
      }

      final currency = Provider.of<AppModel>(context).currency;
      final currencyRate =
          Provider.of<AppModel>(context, listen: false).currencyRate;
      final billingInterval = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_period_interval',
          orElse: () => {})['value'];
      final billingPeriod = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_period',
          orElse: () => {})['value'];

      final trialLength = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_trial_length',
          orElse: () => {})['value'];
      final trialPeriod = product.metaData.firstWhere(
          (element) => element['key'] == '_subscription_trial_period',
          orElse: () => {})['value'];

      var subtotal = model.getProductPrice(productKey);
      var quantity = model.productsInCart[productKey] ?? 1;
      subtotal = subtotal * quantity;
      var period = '';
      if (billingInterval.toString().isNotEmpty &&
          int.parse(billingInterval.toString()) > 1) {
        period +=
            '${billingInterval ?? ''} ${billingPeriod?.toString().isNotEmpty ?? false ? '${billingPeriod}s' : ''}'
                .trim();
      } else {
        period += billingPeriod;
      }
      var subtotalText =
          '${PriceTools.getCurrencyFormatted(subtotal, currencyRate, currency: currency)!}/$period';

      final smallStyle = TextStyle(
          color: Theme.of(context).colorScheme.secondary, fontSize: 14);
      final largeStyle = TextStyle(
          color: Theme.of(context).colorScheme.secondary, fontSize: 18);
      final firstRenewalStyle =
          TextStyle(color: Theme.of(context).primaryColor, fontSize: 16);

      var firstRenewal = '${S.of(context).firstRenewal}: ';
      if (trialLength == '' || trialLength == '0') {
        firstRenewal += DateFormat.yMMMMd('en_US').format(DateTime.now());
      } else {
        var days = 1;
        switch (trialPeriod) {
          case 'day':
            days *= 1;
            break;
          case 'week':
            days *= 7;
            break;
          case 'month':
            days *= 30;
            break;
          case 'year':
            days *= 365;
            break;
        }
        firstRenewal += DateFormat.yMMMMd('en_US').format(
            DateTime.now().add(Duration(days: int.parse(trialLength) * days)));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(3.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).recurringTotals,
                    style: largeStyle, textAlign: TextAlign.left),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(S.of(context).subtotal, style: smallStyle),
                    ),
                    Expanded(flex: 1, child: Text(subtotalText)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(S.of(context).recurringTotals,
                          style: smallStyle),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${PriceTools.getCurrencyFormatted(subtotal, currencyRate, currency: currency)!}/$period'),
                          const SizedBox(height: 5),
                          Text(firstRenewal, style: firstRenewalStyle)
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      );
    });
  }
}
