import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class HasuraDatasource {
  final HasuraConnect _hasuraConnect;

  HasuraDatasource(this._hasuraConnect);

  Future<User> getUser(String uuid) async {
    final queryGetUser = """
    query MyQuery {
      users(where: {uuid: {_eq: "$uuid"}}) {
        id
        uuid
        name
        avatar_url
        bio
        email
        dob
        phone_number
        current_pets {
          id
          name
          gender
          bio
          avatar_url
        }
        settings {
          id
          setting
          updated_at
          created_at
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(queryGetUser);
    final listUser = GetMapFromHasura.getMap(data as Map)["users"] as List;
    return User.fromJson(listUser[0] as Map<String, dynamic>);
  }
}
