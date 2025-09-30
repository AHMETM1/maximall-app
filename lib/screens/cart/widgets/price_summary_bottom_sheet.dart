import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools/price_tools.dart';
import '../../../models/cart/cart_base.dart';

class PriceSummaryBottomSheet extends StatelessWidget {
  const PriceSummaryBottomSheet({
    super.key,
    required this.currencyRate,
    this.currency,
  });

  final String? currency;
  final Map<String, dynamic> currencyRate;

  @override
  Widget build(BuildContext context) {
    final modelCart = Provider.of<CartModel>(context);
    final defaultCurrency = kAdvanceConfig.defaultCurrency;
    final usedCurrency =
        modelCart.isWalletCart() ? defaultCurrency?.currencyCode : currency;

    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        );
    final totalStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.secondary,
        );

    final subTotal = modelCart.getSubTotal() ?? 0;
    final shippingCost = modelCart.getShippingCost() ?? 0;
    final taxes = modelCart.taxesTotal;
    final discount = modelCart.rewardTotal;
    final total = modelCart.getTotal() ?? 0;
    final couponObj = modelCart.couponObj;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.withValueOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            S.of(context).orderSummary,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).subtotal, style: titleStyle),
              Text(
                PriceTools.getCurrencyFormatted(subTotal, currencyRate,
                    currency: usedCurrency)!,
                style: valueStyle,
              ),
            ],
          ),
          const Divider(height: 24),
          if (shippingCost > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).shipping, style: titleStyle),
                Text(
                  PriceTools.getCurrencyFormatted(shippingCost, currencyRate,
                      currency: usedCurrency)!,
                  style: valueStyle,
                ),
              ],
            ),
            const Divider(height: 24),
          ],
          if (taxes > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).tax, style: titleStyle),
                Text(
                  PriceTools.getCurrencyFormatted(taxes, currencyRate,
                      currency: usedCurrency)!,
                  style: valueStyle,
                ),
              ],
            ),
            const Divider(height: 24),
          ],
          if (discount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).cartDiscount, style: titleStyle),
                Text(
                  '- ${PriceTools.getCurrencyFormatted(discount, currencyRate, currency: usedCurrency)!}',
                  style: valueStyle?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
          ],
          if (couponObj != null && (couponObj.amount ?? 0) > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${S.of(context).couponCode}: ${couponObj.code}',
                    style: titleStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  couponObj.discountType == 'percent'
                      ? '-${couponObj.amount}%'
                      : '- ${PriceTools.getCurrencyFormatted(couponObj.amount, currencyRate, currency: usedCurrency)!}',
                  style: valueStyle?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).total, style: totalStyle),
              Text(
                PriceTools.getCurrencyFormatted(total, currencyRate,
                    currency: usedCurrency)!,
                style: totalStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
