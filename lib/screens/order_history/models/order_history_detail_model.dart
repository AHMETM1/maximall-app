import 'package:flutter/cupertino.dart';

import '../../../data/boxes.dart';
import '../../../models/entities/index.dart';
import '../../../modules/analytics/analytics.dart';
import '../../../services/index.dart';

class OrderHistoryDetailModel extends ChangeNotifier {
  Order _order;
  List<OrderNote>? _listOrderNote;
  bool _orderNoteLoading = false;
  bool _orderLoading = false;

  final User user;
  final _services = Services();

  Order get order => _order;

  List<OrderNote>? get listOrderNote => _listOrderNote;
  bool get orderNoteLoading => _orderNoteLoading;
  bool get orderLoading => _orderLoading;

  OrderHistoryDetailModel({
    required Order order,
    required this.user,
  }) : _order = order {
    _fetchImageOfOrder();
  }

  Future<void> _fetchImageOfOrder() async {
    await _fetchProductItems();
    await _fetchImage();
  }

  Future<void> _fetchProductItems() async {
    final listProductItem =
        await _services.api.getListProductItemByOrderId(order.id ?? '');
    if (listProductItem.isNotEmpty) {
      _order.lineItems = listProductItem;
      notifyListeners();
    }
  }

  Future<void> _fetchImage() async {
    if (_order.lineItems.isNotEmpty) {
      final firstProduct = _order.lineItems.first;
      if (firstProduct.featuredImage?.isEmpty ?? true) {
        final listImage =
            await _services.api.getImagesByProductId(firstProduct.productId!);
        if (listImage.isNotEmpty) {
          firstProduct.featuredImage = listImage.first;
        }
      }
      notifyListeners();
    }
  }

  Future<void> cancelOrder() async {
    if (order.status!.isCancelled) return;

    _orderLoading = true;
    notifyListeners();

    final newOrder = await _services.api.cancelOrder(
      order: order,
      userCookie: user.cookie,
    );

    // update local orders for guest
    if (newOrder != null && user.cookie == null) {
      var items = UserBox().orders;
      var list = <Map>[];
      if (items.isNotEmpty) {
        for (var item in items) {
          if (item['id'] == newOrder.id) {
            item['status'] = newOrder.status?.content;
          }
          list.add(item);
        }
      }
      UserBox().orders = list;
    }

    if (newOrder != null) {
      newOrder.lineItems = order.lineItems;
      _order = newOrder;
      await _fetchImageOfOrder();
    }

    _orderLoading = false;
    notifyListeners();
  }

  Future<void> createRefund() async {
    if (order.status == OrderStatus.refunded) return;

    _orderLoading = true;
    notifyListeners();

    final newOrder = await _services.api.updateOrder(
      order.id,
      status: 'refund-req',
      token: user.cookie,
    );

    if (newOrder != null) {
      _order = newOrder;
      Analytics.triggerCreateRefund(_order);
    }

    _orderLoading = false;
    notifyListeners();
  }

  void getOrderNote() async {
    _orderNoteLoading = true;
    notifyListeners();

    _listOrderNote = await _services.api.getOrderNote(
      userId: user.id,
      orderId: order.id,
    );

    _orderNoteLoading = false;
    notifyListeners();
  }
}
