import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fstore/common/config.dart';
import 'package:fstore/common/config/models/config_chat.dart';

import '../constants/enums.dart';
import '../repos/base/chat_repository.dart';
import 'entities/chat_message.dart';
import 'entities/chat_room.dart';

class ChatViewModel extends ChangeNotifier {
  final RealtimeChatType _type;

  /// Receiver email (for Firestore Database)
  final String _receiver;
  final String _receiverName;

  ChatViewModel(
    this._type,
    this._receiverName,
    this._receiver,
  );

  ChatRepository? _repository;

  /// Sender email (for Firestore Database)
  /// Only used for UI control.
  late String _sender;

  bool get isAdmin =>
      _sender == adminEmail || _type == RealtimeChatType.adminToCustomers;

  RealtimeChatType get type => _type;

  String get sender => _sender;

  String get receiverName => _receiverName;

  String get receiver => _receiver;

  // StreamSubscription<String>? _authSubscription;

  bool get isAuthenticated => _sender.isNotEmpty;

  bool get isInitialized => _repository != null;

  Stream<List<ChatRoom>> _chatRooms = const Stream.empty();

  Stream<List<ChatRoom>> get chatRooms => _chatRooms;

  String? _selectedChatRoomId;

  String? get selectedChatRoomId => _selectedChatRoomId;

  set selectedChatRoomId(String? value) {
    _selectedChatRoomId = value;
    notifyListeners();
  }

  Stream<ChatRoom> get selectedChatRoomStream => _selectedChatRoomId != null
      ? _repository!.getChatRoom(
          _selectedChatRoomId!,
        )
      : const Stream.empty();

  Future<void> init(ChatRepository repository) async {
    _repository = repository;

    _sender = _repository!.sender;

    if (_type == RealtimeChatType.adminToCustomers ||
        _type == RealtimeChatType.vendorToCustomers ||
        _type == RealtimeChatType.userToUsers) {
      final isAllowAdminGetAllChatRooms =
          _sender == adminEmail && adminCanAccessAllChatRooms;
      _chatRooms = getChatRoomsStream(isAllowAdminGetAllChatRooms);
    } else {
      _selectedChatRoomId = await _repository?.getChatRoomId(
        _receiver,
      );
    }
    notifyListeners();

    // /// Only for Firestore Database.
    // _authSubscription = repository.userEmailStream.listen((email) {
    //   if (email.isNotEmpty && email != _sender) {
    //     // Callback to update sender to rebuild UI.
    //     _sender = email;
    //     notifyListeners();
    //   }
    // });
  }

  @override
  void dispose() {
    // _authSubscription?.cancel();
    super.dispose();
  }

  RealtimeChatConfig get realtimeChatConfig => kConfigChat.realtimeChatConfig;

  String get adminName => realtimeChatConfig.adminName;

  String get adminEmail => realtimeChatConfig.adminEmail;

  bool get enableRealtimeChat => realtimeChatConfig.enable;

  bool get userCanDeleteChat => realtimeChatConfig.userCanDeleteChat;

  bool get userCanBlockAnotherUser =>
      realtimeChatConfig.userCanBlockAnotherUser;

  bool get adminCanAccessAllChatRooms =>
      realtimeChatConfig.adminCanAccessAllChatRooms;

  Stream<List<ChatRoom>> getChatRoomsStream(bool allowAdminGetAllChatRooms) {
    return _repository!.getChatRooms(allowAdminGetAllChatRooms);
  }

  Stream<List<ChatMessage>> getChatConversation(String chatId) {
    return _repository!.getConversation(chatId);
  }

  Future<void> sendChatMessage(
    String chatId,
    String message,
  ) async {
    await _repository!.sendChatMessage(
      chatId,
      message,
    );
    await _repository!.updateChatRoom(
      chatId,
      latestMessage: message,
      receiverUnreadCountPlus: 1,
    );
  }

  Future<void> updateTypingStatus(String chatId, bool status) async {
    switch (_type) {
      case RealtimeChatType.adminToCustomers:
      case RealtimeChatType.vendorToCustomers:
      case RealtimeChatType.customerToAdmin:
      case RealtimeChatType.customerToVendor:
      case RealtimeChatType.userToUsers:
        await _repository!.updateTypingStatus(
          chatId,
          isTyping: status,
        );
        break;
    }
  }

  Future<void> deleteCurrentChatRoom() async {
    final chatRoomId = _selectedChatRoomId;
    if (chatRoomId != null) {
      _selectedChatRoomId = null;
      notifyListeners();
      await _repository!.deleteChatRoom(chatRoomId);
    }
  }

  Future<void> updateBlackList(String chatId, List<String> emails) async {
    return _repository!.updateBlackList(
      chatId,
      blackList: emails,
    );
  }
}
