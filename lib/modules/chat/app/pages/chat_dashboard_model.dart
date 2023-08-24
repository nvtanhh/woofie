import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/configs/app_config.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_with_uuid_usecase.dart';
import 'package:meowoof/modules/chat/app/request_message/request_message.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/domain/usecases/request_message/count_user_request_message.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_chat_rooms_usecase.dart';
import 'package:meowoof/modules/social_network/domain/models/setting.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/setting/get_setting_remote_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ChatManagerModel extends BaseViewModel {
  final GetChatRoomsUseCase _getChatRoomsUseCase;
  final GetUserWithUuidUsecase _getUserWithUuidUsecase;
  final CountUserRequestMessagesUsecase _countUserRequestMessagesUsecase;
  final GetSettingUsecase _getSettingUsecase;

  late PagingController<int, ChatRoom> pagingController;
  late DateTime _lastRefeshTime;
  static const int _pageSize = 10;
  final RxInt _countUserRequestMessage = RxInt(0);

  bool? _isEveryoneCanChatWithMe;

  ChatManagerModel(
    this._getChatRoomsUseCase,
    this._getUserWithUuidUsecase,
    this._countUserRequestMessagesUsecase,
    this._getSettingUsecase,
  );

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    pagingController
        .addPageRequestListener((pageKey) => _loadMoreChatRoom(pageKey));
    _lastRefeshTime = DateTime.now();
    _getCountUserRequestMessage();
    _getMessageSetting();
    super.initState();
  }

  Future<void> _loadMoreChatRoom(int pageKey) async {
    try {
      if (_isEveryoneCanChatWithMe == null) {
        await _getMessageSetting();
      }
      final chatRooms = await _getChatRoomsUseCase.call(
        skip: pageKey,
        isEveryoneCanChatWithMe: _isEveryoneCanChatWithMe,
      );
      chatRooms.forEach(_getMoreChatRoomInformation);
      final isLastPage = chatRooms.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(chatRooms);
      } else {
        final nextPageKey = pageKey + chatRooms.length;
        pagingController.appendPage(chatRooms, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    } finally {
      _lastRefeshTime = DateTime.now();
    }
  }

  void _getMoreChatRoomInformation(ChatRoom room) {
    _getDisplayedNameAndAvatarSync(room);
    _getMembersSync(room);
  }

  Future<void> _getDisplayedNameAndAvatarSync(ChatRoom room) async {
    // Bcz room.rawName is a processed string which is userUuid
    if (!room.isGroup) {
      final userUuid = room.rawName;
      final user = await _getUserWithUuid(userUuid);
      try {
        room.privateChatPartner = user;
        room.notifyUpdate();
      } catch (error) {
        printError(info: error.toString());
      }
    }
  }

  Future<User> _getUserWithUuid(String userUuid) async {
    final User? user = User.getUserFromCache(key: userUuid);
    if (user != null) return user;
    return _getUserWithUuidUsecase.call(userUuid);
  }

  Future<void> _getMembersSync(ChatRoom room) async {
    room.members = await Future.wait(
      room.memberUuids
          .map((userUuid) async => _getUserWithUuid(userUuid))
          .toList(),
    );
  }

  void goToRequestMessagePage() {
    Get.to(() => RequestMessagePage());
  }

  Future<void> onRefresh() async {
    if (_isCanRefesh()) {
      pagingController.refresh();
    }
  }

  bool _isCanRefesh() {
    return DateTime.now().difference(_lastRefeshTime).inSeconds >
        AppConfig.REFRESH_INTERVAL_LIMIT_SECOND;
  }

  void onChatRoomPressed(ChatRoom room) {
    injector<NavigationService>().navigateToChatRoom(
      room: room,
      onAddNewMessages: (List<Message> messages) =>
          _onChatRoomAddNewMessage(room, messages),
    );
  }

  void _onChatRoomAddNewMessage(ChatRoom room, List<Message> messages) {
    room.updateMessages(messages);
    final rooms = pagingController.itemList!;
    rooms.insert(0, rooms.removeAt(rooms.indexOf(room)));
    // ignore: invalid_use_of_protected_member,  invalid_use_of_visible_for_testing_member
    pagingController.notifyListeners();
  }

  void _getCountUserRequestMessage() {
    run(
      () async => countUserRequestMessage =
          await _countUserRequestMessagesUsecase.run(),
      showLoading: false,
    );
  }

  int get countUserRequestMessage => _countUserRequestMessage.value;

  set countUserRequestMessage(int value) {
    _countUserRequestMessage.value = value;
  }

  Future _getMessageSetting() async {
    final loggedInUser = injector<LoggedInUser>().user;
    if (loggedInUser!.setting != null) {
      _isEveryoneCanChatWithMe =
          loggedInUser.setting!.isEveryoneCanChatWithMe();
    } else {
      final Setting? setting = await _getSettingUsecase.call();
      if (setting != null) {
        _isEveryoneCanChatWithMe = setting.isEveryoneCanChatWithMe();
      } else {
        _isEveryoneCanChatWithMe = true;
      }
    }
  }
}
