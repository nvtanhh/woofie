import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/domain/usecases/message/get_messages_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_presined_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';
import 'package:uuid/uuid.dart';

@injectable
class ChatRoomPageModel extends BaseViewModel {
  final MediaService _mediaService;
  final GetPresignedUrlForChatUsecase _getPresignedUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final GetMessagesUseCase _getMessagesUseCase;

  late ChatRoom room;
  late RxList<Message> messages = <Message>[].obs;

  final RxList<MediaFile> _sendingMedias = <MediaFile>[].obs;
  ScrollController scrollController = ScrollController();
  final TextEditingController messageSenderTextController =
      TextEditingController();
  final RxBool _isCanSendMessage = false.obs;

  late PagingController<int, Message> pagingController;
  static const int _pageSize = 10;

  final keyboardVisibilityController = KeyboardVisibilityController();

  ChatRoomPageModel(
    this._mediaService,
    this._getPresignedUrlUsecase,
    this._uploadMediaUsecase,
    this._getMessagesUseCase,
  );

  // List<Message> get messages => _messages.toList();
  // set messages(List<Message> list) => _messages.value = list;

  @override
  void initState() {
    super.initState();
    // pagingController = PagingController(firstPageKey: room.messages.length);
    // pagingController.appendPage(room.messages, room.messages.length);
    // pagingController
    //     .addPageRequestListener((pageKey) => _loadMorePost(pageKey));

    _addScrollListener();

    _setupListenCanSendMessage();
  }

  void _addScrollListener() {
    //  scrollController.addListener(() {
    //   bool topReached = widget.inverted
    //       ? scrollController.offset >=
    //               scrollController.position.maxScrollExtent &&
    //           !scrollController.position.outOfRange
    //       : scrollController.offset <=
    //               scrollController.position.minScrollExtent &&
    //           !scrollController.position.outOfRange;

    //   if (widget.shouldShowLoadEarlier) {
    //     if (topReached) {
    //       setState(() {
    //         showLoadMore = true;
    //       });
    //     } else {
    //       setState(() {
    //         showLoadMore = false;
    //       });
    //     }
    //   } else if (topReached) {
    //     widget.onLoadEarlier!();
    //   }
    // });
    // }
  }

  Future<void> _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getMessagesUseCase.call(skip: pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    } finally {}
  }

  void _setupListenCanSendMessage() {
    messageSenderTextController.addListener(() {
      if (messageSenderTextController.text.trim().isNotEmpty) {
        _isCanSendMessage.value = true;
      } else {
        _isCanSendMessage.value = false;
      }
    });
    _sendingMedias.stream.listen((list) {
      if (list != null && list.isNotEmpty) {
        _isCanSendMessage.value = true;
      } else if (list != null) {
        _isCanSendMessage.value = false;
      }
    });
  }

  List<MediaFile> get sendingMedias => _sendingMedias.toList();

  bool get isCanSendMessage => _isCanSendMessage.value;

  bool checkIsDisplayAvatar(int index) {
    // final messages = pagingController.itemList!;
    return index == messages.length - 1 ||
        messages[index].senderId != messages[index + 1].senderId;
  }

  Future<void> onMediaPicked(List<MediaFile> media) async {
    _sendingMedias.value = media;
  }

  Future<void> onRemoveSeedingMedia(MediaFile media) async {
    _sendingMedias.remove(media);
  }

  void onSendMessage() {
    if (isCanSendMessage) {
      call(
        () async {
          // final uploadedMediaUrl = await _startUploadMedia();
          final messageType = _getMessageType();
          final content = messageType == MessageType.text
              ? messageSenderTextController.text
              : await _startUploadMedia();
          final description = messageType != MessageType.text
              ? messageSenderTextController.text
              : null;
          final senderId = injector<LoggedInUser>().user!.uuid!;
          final Message fakeNewMessage = Message(
            objectId: const Uuid().v4(),
            content: content,
            description: description,
            type: messageType,
            senderId: senderId,
            createdAt: DateTime.now(),
          );

          // pagingController
          //     .appendPage([fakeNewMessage], pagingController.nextPageKey);

          messages.insert(0, fakeNewMessage);

          // scrollToBottom();
        },
        onFailure: (error) {
          Get.snackbar(
            "Error",
            "Can't send message. Please try again.",
            duration: const Duration(seconds: 1),
            backgroundColor: UIColor.danger,
            colorText: UIColor.white,
          );
        },
        onSuccess: () {
          _cleanSender();
        },
        showLoading: false,
      );
    }
  }

  Future<String> _startUploadMedia() async {
    final compressedImage = await _compressPostMediaItem(_sendingMedias.first);
    final String fileName = basename(compressedImage.file.path);
    final String preSignedUrl =
        await _getPresignedUrlUsecase.call(fileName, room.id);
    final uploadedMediaUrl =
        await _uploadMediaUsecase.call(preSignedUrl, compressedImage.file);
    return uploadedMediaUrl!;
  }

  Future<MediaFile> _compressPostMediaItem(MediaFile postMediaItem) async {
    return _mediaService.compressPostMediaItem(postMediaItem);
  }

  MessageType _getMessageType() {
    MessageType? type;
    if (sendingMedias.isNotEmpty) {
      final media = sendingMedias.first;
      if (media.isImage) {
        type = MessageType.image;
      } else if (media.isImage) {
        type = MessageType.video;
      }
    } else {
      type = MessageType.text;
    }
    return type ?? MessageType.text;
  }

  void _cleanSender() {
    _sendingMedias.clear();
    messageSenderTextController.clear();
  }

  void scrollToBottom() {
    Timer(
      const Duration(milliseconds: 200),
      () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
    );
  }
}
