import 'dart:async';

import '../../common/config/models/dynamic_link/dynamic_link.dart';
import 'dynamic_link_service.dart';

class SelfHostedDynamicLinkService extends DynamicLinkService {
  SelfHostedDynamicLinkService({
    required super.linkService,
  }) : super(DynamicLinkType.selfhosted);

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> createDynamicLink(String url) async {
    return url;
  }

  @override
  Future<void> handleLink(String url) async {}

  @override
  bool isSupportedLink(String url) {
    return false;
  }
}
