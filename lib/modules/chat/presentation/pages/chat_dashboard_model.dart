import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/usecases/room/get_chat_rooms_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ChatManagerModel extends BaseViewModel {
  final GetChatRoomsUseCase _getChatRoomsUseCase;
  late PagingController<int, ChatRoom> pagingController;
  late DateTime _lastRefeshTime;
  static const int _pageSize = 10;

  ChatManagerModel(this._getChatRoomsUseCase);

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

  void onWantsToCreateNewChat() {}

  Future<void> onRefresh() async {}
}
