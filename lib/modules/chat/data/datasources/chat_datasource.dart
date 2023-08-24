import 'dart:convert';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/url_parser.dart';
import 'package:meowoof/core/services/environment_service.dart';
import 'package:meowoof/core/services/httpie.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ChatDatasource {
  final HttpieService _httpieService;
  final UrlParser _urlParser;

  late String baseUrl;

  // ignore: constant_identifier_names
  static const GET_CHAT_ROOM_ENDPOINT = 'api/room';
  // ignore: constant_identifier_names
  static const INIT_CHAT_ROOM_ENDPOINT = 'api/room';
  // ignore: constant_identifier_names
  static const GET_MESSAGES_ENDPOINT = 'api/message/{room_id}';
  // ignore: constant_identifier_names
  static const SEND_MESSAGE_ENDPOINT = 'api/message/{room_id}';

  ChatDatasource(this._httpieService, this._urlParser) {
    baseUrl = injector<EnvironmentService>().chatUrl;
  }

  Future<List<ChatRoom>> getChatRooms(
    int limit,
    int skip, {
    bool? isEveryoneCanChatWithMe,
  }) async {
    final Map<String, dynamic> queryParameters = {};
    queryParameters['limit'] = limit;
    queryParameters['skip'] = skip;
    if (isEveryoneCanChatWithMe != null) {
      queryParameters['acceptEmptyChatRoom'] = !isEveryoneCanChatWithMe;
    }

    final response = await _httpieService.get(
      '$baseUrl/$GET_CHAT_ROOM_ENDPOINT',
      queryParameters: queryParameters,
      appendAuthorizationToken: true,
    );
    if (response.statusCode == 200) {
      final list = (json.decode(response.body) as Map)['rooms'] as List;
      return list
          .map((room) => ChatRoom.fromJson(room as Map<String, dynamic>))
          .toList();
    } else {
      printError(info: 'Failed to get chat rooms: $response');
      throw Error;
    }
  }

  Future<List<Message>> getMessagesWithRoomId(
    int limit,
    int skip,
    String roomId,
  ) async {
    final Map<String, dynamic> queryParameters = {
      'limit': limit,
      'skip': skip,
    };
    final endpoint =
        _urlParser.parse(SEND_MESSAGE_ENDPOINT, {'room_id': roomId});
    final response = await _httpieService.get(
      '$baseUrl/$endpoint',
      queryParameters: queryParameters,
      appendAuthorizationToken: true,
    );
    if (response.statusCode == 200) {
      final list = json.decode(response.body)['messages'] as List;
      return list
          .map((room) => Message.fromJson(room as Map<String, dynamic>))
          .toList();
    } else {
      printError(info: 'Failed to get more messages: $response');
      throw Error;
    }
  }

  Future<Message> sendMessages(Message sendingMessage) async {
    final endpoint = _urlParser
        .parse(SEND_MESSAGE_ENDPOINT, {'room_id': sendingMessage.roomId});

    final body = {
      'content': sendingMessage.content,
      'type': _pareMessageType(sendingMessage.type),
      'createdAt': sendingMessage.createdAt.toString(),
    };
    if (sendingMessage.description != null &&
        sendingMessage.description!.isNotEmpty) {
      body['description'] = sendingMessage.description!;
    }

    final response = await _httpieService.post(
      '$baseUrl/$endpoint',
      body: body,
      appendAuthorizationToken: true,
    );
    if (response.statusCode == 201) {
      final Message newMessage = Message.fromJson(
        json.decode(response.body)['new_message'] as Map<String, dynamic>,
      );
      newMessage.localUuid = sendingMessage.localUuid;
      return newMessage;
    } else {
      printError(info: 'Failed to send message: $response');
      throw Error;
    }
  }

  Future<ChatRoom> initPrivateChatRoom(User user) async {
    final body = {
      'members': [user.uuid],
      'isGroup': false,
    };
    final response = await _httpieService.postJSON(
      '$baseUrl/$INIT_CHAT_ROOM_ENDPOINT',
      body: body,
      appendAuthorizationToken: true,
    );
    if (response.statusCode == 200) {
      return ChatRoom.fromJson(
        (json.decode(response.body) as Map)['chatRoom'] as Map<String, dynamic>,
      );
    } else {
      printError(info: 'Failed to init chat room: $response');
      throw Exception();
    }
  }

  String _pareMessageType(MessageType type) {
    switch (type) {
      case MessageType.text:
        return 'T';
      case MessageType.image:
        return 'I';
      case MessageType.video:
        return 'V';
      case MessageType.post:
        return 'P';
      default:
        return 'T';
    }
  }
}
