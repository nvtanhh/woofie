import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/auth/domain/usecases/get_user_with_uuid_usecase.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_chat_rooms_usecase.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';
import 'package:get/get.dart';

@injectable
class ChatManagerModel extends BaseViewModel {
  final GetChatRoomsUseCase _getChatRoomsUseCase;
  final GetUserWithUuidUsecase _getUserWithUuidUsecase;

  late PagingController<int, ChatRoom> pagingController;
  late DateTime _lastRefeshTime;
  static const int _pageSize = 10;

  ChatManagerModel(this._getChatRoomsUseCase, this._getUserWithUuidUsecase);

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener((pageKey) => _loadMorePost(pageKey));
    _lastRefeshTime = DateTime.now();
    super.initState();
  }

  Future<void> _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getChatRoomsUseCase.call();
      newItems.forEach(_getMoreChatRoomInformation);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
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
    room.members = await Future.wait(room.memberUuids.map((userUuid) async => _getUserWithUuid(userUuid)).toList());
  }

  void onWantsToCreateNewChat() {}

  Future<void> onRefresh() async {}

  void onChatRoomPressed(ChatRoom room) {
    injector<NavigationService>().navigateToChatRoom(room);
  }
}
