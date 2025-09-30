import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../models/index.dart'
    show AppModel, CartModel, Order, PaymentMethodModel, TaxModel;
import '../../../models/tera_wallet/index.dart';
import '../../../modules/dynamic_layout/helper/helper.dart';
import '../../../modules/native_payment/razorpay/services.dart';
import '../../../services/index.dart';
import '../../cart/widgets/shopping_cart_sumary.dart';
import '../mixins/payment_mixin.dart';
import 'checkout_action.dart';

class PaymentMethods extends StatefulWidget {
  final Function? onBack;
  final Function(Order)? onFinish;
  final Function(bool)? onLoading;
  final bool hideCheckout;

  const PaymentMethods({
    this.onBack,
    this.onFinish,
    this.onLoading,
    this.hideCheckout = false,
  });

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods>
    with RazorDelegate, PaymentMixin {
  @override
  Function? get onBack => widget.onBack;

  @override
  Function(Order)? get onFinish => widget.onFinish;

  @override
  Function(bool)? get onLoading => widget.onLoading;

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final paymentMethodModel = Provider.of<PaymentMethodModel>(context);
    final taxModel = Provider.of<TaxModel>(context);
    final useDesktopLayout = Layout.isDisplayDesktop(context);

    var cartTotal = cartModel.getTotal();

    //if Risk Free Cod is checked, the total should be calculated by server, it will be included extra fee that settings on the website.
    if ((cartModel.wooSmartCod?.userAdvanceAmount ?? 0) > 0) {
      final cod = paymentMethodModel.paymentMethods
          .firstWhereOrNull((e) => e.smartCod != null);
      cartTotal = cod?.smartCod?.realTotal ?? cartTotal;
    }

    final body = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S.of(context).paymentMethods,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text(
              S.of(context).chooseYourPaymentMethod,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValueOpacity(0.6),
              ),
            ),
            Services().widget.renderPayByWallet(context),
            const SizedBox(height: 20),
            Consumer2<PaymentMethodModel, WalletModel>(
                builder: (context, model, walletModel, child) {
              if (model.isLoading) {
                return SizedBox(height: 100, child: kLoadingWidget(context));
              }

              if (model.message != null) {
                return SizedBox(
                  height: 100,
                  child: Center(
                      child: Text(model.message!,
                          style: const TextStyle(color: kErrorRed))),
                );
              }

              var paymentMethods = model.paymentMethods;
              if (cartModel.wooSmartCod?.isRiskFreeEnabled == true &&
                  (cartModel
                          .wooSmartCod?.disallowedPaymentGateways?.isNotEmpty ??
                      false)) {
                paymentMethods = paymentMethods
                    .where((e) => !(cartModel
                            .wooSmartCod?.disallowedPaymentGateways
                            ?.contains(e.id ?? '') ??
                        false))
                    .toList();

                if (cartModel.wooSmartCod?.disallowedPaymentGateways
                        ?.contains(selectedId ?? '') ??
                    true) {
                  selectedId = paymentMethods.firstWhereOrNull((item) {
                    return item.id != 'cod' && item.enabled!;
                  })?.id;
                  cartModel.setPaymentMethod(
                    paymentMethods.firstWhereOrNull(
                      (item) => item.id == selectedId,
                    ),
                  );
                }
              }

              if (paymentMethods.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/images/leaves.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                );
              }

              var ignoreWallet = false;
              final isWalletExisted =
                  paymentMethods.firstWhereOrNull((e) => e.id == 'wallet') !=
                      null;
              if (isWalletExisted) {
                final total =
                    (cartModel.getTotal() ?? 0) + cartModel.walletAmount;
                ignoreWallet = total > walletModel.balance;
              }

              if (selectedId == null && paymentMethods.isNotEmpty) {
                selectedId = paymentMethods.firstWhereOrNull((item) {
                  if (ignoreWallet) {
                    return item.id != 'wallet' && item.enabled!;
                  } else {
                    return item.enabled!;
                  }
                })?.id;
                cartModel.setPaymentMethod(
                  paymentMethods.firstWhereOrNull(
                    (item) => item.id == selectedId,
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  for (int i = 0; i < paymentMethods.length; i++)
                    paymentMethods[i].enabled!
                        ? Services().widget.renderPaymentMethodItem(
                            context,
                            paymentMethods[i],
                            (i) {
                              setState(() {
                                selectedId = i;
                              });
                              final paymentMethod = paymentMethods
                                  .firstWhere((item) => item.id == i);
                              cartModel.setPaymentMethod(paymentMethod);
                            },
                            selectedId,
                            useDesktopStyle: useDesktopLayout,
                          )
                        : const SizedBox()
                ],
              );
            }),
            if (widget.hideCheckout == false) ...[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: ShoppingCartSummary(
                  showPrice: false,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      S.of(context).subtotal,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValueOpacity(0.8),
                      ),
                    ),
                    Text(
                        PriceTools.getCurrencyFormatted(
                            cartModel.getSubTotal(), currencyRate,
                            currency: cartModel.currencyCode)!,
                        style: const TextStyle(fontSize: 14, color: kGrey400))
                  ],
                ),
              ),
              Services().widget.renderShippingMethodInfo(context),
              if (cartModel.getCoupon() != '')
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        S.of(context).discount,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValueOpacity(0.8),
                        ),
                      ),
                      Text(
                        cartModel.getCoupon(),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withValueOpacity(0.8),
                                ),
                      )
                    ],
                  ),
                ),
              Services().widget.renderTaxes(taxModel, context),
              Services().widget.renderRewardInfo(context),
              Services().widget.renderLoyaltyCouponInfo(context),
              Services().widget.renderCheckoutWalletInfo(context),
              Services().widget.renderCODExtraFee(context),
              Services().renderSmartCodCheckoutExtraFeeInfo(context),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      S.of(context).total,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(
                      PriceTools.getCurrencyFormatted(cartTotal, currencyRate,
                          currency: cartModel.currencyCode)!,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Services().renderSmartCodCheckoutRiskFreeInfo(context),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
    );

    return ListenableProvider.value(
      value: paymentMethodModel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (useDesktopLayout)
            Padding(padding: const EdgeInsets.only(bottom: 50), child: body)
          else
            Expanded(child: body),
          Consumer<PaymentMethodModel>(builder: (context, model, child) {
            return _buildBottom(model, cartModel);
          })
        ],
      ),
    );
  }

  Widget _buildBottom(PaymentMethodModel paymentMethodModel, cartModel) {
    return CheckoutActionWidget(
      iconPrimary: CupertinoIcons.check_mark_circled_solid,
      labelPrimary: S.of(context).placeMyOrder,
      onTapPrimary: (paymentMethodModel.message?.isNotEmpty ?? false)
          ? null
          : () => isPaying || selectedId == null
              ? showSnackbar()
              : placeOrder(paymentMethodModel, cartModel),
      labelSecondary: kPaymentConfig.enableReview
          ? S.of(context).goBack.toUpperCase()
          : kPaymentConfig.enableShipping
              ? S.of(context).goBackToShipping
              : S.of(context).goBackToAddress,
      onTapSecondary: () {
        isPaying ? showSnackbar : widget.onBack!();
      },
      showSecondary: kPaymentConfig.enableShipping ||
          kPaymentConfig.enableAddress ||
          kPaymentConfig.enableReview,
      showPrimary: widget.hideCheckout == false,
    );
  }
}
