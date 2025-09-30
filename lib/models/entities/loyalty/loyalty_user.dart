import '../user.dart';
import 'member_type_enum.dart';

class LoyaltyUser {
  final String userId;
  final String name;
  final String? email;
  final String? avatar;
  final int points;
  final int totalPoints;
  final MemberType type;

  const LoyaltyUser({
    required this.userId,
    this.name = '',
    this.email,
    this.avatar,
    this.points = 0,
    this.totalPoints = 0,
    this.type = MemberType.bronze,
  });

  LoyaltyUser copyWith({
    String? userId,
    String? name,
    String? email,
    String? avatar,
    int? points,
    int? totalPoints,
    MemberType? type,
  }) {
    return LoyaltyUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      points: points ?? this.points,
      totalPoints: totalPoints ?? this.totalPoints,
      type: type ?? this.type,
    );
  }

  factory LoyaltyUser.fromUser(User user) {
    return LoyaltyUser(
      userId: user.id ?? '',
      name: user.name ?? '',
      email: user.email,
      avatar: user.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'avatar': avatar,
      'points': points,
      'total_points': totalPoints,
      'type': type.rawValue,
    };
  }

  factory LoyaltyUser.fromMap(Map map) {
    return LoyaltyUser(
      userId: map['user_id'],
      name: map['name'] ?? '',
      email: map['email'],
      avatar: map['avatar'],
      points: map['points'] ?? 0,
      totalPoints: map['total_points'] ?? 0,
      type: MemberTypeX.initFrom(map['type']) ?? MemberType.bronze,
    );
  }
}
