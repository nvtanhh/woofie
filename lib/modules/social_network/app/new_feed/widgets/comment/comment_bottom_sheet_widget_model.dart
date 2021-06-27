import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/create_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_comment_in_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_comment_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentBottomSheetWidgetModel extends BaseViewModel {
  final Rx<User?> user = Rx<User?>(null);
  List<Comment> _comments = [];
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final UserStorage _userStorage;
  final CreateCommentUsecase _createCommentUsecase;
  final LikeCommentUsecase _likeCommentUsecase;
  TextEditingController commentEditingController = TextEditingController();
  late int postId;
  late PagingController<int, Comment> pagingController;
  final int pageSize = 10;
  final List<User> tagUsers = [];
  int nextPageKey = 0;

  CommentBottomSheetWidgetModel(
    this._getCommentInPostUsecase,
    @Named("current_user_storage") this._userStorage,
    this._createCommentUsecase,
    this._likeCommentUsecase,
  ) {
    pagingController = PagingController(firstPageKey: 0);
  }

  void _loadComments(int pageKey) {
    call(
      () async {
        _comments = await _getCommentInPostUsecase.call(postId, offset: nextPageKey);
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

  void onSendComment() {
    call(
      () async {
        final Comment? comment = await _createCommentUsecase.call(postId, commentEditingController.text, tagUsers);
        if (comment != null) {
          pagingController.itemList?.insert(0, comment);
          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
          pagingController.notifyListeners();
          commentEditingController.clear();
        }
      },
      showLoading: false,
    );
  }

  void onLikeCommentClick(int idComment) {
    call(
      () => _likeCommentUsecase.call(idComment),
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
