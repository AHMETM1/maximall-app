import 'transaction_type_enum.dart';

class LoyaltyTransaction {
  final String docId;
  final String userId;
  final int points;
  final TransactionType type;
  final DateTime? createdAt;
  final String? note;

  LoyaltyTransaction({
    required this.docId,
    required this.userId,
    required this.points,
    required this.type,
    this.createdAt,
    this.note,
  });

  String get title =>
      type == TransactionType.add ? 'QR - Add points' : 'QR - Redeem points';

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'points': points,
      'type': type.rawValue,
      'created_at': DateTime.now().toIso8601String(),
      'note': note
    };
  }

  factory LoyaltyTransaction.fromMap(Map<String, dynamic> map, String docId) {
    final createdAtIsTimestamp =
        map['created_at'].runtimeType.toString() == 'Timestamp';
    return LoyaltyTransaction(
      docId: docId,
      userId: map['user_id'],
      points: map['points'] ?? 0,
      type: TransactionTypeX.initFrom(map['type']) ?? TransactionType.add,
      createdAt: map['created_at'] != null
          ? createdAtIsTimestamp
              ? map['created_at'].toDate()
              : DateTime.tryParse(map['created_at'])
          : null,
      note: map['note'],
    );
  }
}
