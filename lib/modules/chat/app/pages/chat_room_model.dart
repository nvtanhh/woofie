import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/configs/backend_config.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/domain/usecases/message/get_messages_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_messages_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_presined_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:path/path.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:suga_core/suga_core.dart';

@injectable
class ChatRoomPageModel extends BaseViewModel {
  final GetPresignedUrlForChatUsecase _getPresignedUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessagesUsecase _sendMessagesUsecase;

  final MediaService _mediaService;
  final FirebaseAuth _auth;

  late ChatRoom room;

  final RxList<MediaFile> _sendingMedias = <MediaFile>[].obs;
  ScrollController scrollController = ScrollController();
  final TextEditingController messageSenderTextController =
      TextEditingController();
  final RxBool _isCanSendMessage = false.obs;

  late PagingController<int, Message> pagingController;
  static const int _pageSize = 10;

  final RxBool isTyping = false.obs;
  late Function(List<Message>) popOutCallback;

  late IO.Socket? _socket;

  Timer? _typingDisableTimer;

  ChatRoomPageModel(
    this._mediaService,
    this._getPresignedUrlUsecase,
    this._uploadMediaUsecase,
    this._getMessagesUseCase,
    this._sendMessagesUsecase,
    this._auth,
  );

  @override
  void initState() {
    super.initState();
    pagingController = PagingController(firstPageKey: room.messages.length);
    pagingController.appendPage(room.messages, room.messages.length);
    pagingController
        .addPageRequestListener((pageKey) => _loadMoreMessage(pageKey));
    _initChatSocket();
    _setupListenCanSendMessage();
  }

  Future<void> _initChatSocket() async {
    printInfo(info: 'Initiating socket..........');
    final token = await _auth.currentUser?.getIdToken();

    _socket = IO.io(
      BackendConfig.BASE_CHAT_URL,
      IO.OptionBuilder()
          .setQuery({
            'token': token,
          })
          .setTransports(['websocket'])
          .enableForceNew()
          .build(),
    );

    _socket?.onConnect((_) {
      printInfo(info: 'Socket connected...');
    });

    _socket?.on('authenticated', (data) {
      printInfo(info: 'Socket authenticate status ${data.toString()}');
    });

    _socket?.on('is-typing', _onPartnerTyping);
    _socket?.onDisconnect((_) {});
  }

  @override
  void disposeState() {
    _socket?.dispose();
    _typingDisableTimer?.cancel();
    messageSenderTextController.dispose();
    pagingController.dispose();
    super.disposeState();
  }

  Future<void> _loadMoreMessage(int pageKey) async {
    try {
      final newItems =
          await _getMessagesUseCase.call(skip: pageKey, roomId: room.id);
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
      _sentTypingEvent();
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
    final messages = pagingController.itemList!;
    return index == 0 ||
        messages[index].senderId != messages[index - 1].senderId;
  }

  Future<void> onMediaPicked(List<MediaFile> media) async {
    _sendingMedias.value = media;
  }

  Future<void> onRemoveSeedingMedia(MediaFile media) async {
    _sendingMedias.remove(media);
  }

  Future<void> onSendMessage() async {
    if (isCanSendMessage) {
      await call(
        () async {
          final messageType = _getMessageType();
          String content = '';
          if (messageType == MessageType.text) {
            content = messageSenderTextController.text;
          } else if (messageType == MessageType.image ||
              messageType == MessageType.video) {
            content = await _startUploadMedia();
          }

          final description = messageType != MessageType.text
              ? messageSenderTextController.text
              : null;

          final message = await _sendMessagesUsecase.call(
              roomId: room.id,
              content: content,
              type: messageType,
              description: description);

          pagingController.itemList!.insert(0, message);
          // ignore: invalid_use_of_protected_member,  invalid_use_of_visible_for_testing_member
          pagingController.notifyListeners();
          room.updateMessage(message);
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
      } else if (media.isVideo) {
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
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
    );
  }

  void _onPartnerTyping(data) {
    // final String typingUserUuid = data as String;
    isTyping.value = true;
    startTypingTimeout();
  }

  void startTypingTimeout() {
    if (_typingDisableTimer?.isActive ?? false) {
      _typingDisableTimer?.cancel();
    }
    _typingDisableTimer =
        Timer(const Duration(seconds: 2), () => isTyping.value = false);
  }

  void _sentTypingEvent() {
    _socket?.emit('typing', room.creatorUuid);
  }
}
