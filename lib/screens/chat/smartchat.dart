import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/config.dart' show kConfigChat;
import 'bottom_sheet_smart_chat.dart';
import 'fab_circle_smart_chat.dart';

class SmartChat extends StatelessWidget {
  final EdgeInsets? margin;

  const SmartChat({
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final version = kConfigChat.version;

    if (version == '2') {
      return const BottomSheetSmartChat();
    }

    return FabCircleSmartChat(
      margin: margin,
    );
  }
}
