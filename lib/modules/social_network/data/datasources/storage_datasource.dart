import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/url_parser.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

@injectable
class StorageDatasource {
  // ignore: constant_identifier_names
  static const String POST_MEDIA_SUBFOLDER = 'medias/{post_uuid}';
  // ignore: constant_identifier_names
  static const String AVATAR_SUBFOLDER = 'avatars/{user_uuid}';

  final UrlParser _urlParser;

  StorageDatasource(this._urlParser);

  Future<String?> _getPresignedUrl(String objectName) async {
    return '';
  }

  Future<String?> getPresignedUrlForPostMedia(
      String objectName, String postUuid) async {
    final String subFolder =
        _urlParser.parse(POST_MEDIA_SUBFOLDER, {'post_uuid': postUuid});

    return _getPresignedUrl('$subFolder/$objectName');
  }

  Future<String?> putObjectByPresignedUrl(String url, File object) async {
    return '';
  }

  Future addMediaToPost(List<MediaFileUploader> medias) async {}
}
