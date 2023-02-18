import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_item_shimmer.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post_item.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_posts_of_pet_usecase.dart';

class PostsOfPetWidget extends StatefulWidget {
  final int idPet;

  final PostsOfPetWidgetController controller;

  const PostsOfPetWidget({
    super.key,
    required this.idPet,
    required this.controller,
  });

  @override
  PostsOfPetWidgetState createState() => PostsOfPetWidgetState();
}

class PostsOfPetWidgetState extends State<PostsOfPetWidget> {
  final int pageSize = 10;

  int nextPageKey = 0;

  List<Post> _post = [];

  final PagingController<int, Post> _pagingController =
      PagingController<int, Post>(firstPageKey: 0);

  final GetPostsOfPetUsecase _getPostsOfPetUsecase =
      injector<GetPostsOfPetUsecase>();

  @override
  void initState() {
    super.initState();
    widget.controller.attach(context: context, state: this);
    registerEvent();
  }

  Future _loadMorePost(int pageKey) async {
    _post = [];
    try {
      _post =
          await _getPostsOfPetUsecase.call(widget.idPet, offset: nextPageKey);
      final isLastPage = _post.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(_post);
      } else {
        nextPageKey = pageKey + _post.length;
        _pagingController.appendPage(_post, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void registerEvent() {
    _pagingController.addPageRequestListener((pageKey) {
      _loadMorePost(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Post>(
      pagingController: _pagingController,
      physics: const NeverScrollableScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, post, index) {
          return PostItem(
            post: post,
            onLikeClick: onLikeClick,
            onEditPost: () => onPostEdited(post),
            onDeletePost: () => onPostDeleted(post),
            onPostClick: onPostClick,
          );
        },
        firstPageProgressIndicatorBuilder: (_) => PostItemShimmer(),
      ),
    );
  }

  void onPostEdited(Post post) {}

  void onLikeClick(int post) {}

  void onPostDeleted(Post post) {}

  void onPostClick(Post post) {
    Get.to(() => PostDetail(post: post));
  }

  void refreshPost() {
    _pagingController.refresh();
  }
}

class PostsOfPetWidgetController {
  late PostsOfPetWidgetState _state;
  void attach(
      {required BuildContext context, required PostsOfPetWidgetState state,}) {
    _state = state;
  }

  void refreshPost() {
    _state.refreshPost();
  }
}
