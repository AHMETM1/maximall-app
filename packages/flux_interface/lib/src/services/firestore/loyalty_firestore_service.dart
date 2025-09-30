import 'package:fstore/models/entities/loyalty/transaction_type_enum.dart';
import 'package:fstore/models/index.dart';

class LoyaltyFirestoreService {
  Future<LoyaltyUser?> getLoyaltyUser(String userId) async {
    return null;
  }

  Future<void> addLoyaltyUser(LoyaltyUser loyaltyUser) async {}

  Future<void> addPoints(
      {required String userId,
      required int points,
      required String? note}) async {}

  Future<void> usePoints({
    required String userId,
    required int points,
    required String? note,
  }) async {}

  Future<List<LoyaltyTransaction>> getTransactionsByUserId(
      {required String userId, TransactionType? type, String? keyword}) async {
    return [];
  }

  Future<void> checkIndexesException(dynamic error,
      {Future<void> Function(String?)? openIndexUrl}) async {}

  Future<List<LoyaltyCoupon>> getCoupons(
      {required LoyaltyUser user, int? limit}) async {
    return [];
  }

  Future<List<LoyaltyCoupon>> getAllCoupons() async {
    return [];
  }

  Future<List<LoyaltyRedemption>> getRedemptions(LoyaltyUser user) async {
    return [];
  }

  Future<void> claimCoupon({
    required LoyaltyUser user,
    required LoyaltyCoupon coupon,
  }) async {}

  Future<void> onCheckoutSuccess({
    required String userId,
    required LoyaltyCoupon coupon,
  }) async {}

  Future<void> deleteCoupon(LoyaltyCoupon coupon) async {}

  Future<LoyaltyCoupon?> createCoupon(LoyaltyCoupon coupon) async {
    return null;
  }

  Future<LoyaltyCoupon?> updateCoupon(LoyaltyCoupon coupon) async {
    return null;
  }
}
