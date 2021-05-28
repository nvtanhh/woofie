import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/injector.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewFeedWidgetModel extends BaseViewModel {
  final BottomSheetService bottomSheetService = injector<BottomSheetService>();
  final GetPostsUsecase _getPostsUsecase;
  List<Post> posts = [];
  final LikePostUsecase _likePostUsecase;
  late PagingController<int, Post> pagingController;
  final int pageSize = 10;

  NewFeedWidgetModel(this._getPostsUsecase, this._likePostUsecase) {
    pagingController = PagingController(firstPageKey: 0);
  }

  @override
  void initState() {
    pagingController.addPageRequestListener(
      (pageKey) {
        _loadMorePost(pageKey);
      },
    );
    super.initState();
  }

  Future _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getPostsUsecase.call();
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
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
    pagingController.removeListener(() {});
    pagingController.dispose();
    super.disposeState();
  }

  void onPostEdited(Post post) {
    injector<ToastService>().success(message: 'Post edited', context: Get.context!);
  }

  void onPostDeleted(Post post) {
    injector<ToastService>().success(message: 'Post delted!', context: Get.context!);
  }

  Future onWantsCreateNewPost() async {
    await injector<NavigationService>().navigateToSavePost();
  }
}
