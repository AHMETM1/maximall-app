import 'package:collection/collection.dart';

enum SocialLoginType {
  google,
  facebook,
  apple,
  sms,
  email,
  none;

  bool get isGoogle => this == SocialLoginType.google;
  bool get isFacebook => this == SocialLoginType.facebook;
  bool get isApple => this == SocialLoginType.apple;
  bool get isSMS => this == SocialLoginType.sms;
  bool get isEmail => this == SocialLoginType.email;
  bool get isNone => this == SocialLoginType.none;

  factory SocialLoginType.fromString(String? type) {
    return SocialLoginType.values.firstWhereOrNull((e) => e.name == type) ??
        SocialLoginType.none;
  }
}
