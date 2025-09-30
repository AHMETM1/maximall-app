import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fstore/services/services.dart';

import '../../impl/firebase_service.dart';
import '../data/firestore.dart';
import '../models/entities/chat_message.dart';
import '../models/entities/chat_room.dart';
import 'base/chat_repository.dart';

class FirestoreChatRepository implements ChatRepository {
  // auth.FirebaseAuth get _auth => _firebaseServices.firebaseAuth;
  FirebaseFirestore get _firestore => _firebaseServices.firestore;

  late final FirebaseServices _firebaseServices;
  late final FirestoreChat _firestoreChat;

  final String _email;

  FirestoreChatRepository(this._email) {
    final firebaseService = Services().firebase;
    if (firebaseService is! FirebaseServices) {
      throw Exception(
          'FirestoreChatRepository requires FirebaseServices implementation, '
          'but got ${firebaseService.runtimeType}');
    }

    _firebaseServices = firebaseService;
    _firebaseServices.getMessagingToken().then((token) {
      _pushToken = token;
    });
    _firestoreChat = FirestoreChat(_firestore);
  }

  String? _pushToken;

  @override
  String? get pushToken => _pushToken;

  @override
  String get sender => _email;

  // @override
  // Stream<String> get userEmailStream => _auth.authStateChanges().transform(
  //       StreamTransformer.fromHandlers(
  //         handleData: (auth.User? user, EventSink<String> sink) {
  //           if (user?.email?.isNotEmpty ?? false) {
  //             _email = user?.email ?? '';
  //             sink.add(_email);
  //           }
  //         },
  //       ),
  //     );

  @override
  Stream<List<ChatRoom>> getChatRooms(bool getAllChatRooms) {
    return _firestoreChat.getChatRooms().map((snapshot) {
      return snapshot.docs
          .map<ChatRoom?>((doc) {
            final data = doc.data();

            if (getAllChatRooms) {
              return data;
            }

            // Check if user is a member of the chat room.
            if (!data.users.any((e) => e.email == _email)) {
              return null;
            }
            return data;
          })
          .whereType<ChatRoom>()
          .toList();
    });
  }

  @override
  Stream<ChatRoom> getChatRoom(String roomId) {
    return _firestoreChat.getChatRoom(roomId).map((snapshot) {
      return snapshot.data()!;
    });
  }

  @override
  Stream<List<ChatMessage>> getConversation(String chatId) {
    return _firestoreChat.getConversation(chatId).map((snapshot) {
      return snapshot.docs.map<ChatMessage>((doc) {
        return doc.data();
      }).toList();
    });
  }

  @override
  Future<void> sendChatMessage(
    String chatId,
    String message,
  ) async {
    await _firestoreChat.sendChatMessage(
      chatId,
      _email,
      message,
    );
  }

  @override
  Future<void> updateTypingStatus(
    String chatId, {
    bool? isTyping,
  }) async {
    await _firestoreChat.updateTypingStatus(
      chatId,
      isTyping: isTyping,
      senderEmail: _email,
    );
  }

  @override
  Future<void> updateChatRoom(
    String chatId, {
    String? latestMessage,
    int? receiverUnreadCountPlus,
  }) async {
    await _firestoreChat.updateChatRoom(
      chatId,
      latestMessage: latestMessage,
      receiverUnreadCountPlus: receiverUnreadCountPlus,
      senderEmail: _email,
      pushToken: pushToken,
    );
  }

  @override
  Future<void> deleteChatRoom(String chatId) async {
    await _firestoreChat.deleteChatRoom(chatId);
  }

  @override
  Future<String> getChatRoomId(String receiver) {
    return _firestoreChat.getChatRoomId(_email, receiver);
  }

  @override
  Future<void> updateBlackList(
    String chatId, {
    List<String>? blackList,
  }) async {
    return _firestoreChat.updateBlackList(
      chatId,
      blackList: blackList,
      senderEmail: _email,
      pushToken: pushToken,
    );
  }
}
