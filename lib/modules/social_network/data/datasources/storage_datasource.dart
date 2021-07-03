import 'dart:io';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/core/helpers/url_parser.dart';
import 'package:meowoof/core/services/httpie.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

@injectable
class StorageDatasource {
  // ignore: constant_identifier_names
  static const String POST_MEDIA_SUBFOLDER = '{post_uuid}';
  // ignore: constant_identifier_names
  static const String AVATAR_SUBFOLDER = '{user_uuid}';

  final UrlParser _urlParser;

  final HasuraConnect _hasuraConnect;

  final HttpieService _httpieService;

  StorageDatasource(
    this._urlParser,
    this._hasuraConnect,
    this._httpieService,
  );

  Future<String?> getPresignedUrlForPostMedia(String objectName, String postUuid) async {
    final String subFolder = _urlParser.parse(POST_MEDIA_SUBFOLDER, {'post_uuid': postUuid});

    return _getPresignedUrl('$subFolder/$objectName');
  }

  Future<String?> _getPresignedUrl(String objectName) async {
    final String query = """
    mutation MyMutation {
      get_presigned_url(fileName: "$objectName") {
        url
      }
    }
    """;
    final data = await _hasuraConnect.mutation(query);
    final result = GetMapFromHasura.getMap(data as Map)["get_presigned_url"] as Map;
    return result['url'] as String;
  }

  Future<bool?> putObjectByPresignedUrl(String url, File object) async {
    final response = await _httpieService.putBinary(url, object);
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Put object to s3 failed');
  }

  Future addMediaToPost(List<MediaFileUploader> medias, int postId) async {
    late String mediasData;
    if (medias.isNotEmpty) {
      mediasData = medias.map((e) => _mediaToJson(e, postId)).toList().toString();
    } else {
      mediasData = '[]';
    }

    final String query = """
    mutation MyMutation {
      insert_medias(objects: $mediasData) {
        affected_rows
      }
    }
    """;

    final data = await _hasuraConnect.mutation(query);
    final result = GetMapFromHasura.getMap(data as Map)["insert_medias"] as Map;
    final int affectedRows = result['affected_rows'] as int;
    if (affectedRows == medias.length) {
      return true;
    } else {
      return false;
    }
  }

  String _mediaToJson(MediaFileUploader e, int id) {
    return '{post_id: $id, url: "${e.uploadedUrl}", type: ${e.type}}';
  }
}
