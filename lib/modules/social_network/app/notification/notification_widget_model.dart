import 'package:async/async.dart';
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/chat/app/request_message/request_message.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification_type.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NotificationWidgetModel extends BaseViewModel {
  final DeleteNotificationUsecase _deleteNotificationUsecase;
  final pageSize = 10;
  int nextPageKey = 0;
  late PagingController<int, Notification> pagingController;
  List<Notification> notifications = [];
  CancelableOperation? cancelableOperation;
  final GetNotificationUsecase _getNotificationUsecase;

  material.ScrollController scrollController = material.ScrollController();

  NotificationWidgetModel(
    this._getNotificationUsecase,
    this._deleteNotificationUsecase,
  );

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: nextPageKey);
    pagingController.addPageRequestListener(
      (pageKey) {
        cancelableOperation =
            CancelableOperation.fromFuture(_loadMoreNotification(pageKey));
      },
    );
    super.initState();
  }

  Future _loadMoreNotification(int pageKey) async {
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
      printInfo(info: error.toString());
      pagingController.error = error;
    }
  }

  Future onRefresh() async {
    nextPageKey = 0;
    pagingController.refresh();
  }

  void onDeleteNotify(Notification notification) {
    call(
      () async => _deleteNotificationUsecase.run(notification.id),
      showLoading: false,
    );
  }

  void onOptionTap() {}

  void onItemTab(Notification item) {
    switch (item.type) {
      case NotificationType.react:
        goToPost(item.postId!);
        return;
      case NotificationType.follow:
        return;
      case NotificationType.comment:
        goToPost(item.postId!);
        return;
      case NotificationType.adoption:
        return;
      case NotificationType.matting:
        goToPost(item.postId!);
        return;
      case NotificationType.lose:
        goToPost(item.postId!);
        return;
      case NotificationType.commentTagUser:
        goToPost(item.postId!);
        return;
      case NotificationType.reactComment:
        goToPost(item.postId!);
        return;
      case NotificationType.requestMessage:
        Get.to(() => RequestMessagePage());
        return;
    }
  }

  void goToPost(int postId) {
    Get.to(() =>
        PostDetail(post: Post(id: postId, uuid: "", type: PostType.activity)));
  }

  @override
  void disposeState() {
    cancelableOperation?.cancel();
    pagingController.dispose();
    super.disposeState();
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: material.Curves.easeOut,
      );
    }
  }
}
