import '../../common/tools.dart';

class FilterAttribute {
  int? id;
  String? slug;
  String? name;
  bool isVisible = true;

  /// Only use for WooCommerce because we have customized the API response to
  /// return the sub attributes when getting attribute data
  List<SubAttribute>? subAttributes;

  FilterAttribute.fromJson(Map parsedJson) {
    id = parsedJson['id'];
    slug = parsedJson['slug'];
    name = parsedJson['name']?.toString().unescape()?.trim();
    isVisible = parsedJson['is_visible'] ?? true;

    if (parsedJson['terms'] != null) {
      subAttributes = [];
      for (var subAttribute in parsedJson['terms']) {
        subAttributes?.add(SubAttribute.fromJson(subAttribute));
      }
    }
  }
}

class SubAttribute {
  int? id;
  String? name;
  int? count;

  SubAttribute.fromJson(Map parsedJson) {
    id = parsedJson['id'] ?? parsedJson['term_id'];
    name = parsedJson['name']?.toString().unescape()?.trim();
    count = parsedJson['count'];
  }

  @override
  String toString() {
    return '[id: $id ===== name: $name]';
  }
}
