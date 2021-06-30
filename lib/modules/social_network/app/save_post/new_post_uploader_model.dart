import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/file_helper.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/create_draft_post_usecase.dart';
import 'package:suga_core/suga_core.dart';
import 'package:mime/mime.dart';

@injectable
class NewPostUploaderModel extends BaseViewModel {
  late NewPostData data;
  Rx<PostUploaderStatus> status = PostUploaderStatus.idle.obs;
  RxString statusMessage = ''.obs;

  final CreateDraftPostUsecase _createDraftPostUsecase;

  NewPostUploaderModel(this._createDraftPostUsecase);

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
      // compress image

      data.compressedMedia.add(postMediaItem);
    } else if (postMediaItem.isVideo) {
      // compress video

      data.compressedMedia.add(postMediaItem);
    } else {
      printError(info: 'Unsupported media type for compression');
    }
    data.remainingMediaToCompress.remove(postMediaItem);
  }

  Future _addPostMedia() async {
    return Future.wait(data.remainingCompressedMediaToUpload
        .map(_uploadPostMediaItem)
        .toList());
  }

  Future _uploadPostMediaItem(MediaFile mediaFile) async {
    // get presigned URL

    // upload media to s3

    // Add media URL to createdDraftPost

    data.remainingCompressedMediaToUpload.remove(mediaFile);
  }

  Future _publishPost() async {
    // _publishPost
  }
}
