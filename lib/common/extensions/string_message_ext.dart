import 'package:flutter/widgets.dart';
import 'package:flux_localization/flux_localization.dart';

extension StringMessageExt on String {
  String improveMessage(BuildContext context) {
    if (contains('[firebase_auth/email-already-in-use]')) {
      return S.of(context).emailAlreadyInUse;
    }

    return this;
  }
}
