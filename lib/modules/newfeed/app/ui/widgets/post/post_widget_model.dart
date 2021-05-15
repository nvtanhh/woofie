import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
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
  final RxBool _isLoaded = RxBool(false);
  final GetCommentInPostUsecase _getCommentInPostUsecase;

  PostWidgetModel(
    @Named("current_user_storage") this._userStorage,
    this._likePostUsecase,
    this._getCommentInPostUsecase,
  );

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
    _loadComments();
    super.initState();
  }

  void _loadComments() {
    call(
      () async => post.comments = await _getCommentInPostUsecase.call(post.id!),
      showLoading: false,
      onSuccess: () {
        isLoaded = true;
      },
    );
  }

  void _loadUserLocal() {
    call(
      () async => user.value = _userStorage.get(),
      showLoading: false,
    );
  }

  void onSendComment() {}

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }

  @override
  void disposeState() {
    commentEditingController.dispose();
    super.disposeState();
  }
}
