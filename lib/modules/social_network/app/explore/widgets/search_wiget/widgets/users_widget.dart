import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersWidget extends StatelessWidget {
  final PagingController<int, User> pagingController;

  const UsersWidget({
    Key? key,
    required this.pagingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, User>(
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, user, index) {
          return GestureDetector(
            onTap: () => Get.to(
              () => UserProfile(user: user),
            ),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: MWAvatar(
                avatarUrl: user.avatarUrl ?? '',
                borderRadius: 10.r,
              ),
              title: Text(
                user.name ?? '',
                style: UITextStyle.heading_16_semiBold,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Text(
                user.bio ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
        newPageProgressIndicatorBuilder: (_) => const SizedBox(),
        firstPageProgressIndicatorBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
      ),
      pagingController: pagingController,
    );
  }
}
