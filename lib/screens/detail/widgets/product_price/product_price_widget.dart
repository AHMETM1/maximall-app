import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../../common/tools/price_tools.dart';
import '../../../../models/app_model.dart';
import '../../../../models/entities/product.dart';
import '../../../../models/product_model.dart';
import '../../../../services/services.dart';
import '../../mixins/detail_product_price_mixin.dart';

class ProductPrice extends StatelessWidget {
  final Product product;
  final DetailProductPriceStateUI? priceData;
  final bool? isShowCountDown;
  final int? countDown;
  final Axis axisType;

  const ProductPrice({
    required this.product,
    this.priceData,
    this.isShowCountDown = false,
    this.countDown = 0,
    this.axisType = Axis.horizontal,
  });

  bool get shouldShowCountDown {
    return isShowCountDown == true && countDown != null && countDown! > 0;
  }

  @override
  Widget build(BuildContext context) {
    final appModel = context.read<AppModel>();
    final currency = appModel.currency;
    final currencyRate = appModel.currencyRate;
    final langCode = appModel.langCode;
    final style = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        );

    var priceString = PriceTools.getCurrencyFormatted(
      priceData?.price ?? product.price ?? '0.0',
      currencyRate,
      currency: currency,
    )!;

    if (product.type == 'grouped') {
      priceString = Provider.of<ProductModel>(context).detailPriceRange;
    }

    if (product.isAppointment && product.appointmentDuration != null) {
      final duration = product.appointmentDuration ?? 0;
      final unit = product.appointmentDurationUnit;
      return Text.rich(
        TextSpan(
          text: '$priceString ',
          children: [
            TextSpan(
              text: '- ${TimeAgo.toUnitString(
                duration,
                unit: unit,
                langCode: langCode,
              )}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValueOpacity(0.7),
                  ),
            ),
          ],
        ),
        style: style,
      );
    }

    var isOnSale = false;

    if (priceData != null) {
      isOnSale = priceData?.price != null &&
          priceData?.regularPrice != null &&
          priceData?.price != priceData?.regularPrice;
    } else {
      isOnSale = product.price != null &&
          product.regularPrice != null &&
          product.price != product.regularPrice;
    }

    isOnSale =
        isOnSale && !Services().widget.hideProductPrice(context, product);

    return isOnSale
        ? _buildSalePrice(context, priceString, style)
        : Text(priceString, style: style);
  }

  Widget _buildSalePrice(
    BuildContext context,
    String priceString,
    TextStyle? style,
  ) {
    final isVertical = axisType == Axis.vertical;

    /// render regular price
    final textRegularPrice = Text(
      PriceTools.getCurrencyFormatted(
        priceData?.regularPrice ?? product.regularPrice ?? '0.0',
        context.read<AppModel>().currencyRate,
        currency: context.read<AppModel>().currency,
      )!,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color:
                Theme.of(context).colorScheme.secondary.withValueOpacity(0.6),
            fontWeight: isVertical ? FontWeight.w600 : FontWeight.w400,
            decoration: TextDecoration.lineThrough,
            fontSize: isVertical ? 14 : null,
          ),
    );

    /// render price
    final textPrice = Text(
      priceString,
      style: style,
    );

    /// render countdown timer
    final countDownTimer = CountDownTimer(
      Duration(milliseconds: countDown ?? 0),
      builder: (context, countdownWidget, isEnd) {
        if (isEnd) {
          return const SizedBox();
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).endsIn('').toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValueOpacity(0.9),
                  )
                  .apply(fontSizeFactor: 0.6),
            ),
            countdownWidget,
          ],
        );
      },
    );

    if (isVertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (shouldShowCountDown) countDownTimer,
          Row(children: [
            textPrice,
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 10.0),
              child: textRegularPrice,
            ),
          ]),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        textPrice,
        Row(
          children: [
            Expanded(child: textRegularPrice),
            if (shouldShowCountDown) countDownTimer,
          ],
        ),
      ],
    );
  }
}
