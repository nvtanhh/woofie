import 'dart:collection';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/new_post_uploader.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/refresh_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/edit_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_presigned_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class PostService extends BaseViewModel {
  final BottomSheetService _bottomSheetService;
  final MediaService _mediaService;
  final GetPresignedUrlUsecase _getPresignedUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final EditPostUsecase _editPostUsecase;
  final LikePostUsecase _likePostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final ToastService _toastService;
  final RefreshPostsUsecase _refreshPostsUsecase;
  RxList<Widget> prependedWidgets = <Widget>[].obs;
  RxList<NewPostData> newPostsData = <NewPostData>[].obs;
  final HashMap _prependedWidgetsRemover = HashMap<String, VoidCallback>();
  late PagingController<int, Post> pagingController;

  PostService(
    this._mediaService,
    this._getPresignedUrlUsecase,
    this._uploadMediaUsecase,
    this._editPostUsecase,
    this._likePostUsecase,
    this._bottomSheetService,
    this._deletePostUsecase,
    this._toastService,
    this._refreshPostsUsecase,
  );

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    super.initState();
  }

  void onPostDeleted(int index) {
    pagingController.itemList?.removeAt(index);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    pagingController.notifyListeners();
  }

  Future onPostEdited(EditedPostData editedPostData) async {
    if (editedPostData.newAddedFiles != null && editedPostData.newAddedFiles!.isNotEmpty) {
      editedPostData.newAddedMedias = await _startUploadNewMediaFiles(editedPostData.newAddedFiles!, editedPostData.originPost);
    }

    final bool isEditSuccessed = await _startEditPost(editedPostData);
    if (isEditSuccessed) {
      _refreshPost(editedPostData.originPost.id);
    } else {
      _onPostEditFailed();
    }
  }

  void onLikeClick(int idPost) {
    call(
      () => _likePostUsecase.call(idPost),
      showLoading: false,
      onFailure: (err) {},
    );
  }

  Future onWantsToCreateNewPost() async {
    final NewPostData? newPostData = await injector<NavigationService>().navigateToCreatePost();
    if (newPostData != null) {
      newPostsData.add(newPostData);
      _prepenedNewPostUploadingWidget(newPostData);
    }
  }

  void onPostClick(Post post) {
    injector<NavigationService>().navigateToPostDetail(post);
  }

  void onCommentClick(Post post) {
    _bottomSheetService.showComments(post, Get.context!);
  }

  void onDeletePost(Post post, int index) {
    bool isSuccess = false;
    call(
      () async {
        isSuccess = await _deletePostUsecase.call(post.id);
      },
      onSuccess: () {
        if (isSuccess) {
          _toastService.success(message: 'Post deleted!', context: Get.context!);
        }
        pagingController.itemList?.removeAt(index);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      onFailure: (err) {
        _toastService.success(message: err.toString(), context: Get.context!);
      },
    );
  }

  Future onWantsToEditPost(Post post) async {
    final EditedPostData? editedPostData = await injector<NavigationService>().navigateToEditPost(post);

    if (editedPostData != null) {
      await onPostEdited(editedPostData);
    }
  }

  Future<List<UploadedMedia>> _startUploadNewMediaFiles(List<MediaFile> newAddedFiles, Post oldPost) async {
    final List<MediaFile> compressMediaFiles = await Future.wait(newAddedFiles.map((file) async => _compressPostMediaItem(file)).toList());
    final List<UploadedMedia> storedMediaFiles = [];

    for (final compressedFile in compressMediaFiles) {
      final uploadedFile = await _storeMediaItem(compressedFile, oldPost);
      if (uploadedFile != null) {
        storedMediaFiles.add(uploadedFile);
      }
    }

    return storedMediaFiles;
  }

  Future<bool> _startEditPost(EditedPostData editedPostData) async {
    bool isEdited = false;
    await call(() async {
      isEdited = await _editPostUsecase.call(editedPostData);
    }, onFailure: (error) {
      printError(info: error.toString());
    });
    return isEdited;
  }

  Future<MediaFile> _compressPostMediaItem(MediaFile postMediaItem) async {
    if (postMediaItem.isImage) {
      postMediaItem.file = await _mediaService.compressImage(postMediaItem.file);
    } else if (postMediaItem.isVideo) {
      postMediaItem.file = await _mediaService.compressVideo(postMediaItem.file);
    } else {
      printError(info: 'Unsupported media type for compression');
    }
    return postMediaItem;
  }

  Future<UploadedMedia?> _storeMediaItem(MediaFile mediaFile, Post oldPost) async {
    final String fileName = basename(mediaFile.file.path);
    final String postUuid = oldPost.uuid;
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
      return mediaFileUploader;
    }
    return null;
  }

  void _removeNewPostDataUploader(NewPostData newPostData) {
    newPostsData.remove(newPostData);
    _prependedWidgetsRemover[newPostData.newPostUuid]();
  }

  VoidCallback _removeNewPostDataWidget(NewPostUploader newPostUploaderWidget) {
    return () {
      prependedWidgets.remove(newPostUploaderWidget);
    };
  }

  void _showSnackbarCreatePostSuccessful() {
    Get.snackbar(
      "Congrats 🎉",
      "Create new post successful",
      duration: const Duration(seconds: 2),
      backgroundColor: UIColor.accent2,
      colorText: UIColor.white,
    );
  }

  void _onNewPostDataUploaderCancelled(NewPostData newPostData) {
    _removeNewPostDataUploader(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(Post publishedPost, NewPostData newPostData) {
    _showSnackbarCreatePostSuccessful();
    pagingController.itemList?.insert(0, publishedPost);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    pagingController.notifyListeners();
    _removeNewPostDataUploader(newPostData);
  }

  void _prepenedNewPostUploadingWidget(NewPostData newPostData) {
    final NewPostUploader newPostUploaderWidget = NewPostUploader(
      data: newPostData,
      onPostPublished: _onNewPostDataUploaderPostPublished,
      onCancelled: _onNewPostDataUploaderCancelled,
    );

    prependedWidgets.add(newPostUploaderWidget);
    _prependedWidgetsRemover[newPostData.newPostUuid] = _removeNewPostDataWidget(newPostUploaderWidget);
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

  void _onPostEditFailed() {
    injector<ToastService>()
        .error(message: 'Post update failed! Please try again latter.', duration: const Duration(seconds: 2), context: Get.context!);
  }

  void _refreshPost(int postId) {
    call(
      () => _refreshPostsUsecase.call(postId),
      onSuccess: () {
        injector<ToastService>().success(message: 'Post updated!', context: Get.context!);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      showLoading: false,
    );
  }

  @override
  void disposeState() {
    pagingController.dispose();
    prependedWidgets.close();
    newPostsData.close();
    super.disposeState();
  }
}
