import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flux_localization/flux_localization.dart';

enum MemberType {
  bronze,
  silver,
  gold,
  platinum,
}

extension MemberTypeX on MemberType {
  String get displayName {
    switch (this) {
      case MemberType.bronze:
        return S.current.bronzePriority;
      case MemberType.silver:
        return S.current.silverPriority;
      case MemberType.gold:
        return S.current.goldPriority;
      case MemberType.platinum:
        return S.current.platinumPriority;
    }
  }

  String get name {
    switch (this) {
      case MemberType.bronze:
        return S.current.bronze;
      case MemberType.silver:
        return S.current.silver;
      case MemberType.gold:
        return S.current.gold;
      case MemberType.platinum:
        return S.current.platinum;
    }
  }

  String get rawValue {
    switch (this) {
      case MemberType.bronze:
        return 'bronze';
      case MemberType.silver:
        return 'silver';
      case MemberType.gold:
        return 'gold';
      case MemberType.platinum:
        return 'platinum';
    }
  }

  Color get bgColor {
    switch (this) {
      case MemberType.bronze:
        return const Color(0xFFFFEAD5);
      case MemberType.silver:
        return const Color(0xFFF2F4F7);
      case MemberType.gold:
        return const Color(0xFFFEF0C7);
      case MemberType.platinum:
        return const Color(0xFF1D2939);
    }
  }

  Color get color {
    switch (this) {
      case MemberType.bronze:
        return const Color(0xFFFEB273);
      case MemberType.silver:
        return const Color(0xFFD0D5DD);
      case MemberType.gold:
        return const Color(0xFFFEC84B);
      case MemberType.platinum:
        return const Color(0xFF667085);
    }
  }

  String get icon {
    switch (this) {
      case MemberType.bronze:
        return 'assets/icons/loyalty/ic_bronze.svg';
      case MemberType.silver:
        return 'assets/icons/loyalty/ic_silver.svg';
      case MemberType.gold:
        return 'assets/icons/loyalty/ic_gold.svg';
      case MemberType.platinum:
        return 'assets/icons/loyalty/ic_platinum.svg';
    }
  }

  String get bgImage {
    switch (this) {
      case MemberType.bronze:
        return 'assets/icons/loyalty/bg_bronze.png';
      case MemberType.silver:
        return 'assets/icons/loyalty/bg_silver.png';
      case MemberType.gold:
        return 'assets/icons/loyalty/bg_gold.png';
      case MemberType.platinum:
        return 'assets/icons/loyalty/bg_platinum.png';
    }
  }

  static MemberType? initFrom(String? value) {
    return MemberType.values.firstWhereOrNull(
        (MemberType e) => e.rawValue.toLowerCase() == value?.toLowerCase());
  }
}
