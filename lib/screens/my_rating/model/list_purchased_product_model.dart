import 'dart:async';

import '../../../common/constants.dart';
import '../../../models/entities/index.dart' show User;
import '../../../models/entities/paging_response.dart';
import '../../../models/entities/purchased_product.dart';
import '../../../models/paging_data_model.dart';

class ListPurchasedProductModel extends PagingDataModel<PurchasedProduct> {
  final User _user;
  late final StreamSubscription _submitReviewSuccessSubscription;

  ListPurchasedProductModel({
    required User? user,
  }) : _user = user ?? User() {
    _submitReviewSuccessSubscription =
        eventBus.on<EventSubmitReviewSuccess>().listen((event) {
      refresh();
    });

    getData();
  }

  @override
  Future<PagingResponse<PurchasedProduct>> Function(dynamic cursor)
      get requestApi => (cursor) => api.getListPurchasedProduct(
            userCookie: _user.cookie ?? '',
            page: cursor,
            perPage: 10,
          );

  @override
  void dispose() {
    _submitReviewSuccessSubscription.cancel();
    super.dispose();
  }
}
