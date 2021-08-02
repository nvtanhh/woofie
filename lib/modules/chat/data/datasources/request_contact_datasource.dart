import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/object_aggregate.dart';

@lazySingleton
class RequestContactDatasource {
  final HasuraConnect _hasuraConnect;
  final LoggedInUser _loggedInUser;

  RequestContactDatasource(
    this._hasuraConnect,
    this._loggedInUser,
  );

  Future<RequestContact> requestContact(String toUserUUID) async {
    final RequestContact? request = await checkUserRequestedMessage(toUserUUID);
    if (request != null) {
      return request;
    }
    final String mutation = """
   mutation MyMutation {
  insert_request_contact_one(object: {to_user_uuid: "$toUserUUID"}) {
    id
    status
    from_user_uuid
    to_user_uuid
    created_at
    updated_at
  }
  }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final requestContact = GetMapFromHasura.getMap(data as Map)["insert_request_contact_one"] as Map<String, dynamic>;
    return RequestContact.fromJson(requestContact);
  }

  Future<List<RequestContact>> getRequestMessagesFromUser() async {
    return [];
  }

  Future<List<RequestContact>> getRequestMessagesToUser() async {
    final String query = """
  query MyQuery {
  request_contact(where: {_and: {status: {_eq: ${RequestContactStatus.waiting.index}}, to_user_uuid: {_eq: "${_loggedInUser.user!.uuid}"}}}, order_by: {updated_at: desc, created_at: desc}) {
    id
    from_user_uuid
    status
    created_at
    from_user {
      id
      name
      avatar_url
      uuid
    }
  }
  }
    """;
    final data = await _hasuraConnect.query(query);
    final requestContacts = GetMapFromHasura.getMap(data as Map)["request_contact"] as List;
    return requestContacts.map((e) => RequestContact.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RequestContact> acceptRequestMessages(RequestContact requestContact) async {
    final String mutation = """
  mutation MyMutation {
  update_request_contact_by_pk(pk_columns: {id: ${requestContact.id}}, _set: {status: ${RequestContactStatus.accept.index}}) {
    id
    status
    from_user_uuid
    to_user_uuid
    updated_at
  }
  }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final requestContacts = GetMapFromHasura.getMap(data as Map)["update_request_contact_by_pk"] as Map<String, dynamic>;
    return RequestContact.fromJson(requestContacts);
  }

  Future<RequestContact> denyRequestMessages(RequestContact requestContact) async {
    String mutation = """
  mutation MyMutation {
  update_request_contact_by_pk(pk_columns: {id: ${requestContact.id}}, _set: {status: ${RequestContactStatus.deny.index}}) {
    id
    status
    from_user_uuid
    to_user_uuid
    updated_at
  }
  }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final requestContacts = GetMapFromHasura.getMap(data as Map)["update_request_contact_by_pk"] as Map<String, dynamic>;
    return RequestContact.fromJson(requestContacts);
  }

  Future<int> countUserRequestMessage() async {
    final String query = """
  query MyQuery {
  request_contact_aggregate(where: {_and: {to_user_uuid: {_eq: "${_loggedInUser.user!.uuid}"}}, status: {_eq: ${RequestContactStatus.waiting.index}}}) {
    aggregate {
      count(columns: id)
    }
  }
  }
    """;
    final data = await _hasuraConnect.query(query);
    final requestContacts = GetMapFromHasura.getMap(data as Map)["request_contact_aggregate"] as Map<String, dynamic>;
    return ObjectAggregate.fromJson(requestContacts).aggregate.count ?? -1;
  }

  Future<RequestContact?> checkUserRequestedMessage(String toUserUUID) async {
    final String query = """
query MyQuery {
  request_contact(where: {status: {_eq: ${RequestContactStatus.accept.index}}, _and: {from_user_uuid: {_in: ["$toUserUUID","${_loggedInUser.user!.uuid}"]}, to_user_uuid: {_in: ["$toUserUUID","${_loggedInUser.user!.uuid}"]}}}) {
    id
    updated_at
    to_user_uuid
    status
    created_at
    from_user_uuid
    to_user {
      id
      name
      uuid
    }
    from_user {
      id
      uuid
    }
  }
}
    """;
    final data = await _hasuraConnect.query(query);
    final requestContacts = GetMapFromHasura.getMap(data as Map)["request_contact"] as List;
    if (requestContacts.isNotEmpty == true) {
      return RequestContact.fromJson(requestContacts[0] as Map<String, dynamic>);
    }
    return null;
  }
}
