import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/injector.dart';

// ignore: must_be_immutable
class Message implements Comparable<Message> {
  String? id;
  final String roomId;
  String content;
  String? description;
  MessageType type;
  final DateTime createdAt;
  final String senderId;

  bool isSent;
  String? localUuid;

  Message({
    this.id,
    required this.roomId,
    required this.content,
    required this.type,
    required this.senderId,
    required this.createdAt,
    required this.isSent,
    this.description,
    this.localUuid,
  });

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        roomId = json['chatRoomId'] as String,
        content = json['content'] as String,
        description = json['description'] as String?,
        type = parseType(json['type'] as String),
        senderId = json['sender'] as String,
        createdAt = DateTime.parse(json['createdAt'] as String).toLocal(),
        isSent = true;

  Map<String, dynamic> toJson() => {};

  bool get isSentByMe => senderId == injector<LoggedInUser>().user!.uuid;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          ((id != null && other.id != null && id == other.id) ||
              (localUuid != null &&
                  other.localUuid != null &&
                  localUuid == other.localUuid));

  @override
  int get hashCode => id.hashCode;

  static MessageType parseType(String type) {
    switch (type) {
      case 'T':
        return MessageType.text;
      case 'I':
        return MessageType.image;
      case 'V':
        return MessageType.video;
      default:
        throw Exception('Unsupported message type: $type');
    }
  }

  Message clone() {
    return Message(
      id: id,
      roomId: roomId,
      content: content,
      type: type,
      senderId: senderId,
      createdAt: createdAt,
      description: description,
      isSent: isSent,
      localUuid: localUuid,
    );
  }

  @override
  int compareTo(Message other) {
    return other.createdAt.compareTo(createdAt);
  }
}

enum MessageType { text, image, video }
