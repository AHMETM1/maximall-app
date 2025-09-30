import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../common/tools/price_tools.dart';
import '../../../../models/app_model.dart';
import '../../../../models/order/order.dart';
import 'order_price.dart';

class OrderTotal extends StatelessWidget {
  const OrderTotal({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final currencyCode =
        order.currencyCode ?? Provider.of<AppModel>(context).currencyCode!;
    final currencyRate = (order.currencyCode?.isEmpty ?? true)
        ? Provider.of<AppModel>(context).currencyRate
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          if (order.deliveryDate != null && order.storeDeliveryDates == null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Text(S.of(context).expectedDeliveryDate,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.deliveryDate!,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  )
                ],
              ),
            ),
          if (order.paymentMethodTitle?.isNotEmpty ?? false)
            _CustomListTile(
              leading: S.of(context).paymentMethod,
              trailing: order.paymentMethodTitle!,
            ),
          if (order.paymentMethodTitle?.isNotEmpty ?? false)
            const SizedBox(height: 10),
          (order.shippingMethodTitle?.isNotEmpty ?? false) &&
                  kPaymentConfig.enableShipping
              ? _CustomListTile(
                  leading: S.of(context).shippingMethod,
                  trailing: order.shippingMethodTitle!,
                )
              : const SizedBox(),
          if (order.totalShipping != null) const SizedBox(height: 10),
          if (order.totalShipping != null)
            _CustomListTile(
              leading: S.of(context).shippingFee,
              trailing: PriceTools.getCurrencyFormatted(
                  order.totalShipping, currencyRate,
                  currency: currencyCode)!,
            ),
          const SizedBox(height: 10),
          ...List.generate(
            order.feeLines.length,
            (index) {
              final item = order.feeLines[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(item.name ?? '',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      PriceTools.getCurrencyFormatted(item.total, currencyRate,
                          currency: currencyCode)!,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    )
                  ],
                ),
              );
            },
          ),
          _CustomListTile(
            leading: S.of(context).subtotal,
            trailing: PriceTools.getCurrencyFormatted(
                order.calculateSubtotal, currencyRate,
                currency: currencyCode)!,
          ),
          const SizedBox(height: 10),
          if (order.discountTotal > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  S.of(context).discount,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
                Text(
                  '-${PriceTools.getCurrencyFormatted(order.discountTotal, currencyRate, currency: currencyCode)!}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                S.of(context).totalTax,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              OrderPrice.tax(
                order: order,
                currencyRate: currencyRate,
                currencyCode: currencyCode,
                style: Theme.of(context).textTheme.titleMedium!,
              ),
            ],
          ),
          Divider(
            height: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                S.of(context).total,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              OrderPrice(
                order: order,
                currencyRate: currencyRate,
                currencyCode: currencyCode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.leading,
    required this.trailing,
  });

  final String leading;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleMedium!,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(leading),
          ),
          const SizedBox(width: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              trailing,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
