import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../modules/dynamic_layout/config/icon/icon_config_extension.dart';
import 'chat_mixin.dart';
import 'fab_circle_menu.dart';

class FabCircleSmartChat extends StatefulWidget {
  final EdgeInsets? margin;

  const FabCircleSmartChat({this.margin, super.key});

  @override
  State<FabCircleSmartChat> createState() => _FabCircleSmartChatState();
}

class _FabCircleSmartChatState extends State<FabCircleSmartChat>
    with ChatMixin {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final list = supportedSmartChatOptions;
    if (list.isEmpty) return const SizedBox();

    if (list.length == 1) {
      final option = list[0];
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, bottomPadding),
          child: FloatingActionButton(
            onPressed: () {},
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            child: buildItemIcon(
              option,
              32,
              Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, bottomPadding),
        child: FabCircularMenu(
          fabOpenIcon: kConfigChat.iconConfig.getIconWidget(
            defaultColor: Colors.white,
          ),
          fabCloseIcon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          ringColor: Theme.of(context).primaryColor,
          ringWidth: 100.0,
          ringDiameter: 250.0,
          fabMargin: widget.margin ?? const EdgeInsets.only(bottom: 0),
          options: List.generate(
            supportedSmartChatOptions.length,
            (index) {
              final option = supportedSmartChatOptions[index];
              return buildItemIcon(
                option,
                28,
                Theme.of(context).primaryColorLight,
              );
            },
          ),
          child: const SizedBox(),
        ),
      ),
    );
  }
}
