import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/new_post_uploader.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewFeedWidgetModel extends BaseViewModel {
  final BottomSheetService bottomSheetService = injector<BottomSheetService>();
  final GetPostsUsecase _getPostsUsecase;
  final DeletePostUsecase _deletePostUsecase;
  List<Post> posts = [];
  final LikePostUsecase _likePostUsecase;
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
    this._likePostUsecase,
    this._deletePostUsecase,
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
        cancelableOperation = CancelableOperation.fromFuture(_loadMorePost(pageKey));
      },
    );
    _lastRefeshTime = DateTime.now();
  }

  void onCommentClick(Post post) {
    bottomSheetService.showComments(post);
  }

  void onDeletePost(Post post, int index) {
    bool isSuccess = false;
    call(
      () async {
        isSuccess = await _deletePostUsecase.call(post.id);
      },
      onSuccess: () {
        if (isSuccess) {
          injector<ToastService>().success(message: 'Post deleted!', context: Get.context!);
        }
        pagingController.itemList?.removeAt(index);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      onFailure: (err) {
        injector<ToastService>().success(message: err.toString(), context: Get.context!);
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

  void onPostEdited(Post post) {
    Get.to(() => CreatePost(
          post: post,
        ));
  }

  Future onWantsToCreateNewPost() async {
    final NewPostData? newPostData = await injector<NavigationService>().navigateToSavePost();
    if (newPostData != null) {
      newPostsData.add(newPostData);
      _prepenedNewPostUploadingWidget(newPostData);
    }
  }

  Future _loadMorePost(int pageKey) async {
    // try {
    final newItems = await _getPostsUsecase.call(offset: nextPageKey, lastValue: dateTimeValueLast);
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(newItems);
    } else {
      nextPageKey = pageKey + newItems.length;
      dateTimeValueLast = newItems.last.createdAt;
      pagingController.appendPage(newItems, nextPageKey);
    }
    // } catch (error) {
    //   print(error);
    //   pagingController.error = error;
    // }
  }

  void _onNewPostDataUploaderCancelled(NewPostData newPostData) {
    _removeNewPostDataUploader(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(Post publishedPost, NewPostData newPostData) {
    _showSnackbarCreatePostSuccessful();
    pagingController.itemList?.insert(0, publishedPost);
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
      pagingController.notifyListeners();
    } else {
      printInfo(info: 'Please wait $_refreshIntervalLimitSecond seconds');
    }
  }

  bool _isCanRefesh() {
    return DateTime.now().difference(_lastRefeshTime).inSeconds > _refreshIntervalLimitSecond;
  }
}
