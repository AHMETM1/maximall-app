import 'package:flux_interface/flux_interface.dart';

import '../common/config.dart';
import '../common/config/models/dynamic_link/dynamic_link.dart';
import '../common/constants.dart';
import '../dependency_injection/di_core.dart';
import '../frameworks/shopify/services/shopify_mixin.dart';
import '../frameworks/wordpress/services/wordpress_mixin.dart';
import '../modules/advertisement/index.dart' show AdvertisementServiceImpl;
import '../modules/onesignal/one_signal_notification_service.dart';
import '../modules/tera_wallet/services/wallet_service_mixin.dart';
import 'advertisement/advertisement_service.dart';
import 'chat/all_chat_services.dart';
import 'dynamic_link/dynamic_link_service.dart';
import 'link_service.dart';
import 'notification/notification_service.dart';
import 'notification/notification_service_impl.dart';
import 'service_config.dart';

export 'base_remote_config.dart';

class Services
    with ConfigMixin, ShopifyMixin, WordPressMixin, WalletServiceMixin {
  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();

  final BaseFirebaseServices firebase = injector.get<BaseFirebaseServices>();

  /// using AdvertisementService when disable the Advertisement
  // final AdvertisementService advertisement = AdvertisementService();
  final AdvertisementService advertisement = AdvertisementServiceImpl();

  final ChatServices chatServices = ChatServices();

  late final linkService = LinkService(api);

  static DynamicLinkService? _dynamicLinkService;

  /// Get dynamic link service
  DynamicLinkService get dynamicLinkService {
    if (_dynamicLinkService != null) {
      return _dynamicLinkService!;
    }

    final listService =
        dynamicLinkConfig.serviceConfigs.createServices(linkService);

    return _dynamicLinkService = UnifiedDynamicLinkService(
      linkService: linkService,
      allowShareLink: dynamicLinkConfig.allowShareLink,
      type: dynamicLinkConfig.type,
      dynamicLinkServices: listService,
    );
  }

  static NotificationService getNotificationService() {
    NotificationService notificationService = NotificationServiceImpl();

    if ((kOneSignalKey['enable'] ?? false) &&
        (kOneSignalKey['appID'] != null)) {
      if (isMobile) {
        notificationService = OneSignalNotificationService(
          appID: kOneSignalKey['appID'],
        );
      }
    } else if (_instance.firebase.isEnabled) {
      final isRegistered = injector.isRegistered<FirebaseNotificationService>();

      if (isRegistered) {
        notificationService = injector.get<FirebaseNotificationService>();
      }
    }
    return notificationService;
  }
}
