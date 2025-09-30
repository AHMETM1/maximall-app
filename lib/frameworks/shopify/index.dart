import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/widgets/coupon_card.dart';
import 'package:provider/provider.dart';

// import 'package:shopify_checkout_sheet_kit/shopify_checkout_sheet_kit.dart';

import '../../common/config.dart';
import '../../common/config/models/cart_config.dart';
import '../../common/constants.dart'
    show kBlogLayout, kIsWeb, printError, printLog;
import '../../common/tools.dart';
import '../../models/cart/cart_item_meta_data.dart';
import '../../models/cart/cart_model_shopify.dart';
import '../../models/entities/filter_sorty_by.dart';
import '../../models/index.dart'
    show
        Address,
        AppModel,
        CartModel,
        Country,
        CountryState,
        Coupons,
        Discount,
        Order,
        PaymentMethod,
        Product,
        ShippingMethodModel,
        User,
        UserModel;
import '../../modules/analytics/analytics.dart';
import '../../modules/product_reviews/product_reviews_index.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/checkout/payment_webview_screen.dart';
import '../../screens/checkout/webview_checkout_success_screen.dart';
import '../../services/index.dart';
import '../frameworks.dart';
import '../product_variant_mixin.dart';
import 'services/shopify_service.dart';
import 'shopify_variant_mixin.dart';

const _defaultTitle = 'Title';
const _defaultOptionTitle = 'Default Title';

class ShopifyWidget extends BaseFrameworks
    with ProductVariantMixin, ShopifyVariantMixin {
  final ShopifyService shopifyService;

  // ShopifyCustomerAccountService? customerAccountService;

  ShopifyWidget(this.shopifyService);

  @override
  bool get enableProductReview => false; // currently did not support review

  @override
  void updateUserInfo({
    User? loggedInUser,
    context,
    required onError,
    onSuccess,
    required currentPassword,
    required userDisplayName,
    userEmail,
    username,
    userNiceName,
    userUrl,
    userPassword,
    userFirstname,
    userLastname,
    userPhone,
  }) {
    final params = {
      'email': userEmail,
      'firstName': userFirstname,
      'lastName': userLastname,
      'password': userPassword,
      'phone': userPhone,
    };

    Services().api.updateUserInfo(params, loggedInUser!.cookie)!.then((value) {
      params['cookie'] = loggedInUser.cookie;
      // ignore: unnecessary_null_comparison
      onSuccess!(value != null
          ? User.fromShopifyJson(value, loggedInUser.cookie,
              tokenExpiresAt: loggedInUser.expiresAt)
          : loggedInUser);
    }).catchError((e) {
      onError(e.toString());
    });
  }

  @override
  Widget renderVariantCartItem(
    BuildContext context,
    Product product,
    variation,
    Map? options, {
    AttributeProductCartStyle style = AttributeProductCartStyle.normal,
  }) {
    var list = <Widget>[];
    for (var att in variation.attributes) {
      final name = att.name;
      final option = att.option;
      if (name == _defaultTitle && option == _defaultOptionTitle) {
        continue;
      }

      list.add(Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 50.0, maxWidth: 200),
            child: Text(
              '${name?[0].toUpperCase()}${name?.substring(1)} ',
            ),
          ),
          name == 'color'
              ? Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: HexColor(
                          context.getHexColor(option),
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Text(
                    option ?? '',
                    textAlign: TextAlign.end,
                  ),
                ),
        ],
      ));
      list.add(const SizedBox(
        height: 5.0,
      ));
    }

    return Column(children: list);
  }

  @override
  void loadShippingMethods(
    BuildContext context,
    CartModel cartModel,
    bool beforehand,
  ) {
//    if (!beforehand) return;
    if (context.mounted == false) return;

    final cartModel = Provider.of<CartModel>(context, listen: false);
    final token = context.read<UserModel>().user?.cookie;
    final langCode = context.read<AppModel>().langCode;
    context.read<ShippingMethodModel>().getShippingMethods(
        cartModel: cartModel,
        token: token,
        checkoutId: cartModel.getCartId(),
        langCode: langCode);
  }

  @override
  String? getPriceItemInCart(
    Product product,
    CartItemMetaData? cartItemMetaData,
    currencyRate,
    String? currency, {
    int quantity = 1,
  }) {
    final variation = cartItemMetaData?.variation;
    return variation != null && variation.id != null
        ? PriceTools.getVariantPriceProductValue(
            variation,
            currencyRate,
            currency,
            quantity: quantity,
            onSale: true,
            selectedOptions: cartItemMetaData?.addonsOptions,
          )
        : PriceTools.getPriceProduct(product, currencyRate, currency,
            quantity: quantity, onSale: true);
  }

  @override
  Future<List<Country>> loadCountries() async {
    var countries = <Country>[];
    if (kDefaultCountry.isNotEmpty) {
      for (var item in kDefaultCountry) {
        countries.add(Country.fromConfig(
            item['iosCode'], item['name'], item['icon'], []));
      }
    }
    return countries;
  }

  @override
  Future<List<CountryState>> loadStates(Country country) async {
    final items = await Tools.loadStatesByCountry(country.id!);
    var states = <CountryState>[];
    if (items.isNotEmpty) {
      for (var item in items) {
        states.add(CountryState.fromConfig(item));
      }
    }
    return states;
  }

  @override
  Future<void> resetPassword(BuildContext context, String username) async {
    try {
      final val = await (Provider.of<UserModel>(context, listen: false)
          .submitForgotPassword(forgotPwLink: '', data: {'email': username}));
      if (val?.isEmpty ?? true) {
        Future.delayed(
            const Duration(seconds: 1), () => Navigator.of(context).pop());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).checkConfirmLink),
          duration: const Duration(seconds: 5),
        ));
      } else {
        Tools.showSnackBar(ScaffoldMessenger.of(context), val);
      }
      return;
    } catch (e) {
      printLog(e);
      if (e.toString().contains('UNIDENTIFIED_CUSTOMER')) {
        throw Exception(S.of(context).emailDoesNotExist);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget renderRelatedBlog({
    categoryId,
    required kBlogLayout type,
    EdgeInsetsGeometry? padding,
  }) {
    return const SizedBox();
  }

  @override
  Widget renderCommentField(dynamic postId) {
    return const SizedBox();
  }

  @override
  Widget renderCommentLayout(dynamic postId, kBlogLayout type) {
    return const SizedBox();
  }

  @override
  Widget productReviewWidget(
    Product product, {
    bool isStyleExpansion = true,
    bool isShowEmpty = false,
    Widget Function(int)? builderTitle,
  }) {
    return ProductReviewsIndex(
      product: product,
      isStyleExpansion: isStyleExpansion,
      isShowEmpty: isShowEmpty,
      builderTitle: builderTitle,
    );
  }

  @override
  List<OrderByType> get supportedSortByOptions =>
      [OrderByType.date, OrderByType.price, OrderByType.title];

  @override
  Future<void> applyCoupon(
    context, {
    Coupons? coupons,
    String? code,
    Function? success,
    Function? error,
    bool cartChanged = false,
  }) async {
    final cartModel =
        Provider.of<CartModel>(context, listen: false) as CartModelShopify;
    try {
      var cartDataShopify = cartModel.cartDataShopify;

      if (cartChanged || cartDataShopify == null) {
        cartDataShopify = await shopifyService.createCart(cartModel: cartModel);
      }

      if (cartDataShopify == null) {
        error!('Cannot apply coupon for now. Please try again later.');
        return;
      }
      cartModel.setCartDataShopify(cartDataShopify);

      final cartAppliedCoupon = await shopifyService.applyCouponWithCartId(
        cartId: cartDataShopify.id,
        discountCode: code!,
      );

      cartModel.setCartDataShopify(cartAppliedCoupon);
      final coupon = cartAppliedCoupon?.discountCodeApplied;
      if (cartAppliedCoupon != null && coupon != null) {
        printLog(
            '::::::::::::::::::: applyCoupon success ::::::::::::::::::::::');
        printLog('Cart ID: ${cartAppliedCoupon.id} applied coupon: [$coupon]');
        success!(Discount(
            discountValue: cartAppliedCoupon.totalDiscount,
            coupon: Coupon(
              code: coupon,
              amount: cartAppliedCoupon.totalDiscount,
            )));
        return;
      }

      error!(S.of(context).couponInvalid);
    } on Exception catch (e, trace) {
      printLog('::::::::::::::::::: applyCoupon error ::::::::::::::::::::::');
      printError(e, trace);
      error!(e.toString());
    }
  }

  @override
  Future<void> removeCoupon(context) async {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    final cartDataShopify = cartModel.cartDataShopify;
    if (cartDataShopify == null) return;
    try {
      final cartRemovedCoupon =
          await shopifyService.removeCouponWithCartId(cartDataShopify.id);

      printLog(
          '::::::::::::::::::: removeCoupon success ::::::::::::::::::::::');
      printLog('Cart ID: ${cartRemovedCoupon?.id} removed coupon');
      cartModel.setCartDataShopify(cartRemovedCoupon);
    } catch (e, trace) {
      printLog('::::::::::::::::::: removeCoupon error ::::::::::::::::::::::');
      printError(e, trace);
    }
  }

  @override
  Map<dynamic, dynamic> getPaymentUrl(context) {
    return {
      'headers': {},
      'url': Provider.of<CartModel>(context, listen: false)
          .cartDataShopify
          ?.checkoutUrl
    };
  }

  @override
  Future<void> doCheckout(
    context, {
    Function? success,
    Function? loading,
    Function? error,
  }) async {
    final cartModel =
        Provider.of<CartModel>(context, listen: false) as CartModelShopify;

    final currentCart = cartModel.cartDataShopify;
    final discountCodeApplied = currentCart?.discountCodeApplied;

    try {
      final cartDataShopify =
          await shopifyService.createCart(cartModel: cartModel);
      if (cartDataShopify == null) {
        error!('Cannot create cart right now. Please try again later.');
        return;
      }

      if (discountCodeApplied != null) {
        final cartAppliedCoupon = await shopifyService.applyCouponWithCartId(
          cartId: cartDataShopify.id,
          discountCode: discountCodeApplied,
        );
        cartModel.setCartDataShopify(cartAppliedCoupon);
      } else {
        // Use new cart
        cartModel.setCartDataShopify(cartDataShopify);
      }

      if (kPaymentConfig.enableWebviewCheckout) {
        /// Navigate to Webview payment

        String? orderNum;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebview(
              url: cartDataShopify.checkoutUrl,
              token: cartModel.user?.cookie,
              onFinish: (number) async {
                orderNum = number;
              },
            ),
          ),
        );
        if (orderNum != null && !kIsWeb) {
          loading!(true);
          unawaited(cartModel.clearCart());
          Analytics.triggerPurchased(
              Order(
                number: orderNum,
                total: cartDataShopify.cost.totalAmount(),
                id: '',
              ),
              context);
          final user = cartModel.user;
          if (user != null && (user.cookie?.isNotEmpty ?? false)) {
            final order =
                await shopifyService.getLatestOrder(cookie: user.cookie ?? '');
            if (order != null) {
              orderNum = order.number;
            }
          }
          if (kPaymentConfig.showNativeCheckoutSuccessScreenForWebview) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebviewCheckoutSuccessScreen(
                  order: Order(number: orderNum),
                ),
              ),
            );
          }
        }
        loading!(false);
        return;
      }
      success!();
    } catch (e, trace) {
      printError(e, trace);
      error!(e.toString());
    }
  }

  @override
  void placeOrder(
    context, {
    required CartModel cartModel,
    PaymentMethod? paymentMethod,
    Function? onLoading,
    Function? success,
    Function? error,
  }) async {
    {
      final cartDataShopify = cartModel.cartDataShopify;
      final cartId = cartDataShopify?.id;
      if (cartId == null) {
        error!('Cart is empty');
        return;
      }
      final deliveryDate = cartModel.selectedDate?.dateTime;
      if (deliveryDate != null) {
        await shopifyService.updateCartAttributes(
          cartId: cartModel.cartDataShopify!.id,
          deliveryDate: deliveryDate,
        );
      }

      final note = cartModel.notes;
      if (note != null) {
        await shopifyService.updateCartNote(
          cartId: cartId,
          note: note,
        );
      }

      // final shopifyCheckout = ShopifyCheckoutSheetKit();
      // shopifyCheckout.setCheckoutCallback(
      //   onCancel: () {
      //     error!('Payment cancelled');
      //     return;
      //   },
      //   onFail: (err) {
      //     error!(err.message);
      //   },
      //   onComplete: (orderCompletedEvent) async {
      //     if (!cartModel.user!.isGuest) {
      //       final order = await shopifyService.getLatestOrder(
      //           cookie: cartModel.user?.cookie ?? '');
      //       if (order == null) return error!('Checkout failed');
      //       success!(order);
      //       return;
      //     }
      //     success!(Order());
      //     return;
      //   },
      // );
      // shopifyCheckout.showCheckoutSheet(
      //     checkoutUrl: cartModel.cartDataShopify!.checkoutUrl);
      // onLoading!(false);
      // return;

      String? orderNum;
      final user = cartModel.user;
      await FluxNavigate.push(
        MaterialPageRoute(
          builder: (context) => PaymentWebview(
            token: user?.cookie,
            url: cartModel.cartDataShopify!.checkoutUrl,
            onFinish: (number) async {
              // Success
              orderNum = number;
              if (number == '0') {
                if (user != null && (user.cookie?.isNotEmpty ?? false)) {
                  /// Delay to await actually order create
                  await Future.delayed(const Duration(seconds: 1));
                  final order = await shopifyService.getLatestOrder(
                      cookie: user.cookie ?? '');
                  if (order == null) return error!('Checkout failed');
                  Analytics.triggerPurchased(
                      Order(
                        number: orderNum,
                        total: cartModel
                                .cartDataShopify?.cost.totalAmount.amount ??
                            0,
                        id: '',
                      ),
                      context);
                  success!(order);
                  return;
                }
                success!(Order());
                return;
              }
            },
            onClose: () {
              // Check in case the payment is successful but the webview is still displayed, need to press the close button
              if (orderNum != '0') {
                error!('Payment cancelled');
                return;
              }
            },
          ),
        ),
        forceRootNavigator: true,
        context: context,
      );
      onLoading!(false);
    }
  }

  @override
  Future<bool> updateCartBuyerIdentity({
    required CartModel cartModel,
    required Address? address,
  }) async {
    final email = address?.email;
    // String? customerAccessToken;

    // Try to get token from Customer Account API if available

    final cartDataShopify = await shopifyService.updateCartBuyerIdentity(
      cartId: cartModel.getCartId(),
      buyerIdentity: {
        'email': email,
        'deliveryAddressPreferences': [
          {
            'deliveryAddress': address?.toShopifyJson(),
          }
        ]
      },
    );
    if (cartDataShopify == null) {
      return false;
    }
    cartModel.setCartDataShopify(cartDataShopify);
    return true;
  }

  @override
  String calculateOrderSubtotal({
    required Order order,
    Map<String, dynamic>? currencyRate,
    String? currencyCode,
  }) {
    return PriceTools.getCurrencyFormatted(order.subtotal, currencyRate,
        currency: currencyCode)!;
  }
}
