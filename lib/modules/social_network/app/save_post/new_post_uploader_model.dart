import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/add_post_media_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/create_draft_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_post_status_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_presign_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_published_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/publish_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
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
  final GetPostStatusUsecase _getPostStatusUsecase;
  final GetPublishedPostUsecase _getPublishedPostUsecase;

  late NewPostData data;
  Rx<PostUploaderStatus> status = PostUploaderStatus.idle.obs;
  RxString statusMessage = ''.obs;

  late Timer? _checkPostStatusTimer;

  CancelableOperation? _getPostStatusOperation;
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
    this._getPostStatusUsecase,
    this._getPublishedPostUsecase,
  );

  @override
  void disposeState() {}

  @override
  void initState() {
    _startUpload();
  }

  // ignore: use_setters_to_change_properties
  void _setStatus(PostUploaderStatus uploadStatus) {
    status.value = uploadStatus;
  }

  void _setStatusMessage(String message) {}

  Future _startUpload() async {
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

    if (data.remainingCompressedMediaToUpload.isNotEmpty) {
      _setStatusMessage('Uploading media...');
      _setStatus(PostUploaderStatus.addingPostMedia);
      await _addPostMedia();
    }

    if (!data.postPublishRequested) {
      _setStatusMessage('Publishing post...');
      _setStatus(PostUploaderStatus.publishing);
      await _publishPost();
      data.postPublishRequested = true;
    }

    _setStatusMessage('Processing post...');
    _setStatus(PostUploaderStatus.processing);
    _ensurePostStatusTimerIsCancelled();

    if (data.createdDraftPostStatus != PostStatus.published) {
      _checkPostStatusTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_getPostStatusOperation != null) return;
        _getPostStatusOperation = CancelableOperation.fromFuture(
          _getPostStatusUsecase.call(data.createdDraftPost!.id),
        );
        final PostStatus status =
            await _getPostStatusOperation!.value as PostStatus;
        printInfo(
            info:
                ' Polling for post published status, got status: ${status.toString()}');
        data.createdDraftPostStatus = status;
        if (data.createdDraftPostStatus == PostStatus.published) {
          printInfo(info: 'Received post status is published');
          _checkPostStatusTimer!.cancel();
          unawaited(_getPublishedPost());
        }
        _getPostStatusOperation = null;
      });
    } else {
      unawaited(_getPublishedPost());
    }
  }

  Future<Post?> _createDraftPost() async {
    try {
      return _createDraftPostUsecase.call(data);
    } catch (error) {
      printError(info: error.toString());
    }
  }

  Future _compressPostMedia() {
    return Future.wait(
        data.remainingMediaToCompress.map(_compressPostMediaItem).toList());
  }

  Future _compressPostMediaItem(MediaFile postMediaItem) async {
    if (postMediaItem.isImage) {
      postMediaItem.file =
          await _mediaService.compressImage(postMediaItem.file);
      data.compressedMedia.add(postMediaItem);
    } else if (postMediaItem.isVideo) {
      postMediaItem.file =
          await _mediaService.compressVideo(postMediaItem.file);
      data.compressedMedia.add(postMediaItem);
    } else {
      printError(info: 'Unsupported media type for compression');
    }
    data.remainingMediaToCompress.remove(postMediaItem);
  }

  Future _addPostMedia() async {
    await Future.wait(
        data.remainingCompressedMediaToUpload.map(_storeMediaItem).toList());
    await _addMediaToPost();
    data.remainingCompressedMediaToAddToPost.clear();
  }

  Future _storeMediaItem(MediaFile mediaFile) async {
    final String fileName = basename(mediaFile.file.path);
    final String postUuid = data.createdDraftPost!.uuid;
    // get presigned URL
    final String? preSignedUrl =
        await _getPresignedUrlUsecase.call(fileName, postUuid);
    // upload media to s3
    String? uploadedMediaUrl;
    if (preSignedUrl != null) {
      uploadedMediaUrl =
          await _uploadMediaUsecase.call(preSignedUrl, mediaFile.file);
    }
    if (uploadedMediaUrl != null) {
      final MediaFileUploader mediaFileUploader =
          MediaFileUploader(uploadedMediaUrl, mediaFile.type.toString());
      data.remainingCompressedMediaToAddToPost.add(mediaFileUploader);
    }
    data.remainingCompressedMediaToUpload.remove(mediaFile);
  }

  Future _addMediaToPost() {
    return _addPostMediaUsecase.call(data.remainingCompressedMediaToAddToPost);
  }

  Future _publishPost() async {
    return _publishUsecase.call(data.createdDraftPost!.id);
  }

  void _ensurePostStatusTimerIsCancelled() {
    if (_checkPostStatusTimer != null && _checkPostStatusTimer!.isActive) {
      _checkPostStatusTimer!.cancel();
    }
  }

  Future<void> _getPublishedPost() async {
    final Post? publishedPost =
        await _getPublishedPostUsecase.call(data.createdDraftPost!.id);
    if (publishedPost != null) onPostPublished(publishedPost, data);

    unawaited(_removeMediaFromCache());
  }

  Future _removeMediaFromCache() async {
    printInfo(info: 'Clearing local cached media for post');
    data.mediaFiles?.forEach(_deleteMediaFile);
    data.compressedMedia.forEach(_deleteMediaFile);

    // if (data?.mediaThumbnail != null &&
    //     data?.mediaFiles?.first != null &&
    //     data.mediaThumbnail != data.media.first) {
    //   data.mediaThumbnail.delete();
    // }
  }

  void _deleteMediaFile(MediaFile file) {
    file.delete();
  }
}
