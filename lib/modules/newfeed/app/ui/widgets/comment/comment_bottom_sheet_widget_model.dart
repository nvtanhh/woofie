import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/domain/models/user.dart';
import 'package:meowoof/modules/newfeed/domain/models/comment.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CommentBottomSheetWidgetModel extends BaseViewModel {
  final Rx<User> _user = Rx<User>();
  final RxList<Comment> _comments = RxList<Comment>();
  TextEditingController commentEditingController = TextEditingController();

  void onSendComment() {}

  @override
  void initState() {
    super.initState();
  }

  User get user => _user.value;

  set user(User value) {
    _user.value = value;
  }

  List<Comment> get comments => _comments.toList();

  set comments(List<Comment> value) {
    _comments.assignAll(value);
  }

  @override
  void disposeState() {
    super.disposeState();
  }
}
