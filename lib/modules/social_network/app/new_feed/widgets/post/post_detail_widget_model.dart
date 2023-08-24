import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_service.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_detail_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_comment_in_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class PostDetailWidgetModel extends BaseViewModel {
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final GetDetailPostUsecase _getDetailPostUsecase;
  final LikePostUsecase _likePostUsecase;
  final CommentServiceModel commentServiceModel;

  late Post post;
  final int pageSize = 10;
  int nextPageKey = 0;
  List<User> tagUsers = [];
  List<Comment> comments = [];

  PostDetailWidgetModel(
    this._getCommentInPostUsecase,
    this._getDetailPostUsecase,
    this.commentServiceModel,
    this._likePostUsecase,
  );

  @override
  void initState() {
    commentServiceModel.initState();
    commentServiceModel.post = post;
    checkNeedReloadPost();
    super.initState();
  }

  void onLikeClick(int idPost) {
    run(
      () => _likePostUsecase.call(idPost),
      showLoading: false,
      onFailure: (err) {},
    );
  }

  Future checkNeedReloadPost() async {
    if (post.creator == null) {
      await run(
        () async => post.update(await _getDetailPostUsecase.call(post.id)),
        onSuccess: () {
          _loadComments(nextPageKey);
          commentServiceModel.pagingController.addPageRequestListener(
            (pageKey) {
              _loadComments(pageKey);
            },
          );
          commentServiceModel.registerSubscriptionComment(post.id,
              indexInsertToList: 1,);
        },
      );
      return;
    }
    commentServiceModel.pagingController.addPageRequestListener(
      (pageKey) {
        _loadComments(pageKey);
      },
    );
    commentServiceModel.registerSubscriptionComment(post.id,
        indexInsertToList: 1,);
  }

  void _loadComments(int pageKey) {
    run(
      () async {
        comments =
            await _getCommentInPostUsecase.call(post.id, offset: nextPageKey);
        if (commentServiceModel.pagingController.itemList == null ||
            commentServiceModel.pagingController.itemList?.isEmpty == true) {
          comments.insert(0,
              Comment(id: 0, content: "content", postId: 0, creatorUUID: "0"),);
        }
        if (comments.length < pageSize) {
          commentServiceModel.pagingController.appendLastPage(comments);
        } else {
          nextPageKey = pageKey + comments.length;
          commentServiceModel.pagingController
              .appendPage(comments, nextPageKey);
        }
      },
      showLoading: false,
      onSuccess: () {},
      onFailure: (err) {
        commentServiceModel.pagingController.error = err;
      },
    );
  }

  void onSendComment(Comment comment) {
    // create new comment
    if (commentServiceModel.commentUpdate == null) {
      if (commentServiceModel.canInsertToList(1, comment.id)) {
        commentServiceModel.pagingController.itemList?.insert(1, comment);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        commentServiceModel.pagingController.notifyListeners();
      }
    } else {
      // update comment
      commentServiceModel.onEditComment(
        oldComment: commentServiceModel.commentUpdate!,
        newComment: comment,
      );
    }
  }

  Future onRefresh() async {
    nextPageKey = 0;
    commentServiceModel.pagingController.refresh();
  }

  @override
  void disposeState() {
    commentServiceModel.disposeState();
    super.disposeState();
  }
}
