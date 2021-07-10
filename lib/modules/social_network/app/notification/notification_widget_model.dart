import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification_type.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
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

  void onItemTab(Notification item) {
    switch (item.type) {
      case NotificationType.react:
      case NotificationType.follow:
      case NotificationType.comment:
        goToPost(item.post!);
        return;
      case NotificationType.adoption:
      case NotificationType.matting:
        goToPost(item.post!);
        return;
      case NotificationType.lose:
        goToPost(item.post!);
        return;
      case NotificationType.commentTagUser:
        goToPost(item.post!);
        return;
      case NotificationType.reactComment:
        goToPost(item.post!);
        return;
    }
  }

  void goToPost(Post post) {
    Get.to(() => PostDetail(post: post));
  }
}
