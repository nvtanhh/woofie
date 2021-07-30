import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_service.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_comment_in_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/play_sound_receiver_comment.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentBottomSheetWidgetModel extends BaseViewModel {
  List<Comment> _comments = [];
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final CommentServiceModel commentServiceModel;
  late Post post;
  final int pageSize = 10;
  int nextPageKey = 0;

  CommentBottomSheetWidgetModel(
    this._getCommentInPostUsecase,
    this.commentServiceModel,
  );

  @override
  void initState() {
    commentServiceModel.initState();
    commentServiceModel.post = post;
    super.initState();
  }

  void startLoadingPaging() {
    if (commentServiceModel.pagingController.itemList == null) {
      _loadComments(nextPageKey);
      commentServiceModel.pagingController.addPageRequestListener(
        (pageKey) {
          _loadComments(pageKey);
        },
      );
    }
  }

  void _loadComments(int pageKey) {
    call(
      () async {
        _comments = await _getCommentInPostUsecase.call(post.id, offset: nextPageKey);
        if (_comments.length < pageSize) {
          commentServiceModel.pagingController.appendLastPage(_comments);
        } else {
          nextPageKey = pageKey + _comments.length;
          commentServiceModel.pagingController.appendPage(_comments, nextPageKey);
        }
      },
      showLoading: false,
      onSuccess: () {},
      onFailure: (err) {
        printError(info: err.toString());
        commentServiceModel.pagingController.error = err;
      },
    );
  }

  void onSendComment(Comment comment) {
    // create new comment
    if (commentServiceModel.commentUpdate == null) {
      commentServiceModel.pagingController.itemList?.insert(0, comment);
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      commentServiceModel.pagingController.notifyListeners();
    } else {
      // update comment
      commentServiceModel.onEditComment(
        oldComment: commentServiceModel.commentUpdate!,
        newComment: comment,
      );
    }
  }

  @override
  void disposeState() {
    commentServiceModel.disposeState();
    super.disposeState();
  }
}
