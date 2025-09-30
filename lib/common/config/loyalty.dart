part of '../config.dart';

LoyaltyConfig get kLoyaltyConfig =>
    LoyaltyConfig.fromJson(Configurations.loyaltyConfig);

MemberType getMemberTypeByPoints(int points) {
  var type = [
    MemberType.platinum,
    MemberType.gold,
    MemberType.silver,
    MemberType.bronze
  ].firstWhereOrNull((type) =>
      kLoyaltyConfig.levels[type.rawValue] != null &&
      points >= kLoyaltyConfig.levels[type.rawValue]!);
  return type ?? MemberType.bronze;
}
