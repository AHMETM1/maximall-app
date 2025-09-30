import 'package:flutter/cupertino.dart';
import 'package:flux_localization/flux_localization.dart';

import '../../common/extensions/extensions.dart';

mixin DeleteAccountMixin {
  Future<bool> showConfirmDeleteAccountDialog(BuildContext context) async {
    return context.showFluxDialogConfirm(
      title: S.of(context).deleteAccount,
      body: S.of(context).areYouSureDeleteAccount,
      primaryAsDestructiveAction: true,
    );
  }
}
