import '../../models/entities/chat_message.dart';
import '../../models/entities/chat_room.dart';

abstract class ChatRepository {
  String? get pushToken;

  String get sender;

  // Stream<String> get userEmailStream;

  Stream<List<ChatRoom>> getChatRooms(bool getAllChatRooms);

  Stream<ChatRoom> getChatRoom(String roomId);

  Stream<List<ChatMessage>> getConversation(String chatId);

  Future<void> sendChatMessage(
    String chatId,
    String message,
  );

  Future<void> updateTypingStatus(
    String chatId, {
    bool? isTyping,
  });

  Future<void> updateChatRoom(
    String chatId, {
    String? latestMessage,
    int? receiverUnreadCountPlus,
  });

  Future<void> deleteChatRoom(String chatId);

  Future<String> getChatRoomId(String receiver);

  Future<void> updateBlackList(
    String chatId, {
    List<String>? blackList,
  });
}
