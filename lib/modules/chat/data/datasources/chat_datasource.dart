import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/url_parser.dart';
import 'package:meowoof/core/services/httpie.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/configs/backend_config.dart';
import 'package:get/get.dart';

@lazySingleton
class ChatDatasource {
  final HttpieService _httpieService;
  final UrlParser _urlParser;

  late String baseUrl;

  // ignore: constant_identifier_names
  static const GET_CHAT_ROOM_ENDPOINT = 'api/room/';
  // ignore: constant_identifier_names
  static const SEND_MESSAGE_ENDPOINT = 'api/message/{room_id}';

  ChatDatasource(this._httpieService, this._urlParser) {
    baseUrl = BackendConfig.BASE_CHAT_URL;
  }

  Future<List<ChatRoom>> getChatRooms(int limit, int skip) async {
    final Map<String, dynamic> queryParameters = {};
    queryParameters['limit'] = limit;
    queryParameters['skip'] = skip;

    final response = await _httpieService.get(
        '$baseUrl/$GET_CHAT_ROOM_ENDPOINT',
        queryParameters: queryParameters,
        appendAuthorizationToken: true);
    if (response.statusCode == 200) {
      final list = json.decode(response.body)['rooms'] as List;
      return list
          .map((room) => ChatRoom.fromJson(room as Map<String, dynamic>))
          .toList();
    } else {
      printError(info: 'Failed to get chat rooms: $response');
      throw Error;
    }
  }

  Future<List<Message>> getMessages(int limit, int skip) async {
    return [];
  }

  Future<Message> sendMessages({
    required String roomId,
    required String content,
    required MessageType type,
    String? description,
  }) async {
    final endpoint =
        _urlParser.parse(SEND_MESSAGE_ENDPOINT, {'room_id': roomId});

    final body = {
      'content': content,
      'type': _pareMessageType(type),
    };
    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    final response = await _httpieService.post('$baseUrl/$endpoint',
        body: body, appendAuthorizationToken: true);
    if (response.statusCode == 201) {
      return Message.fromJson(
          json.decode(response.body)['new_message'] as Map<String, dynamic>);
    } else {
      printError(info: 'Failed to send message: $response');
      throw Error;
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
      default:
        return 'T';
    }
  }
}
