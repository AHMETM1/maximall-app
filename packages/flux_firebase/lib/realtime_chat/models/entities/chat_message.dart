import '../../constants/keys.dart';

class ChatMessage {
  final String sender;
  final DateTime createdAt;
  final String text;

  ChatMessage({
    this.sender = '',
    required this.createdAt,
    this.text = '',
  });

  factory ChatMessage.fromFirestoreJson(Map json) => ChatMessage(
        sender: json[kFirestoreFieldSender] ?? '',
        createdAt: DateTime.tryParse('${json[kFirestoreFieldCreatedAt]}') ??
            DateTime.now(),
        text: json[kFirestoreFieldText] ?? '',
      );

  Map<String, dynamic> toFirestoreJson() => {
        kFirestoreFieldSender: sender,
        kFirestoreFieldCreatedAt: createdAt.toUtc().toIso8601String(),
        kFirestoreFieldText: text,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          sender == other.sender &&
          createdAt == other.createdAt &&
          text == other.text;

  @override
  int get hashCode => sender.hashCode ^ createdAt.hashCode ^ text.hashCode;
}
