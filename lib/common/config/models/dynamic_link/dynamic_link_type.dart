enum DynamicLinkType {
  branchIO,
  firebase,
  selfhosted,
  none,
  ;

  bool get isFirebase => this == DynamicLinkType.firebase;

  bool get isBranchIO => this == DynamicLinkType.branchIO;

  bool get isSelfHosted => this == DynamicLinkType.selfhosted;

  /// This mean the share dynamic link feature is disabled
  bool get isNone => this == DynamicLinkType.none;

  static DynamicLinkType fromString(String? type) {
    try {
      return DynamicLinkType.values.byName('$type');
    } catch (e) {
      return DynamicLinkType.none;
    }
  }
}
