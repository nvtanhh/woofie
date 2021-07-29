import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/helpers/get_map_from_hasura.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/domain/events/comment/comment_updated_event.dart';
import 'package:meowoof/modules/social_network/domain/events/comment/comment_updating_event.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/create_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/delete_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/edit_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/report_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/subscription_comment_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentServiceModel extends BaseViewModel {
  final DeleteCommentUsecase _deleteCommentUsecase;
  final ReportCommentUsecase _reportCommentUsecase;
  final EditCommentUsecase _editCommentUsecase;
  final LikeCommentUsecase _likeCommentUsecase;
  final SubscriptionCommentUsecase _subscriptionCommentUsecase;
  final EventBus _eventBus;
  final CreateCommentUsecase _createCommentUsecase;
  final Rx<Comment?> _commentUpdate = Rx(null);

  late PagingController<int, Comment> pagingController;
  late Post post;

  int? indexOldComment;
  Snapshot? snapshot;

  CommentServiceModel(
    this._deleteCommentUsecase,
    this._reportCommentUsecase,
    this._likeCommentUsecase,
    this._editCommentUsecase,
    this._createCommentUsecase,
    this._eventBus,
    this._subscriptionCommentUsecase,
  );

  @override
  void initState() {
    printInfo(info: "init");
    pagingController = PagingController(firstPageKey: 0);
    super.initState();
  }

  void registerSubscriptionComment(int postId, {int indexInsertToList = 0}) {
    call(
      () async =>
      snapshot = await _subscriptionCommentUsecase.run(postId),
      onFailure: (err) {
        printError(info: err.toString());
      },
      onSuccess: () => onSubscriptionCommentSuccess(indexInsertToList: indexInsertToList),
      showLoading: false,
    );
  }

  void onSubscriptionCommentSuccess({int indexInsertToList = 0}) {
    snapshot!.listen(
      (event) {
        try {
          Comment? comment = Comment.fromJson((GetMapFromHasura.getMap(event as Map)["comments"])[0] as Map<String,dynamic>);
          printInfo(info: comment.content??"");
          if(canInsertToList(indexInsertToList, comment.id)) {
            pagingController.itemList?.insert(indexInsertToList, comment);
            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
            pagingController.notifyListeners();
          }
        } catch (e) {
          printError(info: e.toString());
        }
      },
    );
  }
  bool canInsertToList(int index,int commentId){
    return pagingController.itemList?[index].id!=commentId;
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

  Future onReportComment(Comment comment, String content) async {
    final String? content = await injector<DialogService>().showInputReport() as String?;
    if (content == null) return;
    await call(
      () async => _reportCommentUsecase.run(comment, content),
      onSuccess: () {
        injector<ToastService>().success(
          message: "Reported",
          context: Get.context!,
        );
      },
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
      () async => comment = await _editCommentUsecase.run(oldComment, newComment),
      onSuccess: () {
        comment?.commentTagUser = newComment.commentTagUser?.toList();
        comment?.creator = oldComment.creator;
        comment?.postId = oldComment.postId;
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
      },
      onFailure: (err) {
        printError(info: err.toString());
      },
    );
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
    snapshot?.close();
    super.disposeState();
  }
}
