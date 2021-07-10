import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/new_post_uploader.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/delete_media_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/edit_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_presigned_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewFeedWidgetModel extends BaseViewModel {
  final BottomSheetService bottomSheetService = injector<BottomSheetService>();
  final GetPostsUsecase _getPostsUsecase;
  final DeleteMediaUsecase _deleteMediaUsecase;
  final MediaService _mediaService;
  final GetPresignedUrlUsecase _getPresignedUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final EditPostUsecase _editPostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final LikePostUsecase _likePostUsecase;

  List<Post> posts = [];
  late PagingController<int, Post> pagingController;
  final int pageSize = 10;
  int nextPageKey = 0;
  DateTime? dateTimeValueLast;
  CancelableOperation? cancelableOperation;
  RxList<Widget> prependedWidgets = <Widget>[].obs;
  RxList<NewPostData> newPostsData = <NewPostData>[].obs;

  final HashMap _prependedWidgetsRemover = HashMap<String, VoidCallback>();

  late DateTime _lastRefeshTime;

  static const int _refreshIntervalLimitSecond = 3;

  NewFeedWidgetModel(
    this._getPostsUsecase,
    this._deleteMediaUsecase,
    this._mediaService,
    this._getPresignedUrlUsecase,
    this._uploadMediaUsecase,
    this._editPostUsecase,
    this._deletePostUsecase,
    this._likePostUsecase,
  ) {
    pagingController = PagingController(firstPageKey: 0);
  }

  @override
  void disposeState() {
    cancelableOperation?.cancel();
    pagingController.dispose();
    super.disposeState();
  }

  void getPosts() {
    call(
      () async => posts = await _getPostsUsecase.call(),
    );
  }

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener(
      (pageKey) {
        cancelableOperation =
            CancelableOperation.fromFuture(_loadMorePost(pageKey));
      },
    );
    _lastRefeshTime = DateTime.now();
  }

  void onPostDeleted(int index) {
    pagingController.itemList?.removeAt(index);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    pagingController.notifyListeners();
  }

  Future onWantsToCreateNewPost() async {
    final NewPostData? newPostData =
        await injector<NavigationService>().navigateToCreatePost();
    if (newPostData != null) {
      newPostsData.add(newPostData);
      _prepenedNewPostUploadingWidget(newPostData);
    }
  }

  Future _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getPostsUsecase.call(
          offset: nextPageKey, lastValue: dateTimeValueLast);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        nextPageKey = pageKey + newItems.length;
        dateTimeValueLast = newItems.last.createdAt;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void _onNewPostDataUploaderCancelled(NewPostData newPostData) {
    _removeNewPostDataUploader(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(
      Post publishedPost, NewPostData newPostData) {
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
    _prependedWidgetsRemover[newPostData.newPostUuid] =
        _removeNewPostDataWidget(newPostUploaderWidget);
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

  Future<void> onRefresh() async {
    if (_isCanRefesh()) {
      final newItems = await _getPostsUsecase.call(limit: pageSize);
      pagingController.itemList = newItems;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      pagingController.notifyListeners();
    } else {
      printInfo(info: 'Please wait $_refreshIntervalLimitSecond seconds');
    }
  }

  bool _isCanRefesh() {
    return DateTime.now().difference(_lastRefeshTime).inSeconds >
        _refreshIntervalLimitSecond;
  }

  void onCommentClick(int idPost) {
    bottomSheetService.showComments(idPost);
  }

  void onDeletePost(Post post, int index) {
    bool isSuccess = false;
    call(
      () async {
        isSuccess = await _deletePostUsecase.call(post.id);
      },
      onSuccess: () {
        if (isSuccess) {
          injector<ToastService>()
              .success(message: 'Post deleted!', context: Get.context!);
        }
        pagingController.itemList?.removeAt(index);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      onFailure: (err) {
        injector<ToastService>()
            .success(message: err.toString(), context: Get.context!);
      },
    );
  }

  void onLikeClick(int idPost) {
    call(
      () => _likePostUsecase.call(idPost),
      showLoading: false,
      onFailure: (err) {},
    );
  }

  void onPostClick(Post post) {
    injector<NavigationService>().navigateToPostDetail(post);
  }

  Future onWantsToEditPost(Post post) async {
    final EditedPostData? editedPostData =
        await injector<NavigationService>().navigateToEditPost(post);

    if (editedPostData != null) {
      await onPostEdited(editedPostData);
    }
  }

  Future onPostEdited(EditedPostData editedPostData) async {
    if (editedPostData.deletedMedias != null &&
        editedPostData.deletedMedias!.isNotEmpty) {
      await _deleteMedia(editedPostData.deletedMedias!);
    }
    if (editedPostData.newAddedFiles != null &&
        editedPostData.newAddedFiles!.isNotEmpty) {
      editedPostData.newAddedMedias = await _startUploadNewMediaFiles(
          editedPostData.newAddedFiles!, editedPostData.originPost);
    }

    await call(
      () async {
        Post editedPost = await _editPostUsecase.call(editedPostData);
      },
    );
  }

  Future _deleteMedia(List<Media> deletedMedias) async {
    await call(
      () async {
        final List<int> ids = deletedMedias.map((media) => media.id).toList();
        await _deleteMediaUsecase.call(ids);
      },
    );
  }

  Future<List<UploadedMedia>> _startUploadNewMediaFiles(
      List<MediaFile> newAddedFiles, Post oldPost) async {
    final List<MediaFile> compressMediaFiles = await Future.wait(newAddedFiles
        .map((file) async => _compressPostMediaItem(file))
        .toList());
    final List<UploadedMedia?> storedMediaFiles = await Future.wait(
        compressMediaFiles
            .map((file) async => _storeMediaItem(file, oldPost))
            .toList());

    storedMediaFiles.where((file) => file != null).toList();

    return storedMediaFiles as List<UploadedMedia>;
  }

  Future<MediaFile> _compressPostMediaItem(MediaFile postMediaItem) async {
    if (postMediaItem.isImage) {
      postMediaItem.file =
          await _mediaService.compressImage(postMediaItem.file);
    } else if (postMediaItem.isVideo) {
      postMediaItem.file =
          await _mediaService.compressVideo(postMediaItem.file);
    } else {
      printError(info: 'Unsupported media type for compression');
    }
    return postMediaItem;
  }

  Future<UploadedMedia?> _storeMediaItem(
      MediaFile mediaFile, Post oldPost) async {
    final String fileName = basename(mediaFile.file.path);
    final String postUuid = oldPost.uuid;
    // get presigned URL
    printInfo(info: 'Getting presigned URL');
    final String? preSignedUrl =
        await _getPresignedUrlUsecase.call(fileName, postUuid);
    // upload media to s3
    String? uploadedMediaUrl;
    if (preSignedUrl != null) {
      printInfo(info: 'Uploading media to s3');
      uploadedMediaUrl =
          await _uploadMediaUsecase.call(preSignedUrl, mediaFile.file);
    }
    if (uploadedMediaUrl != null) {
      final UploadedMedia mediaFileUploader = UploadedMedia(
          uploadedMediaUrl, _convertToMediaTypeCode(mediaFile.type));
      return mediaFileUploader;
    }
    return null;
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
}
