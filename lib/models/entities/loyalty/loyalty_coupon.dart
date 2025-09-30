import 'member_type_enum.dart';

class LoyaltyCoupon {
  final String docId;
  final String name;
  final double? value;
  final double? minTotal;
  final List<MemberType>? tierRestrictions;
  final DateTime? expiredAt;
  final List<String> claimedUsers;

  const LoyaltyCoupon({
    required this.docId,
    this.name = '',
    this.value,
    this.minTotal,
    this.tierRestrictions,
    this.expiredAt,
    this.claimedUsers = const [],
  });

  LoyaltyCoupon copyWith({List<String>? claimedUsers}) {
    return LoyaltyCoupon(
      docId: docId,
      name: name,
      value: value,
      minTotal: minTotal,
      tierRestrictions: tierRestrictions,
      expiredAt: expiredAt,
      claimedUsers: claimedUsers ?? this.claimedUsers,
    );
  }

  factory LoyaltyCoupon.fromMap(Map<String, dynamic> map, String docId) {
    List<MemberType>? list;
    if (map['tier_restrictions'] != null && map['tier_restrictions'] is List) {
      list = List.from(map['tier_restrictions'])
          .map((item) => MemberTypeX.initFrom(item) ?? MemberType.bronze)
          .toList();
    }

    final expiredAtIsTimestamp =
        map['expired_at'].runtimeType.toString() == 'Timestamp';

    return LoyaltyCoupon(
      docId: docId,
      name: map['name'],
      minTotal:
          map['min_total'] != null ? double.parse("${map['min_total']}") : null,
      value: double.parse("${map['value']}"),
      tierRestrictions: list,
      expiredAt: map['expired_at'] != null
          ? map['expired_at'] is String
              ? DateTime.tryParse(map['expired_at'])
              : expiredAtIsTimestamp
                  ? map['expired_at'].toDate()
                  : null
          : null,
      claimedUsers: map['claimed_users'] != null
          ? List<String>.from(map['claimed_users'])
          : [],
    );
  }

  Map<String, dynamic> toRedemptionMap() {
    return {
      'coupon_id': docId,
      'name': name,
      'value': value,
      'min_total': minTotal,
      'expired_at': expiredAt?.toIso8601String(),
      'claimed_users': claimedUsers
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'min_total': minTotal,
      'expired_at': expiredAt?.toIso8601String(),
      'tier_restrictions': tierRestrictions?.map((e) => e.rawValue).toList()
    };
  }
}
