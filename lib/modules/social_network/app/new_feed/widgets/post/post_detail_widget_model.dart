import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_detail_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_comment_in_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class PostDetailWidgetModel extends BaseViewModel {
  late Post post;
  TextEditingController commentEditingController = TextEditingController();
  final LikePostUsecase _likePostUsecase;
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final int pageSize = 10;
  int nextPageKey = 0;
  late PagingController<int, Comment> pagingController;
  final GetDetailPostUsecase _getDetailPostUsecase;
  final List<User> tagUsers = [];
  List<Comment> comments = [];

  PostDetailWidgetModel(
    this._likePostUsecase,
    this._getCommentInPostUsecase,
    this._getDetailPostUsecase,
  );
  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    checkNeedReloadPost();
    super.initState();
  }

  void onLikeCommentClick(int commentId) {}

  void onLikeClick(int idPost) {
    call(
      () => _likePostUsecase.call(idPost),
      showLoading: false,
      onFailure: (err) {},
    );
  }

  Future checkNeedReloadPost() async {
    if (post.creator == null) {
      await call(
        () async => post = await _getDetailPostUsecase.call(post.id),
        onSuccess: () {
          _loadComments(nextPageKey);
          pagingController.addPageRequestListener((pageKey) {
            _loadComments(pageKey);
          });
        },
      );
      return;
    }
    pagingController.addPageRequestListener(
      (pageKey) {
        _loadComments(pageKey);
      },
    );
  }

  void _loadComments(int pageKey) {
    call(
      () async {
        comments = await _getCommentInPostUsecase.call(post.id, offset: nextPageKey);
        if (pagingController.itemList == null || pagingController.itemList?.isEmpty == true) {
          comments.insert(0, Comment(id: 0, content: "content", postId: 0, creatorUUID: "0"));
        }
        if (comments.length < pageSize) {
          pagingController.appendLastPage(comments);
        } else {
          nextPageKey = pageKey + comments.length;
          pagingController.appendPage(comments, nextPageKey);
        }
      },
      showLoading: false,
      onSuccess: () {},
      onFailure: (err) {
        pagingController.error = err;
      },
    );
  }

  void onSendComment(Comment comment) {
    pagingController.itemList?.insert(1, comment);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    pagingController.notifyListeners();
    commentEditingController.clear();
  }

  Future onRefresh() async {
    nextPageKey = 0;
    pagingController.refresh();
  }

  @override
  void disposeState() {
    commentEditingController.dispose();
    pagingController.dispose();
    super.disposeState();
  }
}
