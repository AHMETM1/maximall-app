import 'package:flux_ui/flux_ui.dart';

class LiteProduct {
  final String id;
  final String name;
  final String image;
  Map<String, dynamic>? addonsOptions;
  final String orderId;

  LiteProduct({
    required this.id,
    required this.name,
    required this.image,
    this.addonsOptions,
    required this.orderId,
  });

  bool get hasAddonOptions =>
      addonsOptions != null && addonsOptions!.isNotEmpty;

  String get displayAddonOptions {
    final temp = {};
    final adds = addonsOptions;
    if (adds == null) return '';

    if (adds.isNotEmpty) {
      for (var element in adds.keys) {
        temp[element] = Tools.getFileNameFromUrl(adds[element]!);
      }
    }
    return temp.values.map((e) => e.toString().toUpperCase()).join(' - ');
  }
}
