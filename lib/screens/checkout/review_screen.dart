import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/flash.dart';
import '../../common/tools/loading_helper.dart';
import '../../models/checkout/review_model.dart';
import '../../models/entities/address.dart';
import '../../models/index.dart' show CartModel, Product, TaxModel, UserModel;
import '../../models/mixins/app_status.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../services/index.dart';
import '../../widgets/common/expansion_info.dart';
import '../../widgets/product/cart_item/cart_item.dart';
import '../../widgets/product/cart_item/cart_item_state_ui.dart';
import '../base_screen.dart';
import '../cart/widgets/list_cart_items.dart';
import '../cart/widgets/shopping_cart_sumary.dart';
import 'widgets/checkout_action.dart';
import 'widgets/choose_address_item_widget.dart';
import 'widgets/price_row_item.dart';

class ReviewScreen extends StatefulWidget {
  final Function? onBack;
  final Function? onNext;

  const ReviewScreen({this.onBack, this.onNext});

  @override
  BaseScreen<ReviewScreen> createState() => _ReviewState();
}

class _ReviewState extends BaseScreen<ReviewScreen> {
  TextEditingController note = TextEditingController();
  bool enabledShipping = kPaymentConfig.enableShipping;

  ReviewModel get reviewModel =>
      Provider.of<ReviewModel>(context, listen: false);
  StreamSubscription<AppStatus>? _statusSubscription;
  StreamSubscription<AppStatus>? _loadingSubscription;
  StreamSubscription<AppStatus>? _successSubscription;

  CartModel get cartModel => context.read<CartModel>();

  TaxModel get taxModel => context.read<TaxModel>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    var notes = Provider.of<CartModel>(context, listen: false).notes;
    note.text = notes ?? '';

    Future.delayed(Duration.zero, () {
      final cartModel = Provider.of<CartModel>(context, listen: false);
      setState(() {
        enabledShipping = cartModel.isEnabledShipping();
      });
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _fetchTaxes();
    if (ServerConfig().isShopify &&
        kShopifyPaymentConfig.applePayConfig.enable) {
      _prepareCartForCompletion();
    }
  }

  void _prepareCartForCompletion() {
    _statusSubscription = reviewModel.addStatusListener((status) {
      final message = status.errorType?.getMessage(context);
      if (message == null) {
        return;
      }
      if (status.isError) {
        FlashHelper.errorMessage(
          context,
          message: message,
        );
        return;
      }
      if (status.isWarning) {
        FlashHelper.informationBar(
          context,
          message: message,
        );
        return;
      }
      if (status.isSuccess) {
        FlashHelper.message(context, message: message);
        return;
      }
    });
    _loadingSubscription = reviewModel.addStatusListener((status) {
      if (status.isLoading) {
        LoadingHelper.show();
      }
      if (status.isError || status.isSuccess) {
        LoadingHelper.hide();
      }
    });
    _successSubscription = reviewModel.addSuccessListener((success) {
      _fetchTaxes();
    });
    reviewModel.init(cartModel: cartModel);
  }

  void _fetchTaxes() {
    Provider.of<TaxModel>(context, listen: false).getTaxes(
      Provider.of<CartModel>(context, listen: false),
      Provider.of<UserModel>(context, listen: false).user?.cookie,
      (taxesTotal, taxes, isIncludingTax) {
        Provider.of<CartModel>(context, listen: false)
            .setTaxInfo(taxes, taxesTotal, isIncludingTax);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    _loadingSubscription?.cancel();
    _successSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Layout.isDisplayDesktop(context);

    return isDesktop ? _buildDesktopLayout() : _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: S.of(context).address,
          top: 20,
          bottom: 20,
        ),
        const ShippingAddressInfo(useDesktopStyle: true),
        _SectionTitle(
          title: S.of(context).shippingMethod,
          top: 20,
          bottom: 20,
        ),
        Services()
            .widget
            .renderShippingMethodInfo(context, useDesktopStyle: true),
        _SectionTitle(
          title: S.of(context).productOverview,
          top: 20,
          bottom: 20,
        ),
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: const ListCartBodyWidget(
            enabledTextBoxQuantity: false,
            enable: false,
            cartStyle: CartStyle.web,
          ),
        ),
        if (enabledShipping || kPaymentConfig.enableAddress) ...[
          const SizedBox(height: 50),
          _BackButton(onPressed: () => widget.onBack?.call()),
        ],
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Consumer<CartModel>(
              builder: (context, model, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _ShippingAddressSection(
                        enabledShipping: enabledShipping,
                      ),
                      Container(
                        height: 1,
                        decoration: const BoxDecoration(color: kGrey200),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(S.of(context).orderDetail,
                            style: const TextStyle(fontSize: 18)),
                      ),
                      ..._buildProductsList(model),
                      const _OrderSummary(),
                      if (kEnableCustomerNote)
                        _CustomerNoteSection(
                          noteController: note,
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        _BottomActions(
          enabledShipping: enabledShipping,
          note: note,
          onNext: () => widget.onNext?.call(),
          onBack: () {
            /// Need to reload shipping method when back to shipping method screen
            if (context.mounted) {
              Services().widget.loadShippingMethods(context, cartModel, true);
            }
            widget.onBack?.call();
          },
        ),
      ],
    );
  }

  List<Widget> _buildProductsList(CartModel model) {
    return model.productsInCart.keys.map(
      (key) {
        var productId = Product.cleanProductID(key);

        return ShoppingCartRow(
          cartItemMetaData: model.cartItemMetaDataInCart[key]
              ?.copyWith(variation: model.getProductVariationById(key)),
          product: model.getProductById(productId),
          quantity: model.productsInCart[key],
        );
      },
    ).toList();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final double top;
  final double bottom;

  const _SectionTitle({
    required this.title,
    this.top = 0,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, top: top),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          height: 28 / 18,
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _BackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          S.of(context).goBack.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class _ShippingAddressSection extends StatelessWidget {
  final bool enabledShipping;

  const _ShippingAddressSection({required this.enabledShipping});

  @override
  Widget build(BuildContext context) {
    return enabledShipping
        ? ExpansionInfo(
            title: S.of(context).shippingAddress,
            children: const <Widget>[
              ShippingAddressInfo(),
            ],
          )
        : const SizedBox();
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary();

  @override
  Widget build(BuildContext context) {
    final taxModel = Provider.of<TaxModel>(context);
    final cartModel = Provider.of<CartModel>(context);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: ShoppingCartSummary(
            showPrice: false,
            showRecurringTotals: false,
          ),
        ),
        const SizedBox(height: 20),
        PriceRowItemWidget(
          title: S.of(context).subtotal,
          total: cartModel.getSubTotal(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        Services().widget.renderShippingMethodInfo(context),
        _CouponInfo(coupon: cartModel.getCoupon()),
        Services().widget.renderTaxes(taxModel, context),
        Services().widget.renderRewardInfo(context),
        PriceRowItemWidget(
          title: S.of(context).total,
          total: cartModel.getTotal(),
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
        ),
        Services().widget.renderRecurringTotals(context),
      ],
    );
  }
}

class _CouponInfo extends StatelessWidget {
  final String coupon;

  const _CouponInfo({required this.coupon});

  @override
  Widget build(BuildContext context) {
    if (coupon.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            S.of(context).discount,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          Text(
            coupon,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
          )
        ],
      ),
    );
  }
}

class _CustomerNoteSection extends StatelessWidget {
  final TextEditingController noteController;

  const _CustomerNoteSection({
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          S.of(context).yourNote,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.2,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            maxLines: 5,
            controller: noteController,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: S.of(context).writeYourNote,
              hintStyle: const TextStyle(fontSize: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final bool enabledShipping;
  final TextEditingController note;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const _BottomActions({
    required this.enabledShipping,
    required this.note,
    this.onNext,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context, listen: false);

    return CheckoutActionWidget(
      iconPrimary: CupertinoIcons.creditcard,
      labelPrimary: S.of(context).continueToPayment,
      showSecondary: enabledShipping || kPaymentConfig.enableAddress,
      onTapPrimary: cartModel.enableCheckoutButton == false
          ? null
          : () => {
                onNext?.call(),
                if (note.text.isNotEmpty) cartModel.setOrderNotes(note.text)
              },
      labelSecondary: S.of(context).goBack,
      onTapSecondary: onBack,
    );
  }
}

class ShippingAddressInfo extends StatelessWidget {
  final bool useDesktopStyle;
  final void Function(Address)? onEdit;

  const ShippingAddressInfo({
    super.key,
    this.useDesktopStyle = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final address = cartModel.address!;

    if (useDesktopStyle) {
      return ChooseAddressItemWidget(address: address);
    }

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        children: <Widget>[
          _AddressFields(address: address),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AddressFields extends StatelessWidget {
  final Address address;

  const _AddressFields({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (address.firstName?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).firstName,
            value: address.firstName!,
          ),
        if (address.lastName?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).lastName,
            value: address.lastName!,
          ),
        if (address.phoneNumber?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).phoneNumber,
            value: address.phoneNumber!,
          ),
        if (address.email?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).email,
            value: address.email!,
          ),
        if (address.country?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).country,
            value: address.country!,
          ),
        if (address.state?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).stateProvince,
            value: address.state!,
          ),
        if (address.city?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).city,
            value: address.city!,
          ),
        if (address.apartment?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).streetNameApartment,
            value: address.apartment!,
          ),
        if (address.block?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).streetNameBlock,
            value: address.block!,
          ),
        if (address.street?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).street,
            value: address.street!,
          ),
        if (address.zipCode?.isNotEmpty ?? false)
          _ItemInfoCheckout(
            title: S.of(context).zipCode,
            value: address.zipCode!,
          ),
      ],
    );
  }
}

class _ItemInfoCheckout extends StatelessWidget {
  final String title;
  final String value;

  const _ItemInfoCheckout({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              '$title :',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
