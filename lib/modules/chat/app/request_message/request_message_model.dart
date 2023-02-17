import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/modules/chat/app/pages/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';
import 'package:meowoof/modules/chat/domain/usecases/request_message/accept_request_message_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/request_message/deny_request_message_usecase.dart';
import 'package:meowoof/modules/chat/domain/usecases/request_message/get_request_messages_to_user_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class RequestMessagePageModel extends BaseViewModel {
  final GetRequestMessagesToUserUsecase _getRequestMessagesToUserUsecase;
  final AcceptRequestMessagesUsecase _acceptRequestMessagesUsecase;
  final DenyRequestMessagesUsecase _denyRequestMessagesUsecase;
  final NavigationService _navigationService;
  int _nextPageKey = 0;
  final int _pageSize = 10;
  late PagingController<int, RequestContact> pagingController;

  RequestMessagePageModel(
    this._getRequestMessagesToUserUsecase,
    this._acceptRequestMessagesUsecase,
    this._denyRequestMessagesUsecase,
    this._navigationService,
  );

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: _nextPageKey);
    pagingController.addPageRequestListener(
      (pageKey) => _loadMoreRequestMessage(pageKey),
    );
    super.initState();
  }

  Future _loadMoreRequestMessage(int pageKey) async {
    try {
      final newItems = await _getRequestMessagesToUserUsecase.run();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        _nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, _nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> onRefresh() async {
    pagingController.nextPageKey = 0;
    pagingController.refresh();
    return;
  }

  void acceptRequest(RequestContact requestContact) {
    run(
      () async => _acceptRequestMessagesUsecase.run(requestContact),
      onSuccess: () {
        _navigationService.navigateToChatRoom(user: requestContact.fromUser);
      },
      onFailure: (err) {
        print(err.toString());
      },
    );
  }

  void denyRequest(RequestContact requestContact, int index) {
    run(
      () async => _denyRequestMessagesUsecase.run(requestContact),
      onSuccess: () {
        pagingController.itemList?.removeAt(index);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      onFailure: (err) {},
    );
  }

  @override
  void disposeState() {
    pagingController.dispose();
    super.disposeState();
  }
}
