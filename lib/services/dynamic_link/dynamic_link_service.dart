import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../../common/config/models/dynamic_link/dynamic_link_type.dart';
import '../link_service.dart';

abstract class DynamicLinkService {
  DynamicLinkService(
    this._type, {
    required this.linkService,
  });

  final LinkService linkService;

  final DynamicLinkType _type;

  Future<void> initialize();

  Future<String?> createDynamicLink(String url);

  Future<void> handleLink(String url);

  bool isSupportedLink(String url);
}

class UnifiedDynamicLinkService extends DynamicLinkService {
  final List<DynamicLinkService> _dynamicLinkServices;
  late final DynamicLinkService? _mainService;
  final bool _allowShareLink;

  UnifiedDynamicLinkService({
    required List<DynamicLinkService> dynamicLinkServices,
    required bool allowShareLink,
    required super.linkService,
    required DynamicLinkType type,
  })  : _dynamicLinkServices = dynamicLinkServices,
        _allowShareLink = allowShareLink,
        super(type) {
    _mainService = _dynamicLinkServices.firstWhereOrNull(
      (element) => element._type == type,
    );
  }

  @override
  Future<String?> createDynamicLink(String url) async {
    if (_allowShareLink == false || _mainService == null) return null;

    return _mainService!.createDynamicLink(url);
  }

  @override
  Future<void> handleLink(String url) async {
    for (var service in _dynamicLinkServices) {
      if (service.isSupportedLink(url)) {
        return service.handleLink(url);
      }
    }

    final uri = Uri.tryParse(url);
    if (uri != null) {
      return linkService.handleWebLink(uri);
    }
  }

  @override
  Future<void> initialize() async {
    for (var service in _dynamicLinkServices) {
      unawaited(service.initialize());
    }
  }

  @override
  @protected
  bool isSupportedLink(String url) {
    throw UnimplementedError();
  }
}
