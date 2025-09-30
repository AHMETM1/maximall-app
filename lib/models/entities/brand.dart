import '../../common/constants.dart';
import '../../common/tools.dart';

class Brand {
  dynamic id;
  String? name;
  String? slug;
  String? description;
  String? image;
  int? count;

  // As the old logic, still show all tags
  bool isVisible = true;

  Brand({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.count,
    this.isVisible = true,
  });

  Brand.fromJson(Map parsedJson) {
    try {
      id = parsedJson['id'].toString();
      name = parsedJson['name']?.toString().unescape()?.trim();
      slug = parsedJson['slug'];
      description = parsedJson['description'];
      if (parsedJson['image'] != null) {
        final srcData = parsedJson['image']?['src'];

        image = (srcData is String && srcData.isURL) ? srcData : null;
      }
      count = parsedJson['count'];
      isVisible = parsedJson['is_visible'] ?? true;
    } catch (e, trace) {
      printLog(trace);
      printLog('Brand $name error: ${e.toString()}');
    }
  }

  Brand.fromServerlessJson(Map parsedJson) {
    try {
      id = parsedJson['Id']?.toString();
      final rawName = parsedJson['Name']?.toString();
      name = rawName?.toString().unescape()?.trim();
      slug = parsedJson['Slug'];
      description = parsedJson['Description'];
      if (parsedJson['Image'] != null) {
        final srcData = parsedJson['Image'];
        image = (srcData is String && srcData.isURL) ? srcData : null;
      }
      count = parsedJson['ProductsCount'] ?? 0;
      isVisible = parsedJson['IsVisible'] ?? true;
    } catch (e, trace) {
      printLog(trace);
      printLog('Brand $name error: ${e.toString()}');
    }
  }

  Brand.fromBigCommerce(dynamic json) {
    try {
      id = json['id'].toString();
      name = json['name']?.toString().unescape()?.trim();
      image = ((json['image_url'] as String?)?.isNotEmpty ?? false)
          ? json['image_url']
          : kDefaultImage;
      description = json['meta_description'];
    } catch (e, trace) {
      printLog(trace);
      printLog('Brand $name error: ${e.toString()}');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'count': count,
      'is_visible': isVisible
    };
  }

  /// Convert Brand to Firestore Map
  Map<String, dynamic> toFirestoreMap() {
    return {
      'Id': id,
      'Name': name,
      'Slug': slug,
      'Description': description,
      'Image': image,
      'ProductsCount': count,
      'IsVisible': isVisible
    };
  }

  @override
  String toString() => 'Brand {id: $id, name: $name}';
}

extension ExtListBrand on List<Brand> {
  void merge(List<Brand> brands) {
    for (var brand in brands) {
      final index = indexWhere((element) => element.id == brand.id);

      if (index == -1) {
        add(brand);
      } else {
        this[index] = brand;
      }
    }
  }
}
