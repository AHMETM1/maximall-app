import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/entities/user.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/service_config.dart';
import '../../../services/services.dart';
import 'setting_item/setting_item_widget.dart';

class SettingVendorVacationWidget extends StatelessWidget {
  const SettingVendorVacationWidget({
    super.key,
    required this.user,
    this.cardStyle,
  });

  final SettingItemStyle? cardStyle;
  final User? user;

  @override
  Widget build(BuildContext context) {
    var isVendor = user?.isVender ?? false;
    final isDisableStoreManagement = kVendorConfig.disableNativeStoreManagement;

    if (!isVendor ||
        !ServerConfig().typeName.isWcfm ||
        isDisableStoreManagement) {
      return const SizedBox();
    }

    return SettingItemWidget(
      cardStyle: cardStyle,
      onTap: () {
        FluxNavigate.push(
          MaterialPageRoute(
            builder: (context) => Services().widget.renderVacationVendor(
                  user!.id!,
                  user!.cookie!,
                  isFromMV: true,
                ),
          ),
          context: context,
        );
      },
      icon: Icons.house,
      title: S.of(context).storeVacation,
    );
  }
}
