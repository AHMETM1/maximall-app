import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/icons/icon_picker.dart' deferred as defer_icon;
import 'package:inspireui/widgets/deferred_widget.dart';

import 'icon_config.dart';

extension IconConfigExt on IconConfig {
  Widget getIconWidget({Color? defaultColor}) {
    final isImage = icon.contains('/');

    if (isImage) {
      return FluxImage(
        imageUrl: icon,
        color: color,
        width: size,
        useExtendedImage: false,
      );
    }

    return DeferredWidget(
      defer_icon.loadLibrary,
      () => Icon(
        defer_icon.iconPicker(icon, fontFamily),
        color: color ?? defaultColor,
        size: size,
      ),
    );
  }
}
