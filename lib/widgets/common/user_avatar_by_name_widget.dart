import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../models/index.dart';

class UserAvatarByNameWidget extends StatelessWidget {
  const UserAvatarByNameWidget({
    super.key,
    this.user,
    this.size,
    this.textStyle,
  });

  final User? user;
  final double? size;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final hasName = user?.fullName.isNotEmpty ?? false;

    return FluxAvatarByNameWidget(
      name: hasName ? user?.fullName : user?.identifierInformation,
      size: size,
      textStyle: textStyle,
    );
  }
}
