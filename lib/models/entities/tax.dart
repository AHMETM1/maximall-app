class Tax {
  final String? id;
  final String? title;
  final double? amount;

  Tax({this.id, this.title, this.amount});

  Tax.fromJson(Map parsedJson)
      : id = parsedJson['id'],
        title = parsedJson['label'],
        amount = double.parse('${(parsedJson['value'] ?? 0.0)}');

  Tax.fromMagentoJson(Map parsedJson)
      : id = parsedJson['title'],
        title = parsedJson['title'],
        amount = double.parse('${(parsedJson['value'] ?? 0.0)}');
}

class CartTax {
  const CartTax({this.items, this.total, this.isIncludingTax});

  final List<Tax>? items;
  final double? total;
  final bool? isIncludingTax;
}
