import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../common/enums/load_state.dart';
import '../services/index.dart';
import 'entities/brand.dart';

class BrandLayoutModel extends ChangeNotifier {
  final _services = Services();
  final List<Brand> _brands = [];
  final List<Brand> _brandsByCategory = [];

  List<Brand> get brands => _brands;

  Iterable<Brand>? get listVisibleBrand =>
      _brandsByCategory.where((element) => element.isVisible);

  // To get brands based on category
  List<String>? _categoryIds;

  FSLoadState _state = FSLoadState.loaded;

  FSLoadState get state => _state;
  bool get isEnded => _isEnded;
  bool _isDisposed = false;
  var _page = 1;
  final _perPage = 20;
  bool _isEnded = true;

  void _updateState(state) {
    _state = state;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Brand? getBrandById(String brandId) {
    return _brands.firstWhereOrNull((element) => element.id == brandId);
  }

  void addBrand(Brand brand) {
    final findBrand = getBrandById(brand.id);
    if (findBrand == null) {
      _brands.add(brand);
    }
  }

  Future<void> getBrands({List<String>? categoryIds}) async {
    if (_state == FSLoadState.loading) {
      return;
    }
    _categoryIds = categoryIds;
    _updateState(FSLoadState.loading);
    _page = 1;
    _brandsByCategory.clear();
    final list = await _services.api.getBrands(
          page: _page,
          perPage: _perPage,
          categoryIds: _categoryIds,
        ) ??
        [];

    if (categoryIds?.isEmpty ?? true) {
      _brands.clear();
      _brands.merge(list);
    } else {
      _brandsByCategory.merge(list);
    }
    _isEnded = list.isEmpty;
    _updateState(list.isNotEmpty ? FSLoadState.loaded : FSLoadState.noData);
  }

  Future<List<Brand>> loadMoreBrands() async {
    if (_state == FSLoadState.noData) {
      return [];
    }
    _updateState(FSLoadState.loading);
    _page++;
    final list = await _services.api.getBrands(
          page: _page,
          perPage: _perPage,
          categoryIds: _categoryIds,
        ) ??
        [];

    if (_categoryIds?.isEmpty ?? true) {
      _brands.merge(list);
    } else {
      _brandsByCategory.merge(list);
    }
    _isEnded = list.isEmpty;
    _updateState(list.isNotEmpty ? FSLoadState.loaded : FSLoadState.noData);

    return list;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
