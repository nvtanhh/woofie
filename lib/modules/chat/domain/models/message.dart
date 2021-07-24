import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String objectId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final String senderId;
  const Message({
    required this.objectId,
    required this.content,
    required this.type,
    required this.senderId,
    required this.createdAt,
  });

  Message.fromJson(Map<String, dynamic> json)
      : objectId = json['id'] as String,
        content = json['content'] as String,
        type = parseType(json['type'] as String),
        senderId = json['sender'] as String,
        createdAt = DateTime.parse(json['createdAt'] as String).toLocal();

  Map<String, dynamic> toJson() => {};

  @override
  // TODO: implement props
  List<Object?> get props => [objectId];

  static MessageType parseType(String type) {
    switch (type) {
      case 'T':
        return MessageType.text;
      case 'I':
        return MessageType.image;
      default:
        throw Exception('Unknown message type: $type');
    }
  }
}

enum MessageType { text, image }
