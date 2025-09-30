// ignore_for_file: constant_identifier_names
enum YithAddonsType {
  heading,
  text,
  separator,
  checkbox,
  radio,
  input_text,
  select;

  static YithAddonsType? fromString(String? value) {
    switch (value) {
      case 'html_heading':
        return YithAddonsType.heading;
      case 'html_text':
        return YithAddonsType.text;
      case 'html_separator':
        return YithAddonsType.separator;
      case 'checkbox':
        return YithAddonsType.checkbox;
      case 'radio':
        return YithAddonsType.radio;
      case 'text':
        return YithAddonsType.input_text;
      case 'select':
        return YithAddonsType.select;
      default:
        return null;
    }
  }
}

enum YithAddonsPriceType {
  fixed,
  percentage;

  static YithAddonsPriceType? fromString(String? value) {
    final index = YithAddonsPriceType.values.indexWhere((e) => e.name == value);
    return index != -1 ? YithAddonsPriceType.values[index] : null;
  }
}

enum YithAddonsPriceMethod {
  free,
  increase,
  decrease;

  static YithAddonsPriceMethod? fromString(String? value) {
    final index =
        YithAddonsPriceMethod.values.indexWhere((e) => e.name == value);
    return index != -1 ? YithAddonsPriceMethod.values[index] : null;
  }
}

class YithProductAddons {
  String? id;
  YithAddonsType? type;
  String? title;
  String? description;
  bool? required;
  List<YithAddonsOption>? options;

  YithProductAddons({
    this.id,
    this.type,
    this.title,
    this.description,
    this.required = false,
    this.options,
  });

  YithProductAddons.fromJson(Map<dynamic, dynamic> json) {
    id = json['id']?.toString();
    type = YithAddonsType.fromString(json['type']);
    title = json['title'];
    description = json['description'];
    required = json['required'] == true || json['required'] == 1;

    if (json['options'] != null) {
      final List<dynamic> values = json['options'] ?? [];
      options =
          values.map((option) => YithAddonsOption.fromJson(option)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type?.name;
    data['title'] = title;
    data['description'] = description;
    data['required'] = required ?? false;
    if (options != null) {
      data['options'] = options!.map((option) => option.toJson()).toList();
    }
    return data;
  }
}

/// YITH Addons Option model
class YithAddonsOption {
  String? id;
  String? label;
  String? price;
  String? salePrice;
  YithAddonsPriceType? priceType;
  YithAddonsPriceMethod? priceMethod;
  String? tooltip;
  String? description;
  dynamic inputValue;

  YithAddonsOption({
    this.id,
    this.label,
    this.price,
    this.salePrice,
    this.priceType,
    this.priceMethod,
    this.tooltip,
    this.description,
    this.inputValue,
  });

  YithAddonsOption copyWith({
    String? id,
    String? label,
    String? price,
    String? salePrice,
    YithAddonsPriceType? priceType,
    YithAddonsPriceMethod? priceMethod,
    String? tooltip,
    String? description,
    dynamic inputValue,
  }) {
    return YithAddonsOption(
      id: id ?? this.id,
      label: label ?? this.label,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      priceType: priceType ?? this.priceType,
      priceMethod: priceMethod ?? this.priceMethod,
      tooltip: tooltip ?? this.tooltip,
      description: description ?? this.description,
      inputValue: inputValue ?? this.inputValue,
    );
  }

  YithAddonsOption.fromJson(Map<dynamic, dynamic> json) {
    id = json['id']?.toString();
    label = json['label'];
    price = json['price']?.toString();
    salePrice = json['sale_price']?.toString();
    priceType = YithAddonsPriceType.fromString(json['price_type']);
    priceMethod = YithAddonsPriceMethod.fromString(json['price_method']);
    tooltip = json['tooltip'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['price'] = price;
    data['sale_price'] = salePrice;
    data['price_type'] = priceType?.name;
    data['price_method'] = priceMethod?.name;
    data['tooltip'] = tooltip;
    data['description'] = description;
    return data;
  }
}
