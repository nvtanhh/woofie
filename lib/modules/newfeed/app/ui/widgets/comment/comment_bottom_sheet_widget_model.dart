import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';
import 'package:meowoof/modules/newfeed/domain/usecases/get_comment_in_post_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentBottomSheetWidgetModel extends BaseViewModel {
  final Rx<User?> user = Rx<User?>(null);
  List<Comment> _comments = [];
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final UserStorage _userStorage;
  TextEditingController commentEditingController = TextEditingController();
  late int postId;
  late PagingController<int, Comment> pagingController;
  final int pageSize = 10;

  CommentBottomSheetWidgetModel(
    this._getCommentInPostUsecase,
    @Named("current_user_storage") this._userStorage,
  ) {
    pagingController = PagingController(firstPageKey: 0);
  }

  void _loadComments(int pageKey) {
    call(
      () async {
        _comments = await _getCommentInPostUsecase.call(postId);
        if (_comments.length < pageSize) {
          pagingController.appendLastPage(_comments);
        } else {
          final nextPageKey = pageKey + _comments.length;
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

  void loadUserLocal() {
    call(
      () async => user.value = _userStorage.get(),
      showLoading: false,
      onSuccess: () {},
    );
  }

  @override
  void initState() {
    loadUserLocal();
    pagingController.addPageRequestListener(
      (pageKey) {
        _loadComments(pageKey);
      },
    );
    super.initState();
  }

  void onSendComment() {}

  void onLikeCommentClick(int idComment) {}

  @override
  void disposeState() {
    commentEditingController.dispose();
    pagingController.removeListener(() {});
    pagingController.dispose();
    super.disposeState();
  }
}
