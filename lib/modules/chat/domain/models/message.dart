import 'package:equatable/equatable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/injector.dart';

class Message extends Equatable implements Comparable<Message> {
  final String objectId;
  final String content;
  final String? description;
  final MessageType type;
  final DateTime createdAt;
  final String senderId;
  const Message({
    required this.objectId,
    required this.content,
    required this.type,
    required this.senderId,
    required this.createdAt,
    this.description,
  });

  Message.fromJson(Map<String, dynamic> json)
      : objectId = json['id'] as String,
        content = json['content'] as String,
        description = json['description'] as String?,
        type = parseType(json['type'] as String),
        senderId = json['sender'] as String,
        createdAt = DateTime.parse(json['createdAt'] as String).toLocal();

  Map<String, dynamic> toJson() => {};

  bool get isSentByMe => senderId == injector<LoggedInUser>().user!.uuid;

  @override
  // TODO: implement props
  List<Object?> get props => [objectId];

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

  @override
  int compareTo(Message other) {
    return other.createdAt.compareTo(createdAt);
  }
}

enum MessageType { text, image, video }
