import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/create_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_all_user_in_post_usecase.dart';
import 'package:suga_core/suga_core.dart';
import 'package:type_ahead_text_field/type_ahead_text_field.dart';

@injectable
class SendCommentWidgetModel extends BaseViewModel {
  final GetAllUserInPostUsecase _getAllUserInPostUsecase;
  final CreateCommentUsecase _createCommentUsecase;
  final UserStorage _userStorage;
  List<SuggestedDataWrapper<User>> data = [];
  final RxList<SuggestedDataWrapper<User>> _dataFilter = RxList([]);
  final GlobalKey<EditableTextState> tfKey = GlobalKey();
  final GlobalKey suggestionWidgetKey = GlobalKey();

  late Function(Comment) onSendComment;
  late Post post;
  late Function showSuggestionDialog;
  late TextSpan Function(SuggestedDataWrapper<User>) customSpan;

  User? user;
  List<User> tagUsers = [];
  TypeAheadTextFieldController? controller;
  PrefixMatchState? filterState;
  OverlayEntry? overlayEntry;
  FocusNode focusNode = FocusNode();

  SendCommentWidgetModel(
    this._getAllUserInPostUsecase,
    this._userStorage,
    this._createCommentUsecase,
  ) {
    _loadUserFromLocal();
  }

  @override
  void initState() {
    initController();
    focusNode.addListener(() => _listenKeyBoard());
    super.initState();
  }

  void initController() {
    controller = TypeAheadTextFieldController(
      appliedPrefixes: {'@'},
      textFieldKey: tfKey,
      suggestibleData: data.toSet(),
      edgePadding: const EdgeInsets.all(5),
      onRemove: (List<SuggestedDataWrapper> data) {
        _removeUserInTags(data.map((e) => e.item as User).toList());
      },
      customSpanBuilder: (SuggestedDataWrapper data) {
        return customSpan(data as SuggestedDataWrapper<User>);
      },
      onStateChanged: (PrefixMatchState? state) {
        if (state != null && (filterState == null || filterState != state)) {
          filterState = state;
          filterData();
        }

        if (state != null) {
          if (overlayEntry == null) {
            if (data.isEmpty) {
              _getAllUserInPost(state.text);
            }
            showSuggestionDialog();
          }
        } else {
          removeOverlay();
        }
      },
    );
  }

  void filterData() {
    dataFilter = data
        .where((element) =>
            element.item?.name?.toLowerCase().contains((filterState?.text ?? " ").substring(1, filterState?.text.length ?? 1).toLowerCase()) == true)
        .toList();
  }

  void _listenKeyBoard() {
    printInfo(info: focusNode.hasFocus.toString());
    if (!focusNode.hasFocus) {
      removeOverlay();
    }
  }

  void _loadUserFromLocal() {
    user = _userStorage.get();
  }

  void removeOverlay() {
    try {
      overlayEntry?.remove();
      overlayEntry = null;
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<List<User>> _getAllUserInPost(String keyword) async {
    List<User> users = [];
    await call(
      () async => users = await _getAllUserInPostUsecase.run(post.id),
      showLoading: false,
      onSuccess: () {
        data = users
            .map(
              (e) => SuggestedDataWrapper<User>(
                id: e.name!,
                prefix: "@",
                item: e,
              ),
            )
            .toList();
        filterData();
      },
    );
    return users;
  }

  void onSendCommentClick() {
    if (controller!.text.isEmpty) {
      return;
    }
    call(
      () async {
        final Comment? comment = await _createCommentUsecase.call(
          post.id,
          controller!.text.replaceAll("\n", "\\n"),
          tagUsers,
        );
        if (comment != null) {
          controller?.clear();
          comment.commentTagUser = tagUsers.toList();
          post.increasePostCommentsCount();
          onSendComment(comment);
        }
      },
      showLoading: false,
    );
  }

  void onSubmitted() {
    removeOverlay();
  }

  bool isTagedUser(User user) {
    return tagUsers.lastIndexWhere((element) => element.id == user.id) != -1;
  }

  void addTagUser(User user) {
    tagUsers.add(user);
  }

  void _removeUserInTags(List<User> users) {
    tagUsers.removeWhere((element) => element.id == users[0].id);
  }

  List<SuggestedDataWrapper<User>> get dataFilter => _dataFilter.toList();

  set dataFilter(List<SuggestedDataWrapper<User>> value) {
    _dataFilter.assignAll(value);
  }

  @override
  void disposeState() {
    controller!.dispose();
    focusNode.removeListener(_listenKeyBoard);
    focusNode.dispose();
    super.disposeState();
  }
}
