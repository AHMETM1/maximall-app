import '../index.dart';

class LoyaltyRedemption {
  final String docId;
  final String userId;
  final LoyaltyCoupon? coupon;
  final String redemptionCode;
  final DateTime? createdAt;
  final bool isUsed;

  LoyaltyRedemption(
      {required this.docId,
      required this.userId,
      this.coupon,
      required this.redemptionCode,
      this.createdAt,
      this.isUsed = false});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'coupon': coupon?.toRedemptionMap(),
      'redemption_code': redemptionCode,
      'is_used': isUsed,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  factory LoyaltyRedemption.fromMap(Map<String, dynamic> map, String docId) {
    final createdAtIsTimestamp =
        map['created_at'].runtimeType.toString() == 'Timestamp';
    return LoyaltyRedemption(
      docId: docId,
      userId: map['user_id'],
      coupon: map['coupon'] != null
          ? LoyaltyCoupon.fromMap(map['coupon'], map['coupon']['coupon_id'])
          : null,
      redemptionCode: map['redemption_code'],
      createdAt: map['created_at'] != null
          ? createdAtIsTimestamp
              ? map['created_at'].toDate()
              : null
          : null,
      isUsed: map['is_used'] == true,
    );
  }
}
