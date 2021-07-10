import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/add_post_media_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/create_draft_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_presigned_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_published_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/publish_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewPostUploaderModel extends BaseViewModel {
  final MediaService _mediaService;

  final CreateDraftPostUsecase _createDraftPostUsecase;
  final GetPresignedUrlUsecase _getPresignedUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final AddPostMediaUsecase _addPostMediaUsecase;
  final PublishUsecase _publishUsecase;
  final GetPublishedPostUsecase _getPublishedPostUsecase;
  final DeletePostUsecase _deletePostUsecase;

  late NewPostData data;
  Rx<PostUploaderStatus> status = PostUploaderStatus.idle.obs;
  RxString statusMessage = ''.obs;

  final double mediaPreviewSize = 40;

  CancelableOperation? _uploadPostOperation;

  late Function(NewPostData) onCancelled;

  late Function(Post, NewPostData) onPostPublished;

  NewPostUploaderModel(
    this._mediaService,
    this._createDraftPostUsecase,
    this._getPresignedUrlUsecase,
    this._uploadMediaUsecase,
    this._addPostMediaUsecase,
    this._publishUsecase,
    this._getPublishedPostUsecase,
    this._deletePostUsecase,
  );

  @override
  void disposeState() {
    _uploadPostOperation?.cancel();
  }

  @override
  void initState() {
    _startUpload();
  }

  // ignore: use_setters_to_change_properties
  void _setStatus(PostUploaderStatus uploadStatus) {
    status.value = uploadStatus;
  }

  // ignore: use_setters_to_change_properties
  void _setStatusMessage(String message) {
    statusMessage.value = message;
  }

  void _startUpload() {
    _uploadPostOperation = CancelableOperation.fromFuture(_uploadPost());
  }

  Future _uploadPost() async {
    try {
      if (data.createdDraftPost == null) {
        _setStatus(PostUploaderStatus.creatingPost);
        _setStatusMessage('Creating post...');
        data.createdDraftPost = await _createDraftPost();
      }

      if (data.remainingMediaToCompress.isNotEmpty) {
        _setStatusMessage('Compressing media...');
        _setStatus(PostUploaderStatus.compressingPostMedia);
        await _compressPostMedia();
      }

      if (data.compressedMedia.isNotEmpty) {
        _setStatusMessage('Uploading media...');
        _setStatus(PostUploaderStatus.addingPostMedia);
        await _addPostMedia();
      }

      late Post? publishedPost;
      if (!data.postPublishRequested) {
        _setStatusMessage('Publishing post...');
        _setStatus(PostUploaderStatus.publishing);
        publishedPost = await _publishPost();
        data.postPublishRequested = true;
      }

      _setStatusMessage('Processing post...');
      _setStatus(PostUploaderStatus.processing);

      if (publishedPost != null) _onPostPublished(publishedPost);
    } catch (error) {
      _setStatus(PostUploaderStatus.failed);
      _setStatusMessage('Upload failded.');
    }
  }

  Future<Post?> _createDraftPost() async {
    try {
      return _createDraftPostUsecase.call(data);
    } catch (error) {
      printError(info: error.toString());
    }
  }

  Future _compressPostMedia() async {
    return Future.wait(data.remainingMediaToCompress.map(_compressPostMediaItem));
  }

  Future _compressPostMediaItem(MediaFile postMediaItem) async {
    if (postMediaItem.isImage) {
      postMediaItem.file = await _mediaService.compressImage(postMediaItem.file);
      data.compressedMedia.add(postMediaItem);
    } else if (postMediaItem.isVideo) {
      postMediaItem.file = await _mediaService.compressVideo(postMediaItem.file);
      data.compressedMedia.add(postMediaItem);
    } else {
      printError(info: 'Unsupported media type for compression');
    }
    data.remainingMediaToCompress.remove(postMediaItem);
  }

  Future _addPostMedia() async {
    await Future.wait(data.compressedMedia.map(_storeMediaItem));
    await _addMediaToPost();
    data.uploadedMediasToAddToPost.clear();
  }

  Future _storeMediaItem(MediaFile mediaFile) async {
    final String fileName = basename(mediaFile.file.path);
    final String postUuid = data.createdDraftPost!.uuid;
    // get presigned URL
    printInfo(info: 'Getting presigned URL');
    final String? preSignedUrl = await _getPresignedUrlUsecase.call(fileName, postUuid);
    // upload media to s3
    String? uploadedMediaUrl;
    if (preSignedUrl != null) {
      printInfo(info: 'Uploading media to s3');
      uploadedMediaUrl = await _uploadMediaUsecase.call(preSignedUrl, mediaFile.file);
    }
    if (uploadedMediaUrl != null) {
      final UploadedMedia mediaFileUploader = UploadedMedia(uploadedMediaUrl, _convertToMediaTypeCode(mediaFile.type));
      data.uploadedMediasToAddToPost.add(mediaFileUploader);
      data.compressedMedia.remove(mediaFile);
    }
  }

  Future _addMediaToPost() async {
    return _addPostMediaUsecase.call(data.uploadedMediasToAddToPost, data.createdDraftPost!.id);
  }

  Future<Post?> _publishPost() async {
    return _publishUsecase.call(data.createdDraftPost!.id);
  }

  Future _removeMediaFromCache() async {
    printInfo(info: 'Clearing local cached media for post');
    data.mediaFiles?.forEach(_deleteMediaFile);
    data.compressedMedia.forEach(_deleteMediaFile);
  }

  void _deleteMediaFile(MediaFile file) {
    file.delete();
  }

  Future<File?> getMediaThumbnail() async {
    if (data.mediaThumbnail != null) {
      return data.mediaThumbnail!;
    }

    final File mediaToPreview = data.mediaFiles!.first.file;
    File? mediaThumbnail;

    final String? mediaMime = lookupMimeType(mediaToPreview.path);
    if (mediaMime != null) {
      final String mediaMimeType = mediaMime.split('/')[0];

      if (mediaMimeType == 'image') {
        mediaThumbnail = mediaToPreview;
      } else if (mediaMimeType == 'video') {
        mediaThumbnail = await _mediaService.getVideoThumbnail(mediaToPreview);
      } else {
        printError(info: 'Unsupported media type for preview thumbnail');
      }

      data.mediaThumbnail = mediaThumbnail;

      return mediaThumbnail;
    }
  }

  Future onWantsToCancel() async {
    if (status.value == PostUploaderStatus.cancelling) return;
    _setStatus(PostUploaderStatus.cancelling);
    _setStatusMessage('Cancelling');

    await _deletePostDraftPost();

    _setStatus(PostUploaderStatus.cancelled);
    onCancelled(data);
    unawaited(_removeMediaFromCache());
  }

  Future<bool> _deletePostDraftPost() async {
    final Post? post = data.createdDraftPost;
    if (post != null) {
      bool isSuccess = false;
      await call(
        () async {
          isSuccess = await _deletePostUsecase.call(post.id);
        },
        onSuccess: () {
          if (isSuccess) {
            printInfo(info: 'Successfully deleted post');
          }
          return true;
        },
        onFailure: (error) {
          printError(info: 'Failed to delete post wit error: ${error.toString()}');
          return false;
        },
      );
    }
    return true;
  }

  void onWantsToRetry() {
    if (status.value == PostUploaderStatus.creatingPost || status.value == PostUploaderStatus.addingPostMedia) return;

    printInfo(info: 'Retrying');
    _startUpload();
  }

  int _convertToMediaTypeCode(FileType? type) {
    if (type != null) {
      switch (type) {
        case FileType.image:
          return 0;
        case FileType.video:
          return 1;
        default:
      }
    }
    throw Exception('Unsupported media type for post');
  }

  void _onPostPublished(Post publishedPost) {
    onPostPublished(publishedPost, data);
    unawaited(_removeMediaFromCache());
  }
}
