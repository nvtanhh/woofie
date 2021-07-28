import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/data/datasources/media_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart';
import 'package:meowoof/modules/social_network/data/datasources/storage_datasource.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';

@lazySingleton
class SavePostRepository {
  final PostDatasource _postDatasource;
  final StorageDatasource _storageDatasource;
  final MediaDatasource _mediaDatasource;

  SavePostRepository(
      this._postDatasource, this._storageDatasource, this._mediaDatasource);

  Future<Post?> createDraftPost(NewPostData data) async {
    return _postDatasource.createDraftPost(data);
  }

  Future<String?> getPresignedPostMediaUrl(
      String objectName, String postUuid) async {
    return _storageDatasource.getPresignedUrlForPostMedia(objectName, postUuid);
  }

  Future<String?> putObjectByPresignedUrl(String url, File object) async {
    final bool? isSuccessed =
        await _storageDatasource.putObjectByPresignedUrl(url, object);
    if (isSuccessed != null && isSuccessed) {
      return url.substring(0, url.indexOf('?'));
    } else {
      return null;
    }
  }

  Future addMediaToPost(List<UploadedMedia> medias, int id) {
    return _storageDatasource.addMediaToPost(medias, id);
  }

  Future<Post?> publishPost(int postId) {
    return _postDatasource.publishPost(postId);
  }

  Future<PostStatus?> getPostStatus(int postId) {
    return _postDatasource.getPostStatusWithId(postId);
  }

  Future<Post?> getPublishedPost(int postId) {
    return _postDatasource.getPostWithId(postId);
  }

  Future<bool> deleteMedia(List<int> mediaIds) {
    return _mediaDatasource.deleteMedia(mediaIds);
  }

  Future<bool> editPost(EditedPostData editedPostData) {
    return _postDatasource.editPost(editedPostData);
  }

  Future<String?> getPresignedAvatarUserUrl(String fileName) {
    return _storageDatasource.getPresignedUrlForAvatar(fileName);
  }

  Future<String?> getPresignedAvatarPetUrl(String fileName, String petUUID) {
    return _storageDatasource.getPresignedAvatarPetUrl(fileName, petUUID);
  }
}
