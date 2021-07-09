import 'package:async/async.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';
import 'package:meowoof/modules/social_network/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NotificationWidgetModel extends BaseViewModel {
  final pageSize = 10;
  int nextPageKey = 0;
  late PagingController<int, Notification> pagingController;
  List<Notification> notifications = [];
  CancelableOperation? cancelableOperation;
  final GetNotificationUsecase _getNotificationUsecase;

  NotificationWidgetModel(this._getNotificationUsecase);

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: nextPageKey);
    pagingController.addPageRequestListener(
      (pageKey) {
        cancelableOperation = CancelableOperation.fromFuture(_loadMorePost(pageKey));
      },
    );
    super.initState();
  }

  Future _loadMorePost(int pageKey) async {
    try {
      notifications = await _getNotificationUsecase.run(offset: nextPageKey);
      final isLastPage = notifications.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(notifications);
      } else {
        nextPageKey = pageKey + notifications.length;
        // dateTimeValueLast = newItems.last.createdAt;
        pagingController.appendPage(notifications, nextPageKey);
      }
    } catch (error) {
      print(error.toString());
      pagingController.error = error;
    }
  }

  Future onRefresh() async {
    pagingController.refresh();
  }

  void onOptionTap() {}
}
