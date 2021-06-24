import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class UserDatasource {
  final HasuraConnect _hasuraConnect;

  UserDatasource(this._hasuraConnect);

  Future followPet(int petID) async {
    return;
  }

  Future blockUser(int userID) async {
    return;
  }

  Future<User> getUserProfile(int userId) async {
    final query = """
    query MyQuery {
  users(where: {id: {_eq: $userId}}) {
    avatar_current {
      id
      type
      url
    }
    id
    dob
    email
    name
    phone_number
    bio
    uuid
    pet_owners {
      pet {
        id
        bio
        name
        avatar_current {
          id
          url
        }
      }
    }
  }
}
""";
    final data = await _hasuraConnect.query(query);
    final listUser = GetMapFromHasura.getMap(data as Map)["users"] as List;
    return User.fromJson(listUser[0] as Map<String, dynamic>);
  }

  Future reportUser(int userID) async {
    return;
  }
}
