import 'dart:async';
import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/configs/backend_config.dart';
import 'package:meowoof/core/helpers/unwaited.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/ui/confirm_dialog.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/domain/usecases/message/get_messages_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_messages_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_presined_url_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/init_chat_room_usecase.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_detail_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:path/path.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:suga_core/suga_core.dart';
import 'package:uuid/uuid.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/core/extensions/string_ext.dart';

@injectable
class ChatRoomPageModel extends BaseViewModel {
  final GetPresignedUrlForChatUsecase _getPresignedUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessagesUsecase _sendMessagesUsecase;
  final InitChatRoomsUseCase _initChatRoomsUseCase;
  final LikePostUsecase _likePostUsecase;
  final GetDetailPostUsecase _getDetailPostUsecase;

  final MediaService _mediaService;
  final FirebaseAuth _auth;

  ChatRoom? inputRoom;
  User? partner;
  Function(List<Message>)? onAddNewMessages;

  late ChatRoom room;
  final RxBool isLoaded = false.obs;

  final RxList<MediaFile> _sendingMedias = <MediaFile>[].obs;
  ScrollController scrollController = ScrollController();
  final TextEditingController messageSenderTextController =
      TextEditingController();
  final RxBool _isCanSendMessage = false.obs;

  late PagingController<int, Message> pagingController =
      PagingController(firstPageKey: 0);
  static const int _pageSize = 10;

  final RxBool partnerTypingStatus = false.obs;
  late Function(List<Message>) popOutCallback;

  IO.Socket? _socket;

  Timer? _sendEventStopTypingTimer;

  // Timer? _startDisableTypingTimer;

  // ignore: constant_identifier_names
  static const int TYPING_INTEVAL_TIME = 2;
  bool _isTyping = false;

  late Rxn<Post> attachmentPost = Rxn<Post>();

  ChatRoomPageModel(
    this._mediaService,
    this._getPresignedUrlUsecase,
    this._uploadMediaUsecase,
    this._getMessagesUseCase,
    this._sendMessagesUsecase,
    this._auth,
    this._initChatRoomsUseCase,
    this._likePostUsecase,
    this._getDetailPostUsecase,
  );

  @override
  void disposeState() {
    _disposeSocket();
    _updateChatDashboard();
    messageSenderTextController.dispose();
    pagingController.dispose();
    super.disposeState();
  }

  void _disposeSocket() {
    _sendTypingEvent(isTyping: false);
    _socket?.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (inputRoom != null) {
      room = inputRoom!;
      _initModel();
    } else {
      _initChatRoom().then((chatRoom) {
        if (chatRoom == null) {
          return;
        }
        room = chatRoom;
        room.privateChatPartner = partner;
        _initModel();
      });
    }
    if (attachmentPost.value != null) {
      _isCanSendMessage.value = true;
    }
  }

  Future<ChatRoom?> _initChatRoom() async {
    ChatRoom? chatRoom;
    await call(
      () async {
        chatRoom = await _initChatRoomsUseCase.call(partner!);
      },
      onFailure: (e) {
        Get.back(result: true);
      },
      showLoading: false,
    );
    return chatRoom;
  }

  void _initModel() {
    pagingController = PagingController(firstPageKey: room.messages.length);
    pagingController.appendPage(room.messages, room.messages.length);
    pagingController
        .addPageRequestListener((pageKey) => _loadMoreMessage(pageKey));
    _initChatSocket();
    _setupListenCanSendMessage();
    isLoaded.value = true;
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

    _socket?.onConnect((data) {
      printInfo(info: 'Socket connected...');
    });

    _socket?.on('authenticated', (data) {
      printInfo(info: 'Socket authenticate status ${data.toString()}');
    });

    _socket?.on('is-typing', _onPartnerTyping);
    _socket?.on('new-message', _onNewMessageComming);
    _socket?.onDisconnect((data) {});
  }

  void _onNewMessageComming(data) {
    final newMessage =
        Message.fromJson(data['message'] as Map<String, dynamic>);
    if (room.isMyMessage(newMessage)) {
      _updateNewMessage(newMessage);
      // when a new message comes, we should stop the typing animation
      partnerTypingStatus.value = false;
    } else {
      // hanlde other room's messages
    }
  }

  /// Hanlding on typing event - worked with private chat (for now).
  void _onPartnerTyping(data) {
    if (!room.isGroup) {
      partnerTypingStatus.value = data['isTyping'] as bool;
    }
  }

  // void _startTypingTimeout() {
  //   if (_startDisableTypingTimer?.isActive ?? false) {
  //     _startDisableTypingTimer?.cancel();
  //   }
  //   _startDisableTypingTimer = Timer(
  //     const Duration(seconds: TYPING_INTEVAL_TIME * 2),
  //     () => partnerTypingStatus.value = false,
  //   );
  // }

  void _updateNewMessage(Message message, {bool notifyChatRoom = true}) {
    if (pagingController.itemList!.isEmpty) {
      pagingController.itemList!.add(message);
    } else {
      pagingController.itemList!.insert(0, message);
    }
    if (pagingController.nextPageKey == 0) {
      pagingController.nextPageKey = 1;
    }
    // ignore: invalid_use_of_protected_member,  invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();
    // if (notifyChatRoom) _nofityChatDashboard(message);
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
    attachmentPost.stream.listen((post) {
      checkIsCanSendMessage();
    });
    messageSenderTextController.addListener(() {
      checkIsCanSendMessage();
      _startSendTypingEventTimeout();
    });
    _sendingMedias.stream.listen((list) {
      checkIsCanSendMessage();
    });
  }

  void checkIsCanSendMessage() {
    _isCanSendMessage.value =
        messageSenderTextController.text.trim().isNotEmpty ||
            _sendingMedias.isNotEmpty ||
            attachmentPost.value != null;
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
          final Message sendingMessage = Message(
            roomId: room.id,
            content: '',
            type: _getMessageType(),
            senderId: injector<LoggedInUser>().user!.uuid,
            createdAt: DateTime.now().toUtc(),
            isSent: false,
          );
          sendingMessage.localUuid = const Uuid().v4();

          Message? newMessage;
          // Insert sending message to message list
          if (sendingMessage.type == MessageType.text) {
            sendingMessage.content = messageSenderTextController.text.trim();
            _updateNewMessage(sendingMessage, notifyChatRoom: false);
            _cleanSender();
            newMessage = await _sendMessage(sendingMessage.clone());
          } else if (sendingMessage.type == MessageType.image ||
              sendingMessage.type == MessageType.video) {
            sendingMessage.content = _sendingMedias.first.file.path;
            sendingMessage.description =
                messageSenderTextController.text.trim();
            _updateNewMessage(sendingMessage.clone(), notifyChatRoom: false);

            final MediaFile mediaToUpload = _sendingMedias.first;
            _cleanSender();
            sendingMessage.content = await _startUploadMedia(mediaToUpload);
            newMessage = await _sendMessage(sendingMessage);
          } else if (sendingMessage.type == MessageType.post) {
            final isConfirmed = await _showConfirmActionFunctionalPost();
            if (!isConfirmed) return;
            Pet? petToMatinng;
            if (attachmentPost.value!.type == PostType.mating) {
              await injector<BottomSheetService>().showTagPetBottomSheet(
                title: 'Chọn thú cưng để ghép đôi cùng',
                userPets: injector<LoggedInUser>().user!.currentPets!,
                needConfirmButton: true,
                onPetChosen: (pet) {
                  if (_isCanMating(pet)) {
                    Get.back();
                    petToMatinng = pet;
                  }
                },
              );
              if (petToMatinng == null) return;
            }
            final Map contentMap = {'post': attachmentPost.value!.toJson()};
            if (petToMatinng != null) {
              contentMap['additional_data'] = petToMatinng!.toJson();
            }
            sendingMessage.content = json.encode(contentMap);
            sendingMessage.description =
                messageSenderTextController.text.trim();
            _updateNewMessage(sendingMessage, notifyChatRoom: false);
            // Trigger like post it - it means that the logged in user wants to adop/matting with post's pet
            unawaited(_triggerFunctionalPost(attachmentPost.value!));
            _cleanSender();
            newMessage = await _sendMessage(sendingMessage);
          }

          // find the new message in the recent message list ==> mark it as sent
          if (newMessage != null) {
            final List<Message> messages = pagingController.itemList!;
            final index = messages
                .indexWhere((message) => _isMessageSelf(message, newMessage!));
            messages.removeAt(index);
            messages.insert(index, newMessage);
            // ignore: invalid_use_of_protected_member,  invalid_use_of_visible_for_testing_member
            pagingController.notifyListeners();
            // _nofityChatDashboard(newMessage);
          }
        },
        onFailure: (error) {
          Get.snackbar(
            LocaleKeys.chat_send_message_error_tile.trans(),
            LocaleKeys.chat_send_message_error_description.trans(),
            duration: const Duration(seconds: 1),
            backgroundColor: UIColor.danger,
            colorText: UIColor.white,
          );
        },
        onSuccess: () {},
        showLoading: false,
      );
    }
  }

  bool _isMessageSelf(Message message, Message newMessage) {
    return (message.localUuid != null &&
            newMessage.localUuid != null &&
            message.localUuid == newMessage.localUuid) ||
        (message.createdAt == newMessage.createdAt);
  }

  Future<Message> _sendMessage(Message sendingMessage) async {
    return _sendMessagesUsecase.call(sendingMessage);
  }

  Future<String> _startUploadMedia(MediaFile meida) async {
    final compressedImage = await _compressPostMediaItem(meida);
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
    if (attachmentPost.value != null) {
      type = MessageType.post;
    } else if (sendingMedias.isNotEmpty) {
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
    attachmentPost.value = null;
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
        'receiver': room.privateChatPartner?.uuid,
        'isTyping': isTyping,
      };
      _sendEventToSocket('typing', data);
    }
  }

  void _updateChatDashboard() {
    Future.delayed(
      Duration.zero,
      () {
        try {
          final newMessages = pagingController.itemList!
              .toSet()
              .difference(room.messages.toSet())
              .toList();
          if (newMessages.isNotEmpty && onAddNewMessages != null) {
            onAddNewMessages!(newMessages);
          }
        } catch (error) {
          // Do nothing
          return;
        }
      },
    );
  }

  void onRemoveAttachmentPost() {
    if (attachmentPost.value != null) {
      attachmentPost.value = null;
    }
  }

  Future _triggerFunctionalPost(Post post) async {
    if (!post.isLiked!) {
      await call(
        () async => _likePostUsecase.call(post.id),
        onSuccess: () => post.isLiked = true,
        showLoading: false,
      );
    }
  }

  Future<bool> _showConfirmActionFunctionalPost() async {
    final Pet pet = attachmentPost.value!.taggegPets![0];
    final String content = attachmentPost.value!.type == PostType.adop
        ? 'Khi bạn gửi tin nhắn này đồng nghĩa bạn muốn nhận ${pet.name} làm thú cưng, và bạn sẽ trở thành chủ sở hữu mới của ${pet.name} khi được chủ cũ đồng ý.'
        : 'Khi bạn gửi tin nhắn này đồng nghĩa bạn muốn ghép đôi ${pet.name} với thú cưng của bạn.';
    bool isConfirm = false;
    await Get.dialog(
      ConfirmDialog(
        title: 'Lưu ý',
        content: content,
        confirmText: 'Xác nhận',
        cancelText: 'Hủy',
        onConfirm: () async {
          isConfirm = true;
        },
        onCancel: () {
          isConfirm = false;
        },
      ),
    );
    return isConfirm;
  }

  bool _isCanMating(Pet pet) {
    final Pet postPet = attachmentPost.value!.taggegPets![0];
    if (AgeCalculator.age(pet.dob!).months < 6) {
      Get.dialog(
        const ConfirmDialog(
          title: 'Không thể ghép đôi',
          content:
              'Không thể ghép đôi do thú cưng của bạn chưa đủ 6 tháng tuổi.',
          confirmText: 'Đã hiểu',
          cancelText: '',
        ),
      );
      return false;
    }
    if (pet.gender == postPet.gender) {
      Get.dialog(
        const ConfirmDialog(
          title: 'Không thể ghép đôi',
          content: 'Bạn không thể ghép đôi 2 thú cưng có cùng giới tính.',
          confirmText: 'Đã hiểu',
          cancelText: '',
        ),
      );
      return false;
    }
    return true;
  }
}
