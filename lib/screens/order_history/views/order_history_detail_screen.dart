import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../../models/index.dart' show AppModel, OrderStatus, UserModel;
import '../../../services/index.dart';
import '../../../widgets/common/loading_body.dart';
import '../../base_screen.dart';
import '../../checkout/widgets/success.dart';
import '../models/order_history_detail_model.dart';
import 'widgets/order_notes.dart';
import 'widgets/order_total.dart';
import 'widgets/order_tracking.dart';
import 'widgets/product_order.dart';

class OrderDetailArguments {
  OrderHistoryDetailModel model;
  bool disableReview;

  OrderDetailArguments({
    required this.model,
    this.disableReview = false,
  });
}

class OrderHistoryDetailScreen extends StatefulWidget {
  final bool enableReorder;
  final bool disableReview;

  const OrderHistoryDetailScreen({
    this.enableReorder = true,
    this.disableReview = false,
  });

  @override
  BaseScreen<OrderHistoryDetailScreen> createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState
    extends BaseScreen<OrderHistoryDetailScreen> {
  OrderHistoryDetailModel get orderHistoryModel =>
      Provider.of<OrderHistoryDetailModel>(context, listen: false);

  @override
  void afterFirstLayout(BuildContext context) {
    super.afterFirstLayout(context);
    orderHistoryModel.getOrderNote();
  }

  void _cancelOrder() async {
    final confirmed = await context.showFluxDialogConfirm(
      title: S.of(context).cancelOrder,
      body: S.of(context).areYouSureCancelOrder,
      primaryAsDestructiveAction: true,
    );
    if (confirmed) {
      try {
        await orderHistoryModel.cancelOrder();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).cancelOrderSuccess)),
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).cancelOrderFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderHistoryDetailModel>(builder: (context, model, child) {
      final order = model.order;
      final currencyCode =
          order.currencyCode ?? Provider.of<AppModel>(context).currencyCode!;
      final currencyRate = (order.currencyCode?.isEmpty ?? true)
          ? Provider.of<AppModel>(context).currencyRate
          : null;
      final loggedIn = Provider.of<UserModel>(context).loggedIn;

      final isPending = [
            OrderStatus.refunded,
            OrderStatus.canceled,
            OrderStatus.completed
          ].contains(order.status) ==
          false;

      final allowCancelAndRefund =
          kPaymentConfig.paymentListAllowsCancelAndRefund.isEmpty ||
              kPaymentConfig.paymentListAllowsCancelAndRefund
                  .contains(order.paymentMethod);

      final isCompositeCart = order.lineItems.firstWhereOrNull(
              (e) => e.product?.isCompositeProduct ?? false) !=
          null;

      return LoadingBody(
        isLoading: model.orderLoading,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            actions: [
              if (kOrderConfig.enableReorder &&
                  ServerConfig().isSupportReorder &&
                  loggedIn &&
                  !isCompositeCart)
                Center(child: Services().widget.reOrderButton(order)),
            ],
            title: Text(
              '${S.of(context).orderNo} #${order.number}',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  // separatorBuilder: (context, index) => Container(
                  //   height: 1,
                  //   margin: const EdgeInsets.symmetric(horizontal: 2).copyWith(bottom: 2),
                  //   color: Theme.of(context).dividerColor,
                  // ),
                  itemCount: order.lineItems.length,
                  itemBuilder: (context, index) {
                    final item = order.lineItems[index];
                    return ProductOrder(
                      orderId: order.id!,
                      orderStatus: order.status!,
                      product: item,
                      index: index,
                      storeDeliveryDates: order.storeDeliveryDates,
                      currencyCode: currencyCode,
                      disableReview: widget.disableReview,
                    );
                  },
                ),
                OrderTotal(order: order),

                if (order.smartCodIsRfOrder == true)
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[
                        _CustomListTile(
                          leading: S.of(context).advanceAmount,
                          trailing: PriceTools.getCurrencyFormatted(
                              order.orderSmartCod?.advanceAmount, currencyRate,
                              currency: currencyCode)!,
                        ),
                        const SizedBox(height: 10),
                        _CustomListTile(
                          leading: S.of(context).remainingAmountCod,
                          trailing: PriceTools.getCurrencyFormatted(
                              order.orderSmartCod?.remainingAmount,
                              currencyRate,
                              currency: currencyCode)!,
                        ),
                        const SizedBox(height: 10),
                        _CustomListTile(
                          leading: S.of(context).totalAmount,
                          trailing: PriceTools.getCurrencyFormatted(
                              order.orderSmartCod?.realTotal, currencyRate,
                              currency: currencyCode)!,
                        ),
                      ],
                    ),
                  ),

                OrderTracking(
                  order: order,
                ),

                Services().widget.renderOrderTimelineTracking(context, order),

                /// Render the Cancel and Refund
                if (kPaymentConfig.enableRefundCancel && allowCancelAndRefund)
                  Services().widget.renderButtons(
                      context, order, _cancelOrder, _refundOrder),

                if (isPending && kPaymentConfig.showTransactionDetails) ...[
                  if (order.bacsInfo.isNotEmpty &&
                      kBankTransferConfig
                          .getValueList('paymentMethodIds')
                          .contains(order.paymentMethod))
                    _OrderDetailSection(
                      title: S.of(context).ourBankDetails,
                      child: Column(
                        children: order.bacsInfo
                            .map((e) => BankAccountInfo(bankInfo: e))
                            .toList(),
                      ),
                    ),

                  /// Thai PromptPay
                  /// false: hide show Thank you message - https://tppr.me/xrNh1
                  Services()
                      .thaiPromptPayBuilder(showThankMsg: false, order: order),
                ],

                if (order.billing != null)
                  _OrderDetailSection(
                    title: S.of(context).billingAddress,
                    child: Text(order.billing!.fullInfoAddress),
                  ),

                if (order.shipping != null)
                  _OrderDetailSection(
                    title: S.of(context).shippingAddress,
                    child: Text(order.shipping!.fullInfoAddress),
                  ),

                if (kPaymentConfig.showOrderNotes)
                  OrderNotes(
                    isLoading: model.orderNoteLoading,
                    listOrderNote: model.listOrderNote,
                  ),

                const SizedBox(height: 50)
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _refundOrder() async {
    final confirmed = await context.showFluxDialogConfirm(
      title: S.of(context).refundRequest,
      body: S.of(context).areYouSureRefundOrder,
      primaryAsDestructiveAction: true,
    );
    if (confirmed) {
      try {
        await orderHistoryModel.createRefund();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).refundOrderSuccess)),
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).refundOrderFailed)),
        );
      }
    }
  }
}

class _OrderDetailSection extends StatelessWidget {
  const _OrderDetailSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child,
      ],
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
