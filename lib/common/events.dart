import '../models/entities/fstore_notification_item.dart';
import '../services/review_service.dart';

class EventExpiredCookie {
  const EventExpiredCookie({
    this.isRequiredLogin = false,
    this.skipDuplicateCheck = false,
    this.errMsg,
  });

  final bool isRequiredLogin;
  final bool skipDuplicateCheck;
  final String? errMsg;
}

class EventLoggedIn {
  const EventLoggedIn();
}

class EventScreenChanged {
  final String? screenName;
  const EventScreenChanged({required this.screenName});
}

class EventReloadMyPoints {
  final FStoreNotificationItem notification;
  const EventReloadMyPoints(this.notification);
}

class EventReviewServiceUpdated {
  final ReviewService reviewService;
  const EventReviewServiceUpdated(this.reviewService);
}
