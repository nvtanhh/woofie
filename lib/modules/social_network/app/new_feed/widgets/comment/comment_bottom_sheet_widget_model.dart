import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_comment_in_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_comment_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentBottomSheetWidgetModel extends BaseViewModel {
  List<Comment> _comments = [];
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final LikeCommentUsecase _likeCommentUsecase;
  TextEditingController commentEditingController = TextEditingController();
  late Post post;
  late PagingController<int, Comment> pagingController;
  final int pageSize = 10;
  int nextPageKey = 0;

  CommentBottomSheetWidgetModel(
    this._getCommentInPostUsecase,
    this._likeCommentUsecase,
  ) {
    pagingController = PagingController(firstPageKey: 0);
  }

  void _loadComments(int pageKey) {
    call(
      () async {
        _comments = await _getCommentInPostUsecase.call(post.id, offset: nextPageKey);
        if (_comments.length < pageSize) {
          pagingController.appendLastPage(_comments);
        } else {
          nextPageKey = pageKey + _comments.length;
          pagingController.appendPage(_comments, nextPageKey);
        }
      },
      showLoading: false,
      onSuccess: () {},
      onFailure: (err) {
        printError(info: err.toString());
        pagingController.error = err;
      },
    );
  }

  @override
  void initState() {
    pagingController.addPageRequestListener(
      (pageKey) {
        _loadComments(pageKey);
      },
    );
    super.initState();
  }

  void onSendComment(Comment comment) {
    pagingController.itemList?.insert(0, comment);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    pagingController.notifyListeners();
    commentEditingController.clear();
  }

  void onLikeCommentClick(int idComment) {
    call(
      () => _likeCommentUsecase.run(idComment: idComment, idPost: post.id),
      showLoading: false,
    );
  }

  @override
  void disposeState() {
    commentEditingController.dispose();
    pagingController.removeListener(() {});
    pagingController.dispose();
    super.disposeState();
  }
}
