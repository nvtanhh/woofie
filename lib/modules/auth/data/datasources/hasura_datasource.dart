import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class HasuraDatasource {
  final HasuraConnect _hasuraConnect;

  HasuraDatasource(this._hasuraConnect);

  Future<bool> checkUseHavePet(String userUUID) async {
    final queryCountPetFromUser = """
   query MyQuery {
  pet_owners_aggregate(where: {owner_uuid: {_eq: "$userUUID"}}) {
    aggregate {
      count(columns: owner_uuid)
    }}}
    """;
    final data = await _hasuraConnect.query(queryCountPetFromUser);
    try {
      final listUser = GetMapFromHasura.getMap(data as Map)["pet_owners_aggregate"] as Map;
      if ((listUser["aggregate"]["count"] as int) > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  Future<User?> getUser(String uuid) async {
    final queryGetUser = """
   query MyQuery {
   users(where: {uuid: {_eq: "$uuid"}}) {
    avatar_current {
      type
      url
      id
    }
    email
    id
    phone_number
    uuid
    dob
    bio
    }
    }
    """;
    final data = await _hasuraConnect.query(queryGetUser);
    final listUser = GetMapFromHasura.getMap(data as Map)["users"] as List;
    return User.fromJson(listUser[0] as Map<String, dynamic>);
  }
}
