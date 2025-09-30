import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/index.dart';
import '../../services/chat/all_chat_services.dart';
import '../../services/chat/constants/enums.dart';
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../../widgets/common/webview.dart';
import 'chat_arguments.dart';
import 'chat_screen.dart';

mixin ChatMixin<T extends StatefulWidget> on State<T> {
  /// Service for realtime chat
  BaseFirebaseServices get _firebaseService => Services().firebase;

  /// Other services for chatGPT, zohoSalesiq,...
  ChatServices get _chatServices => Services().chatServices;

  /// Currently, Haravan cases supporting gpt have not been tested,
  /// so both firebase and gpt chat cases are hidden.
  bool get _supportChatProvider => !(ServerConfig().isHaravan);

  /// List of supported smart chat options
  List<Map> get supportedSmartChatOptions {
    final result = [];

    Map<String, dynamic> createItemResult({
      String? app,
      String? description,
      IconData? iconData,
      String? imageData,
      ChatArguments? storeArguments,
    }) {
      return {
        if (app != null) 'app': app,
        if (description != null) 'description': description,
        if (iconData != null) 'iconData': iconData,
        if (imageData != null) 'imageData': imageData,
        if (storeArguments != null) 'storeArguments': storeArguments,
      };
    }

    for (final option in kListSmartChat) {
      final app = option['app']?.toString();
      final item = createItemResult(
        app: app,
        description: option['description'] ?? '',
        iconData: option['iconData'],
        imageData: option['imageData'],
      );

      // Check if the option is one of the supported chat providers and is
      // enabled
      final chatProvider = ChatProviders.fromString(app);
      final isChatProviderExist =
          _chatServices.checkProviderExist(provider: chatProvider);

      if (isChatProviderExist && _supportChatProvider) {
        final isChatProviderEnable =
            _chatServices.checkProviderEnabled(provider: chatProvider);

        if (isChatProviderEnable) {
          result.add(item);
        }
        continue;
      }

      // Check for other chat options
      switch (app) {
        case 'firebase':
          if (_firebaseService.isEnabled &&
              kLoginSetting.enable &&
              _supportChatProvider) {
            item['description'] = option['description'] ?? S.of(context).chat;
            break;
          }
          continue;

        case 'store':
          if (kConfigChat.realtimeChatConfig.enable &&
              _firebaseService.isEnabled &&
              kLoginSetting.enable &&
              option['storeArguments'] is ChatArguments) {
            item['storeArguments'] = option['storeArguments'];
            break;
          }
          continue;

        default:
      }

      result.add(item);
    }
    return List<Map>.from(result);
  }

  Future<void> onTapItem(
    BuildContext context,
    String? app,
    ChatArguments? storeArguments,
  ) async {
    final chatProvider = ChatProviders.fromString(app);
    final isChatProviderExist =
        _chatServices.checkProviderExist(provider: chatProvider);

    if (isChatProviderExist) {
      await _chatServices.showChatScreen(
        context,
        chatProvider,
      );
      return;
    }

    switch (app) {
      case 'firebase':
        final userModel = Provider.of<UserModel>(context, listen: false);
        if (userModel.user == null) {
          await Navigator.of(context).pushNamed(RouteList.login);
          return;
        }
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
        break;

      case 'store':
        if (storeArguments != null) {
          await Navigator.of(context).pushNamed(
            RouteList.vendorChat,
            arguments: storeArguments,
          );
        }
        break;

      default:
        final url = Tools.prepareURL(app);
        if (url != null) {
          try {
            if (Tools.needToOpenExternalApp(url)) {
              await Tools.launchURL(url);
            } else {
              openChatWebview(url: url, context: context);
            }
            return;
          } catch (e) {
            printError(e);
          }
        }

        final snackBar = SnackBar(
          content: Text(
            S.of(context).canNotLaunch,
          ),
          action: SnackBarAction(
            label: S.of(context).undo,
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Build item action for CupertinoActionSheet
  CupertinoActionSheetAction buildItemAction({
    required Map option,
    required BuildContext context,
    required BuildContext popupContext,
  }) {
    final iconData = option['iconData'];
    final imageData = option['imageData'] ?? '';
    final description = option['description'];
    final app = option['app']?.toString();
    final storeArguments = option['storeArguments'];

    return CupertinoActionSheetAction(
      onPressed: () async {
        Navigator.of(popupContext).pop();
        await Future.delayed(const Duration(milliseconds: 300), () {});
        await onTapItem(context, app, storeArguments);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageData.isNotEmpty)
            FluxImage(imageUrl: imageData, width: 24, fit: BoxFit.contain)
          else
            Icon(
              iconData,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void openChatWebview({
    String? url,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => WebView(
          url!,
          appBar: AppBar(
            title: Text(S.of(context).message),
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            elevation: 0.0,
          ),
        ),
      ),
    );
  }

  /// Show action sheet for supported smart chat version 2
  Future showActionSheet({required BuildContext context}) {
    return showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (popupContext) => CupertinoActionSheet(
        actions: List.generate(
          supportedSmartChatOptions.length,
          (index) {
            final option = supportedSmartChatOptions[index];
            return buildItemAction(
              option: option,
              popupContext: popupContext,
              context: context,
            );
          },
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(popupContext).pop,
          isDestructiveAction: true,
          child: Text(
            S.of(context).cancel,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
        ),
      ),
    );
  }

  /// Build chat item
  Widget buildItemIcon(
    Map option,
    double iconSize,
    Color iconColor,
  ) {
    final iconData = option['iconData'];
    final imageData = option['imageData'] ?? '';
    final storeArguments = option['storeArguments'];

    var icon = imageData.isNotEmpty
        ? FluxImage(
            imageUrl: imageData,
            width: iconSize,
            fit: BoxFit.contain,
          )
        : Icon(
            iconData,
            size: iconSize,
            color: iconColor,
          );
    return GestureDetector(
      child: icon,
      onTap: () => onTapItem(context, option['app'], storeArguments),
    );
  }

  double get bottomPadding =>
      20.0 +
      (kAdvanceConfig.alwaysShowTabBar ? 20.0 : 0.0) +
      (kAdvanceConfig.showBottomCornerCart ? 25.0 : 0.0);
}
