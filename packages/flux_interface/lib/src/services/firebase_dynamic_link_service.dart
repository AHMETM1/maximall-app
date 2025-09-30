import 'package:fstore/common/config/models/index.dart';
import 'package:fstore/services/dynamic_link/dynamic_link_service.dart';

class FirebaseDynamicLinkService extends DynamicLinkService {
  FirebaseDynamicLinkService({
    required this.config,
    required super.linkService,
  }) : super(DynamicLinkType.firebase);
  final FirebaseDynamicLinkServiceConfig config;

  @override
  Future<String?> createDynamicLink(String url) async {
    return null;
  }

  @override
  Future<void> handleLink(String url) async {}

  @override
  Future<void> initialize() async {}

  @override
  bool isSupportedLink(String url) {
    return false;
  }
}
