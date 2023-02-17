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
        active
        pets {
          id
          name
          bio
          avatar_url
          gender
          dob
          pet_type {
            id
            name
          }
        }
        location {
          id
          lat
          long
          name
        }
        setting {
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
