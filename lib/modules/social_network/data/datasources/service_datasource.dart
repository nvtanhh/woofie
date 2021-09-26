import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ServiceDatasource {
  final HasuraConnect _hasuraConnect;

  ServiceDatasource(
    this._hasuraConnect,
  );

  Future<List<Service>> getServices() async {
    final query = """
query MyQuery {
  pet_services {
    id
    location {
      id
      lat
      long
      name
    }
    website
    social_contact
    phone_number
    name
    logo
    location_id
    description
  }
}

    """;
    final data = await _hasuraConnect.query(query);
    final listPost = GetMapFromHasura.getMap(data as Map)["pet_services"] as List;
    return listPost.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Service>> searchService(String keyWord, int limit, int offset) async {
    final query = """
    query MyQuery {
      pet_services(where: {name: {_ilike: "%$keyWord%"}}, limit: $limit, offset: $offset, order_by: {name: desc}) {
      google_map_link
      description
      id
      location_id
      logo
      name
      phone_number
      social_contact
      website
      location {
      id
      lat
      long
      name
      }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final list = GetMapFromHasura.getMap(data as Map)["pet_services"] as List;
    return list.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList();
  }
}
