import 'package:easy_localization/easy_localization.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/domain/models/updatable_model.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

class ChatRoom extends UpdatableModel {
  final String id;
  String rawName;
  List<String> memberUuids;
  late String? displayName;
  late List<User?>? members;
  late String? avatarUrl;
  List<Message> messages;
  bool isGroup;
  String? creatorUuid;
  DateTime? createdAt;

  ChatRoom({
    required this.id,
    required this.rawName,
    required this.isGroup,
    required this.memberUuids,
    this.creatorUuid,
    this.messages = const [],
    this.createdAt,
  }) : super(id);

  String get lastMessage => messages.isNotEmpty ? messages.last.content : '';

  String lastSeenTime() {
    if (messages.isEmpty) return '';
    final lastMessageCreatedTime = messages.last.createdAt;
    DateFormat formatter;
    if (lastMessageCreatedTime.difference(DateTime.now()).inDays != 0) {
      formatter = DateFormat.Md();
    } else {
      formatter = DateFormat.Hm();
    }
    return formatter.format(lastMessageCreatedTime);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoom &&
          runtimeType == other.runtimeType &&
          internalId == other.internalId;

  @override
  int get hashCode => internalId.hashCode;

  static final factory = ChatRoomFactory();

  @override
  void updateFromJson(Map json) {}

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }
}

class ChatRoomFactory extends UpdatableModelFactory<ChatRoom> {
  @override
  ChatRoom makeFromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as String,
      rawName: parseGroupName(json['name'] as String,
          isGroup: json['isGroup'] as bool?),
      isGroup: json['isGroup'] as bool,
      memberUuids: List<String>.from(json['members'] as List<dynamic>),
      creatorUuid: json['creator'] as String,
      messages: parseMessages((json['messages'] as List<dynamic>?) ?? []),
      createdAt: parseDateTime(json['createdAt'] as String?),
    );
  }

  List<Message> parseMessages(List<dynamic> list) {
    return list
        .map((message) => Message.fromJson(message as Map<String, dynamic>))
        .toList();
  }

  DateTime? parseDateTime(String? time) {
    return (time == null) ? null : DateTime.parse(time).toLocal();
  }
}

List<User> parseMember(Map<String, dynamic> json) {
  return [];
}

String parseGroupName(String rawName, {bool? isGroup = false}) {
  if (isGroup ?? false) return rawName;
  final loggedInUserUuid = injector<LoggedInUser>().user?.uuid;
  return rawName.replaceFirst(loggedInUserUuid!, '').replaceFirst('_', '');
}
