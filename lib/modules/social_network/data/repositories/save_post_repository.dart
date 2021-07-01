import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/storage_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';

@lazySingleton
class SavePostRepository {
  final PostDatasource _postDatasource;
  final StorageDatasource _storageDatasource;

  SavePostRepository(this._postDatasource, this._storageDatasource);

  Future<Post?> createDraftPost(NewPostData data) async {
    return _postDatasource.createDraftPost(data);
  }

  Future<String?> getPresignedUrl(String objectName, String postUuid) async {
    return _storageDatasource.getPresignedUrlForPostMedia(objectName, postUuid);
  }

  Future<String?> putObjectByPresignedUrl(String url, File object) async {
    return _storageDatasource.putObjectByPresignedUrl(url, object);
  }

  Future addMediaToPost(List<MediaFileUploader> medias) {
    return _storageDatasource.addMediaToPost(medias);
  }

  Future publishPost(int postId) {
    return _postDatasource.publishPost(postId);
  }

  Future<PostStatus?> getPostStatus(int postId) {
    return _postDatasource.getPostStatus(postId);
  }

  Future<Post?> getPublishedPost(int postId) {
    return _postDatasource.getPublishedPost(postId);
  }
}
