import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/data/datasources/chat_datasource.dart';
import 'package:meowoof/modules/chat/data/datasources/request_contact_datasource.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';
import 'package:meowoof/modules/social_network/data/datasources/storage_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ChatRepository {
  final ChatDatasource _datasource;
  final StorageDatasource _storageDatasource;
  final RequestContactDatasource _requestContactDatasource;

  ChatRepository(
    this._datasource,
    this._storageDatasource,
    this._requestContactDatasource,
  );

  Future<List<ChatRoom>> getChatRooms(int limit, int skip,
      {bool? isEveryoneCanChatWithMe}) {
    return _datasource.getChatRooms(limit, skip,
        isEveryoneCanChatWithMe: isEveryoneCanChatWithMe);
  }

  Future<String> getPresignedChatMediaUrl(String fileName, String chatRoomId) {
    return _storageDatasource.getPresignedChatMediaUrl(fileName, chatRoomId);
  }

  Future<List<Message>> getMessagesWithRoomId(
      int limit, int skip, String roomId) {
    return _datasource.getMessagesWithRoomId(limit, skip, roomId);
  }

  Future<Message> sendMessages(Message message) {
    return _datasource.sendMessages(message);
  }

  Future<ChatRoom> initPrivateChatRoom(User user) {
    return _datasource.initPrivateChatRoom(user);
  }

  Future<List<RequestContact>> getRequestMessagesFromUser() {
    return _requestContactDatasource.getRequestMessagesFromUser();
  }

  Future<List<RequestContact>> getRequestMessagesToUser() {
    return _requestContactDatasource.getRequestMessagesToUser();
  }

  Future<RequestContact> acceptRequestMessages(RequestContact requestContact) {
    return _requestContactDatasource.acceptRequestMessages(requestContact);
  }

  Future<RequestContact> denyRequestMessages(RequestContact requestContact) {
    return _requestContactDatasource.denyRequestMessages(requestContact);
  }

  Future<int> countUserRequestMessages() {
    return _requestContactDatasource.countUserRequestMessage();
  }

  Future updateContentRequestMessages(
      RequestContact requestContact, String content) {
    return _requestContactDatasource.updateContentRequestMessage(
        requestContact, content);
  }
}
