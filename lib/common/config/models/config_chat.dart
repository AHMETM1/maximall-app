import '../../../modules/dynamic_layout/config/icon/icon_config.dart';

class ConfigChat {
  final bool enableSmartChat;
  final bool enableVendorChat;
  final List<String> showOnScreens;
  final List<String> hideOnScreens;
  final String version;
  final RealtimeChatConfig realtimeChatConfig;
  final IconConfig iconConfig;

  const ConfigChat({
    this.enableSmartChat = true,
    this.enableVendorChat = true,
    this.showOnScreens = const [],
    this.hideOnScreens = const [],
    this.version = '2',
    this.realtimeChatConfig = const RealtimeChatConfig(),
    required this.iconConfig,
  });

  factory ConfigChat.fromJson(Map json) {
    return ConfigChat(
      enableSmartChat: json['EnableSmartChat'] ?? true,
      enableVendorChat: json['enableVendorChat'] ?? true,
      showOnScreens: List<String>.from(json['showOnScreens'] ?? []),
      hideOnScreens: List<String>.from(json['hideOnScreens'] ?? []),
      version: json['version'] ?? '2',
      realtimeChatConfig:
          RealtimeChatConfig.fromJson(json['realtimeChatConfig'] ?? {}),
      iconConfig: json['iconConfig'] == null
          ? const IconConfig(
              icon: 'chat_rounded',
              fontFamily: 'MaterialIcons',
              colorString: null,
              size: 32,
            )
          : IconConfig.fromJson(json['iconConfig']),
    );
  }

  Map toJson() {
    var map = <String, dynamic>{
      'EnableSmartChat': enableSmartChat,
      'enableVendorChat': enableVendorChat,
      'showOnScreens': showOnScreens,
      'hideOnScreens': hideOnScreens,
      'version': version,
      'realtimeChatConfig': realtimeChatConfig.toJson(),
      'iconConfig': iconConfig.toJson(),
    };
    return map;
  }

  ConfigChat copyWith({
    bool? enableSmartChat,
    bool? enableVendorChat,
    List<String>? showOnScreens,
    List<String>? hideOnScreens,
    String? version,
    RealtimeChatConfig? realtimeChatConfig,
    IconConfig? iconConfig,
  }) {
    return ConfigChat(
      enableSmartChat: enableSmartChat ?? this.enableSmartChat,
      enableVendorChat: enableVendorChat ?? this.enableVendorChat,
      showOnScreens: showOnScreens ?? this.showOnScreens,
      hideOnScreens: hideOnScreens ?? this.hideOnScreens,
      version: version ?? this.version,
      realtimeChatConfig: realtimeChatConfig ?? this.realtimeChatConfig,
      iconConfig: iconConfig ?? this.iconConfig,
    );
  }
}

class RealtimeChatConfig {
  final bool enable;
  final String adminEmail;
  final String adminName;
  final bool userCanDeleteChat;
  final bool userCanBlockAnotherUser;
  final bool adminCanAccessAllChatRooms;

  const RealtimeChatConfig({
    this.enable = false,
    this.adminEmail = '',
    this.adminName = '',
    this.userCanDeleteChat = false,
    this.userCanBlockAnotherUser = false,
    this.adminCanAccessAllChatRooms = false,
  });

  factory RealtimeChatConfig.fromJson(Map json) {
    return RealtimeChatConfig(
      enable: json['enable'] ?? false,
      adminEmail: json['adminEmail'] ?? '',
      adminName: json['adminName'] ?? '',
      userCanDeleteChat: json['userCanDeleteChat'] ?? false,
      userCanBlockAnotherUser: json['userCanBlockAnotherUser'] ?? false,
      adminCanAccessAllChatRooms: json['adminCanAccessAllChatRooms'] ?? false,
    );
  }

  Map toJson() {
    var map = <String, dynamic>{
      'enable': enable,
      'adminEmail': adminEmail,
      'adminName': adminName,
      'userCanDeleteChat': userCanDeleteChat,
      'userCanBlockAnotherUser': userCanBlockAnotherUser,
      'adminCanAccessAllChatRooms': adminCanAccessAllChatRooms,
    };
    return map;
  }

  RealtimeChatConfig copyWith({
    bool? enable,
    String? adminEmail,
    String? adminName,
    bool? userCanDeleteChat,
    bool? userCanBlockAnotherUser,
    bool? adminCanAccessAllChatRooms,
  }) {
    return RealtimeChatConfig(
      enable: enable ?? this.enable,
      adminEmail: adminEmail ?? this.adminEmail,
      adminName: adminName ?? this.adminName,
      userCanDeleteChat: userCanDeleteChat ?? this.userCanDeleteChat,
      userCanBlockAnotherUser:
          userCanBlockAnotherUser ?? this.userCanBlockAnotherUser,
      adminCanAccessAllChatRooms:
          adminCanAccessAllChatRooms ?? this.adminCanAccessAllChatRooms,
    );
  }
}
