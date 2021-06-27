import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
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

  NewFeedWidgetModel(
    this._getPostsUsecase,
    this._likePostUsecase,
    this._deletePostUsecase,
  ) {
    pagingController = PagingController(firstPageKey: 0);
  }

  @override
  void initState() {
    pagingController.addPageRequestListener(
      (pageKey) {
        cancelableOperation = CancelableOperation.fromFuture(_loadMorePost(pageKey));
      },
    );
    super.initState();
  }

  Future _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getPostsUsecase.call(offset: nextPageKey, lastValue: dateTimeValueLast);
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

  void onCommentClick(int idPost) {
    bottomSheetService.showComments(idPost);
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

  void getPosts() {
    call(
      () async => posts = await _getPostsUsecase.call(),
    );
  }

  @override
  void disposeState() {
    cancelableOperation?.cancel();
    pagingController.dispose();
    super.disposeState();
  }

  void onPostEdited(Post post) {
    Get.to(CreatePost(
      post: post,
    ));
  }

  void onPostDeleted(Post post) {
    bool isSuccess = false;
    call(
      () async {
        isSuccess = await _deletePostUsecase.call(post.id);
      },
      onSuccess: () {
        if (isSuccess) {
          injector<ToastService>().success(message: 'Post deleted!', context: Get.context!);
        }
      },
      onFailure: (err) {
        injector<ToastService>().success(message: err.toString(), context: Get.context!);
      },
    );
  }

  Future onWantsCreateNewPost() async {
    await injector<NavigationService>().navigateToSavePost();
  }
}
