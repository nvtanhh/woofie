import 'dart:collection';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/core/ui/confirm_dialog.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/save_post/new_post_uploader.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/updated_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/play_sound_react_post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/refresh_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/report_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_location_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/edit_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_presigned_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class PostService extends BaseViewModel {
  final GetPresignedUrlUsecase _getPresignedUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final EditPostUsecase _editPostUsecase;
  final LikePostUsecase _likePostUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final ToastService _toastService;
  final RefreshPostsUsecase _refreshPostsUsecase;
  final ReportPostUsecase _reportPostUsecase;
  final UpdateLocationUsecase _updateLocationUsecase;

  final BottomSheetService _bottomSheetService;
  final MediaService _mediaService;
  final PlaySoundReactPost _playSoundReactPost;
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
    this._reportPostUsecase,
    this._playSoundReactPost,
    this._updateLocationUsecase,
  );

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    super.initState();
  }

  Future onPostEdited(EditedPostData editedPostData) async {
    if (editedPostData.newAddedFiles != null &&
        editedPostData.newAddedFiles!.isNotEmpty) {
      editedPostData.newAddedMedias = await _startUploadNewMediaFiles(
          editedPostData.newAddedFiles!, editedPostData.originPost,);
    }

    final bool isEditSuccessed = await _startEditPost(editedPostData);
    if (isEditSuccessed) {
      _refreshPost(editedPostData.originPost.id);
    } else {
      _onPostEditFailed();
    }
  }

  void onLikeClick(int idPost) {
    _playSoundReactPost.run();
    run(
      () => _likePostUsecase.call(idPost),
      showLoading: false,
      onFailure: (err) {},
    );
  }

  Future onWantsToCreateNewPost() async {
    final NewPostData? newPostData =
        await injector<NavigationService>().navigateToCreatePost();
    if (newPostData != null) {
      newPostsData.add(newPostData);
      _prepenedNewPostUploadingWidget(newPostData);
    }
  }

  void onPostClick(Post post) {
    if (post.type == PostType.activity) {
      injector<NavigationService>().navigateToPostDetail(
        post,
      );
    } else {
      injector<NavigationService>().navigateToFunctionalPostDetail(
        post,
      );
    }
  }

  void onCommentClick(Post post) {
    _bottomSheetService.showComments(post, Get.context!);
  }

  void onDeletePost(Post post, int index) {
    bool isSuccess = false;
    run(
      () async {
        isSuccess = await _deletePostUsecase.call(post.id);
      },
      onSuccess: () {
        if (isSuccess) {
          _toastService.success(
              message: 'Post deleted!', context: Get.context!,);
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

  void onWantsToDeletePost(Post post, int index) {
    Get.dialog(
      ConfirmDialog(
        title: 'Xác nhận xóa',
        content: 'Bạn có chắc chắn muốn xóa bài viết này?',
        confirmText: 'Xóa',
        cancelText: 'Hủy',
        onConfirm: () => onDeletePost(post, index),
      ),
    );
  }

  Future onWantsToEditPost(Post post) async {
    final EditedPostData? editedPostData =
        await injector<NavigationService>().navigateToEditPost(post);

    if (editedPostData != null) {
      await onPostEdited(editedPostData);
    }
  }

  Future<List<UploadedMedia>> _startUploadNewMediaFiles(
      List<MediaFile> newAddedFiles, Post oldPost,) async {
    final List<MediaFile> compressMediaFiles = await Future.wait(
      newAddedFiles.map((file) async => _compressPostMediaItem(file)).toList(),
    );
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
    await run(
      () async {
        isEdited = await _editPostUsecase.call(editedPostData);
      },
      onFailure: (error) {
        printError(info: error.toString());
      },
      showLoading: false,
    );
    return isEdited;
  }

  Future<MediaFile> _compressPostMediaItem(MediaFile postMediaItem) async {
    return _mediaService.compressPostMediaItem(postMediaItem);
  }

  Future<UploadedMedia?> _storeMediaItem(
      MediaFile mediaFile, Post oldPost,) async {
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
        uploadedMediaUrl,
        _convertToMediaTypeCode(mediaFile.type),
      );
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
      LocaleKeys.save_post_success_tile.trans(),
      LocaleKeys.save_post_success_description.trans(),
      duration: const Duration(seconds: 2),
      backgroundColor: UIColor.accent2,
      colorText: UIColor.white,
    );
  }

  void _onNewPostDataUploaderCancelled(NewPostData newPostData) {
    _removeNewPostDataUploader(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(
      Post publishedPost, NewPostData newPostData,) {
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
    injector<ToastService>().error(
        message: LocaleKeys.save_post_update_failed_toast.trans(),
        duration: const Duration(seconds: 2),
        context: Get.context!,);
  }

  void _refreshPost(int postId) {
    run(
      () => _refreshPostsUsecase.call(postId),
      onSuccess: () {
        injector<ToastService>().success(
            message: LocaleKeys.save_post_update_success_toast.trans(),
            context: Get.context!,);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      showLoading: false,
    );
  }

  void onRefresh() {
    pagingController.refresh();
  }

  Future onReportPost(Post post) async {
    final String? content =
        await injector<DialogService>().showInputReport() as String?;
    if (content == null) return;
    await run(
      () async => _reportPostUsecase.run(post, content),
      onSuccess: () {
        _toastService.success(
          message: "Reported",
          context: Get.context!,
        );
      },
    );
  }

  @override
  void disposeState() {
    pagingController.dispose();
    prependedWidgets.close();
    newPostsData.close();
    super.disposeState();
  }

  Future<void> calculateDistance(Post post) async {
    if (post.location == null) return;
    final UserLocation? userLocation =
        await getUserLocation(injector<LoggedInUser>().user!);
    if (userLocation != null) {
      post.distanceUserToPost = (Geolocator.distanceBetween(
                userLocation.lat!,
                userLocation.long!,
                post.location!.lat!,
                post.location!.long!,
              ) /
              1000)
          .toPrecision(1);
      post.notifyUpdate();
    }
  }

  Future<UserLocation?> getUserLocation(User user) async {
    try {
      final UserLocation? userLocation = user.location;
      if (userLocation != null) {
        unawaited(_checkAndUpdateUserLocation(userLocation));
        return userLocation;
      } else {
        final Position currentPosition =
            await injector<LocationService>().determineCurrentPosition();
        final userLocation = UserLocation(
            lat: currentPosition.latitude, long: currentPosition.longitude,);
        // unawaited(updateLocation(userLocation));
        return userLocation;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _checkAndUpdateUserLocation(UserLocation userLocation) async {
    if (userLocation.updatedAt == null) return;
    if (DateTime.now().difference(userLocation.updatedAt!).inMinutes > 30) {
      final Position currentPosition =
          await injector<LocationService>().determineCurrentPosition();
      userLocation.lat = currentPosition.latitude;
      userLocation.long = currentPosition.longitude;
      unawaited(updateLocation(userLocation));
    }
    return;
  }

  Future updateLocation(UserLocation location) async {
    await run(
      () async => _updateLocationUsecase.run(
        id: location.id!,
        long: location.long!,
        lat: location.lat!,
        name: location.name!,
      ),
      showLoading: false,
    );
    return;
  }
}
