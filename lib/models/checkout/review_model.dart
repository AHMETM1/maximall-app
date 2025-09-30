import 'package:flutter/material.dart';
import 'package:inspireui/utils/logs.dart';

import '../../common/error_codes/error_codes.dart';
import '../../common/tools/retry_manager.dart';
import '../../services/index.dart';
import '../cart/cart_model.dart';
import '../entities/index.dart';
import '../mixins/app_status_mixin.dart';

class ReviewModel extends ChangeNotifier with AppStatusMixin {
  final services = Services().api;

  /// Initialize the model and prepare cart for completion
  Future<void> init({
    required CartModel cartModel,
  }) async {
    final cartDataShopify = cartModel.cartDataShopify;
    if (cartDataShopify == null) {
      emitError(errorType: ErrorType.cartNotAvailable);
      return;
    }

    await prepareCartForCompletion(cartDataShopify.id, cartModel);
  }

  /// Call prepareCartForCompletion API to check if cart is ready for checkout
  Future<void> prepareCartForCompletion(
    String cartId,
    CartModel cartModel,
  ) async {
    try {
      startLoading();

      final retryManager = RetryManager<CartDataShopify>(
        action: () async {
          final result = await services.prepareCartForCompletion(
            cartId: cartId,
          );
          if (result == null) {
            return RetryResult.failure(
                'Cart is empty for now. Please add some items to your cart.');
          }
          if (result.status.isNotReady) {
            return RetryResult.failure('Cart is not ready for checkout');
          }
          if (result.status.isThrottled) {
            return RetryResult.failure(
                'System is busy, we are trying again...');
          }
          return RetryResult.success(result);
        },
        onRetryAttempt: (status) {
          printLog(
              'Retry attempt ${status.currentAttempt}/${status.maxAttempts}');
          emitWarning(data: status.errorMessage);
        },
        onRetryComplete: (status) {
          if (status.isSuccess) {
            final result = status.result;
            cartModel.setCartDataShopify(result);
            emitSuccess();
            stopLoading();
            return;
          }
          emitError(
            errorType: ErrorType.cartNotReadyForCheckout,
            data: status.errorMessage,
          );
          stopLoading();
        },
        maxRetries: 3,
      );

      await retryManager.start();
    } catch (e) {
      emitError(errorType: ErrorType.generalError, data: e.toString());
    } finally {
      stopLoading();
    }
  }
}
