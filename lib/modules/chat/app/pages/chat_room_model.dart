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

  final RxBool partnerTypingStatus = false.obs;
  late Function(List<Message>) popOutCallback;

  late IO.Socket? _socket;

  Timer? _sendEventStopTypingTimer;

  // ignore: constant_identifier_names
  static const int TYPING_INTEVAL_TIME = 2;
  bool _isTyping = false;

  ChatRoomPageModel(
    this._mediaService,
    this._getPresignedUrlUsecase,
    this._uploadMediaUsecase,
    this._getMessagesUseCase,
    this._sendMessagesUsecase,
    this._auth,
  );

  @override
  void disposeState() {
    _socket?.dispose();
    messageSenderTextController.dispose();
    pagingController.dispose();
    super.disposeState();
  }

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: room.messages.length);
    pagingController.appendPage(room.messages, room.messages.length);
    pagingController
        .addPageRequestListener((pageKey) => _loadMoreMessage(pageKey));
    _initChatSocket();
    _setupListenCanSendMessage();
    super.initState();
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
    _socket?.on('new-message', _onNewMessageComming);
    _socket?.onDisconnect((_) {});
  }

  void _onNewMessageComming(data) {
    final newMessage =
        Message.fromJson(data['message'] as Map<String, dynamic>);
    _updateNewMessage(newMessage);
  }

  /// Hanlding on typing event - worked with private chat (for now).
  void _onPartnerTyping(data) {
    if (!room.isGroup) {
      partnerTypingStatus.value = data['isTyping'] as bool;
      // _startTypingTimeout();
    }
  }

  void _updateNewMessage(Message message) {
    pagingController.itemList!.insert(0, message);
    // ignore: invalid_use_of_protected_member,  invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();
    room.updateMessage(message);
  }

  void _startSendTypingEventTimeout() {
    if (_sendEventStopTypingTimer?.isActive ?? false) {
      _sendEventStopTypingTimer?.cancel();
    }
    _sendTypingEvent(isTyping: true);
    _sendEventStopTypingTimer = Timer(
      const Duration(seconds: TYPING_INTEVAL_TIME),
      () => _sendTypingEvent(isTyping: false),
    );
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
      _startSendTypingEventTimeout();
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

          final Message newMessage = await _sendMessagesUsecase.call(
            roomId: room.id,
            content: content,
            type: messageType,
            description: description,
          );
          _updateNewMessage(newMessage);
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

  void _sendEventToSocket(String eventName, Object? data) {
    try {
      _socket?.emit(eventName, data);
    } catch (error) {
      printError(info: error.toString());
    }
  }

  void _sendTypingEvent({required bool isTyping}) {
    if (_isTyping != isTyping) {
      _isTyping = isTyping;
      final Map data = {
        'receiver': room.creatorUuid,
        'isTyping': isTyping,
      };
      _sendEventToSocket('typing', data);
    }
  }
}
