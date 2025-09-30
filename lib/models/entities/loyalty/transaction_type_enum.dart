import 'package:collection/collection.dart';
import 'package:flux_localization/flux_localization.dart';

enum TransactionType {
  add,
  redeem,
}

extension TransactionTypeX on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.add:
        return S.current.add;
      case TransactionType.redeem:
        return S.current.redeem;
    }
  }

  String get rawValue {
    switch (this) {
      case TransactionType.add:
        return 'add';
      case TransactionType.redeem:
        return 'redeem';
    }
  }

  static TransactionType? initFrom(String? value) {
    return TransactionType.values.firstWhereOrNull((TransactionType e) =>
        e.rawValue.toLowerCase() == value?.toLowerCase());
  }
}
