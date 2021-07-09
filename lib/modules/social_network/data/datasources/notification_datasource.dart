import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/modules/social_network/domain/models/aggregate/object_aggregate.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';

@lazySingleton
class NotificationDatasource {
  final HasuraConnect _hasuraConnect;

  NotificationDatasource(this._hasuraConnect);

  Future<List<Notification>> getNotification(int limit, int offset) async {
    final query = """
    query MyQuery {
      notifications(limit: $limit, offset: $offset) {
        actor_uuid
        created_at
        id
        is_read
        owner_id
        owner_uuid
        pet_id
        type
        actor {
          id
          name
          avatar_url
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final listPost =
        GetMapFromHasura.getMap(data as Map)["notifications"] as List;
    return listPost
        .map((e) => Notification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> countNotificationUnread() async {
    const query = """
    query MyQuery {
      notifications_aggregate(where: {is_read: {_eq: false}}) {
        aggregate {
          count
        }
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final objectCount =
        GetMapFromHasura.getMap(data as Map)["notifications_aggregate"]
            as Map<String, dynamic>;
    return ObjectAggregate.fromJson(objectCount).aggregate.count ?? 0;
  }

  Future<int?> readAllNotification() async {
    const mutation = """
    mutation MyMutation {
      readAllNotify {
        affectRow
      }
    }
    """;
    final data = await _hasuraConnect.mutation(mutation);
    final affectedRows =
        GetMapFromHasura.getMap(data as Map)["readAllNotify"] as Map;
    return int.tryParse("${affectedRows["affectRow"]}");
  }
}
