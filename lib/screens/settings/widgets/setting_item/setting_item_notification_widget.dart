import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../models/notification_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/index.dart';
import 'setting_card_widget.dart';
import 'setting_item_widget.dart';

enum _ActionChangePermissionNotification {
  none,
  enable,
  disable;

  bool get isEnable => this == _ActionChangePermissionNotification.enable;
  bool get isDisable => this == _ActionChangePermissionNotification.disable;
}

class SettingNotificationWidget extends StatefulWidget {
  const SettingNotificationWidget({
    super.key,
    this.cardStyle,
  });

  final SettingItemStyle? cardStyle;

  @override
  State<SettingNotificationWidget> createState() =>
      _SettingNotificationWidgetState();
}

class _SettingNotificationWidgetState extends State<SettingNotificationWidget>
    with LifecycleMixin {
  bool _openSetting = false;
  _ActionChangePermissionNotification _action =
      _ActionChangePermissionNotification.none;
  NotificationModel get _notificationModel => context.read<NotificationModel>();
  NotificationService get _notificationService =>
      injector<NotificationService>();

  Future _onChanged(BuildContext context, NotificationModel model,
      bool enableNotification) async {
    if (enableNotification) {
      await model.enableNotification();
      _action = _ActionChangePermissionNotification.enable;
    } else {
      model.disableNotification();
      _action = _ActionChangePermissionNotification.disable;
    }
    _updateNotificationStatus();
  }

  void _updateNotificationStatus() {
    var cookie = Provider.of<UserModel>(context, listen: false).user?.cookie;
    _notificationModel.updateNotificationStatus(cookie);
  }

  @override
  void onChangeLifecycleState(AppLifecycleState lifecycleState) async {
    if (LifecycleEventHandler.isPaused) {
      _openSetting = true;
    } else if (_openSetting) {
      final isGranted = await _notificationService.isGranted();
      // When there is an action to turn on/off notification, the following code will be executed
      if (_action != _ActionChangePermissionNotification.none) {
        // If after the user reopens the app (after the action of pausing
        // the app and reopening it), it is necessary to check:
        // - If isGranted = true and the user's action is to turn on
        // notifications, then turn on notifications
        // - On the contrary, if the user's action is to turn off notifications
        // or isGranted = false, then turn off notifications
        if (isGranted && _action.isEnable) {
          await _notificationModel.enableNotification();
        } else if (_action.isDisable || isGranted == false) {
          _notificationModel.disableNotification();
        }

        _updateNotificationStatus();
        _action = _ActionChangePermissionNotification.none;
      }
      // If the user does not have any action to turn on/off notifications but
      // has an action to reopen the app (after the action of pausing the app
      // and reopening), then it is necessary to check:
      //
      // If the notification on the application is turned on,
      // but isGranted = false, then automatically turn off the notification
      // because at this time the notification permission of the application
      // has been turned off from the system.
      else if (_notificationModel.enable && isGranted == false) {
        _notificationModel.disableNotification();
        _updateNotificationStatus();
      }

      _openSetting = false;
    }
  }

  @override
  void initState() {
    super.initState();
    // When initializing this widget, it is necessary to check:
    // If isGranted = false and notification is enabled, then automatically
    // disable notification because at this time the notification permission
    // of the application has been turned off from the system.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isGranted = await _notificationService.isGranted();

      if (isGranted == false && _notificationModel.enable) {
        _notificationModel.disableNotification();
        _updateNotificationStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = Text(
      S.of(context).getNotification,
      style: const TextStyle(fontSize: 16),
    );

    final icon = Icon(
      CupertinoIcons.bell,
      color: Theme.of(context).colorScheme.secondary,
      size: 24,
    );

    final messageWidget = SettingItemWidget(
      cardStyle: widget.cardStyle,
      icon: CupertinoIcons.list_bullet,
      title: S.of(context).listMessages,
      onTap: () => Navigator.of(context).pushNamed(RouteList.notify),
    );

    return Consumer<NotificationModel>(builder: (context, model, child) {
      switch (widget.cardStyle) {
        case SettingItemStyle.flatShadow:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.flatShadow,
                child: SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    child: icon,
                  ),
                  value: model.enable,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              if (model.enable) messageWidget,
            ],
          );
        case SettingItemStyle.flat:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.flat,
                child: SwitchListTile(
                  secondary: Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValueOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: icon,
                  ),
                  value: model.enable,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              if (model.enable) messageWidget,
            ],
          );
        case SettingItemStyle.flatListTile:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.flatListTile,
                child: SwitchListTile(
                  secondary: Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValueOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: icon,
                  ),
                  value: model.enable,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              if (model.enable) messageWidget,
            ],
          );
        default:
          return Column(
            children: [
              SettingCardWidget(
                style: SettingItemStyle.listTile,
                child: SwitchListTile(
                  secondary: icon,
                  value: model.enable,
                  onChanged: (value) => _onChanged(context, model, value),
                  title: title,
                ),
              ),
              const Divider(color: Colors.black12, height: 1.0, indent: 75),
              if (model.enable) messageWidget,
            ],
          );
      }
    });
  }
}
