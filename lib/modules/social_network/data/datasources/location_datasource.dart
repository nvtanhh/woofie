import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';

@lazySingleton
class LocationDatasource {
  final HasuraConnect _hasuraConnect;

  LocationDatasource(this._hasuraConnect);

  Future<UserLocation> updateLocation(
      int id, double long, double lat, String name) async {
    final manution = """
mutation MyMutation {
  update_locations_by_pk(pk_columns: {id: $id}, _set: {lat: "$lat", long: "$long", name: "$name"}) {
    id
    lat
    long
    name
  }
}
""";
    final data = await _hasuraConnect.mutation(manution);
    final location =
        GetMapFromHasura.getMap(data as Map)["update_locations_by_pk"]
            as Map<String, dynamic>;
    return UserLocation.fromJson(location);
  }

  Future<UserLocation> createLocation(
      double long, double lat, String name) async {
    final manution = """
mutation MyMutation {
  insert_locations_one(object: {lat: "$long", long: "$lat", name: "$name"}) {
    id
    lat
    long
    name
  }
}
""";
    final data = await _hasuraConnect.mutation(manution);
    final location =
        GetMapFromHasura.getMap(data as Map)["insert_locations_one"]
            as Map<String, dynamic>;
    return UserLocation.fromJson(location);
  }
}
