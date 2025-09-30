class OrderSmartCod {
  final double? realTotal;
  final double? remainingAmount;
  final double? advanceAmount;

  const OrderSmartCod({
    this.realTotal,
    this.remainingAmount,
    this.advanceAmount,
  });

  OrderSmartCod copyWith(
      {double? realTotal, double? remainingAmount, double? advanceAmount}) {
    return OrderSmartCod(
      realTotal: realTotal ?? this.realTotal,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      advanceAmount: advanceAmount ?? this.advanceAmount,
    );
  }
}
