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
  // view variables
  late List<User> members;
  User? privateChatPartner;
  late List<Message> _messages;
  bool isGroup;
  String? creatorUuid;

  ChatRoom({
    required this.id,
    required this.rawName,
    required this.isGroup,
    required this.memberUuids,
    this.creatorUuid,
    List<Message> messages = const [],
  }) : super(id) {
    _messages = messages;
  }

  String get firstMessage => messages.isNotEmpty ? messages.first.content : '';

  List<Message> get messages => _messages.toSet().toList();

  String lastActiveTime() {
    if (messages.isEmpty) return '';
    final lastMessageCreatedTime = messages.first.createdAt;
    DateFormat formatter;
    if (lastMessageCreatedTime.difference(DateTime.now()).inDays != 0) {
      formatter = DateFormat.Md();
    } else {
      formatter = DateFormat.Hm();
    }
    return formatter.format(lastMessageCreatedTime);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatRoom && runtimeType == other.runtimeType && internalId == other.internalId;

  @override
  int get hashCode => internalId.hashCode;

  static final factory = ChatRoomFactory();

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('messages')) {
      final newMessages = factory.parseMessages((json['messages'] as List<dynamic>?) ?? []);
      if (newMessages.isEmpty) {
        _messages = newMessages;
      } else {
        updateMessages(newMessages);
      }
    }
  }

  static const int maxStoredMessages = 50;

  void updateMessages(List<Message> newMessages) {
    final List<Message> tempMessage = [..._messages, ...newMessages];
    tempMessage.sort();
    final tempMessageSet = tempMessage.toSet();
    if (tempMessageSet.length > maxStoredMessages) {
      _messages = tempMessageSet.take(maxStoredMessages).toList();
    } else {
      _messages = tempMessageSet.toList();
    }
    notifyUpdate();
  }

  void updateMessage(Message newMessage) {
    _messages.insert(0, newMessage);
    if (_messages.length > maxStoredMessages) {
      _messages.sublist(0, maxStoredMessages);
    }
    notifyUpdate();
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return factory.fromJson(json);
  }

  bool isMyMessage(Message message) {
    return message.roomId == id;
  }
}

class ChatRoomFactory extends UpdatableModelFactory<ChatRoom> {
  @override
  ChatRoom makeFromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as String,
      rawName: parseGroupName(json['name'] as String, isGroup: json['isGroup'] as bool?),
      isGroup: json['isGroup'] as bool,
      memberUuids: List<String>.from(json['members'] as List<dynamic>),
      creatorUuid: json['creator'] as String,
      messages: parseMessages((json['messages'] as List<dynamic>?) ?? []),
    );
  }

  List<Message> parseMessages(List<dynamic> list) {
    return list.map((message) => Message.fromJson(message as Map<String, dynamic>)).toSet().toList();
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
