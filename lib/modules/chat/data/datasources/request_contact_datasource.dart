import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/request_contact.dart';

@lazySingleton
class RequestContactDatasource {
  final HasuraConnect _hasuraConnect;

  RequestContactDatasource(this._hasuraConnect);

  Future<RequestContact> requestContact(String toUserUUID) async {
    final String mutation = """
   mutation MyMutation {
  insert_request_contact_one(object: {to_user_uuid: "$toUserUUID"}) {
    id
    accept
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
}
