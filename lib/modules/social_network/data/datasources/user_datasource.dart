import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class UserDatasource {
  final HasuraConnect _hasuraConnect;

  UserDatasource(this._hasuraConnect);

  Future<String?> followPet(int petID) async {
    final manution = """
  mutation MyMutation {
  follow(pet_id:"$petID") {
    id
  }
  }
""";
    final data = await _hasuraConnect.mutation(manution);
    final affectedRows = GetMapFromHasura.getMap(data as Map)["follow"] as Map;
    return affectedRows["id"] as String;
  }

  Future blockUser(int userID) async {
    return;
  }

  Future<User> getUserProfile(int userId) async {
    final query = """
    query MyQuery {
      users(where: {id: {_eq: $userId}}) {
        id
        uuid
        name
        avatar_url
        bio
        email
        dob
        phone_number
        location_id
        location{
        id
        long
        lat
        name
        }
        current_pets {
          id
          name
          gender
          bio
          avatar_url
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

  Future updateTokenNotify(String tokenNotify) async {
    return OneSignal.shared.setExternalUserId(tokenNotify);
  }

  Future<Map<String, dynamic>> updateUserInformationLocation(int userId, {String? name, String? bio, int? locationId, String? avatarUrl}) async {
    final nName = name == null ? "" : 'name: "$name",';
    final nBio = bio == null ? "" : 'bio: "$bio",';
    final nLocationId = locationId == null ? "" : 'location_id: $locationId,';
    final nPhoneNumber = name == null ? "" : 'phone_number: "$name",';
    final nAvatarUrl = avatarUrl == null ? "" : 'avatar_url: "$avatarUrl"';
    final manution = """
mutation MyMutation {
  update_users_by_pk(pk_columns: {id: $userId}, _set: {$nName $nLocationId $nBio $nAvatarUrl}) {
    avatar_url
    bio
    location_id
    name
  }
}
""";
    final data = await _hasuraConnect.mutation(manution);
    return GetMapFromHasura.getMap(data as Map)["update_users_by_pk"] as Map<String, dynamic>;
  }
}
