import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/commons/shimmer_page.dart';
import 'package:meowoof/modules/social_network/app/notification/notification_widget_model.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification.dart';
import 'package:meowoof/modules/social_network/domain/models/notification/notification_type.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';
import 'package:timeago/timeago.dart' as time_ago;

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends BaseViewState<NotificationWidget, NotificationWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: Get.height,
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.notification_notifications.trans(),
                  style: UITextStyle.text_header_24_w600,
                ),
                InkWell(
                  onTap: () => viewModel.onOptionTap(),
                  child: MWIcon(
                    MWIcons.moreHoriz,
                    customSize: 30.w,
                    color: UIColor.black,
                  ),
                )
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.onRefresh(),
                child: PagedListView<int, Notification>(
                  pagingController: viewModel.pagingController,
                  builderDelegate: PagedChildBuilderDelegate(itemBuilder: (context, item, index) {
                    return Dismissible(
                      key: ObjectKey(item.id),
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [MWIcon(MWIcons.delete)],
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        if (DismissDirection.endToStart == direction) {
                          viewModel.onDeleteNotify(item);
                          return true;
                        }
                      },
                      child: ListTile(
                        leading: MWAvatar(
                          avatarUrl: item.actor?.avatarUrl,
                          customSize: 45.w,
                          borderRadius: 10.r,
                        ),
                        onTap: () => viewModel.onItemTab(item),
                        title: generateContentTitle(item),
                        trailing: defineIcon(item),
                        subtitle: Text(
                          time_ago.format(item.createdAt!, locale: 'vi'),
                          style: UITextStyle.second_12_medium,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    );
                  }, noItemsFoundIndicatorBuilder: (_) {
                    return Center(
                      child: Text(
                        "No have notification",
                        style: UITextStyle.text_body_14_w600,
                      ),
                    );
                  }, firstPageProgressIndicatorBuilder: (_) {
                    return ShimmerPage(
                      width: Get.width,
                      height: 150.h,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget generateContentTitle(Notification notification) {
    switch (notification.type) {
      case NotificationType.react:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_liked.trans(),
        );
      case NotificationType.follow:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_following.trans(),
          pet: notification.pet,
        );
      case NotificationType.comment:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_commented.trans(),
        );
      case NotificationType.adoption:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_adopt.trans(),
          pet: notification.pet,
        );
      case NotificationType.matting:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_matting.trans(),
          pet: notification.pet,
        );
      case NotificationType.lose:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_lose.trans(),
          pet: notification.pet,
        );
      case NotificationType.commentTagUser:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_tag.trans(),
        );
      case NotificationType.reactComment:
        return createTitle(
          notification.actor!,
          LocaleKeys.notification_like_comment.trans(),
        );
    }
  }

  Widget createTitle(User actor, String text, {Pet? pet}) {
    final List<InlineSpan> inlineSpans = [];
    inlineSpans.add(
      TextSpan(
        text: text,
        style: UITextStyle.text_header_16_w400,
      ),
    );
    if (pet != null) {
      inlineSpans.add(
        TextSpan(
          text: pet.name ?? "",
          style: UITextStyle.text_header_16_w600,
        ),
      );
    }
    return Text.rich(
      TextSpan(
        text: actor.name,
        children: inlineSpans,
        style: UITextStyle.text_header_16_w600,
      ),
      maxLines: 3,
    );
  }

  Widget defineIcon(Notification notification) {
    switch (notification.type) {
      case NotificationType.matting:
        return MWIcon(
          MWIcons.icMatting,
          customSize: 35.w,
        );
      case NotificationType.adoption:
        return MWIcon(
          MWIcons.icAdoption,
          customSize: 35.w,
        );
      case NotificationType.lose:
        return MWIcon(
          MWIcons.icLose,
          customSize: 35.w,
        );
      case NotificationType.react:
        return MWIcon(
          MWIcons.icReact,
          customSize: 35.w,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  NotificationWidgetModel createViewModel() => injector<NotificationWidgetModel>();
}
