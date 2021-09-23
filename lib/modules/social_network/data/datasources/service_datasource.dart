
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post_reaction.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/service.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';

@lazySingleton
class ServiceDatasource {
  final HasuraConnect _hasuraConnect;

  ServiceDatasource(this._hasuraConnect,);

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
    final listPost =
        GetMapFromHasura.getMap(data as Map)["pet_services"]
            as List;
    return listPost
        .map((e) => Service.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
