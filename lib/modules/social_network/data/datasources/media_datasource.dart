import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';

@lazySingleton
class MediaDatasource {
  final HasuraConnect _hasuraConnect;

  MediaDatasource(this._hasuraConnect);

  Future<bool> deleteMedia(List<int> mediaIds) async {
    final String query = """
    mutation MyMutation {
      delete_medias(where: {id: {_in: ${mediaIds.toString()}}}){
        affected_rows
      }
    }
    """;
    final data = await _hasuraConnect.query(query);
    final json = GetMapFromHasura.getMap(data as Map)["delete_medias"];
    return json['affected_rows'] as int == mediaIds.length;
  }
}
