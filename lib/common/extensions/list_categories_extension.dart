import '../../models/entities/category.dart';
import '../constants.dart';

extension ListCategoriesExtension on List<Category>? {
  String? getParentByCategoryId(String id) {
    for (var item in (this ?? <Category>[])) {
      if (item.id == id) {
        return (item.parent == null || item.isRoot) ? null : item.parent;
      }
    }
    return null;
  }

  Category? findRootCategoryFromCategoryId(String? id, {String? stopId}) {
    Category? category;

    if (id == null) {
      return null;
    }

    for (var item in (this ?? <Category>[])) {
      if (item.id == id) {
        category = item;
        break;
      }
    }

    if (category == null ||
        ((stopId?.isNotEmpty ?? false) && category.parent == stopId)) {
      return null;
    }

    if ((category.parent?.isNotEmpty ?? false) &&
        category.parent != kEmptyCategoryID &&
        category.parent != kRootCategoryID) {
      return findRootCategoryFromCategoryId(
        category.parent!,
        stopId: stopId ?? id,
      );
    }

    return category;
  }
}
