import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/modules/social_network/domain/events/comment/comment_updated_event.dart';
import 'package:meowoof/modules/social_network/domain/events/comment/comment_updating_event.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/create_comment_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_all_user_in_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/play_sound_add_new_comment.dart';
import 'package:suga_core/suga_core.dart';
import 'package:type_ahead_text_field/type_ahead_text_field.dart';

@injectable
class SendCommentWidgetModel extends BaseViewModel {
  final GetAllUserInPostUsecase _getAllUserInPostUsecase;
  final CreateCommentUsecase _createCommentUsecase;
  final RxList<SuggestedDataWrapper<User>> _dataFilter = RxList([]);
  final GlobalKey<EditableTextState> tfKey = GlobalKey();
  final GlobalKey suggestionWidgetKey = GlobalKey();
  final EventBus _eventBus;
  final LoggedInUser _loggedInUser;
  final PlaySoundAddNewComment _playSoundAddNewComment;
  late Function(Comment) onSendComment;
  late Post post;
  late Function showSuggestionDialog;
  late TextSpan Function(SuggestedDataWrapper<User>) customSpan;
  Comment? comment;
  late User? user;
  List<SuggestedDataWrapper<User>> data = [];
  List<User> tagUsers = [];
  TypeAheadTextFieldController? controller;
  PrefixMatchState? filterState;
  OverlayEntry? overlayEntry;
  bool isUpdate = false;
  StreamSubscription? _commentUpdatingStreamSubscription,
      _commentUpdatedStreamSubscription;

  SendCommentWidgetModel(
    this._getAllUserInPostUsecase,
    this._createCommentUsecase,
    this._eventBus,
    this._loggedInUser,
    this._playSoundAddNewComment,
  ) {
    user = _loggedInUser.user;
  }

  @override
  void initState() {
    initController();
    _registerCommentUpdatingStreamSubscription();
    _registerCommentUpdatedStreamSubscription();
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

  void _registerCommentUpdatingStreamSubscription() {
    _commentUpdatingStreamSubscription =
        _eventBus.on<CommentUpdatingEvent>().listen(
      (event) {
        isUpdate = true;
        comment = event.comment;
        tagUsers = comment!.commentTagUser!.toList();
        controller!.text = comment!.content!;
        reInstallData();
      },
    );
  }

  void _registerCommentUpdatedStreamSubscription() {
    _commentUpdatedStreamSubscription =
        _eventBus.on<CommentUpdatedEvent>().listen(
      (event) {
        isUpdate = false;
        controller?.clear();
      },
    );
  }

// for edit
  void reInstallData() {
    // ignore: avoid_function_literals_in_foreach_calls
    comment?.commentTagUser?.forEach(
      (e) {
        try {
          controller?.approveSelection(
            PrefixMatchState("@", e.name ?? ""),
            SuggestedDataWrapper<User>(
              prefix: "@",
              id: e.name ?? "",
              item: e,
            ),
          );
        } catch (e) {
          // ignore: empty_catches
        }
      },
    );
  }

  void filterData() {
    dataFilter = data
        .where((element) =>
            element.item?.name?.toLowerCase().contains(
                (filterState?.text ?? " ")
                    .substring(1, filterState?.text.length ?? 1)
                    .toLowerCase(),) ==
            true,)
        .toList();
  }

  void loadUserFromLocal() {
    user = _loggedInUser.user;
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
    await run(
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
        //avoid tag yourself
        data.removeWhere((element) => element.item?.id == user?.id);
        filterData();
      },
    );
    return users;
  }

  void onSendCommentClick() {
    if (controller!.text.isEmpty) {
      return;
    }
    Comment? newComment;
    if (!isUpdate) {
      run(
        () async => newComment = await _createCommentUsecase.call(
          post.id,
          controller!.text.replaceAll("\n", "\\n"),
          tagUsers,
        ),
        onSuccess: () {
          if (newComment != null) {
            controller?.clear();
            newComment!.commentTagUser = tagUsers.toList();
            post.increasePostCommentsCount();
            onSendComment(newComment!);
            _playSoundAddNewComment.run();
          }
        },
      );
    } else {
      newComment = Comment(
        id: 0,
        postId: post.id,
        content: controller!.text.replaceAll("\n", "\\n"),
        commentTagUser: tagUsers.toList(),
      );
      onSendComment(newComment);
    }
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
    _commentUpdatingStreamSubscription?.cancel();
    _commentUpdatedStreamSubscription?.cancel();
    super.disposeState();
  }
}
