import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/events/comment/comment_updated_event.dart';
import 'package:meowoof/modules/social_network/domain/events/comment/comment_updating_event.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/create_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/delete_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/edit_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/report_comment_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentServiceModel extends BaseViewModel {
  final DeleteCommentUsecase _deleteCommentUsecase;
  final ReportCommentUsecase _reportCommentUsecase;
  final EditCommentUsecase _editCommentUsecase;
  final LikeCommentUsecase _likeCommentUsecase;
  final EventBus _eventBus;
  final CreateCommentUsecase _createCommentUsecase;
  final Rx<Comment?> _commentUpdate = Rx(null);

  late PagingController<int, Comment> pagingController;
  late Post post;

  int? indexOldComment;

  CommentServiceModel(
    this._deleteCommentUsecase,
    this._reportCommentUsecase,
    this._likeCommentUsecase,
    this._editCommentUsecase,
    this._createCommentUsecase,
    this._eventBus,
  );

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    super.initState();
  }

  void onDeleteComment(Comment comment, int index) {
    call(
      () async => _deleteCommentUsecase.run(comment.id),
      onSuccess: () {
        pagingController.itemList?.removeAt(index);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
    );
  }

  void onReportComment(Comment comment, String content) {
    call(
      () async => _reportCommentUsecase.run(comment.id, content),
      onSuccess: () {},
    );
  }

  void onLikeComment(Comment comment, int postId) {
    call(
      () => _likeCommentUsecase.run(idComment: comment.id, idPost: postId),
      showLoading: false,
    );
  }

  void onEditComment({required Comment oldComment, required Comment newComment}) {
    Comment? comment;
    call(
        // ignore: parameter_assignments
        () async => comment = await _editCommentUsecase.run(oldComment, newComment), onSuccess: () {
      comment?.commentTagUser = newComment.commentTagUser?.toList();
      comment?.creator = oldComment.creator;
      comment?.commentReactsAggregate = oldComment.commentReactsAggregate;
      pagingController.itemList?.replaceRange(
        indexOldComment!,
        indexOldComment! + 1,
        [comment!],
      );
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      pagingController.notifyListeners();
      commentUpdate = null;
      _eventBus.fire(CommentUpdatedEvent(comment!));
    }, onFailure: (err) {
      printError(info: err.toString());
    });
  }

  void setOldComment(Comment comment, int index) {
    commentUpdate = comment;
    indexOldComment = index;
    _eventBus.fire(CommentUpdatingEvent(comment));
  }

  Comment? get commentUpdate => _commentUpdate.value;

  set commentUpdate(Comment? value) {
    _commentUpdate.value = value;
  }

  @override
  void disposeState() {
    pagingController.dispose();
    super.disposeState();
  }
}
