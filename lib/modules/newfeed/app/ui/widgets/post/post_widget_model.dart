import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';
import 'package:meowoof/modules/newfeed/domain/models/post.dart';
import 'package:meowoof/modules/newfeed/domain/usecases/get_comment_in_post_usecase.dart';
import 'package:meowoof/modules/newfeed/domain/usecases/like_post_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class PostWidgetModel extends BaseViewModel {
  late Post post;
  TextEditingController commentEditingController = TextEditingController();
  Rx<User?> user = Rx<User?>(null);
  final UserStorage _userStorage;
  final LikePostUsecase _likePostUsecase;
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final int pageSize = 10;
  late PagingController<int, Comment> pagingController;

  PostWidgetModel(
    @Named("current_user_storage") this._userStorage,
    this._likePostUsecase,
    this._getCommentInPostUsecase,
  ) {
    pagingController = PagingController(firstPageKey: 0);
  }

  void onLikeCommentClick(int commentId) {}

  void onLikeClick(int idPost) {
    call(
      () => _likePostUsecase.call(idPost),
      showLoading: false,
      onFailure: (err) {},
    );
  }

  @override
  void initState() {
    _loadUserLocal();
    pagingController.addPageRequestListener((pageKey) {
      _loadComments(pageKey);
    });
    super.initState();
  }

  void _loadComments(int pageKey) {
    call(
      () async {
        post.comments = await _getCommentInPostUsecase.call(post.id!);
        if ((post.comments?.length ?? 0) < pageSize) {
          pagingController.appendLastPage(post.comments ?? []);
        } else {
          final nextPageKey = pageKey + (post.comments?.length ?? 0);
          pagingController.appendPage(post.comments ?? [], nextPageKey);
        }
      },
      showLoading: false,
      onSuccess: () {},
    );
  }

  void _loadUserLocal() {
    call(
      () async => user.value = _userStorage.get(),
      showLoading: false,
    );
  }

  void onSendComment() {}

  @override
  void disposeState() {
    commentEditingController.dispose();
    super.disposeState();
  }
}
