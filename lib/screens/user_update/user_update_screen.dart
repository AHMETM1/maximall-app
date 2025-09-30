import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/utils/event_bus.dart';
import 'package:inspireui/widgets/auto_hide_keyboard.dart';
import 'package:provider/provider.dart';

import '../../common/events.dart';
import '../../common/tools.dart';
import '../../common/tools/flash.dart';
import '../../models/entities/user.dart';
import '../../models/user_model.dart';
import '../../services/index.dart';
import '../../widgets/common/common_safe_area.dart';
import '../../widgets/common/loading_body.dart';
import '../../widgets/common/user_avatar_by_name_widget.dart';
import '../base_screen.dart';

class UserUpdateScreen extends StatefulWidget {
  @override
  BaseScreen<UserUpdateScreen> createState() => StateUserUpdate();
}

class StateUserUpdate extends BaseScreen<UserUpdateScreen> {
  TextEditingController? userEmail;
  TextEditingController? username;
  TextEditingController? userPassword;
  TextEditingController? userDisplayName;
  late TextEditingController userNiceName;
  late TextEditingController userUrl;
  TextEditingController? currentPassword;

  TextEditingController? userFirstname;
  TextEditingController? userLastname;
  TextEditingController? userPhone;

  String? avatar;
  bool isLoading = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  bool isValidPassword() => userPassword!.text.length >= 8;

  bool get hasChangePassword => isValidPassword();

  User get user => context.read<UserModel>().user!;

  bool isPlatformSupported = ![
    ConfigType.bigCommerce,
    ConfigType.notion,
    ConfigType.shopify,
    ConfigType.presta,
    ConfigType.opencart,
    ConfigType.magento,
    ConfigType.firebase,
  ].contains(ServerConfig().type);

  bool get isNotSupportUpdateDisplayName =>
      ServerConfig().type == ConfigType.magento ||
      ServerConfig().type == ConfigType.shopify;

  bool get isSupportUpdatePhoneNumber =>
      ![
        ConfigType.magento,
        ConfigType.strapi,
        ConfigType.wordpress,
        ConfigType.presta,
        ConfigType.gpt
      ].contains(ServerConfig().type) &&
      (ServerConfig().isShopify && user.isSocial != true);

  @override
  void afterFirstLayout(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false).user;
    setState(() {
      userEmail = TextEditingController(text: user!.email);
      username = TextEditingController(text: user.username);
      userPassword = TextEditingController(text: '');
      currentPassword = TextEditingController(text: '');
      userDisplayName = TextEditingController(text: user.name);
      userNiceName = TextEditingController(text: user.nicename);
      userFirstname = TextEditingController(text: user.firstName);
      userLastname = TextEditingController(text: user.lastName);
      userPhone = TextEditingController(text: user.phoneNumber);
      userUrl = TextEditingController(text: user.userUrl);
      avatar = user.picture;
    });
  }

  void updateUserInfo() {
    if (userPassword!.text.isNotEmpty && !isValidPassword()) {
      FlashHelper.errorMessage(
        context,
        message: S.of(context).errorPasswordFormat,
      );
      return;
    }

    final user = Provider.of<UserModel>(context, listen: false).user;
    setState(() {
      isLoading = true;
    });

    Future<void> onLoginAgain() async {
      userPassword?.text = '';

      await context.showFluxDialogText(
        primaryAsDestructiveAction: true,
        title: S.of(context).loginRequired,
        body: S.of(context).needToLoginAgain,
        primaryAction: S.of(context).login,
      );

      eventBus.fire(const EventExpiredCookie());
      await NavigateTools.navigateToLogin(context, replacement: true);
    }

    Services().widget.updateUserInfo(
          loggedInUser: user,
          onError: (e) {
            _scaffoldMessengerKey.currentState
                ?.showSnackBar(SnackBar(content: Text(e)));
            setState(() {
              isLoading = false;
            });
          },
          onSuccess: (user) {
            Provider.of<UserModel>(context, listen: false).setUser(user);
            setState(() {
              isLoading = false;
            });
            unawaited(
              FlashHelper.message(
                context,
                message: S.of(context).updateSuccess,
                duration: const Duration(seconds: 2),
              ),
            );

            /// If update password, need to pop true to force user log-out and
            /// login again to make effect
            if (hasChangePassword) {
              onLoginAgain();
            } else {
              Navigator.of(context).pop();
            }
          },
          currentPassword: currentPassword!.text,
          userDisplayName: userDisplayName!.text,
          userEmail: userEmail!.text,
          userNiceName: userNiceName.text,
          userUrl: userUrl.text,
          userPassword: userPassword!.text,
          userFirstname: userFirstname?.text,
          userLastname: userLastname?.text,
          userPhone: userPhone?.text,
        );
  }

  @override
  void dispose() {
    userEmail?.dispose();
    username?.dispose();
    userPassword?.dispose();
    userDisplayName?.dispose();
    userNiceName.dispose();
    userUrl.dispose();
    currentPassword?.dispose();
    userFirstname?.dispose();
    userLastname?.dispose();
    super.dispose();
  }

  Widget buildInputField(String label, TextEditingController? controller,
      [bool isEnabled = true]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColorLight,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          controller: controller,
          enabled: isEnabled,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context).user;
    final isSocial = user?.isSocial ?? false;

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        extendBodyBehindAppBar: true,
        body: AutoHideKeyboard(
          child: LoadingBody(
            isLoading: isLoading,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildAvatar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (isPlatformSupported)
                            buildInputField(
                                S.of(context).username, username, isSocial),
                          buildInputField(
                              S.of(context).email, userEmail, isSocial),
                          buildInputField(
                              S.of(context).displayName,
                              userDisplayName,
                              isNotSupportUpdateDisplayName == false),
                          buildInputField(
                              S.of(context).firstName, userFirstname),
                          buildInputField(S.of(context).lastName, userLastname),
                          if (isSupportUpdatePhoneNumber) ...[
                            buildInputField(
                                S.of(context).phoneNumber, userPhone),
                          ],
                          if ([ConfigType.magento, ConfigType.presta]
                              .contains(ServerConfig().type)) ...[
                            buildInputField(
                                S.of(context).password, currentPassword),
                          ],
                          if (!isSocial)
                            buildInputField(
                                S.of(context).newPassword, userPassword),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
                buildButtonUpdate(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvatar() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.25,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.sizeOf(context).height * 0.20,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.elliptical(100, 10),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  )
                ]),
            child: (avatar?.isNotEmpty ?? false)
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.elliptical(100, 10),
                    ),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ),
                      child: FluxImage(
                        imageUrl: avatar!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                color: Theme.of(context).primaryColorLight,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 3,
                ),
              ),
              child: (avatar?.isNotEmpty ?? false)
                  ? Hero(
                      tag: 'user-avatar-$avatar',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: FluxImage(
                          imageUrl: avatar!,
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                          errorWidget: UserAvatarByNameWidget(
                            user: Provider.of<UserModel>(context).user,
                            size: 150,
                          ),
                        ),
                      ),
                    )
                  : UserAvatarByNameWidget(
                      user: Provider.of<UserModel>(context).user,
                      size: 150,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonUpdate() {
    return CommonSafeArea(
      child: ElevatedButton(
        onPressed: isLoading ? null : updateUserInfo,
        child: Text(
          S.of(context).update,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
