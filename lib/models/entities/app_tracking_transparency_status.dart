enum AppTrackingTransparencyStatus {
  firstTime,
  none,
  requesting,
  deniend,
  authorized,
  canRequest;

  bool get isRequesting => this == requesting;
  bool get isNone => this == none;
  bool get isCanRequest => this == canRequest;
  bool get isAuthorized => this == authorized;
  bool get isFirstTime => this == firstTime;

  factory AppTrackingTransparencyStatus.fromString(dynamic name) {
    try {
      return AppTrackingTransparencyStatus.values.byName(name.toString());
    } catch (e) {
      return AppTrackingTransparencyStatus.none;
    }
  }
}
