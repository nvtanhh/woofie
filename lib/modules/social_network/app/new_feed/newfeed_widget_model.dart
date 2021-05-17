import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_bottom_sheet_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewFeedWidgetModel extends BaseViewModel {
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
    showMaterialModalBottomSheet(
      context: Get.context!,
      builder: (context) => CommentBottomSheetWidget(
        postId: idPost,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          topLeft: Radius.circular(30.r),
        ),
      ),
      backgroundColor: Colors.transparent,
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
    Get.to(
      () => PostWidget(
        post: post,
      ),
    );
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
}
