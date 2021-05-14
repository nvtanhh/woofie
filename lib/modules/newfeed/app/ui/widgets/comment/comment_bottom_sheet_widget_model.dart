import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';
import 'package:meowoof/modules/newfeed/domain/usecases/get_comment_in_post_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentBottomSheetWidgetModel extends BaseViewModel {
  final Rx<User?> _user = Rx<User?>(null);
  final RxList<Comment> _comments = RxList<Comment>();
  final GetCommentInPostUsecase _getCommentInPostUsecase;
  final RxBool _isLoading = RxBool(true);
  final UserStorage _userStorage;
  TextEditingController commentEditingController = TextEditingController();
  late int postId;

  CommentBottomSheetWidgetModel(
    this._getCommentInPostUsecase,
    @Named("current_user_storage") this._userStorage,
  );

  void loadComments() {
    call(
      () async => comments = await _getCommentInPostUsecase.call(postId),
      showLoading: false,
      onSuccess: () {
        isLoading = false;
      },
    );
  }

  void loadUserLocal() {
    call(() async => user = _userStorage.get(), showLoading: false, onSuccess: () {
      print(user?.avatar?.url);
    });
  }

  @override
  void initState() {
    loadUserLocal();
    loadComments();
    super.initState();
  }

  void onSendComment() {}

  void onLikeCommentClick(int idComment) {}

  User? get user => _user.value;

  set user(User? value) {
    _user.value = value;
  }

  List<Comment> get comments => _comments.toList();

  set comments(List<Comment> value) {
    _comments.assignAll(value);
  }

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) {
    _isLoading.value = value;
  }
}
