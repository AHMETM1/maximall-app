import 'package:collection/collection.dart';

import '../../entities/address.dart';

enum CartStatus {
  ready,
  notReady,
  throttled,
  ;

  bool get isReady => this == ready;

  bool get isNotReady => this == notReady;

  bool get isThrottled => this == throttled;

  factory CartStatus.fromString(String? json) {
    if (json == null) {
      return CartStatus.notReady;
    }

    return CartStatus.values.byName(json);
  }
}

class CartDataShopify {
  final String id;
  final List<CartLineItem> lineItems;
  final String checkoutUrl;
  final String? note;
  final Cost cost;
  final BuyerIdentity buyerIdentity;
  final List<DeliveryGroup> deliverGroups;
  final List<CartDiscountAllocation> discountAllocations;
  final List<DiscountCode> discountCodes;
  final CartStatus status;

  CartDataShopify({
    required this.id,
    required this.lineItems,
    required this.note,
    required this.checkoutUrl,
    required this.cost,
    required this.buyerIdentity,
    required this.deliverGroups,
    this.discountAllocations = const [],
    this.discountCodes = const [],
    this.status = CartStatus.notReady,
  });

  factory CartDataShopify.fromJson(Map json, [CartStatus? status]) {
    return CartDataShopify(
      id: json['id'],
      lineItems: List<CartLineItem>.from(
          destructNodes(json['lines']).map((x) => CartLineItem.fromJson(x))),
      note: json['note'],
      checkoutUrl: json['checkoutUrl'],
      cost: Cost.fromJson(json['cost']),
      buyerIdentity: BuyerIdentity.fromJson(json['buyerIdentity']),
      deliverGroups: List<DeliveryGroup>.from(
          destructNodes(json['deliveryGroups'])
              .map((x) => DeliveryGroup.fromJson(x))),
      discountCodes: List<DiscountCode>.from(
          List.from(json['discountCodes'] ?? [])
              .map((x) => DiscountCode.fromJson(x))),
      discountAllocations: List<CartDiscountAllocation>.from(
          List.from(json['discountAllocations'] ?? [])
              .map((x) => CartDiscountAllocation.fromJson(x))),
      status: CartStatus.fromString(json['status']),
    );
  }

  String? get discountCodeApplied {
    return discountCodes
        .firstWhereOrNull((element) => element.applicable)
        ?.code;
  }

  double get productDiscount {
    return lineItems.fold(0, (sum, item) => sum + item.totalDiscountAmount);
  }

  double get orderDiscount {
    return discountAllocations.fold(
        0, (sum, item) => sum + item.discountedAmount.amount);
  }

  double get totalDiscount => productDiscount + orderDiscount;

  CartDataShopify copyWith({
    CartStatus? status,
    List<CartLineItem>? lineItems,
    String? note,
    String? checkoutUrl,
    Cost? cost,
    BuyerIdentity? buyerIdentity,
    List<DeliveryGroup>? deliverGroups,
    List<CartDiscountAllocation>? discountAllocations,
    List<DiscountCode>? discountCodes,
  }) {
    return CartDataShopify(
      id: id,
      lineItems: lineItems ?? this.lineItems.toList(),
      note: note ?? this.note,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      cost: cost ?? this.cost,
      buyerIdentity: buyerIdentity ?? this.buyerIdentity,
      deliverGroups: deliverGroups ?? this.deliverGroups.toList(),
      discountAllocations:
          discountAllocations ?? this.discountAllocations.toList(),
      discountCodes: discountCodes ?? this.discountCodes.toList(),
      status: status ?? this.status,
    );
  }
}

class DiscountCode {
  final bool applicable;
  final String code;

  DiscountCode({required this.applicable, required this.code});

  factory DiscountCode.fromJson(Map json) {
    return DiscountCode(applicable: json['applicable'], code: json['code']);
  }
}

class CartDiscountAllocation {
  final Money discountedAmount;
  final DiscountApplication discountApplication;

  CartDiscountAllocation({
    required this.discountedAmount,
    required this.discountApplication,
  });

  factory CartDiscountAllocation.fromJson(Map json) {
    return CartDiscountAllocation(
      discountedAmount: Money.fromJson(json['discountedAmount']),
      discountApplication:
          DiscountApplication.fromJson(json['discountApplication']),
    );
  }
}

class DiscountApplication {
  final DiscountApplicationType type;
  final double value;
  final String? currencyCode;

  DiscountApplication({
    required this.type,
    required this.value,
    this.currencyCode,
  });

  factory DiscountApplication.fromJson(Map json) {
    final value = json['value'];
    final type = DiscountApplicationType.fromString(value['__typename']);
    if (type.isPercentage) {
      return DiscountApplication(
        type: type,
        value: value['percentage'],
      );
    }

    return DiscountApplication(
      type: type,
      value: num.tryParse(value['amount'])?.toDouble() ?? 0,
      currencyCode: value['currencyCode'],
    );
  }
}

class BuyerIdentity {
  final String? countryCode;
  final List<Address> deliveryAddressPreferences;
  final String? email;
  final String? phone;

  BuyerIdentity({
    required this.countryCode,
    required this.deliveryAddressPreferences,
    required this.email,
    required this.phone,
  });

  factory BuyerIdentity.fromJson(Map json) {
    return BuyerIdentity(
      countryCode: json['countryCode'],
      deliveryAddressPreferences: List.from(json['deliveryAddressPreferences'])
          .map((x) => Address.fromShopifyJson(x))
          .toList(),
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class DeliveryGroup {
  final String id;
  final DeliveryOption selectedDeliveryOption;
  final List<DeliveryOption> deliveryOptions;

  DeliveryGroup({
    required this.id,
    required this.selectedDeliveryOption,
    required this.deliveryOptions,
  });

  factory DeliveryGroup.fromJson(Map json) {
    return DeliveryGroup(
      id: json['id'],
      selectedDeliveryOption:
          DeliveryOption.fromJson(json['selectedDeliveryOption']),
      deliveryOptions: List.from(json['deliveryOptions'])
          .map((x) => DeliveryOption.fromJson(x))
          .toList(),
    );
  }
}

class DeliveryOption {
  final String title;
  final String handle;
  final String description;
  final String deliveryMethodType;
  final Money estimatedCost;

  DeliveryOption({
    required this.title,
    required this.handle,
    required this.description,
    required this.deliveryMethodType,
    required this.estimatedCost,
  });

  factory DeliveryOption.fromJson(Map json) {
    return DeliveryOption(
      title: json['title'],
      handle: json['handle'],
      description: json['description'],
      deliveryMethodType: json['deliveryMethodType'],
      estimatedCost: Money.fromJson(json['estimatedCost']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'handle': handle,
      'description': description,
      'deliveryMethodType': deliveryMethodType,
      'estimatedCost': estimatedCost.toJson(),
    };
  }
}

class CartLineItem {
  final String id;
  final int quantity;
  final String merchandiseId;
  final List<CartDiscountAllocation> discountAllocations;

  CartLineItem({
    required this.id,
    required this.quantity,
    required this.merchandiseId,
    this.discountAllocations = const [],
  });

  factory CartLineItem.fromJson(Map json) {
    return CartLineItem(
      id: json['id'],
      quantity: json['quantity'],
      merchandiseId: json['merchandise']['id'],
      discountAllocations: List.from(json['discountAllocations'] ?? [])
          .map((x) => CartDiscountAllocation.fromJson(x))
          .toList(),
    );
  }

  double get totalDiscountAmount {
    return discountAllocations.fold(
        0, (sum, allocation) => sum + allocation.discountedAmount.amount);
  }
}

class Cost {
  final Money totalAmount;
  final Money subtotalAmount;
  final Money? totalTaxAmount;
  final Money? totalDutyAmount;

  Cost({
    required this.totalAmount,
    required this.subtotalAmount,
    required this.totalTaxAmount,
    required this.totalDutyAmount,
  });

  factory Cost.fromJson(Map json) {
    return Cost(
      totalAmount: Money.fromJson(json['totalAmount']),
      subtotalAmount: Money.fromJson(json['subtotalAmount']),
      totalTaxAmount: json['totalTaxAmount'] != null
          ? Money.fromJson(json['totalTaxAmount'])
          : null,
      totalDutyAmount: json['totalDutyAmount'] != null
          ? Money.fromJson(json['totalDutyAmount'])
          : null,
    );
  }
}

enum DiscountApplicationType {
  pricingPercentageValue,
  fixedCart,
  ;

  bool get isFixedCart => this == fixedCart;

  bool get isPercentage => this == pricingPercentageValue;

  factory DiscountApplicationType.fromString(String json) {
    if (json == 'PricingPercentageValue') {
      return DiscountApplicationType.pricingPercentageValue;
    }

    return DiscountApplicationType.fixedCart;
  }
}

class Money {
  final double amount;
  final String currencyCode;

  Money({
    required this.amount,
    required this.currencyCode,
  });

  double call() => amount;

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      amount: num.parse(json['amount'].toString()).toDouble(),
      currencyCode: json['currencyCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount.toString(),
      'currencyCode': currencyCode,
    };
  }
}

List<Map> destructNodes(Map<String, dynamic> json) {
  return List<Map>.from(json['nodes']);
}
