import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_owner_history.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as time_ago;

class PetOwnerHistoryScreen extends StatelessWidget {
  final List<PetOwnerHistory> ownerHistories;

  const PetOwnerHistoryScreen({Key? key, required this.ownerHistories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.profile_pet_owners.trans(),
          style: UITextStyle.text_header_18_w600,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Timeline.tileBuilder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      theme: TimelineThemeData(
        nodePosition: 0.2,
      ),
      builder: TimelineTileBuilder.connected(
        itemCount: ownerHistories.length,
        oppositeContentsBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Text(
            ownerHistories[index].isCurrentOwner()
                ? LocaleKeys.profile_now.trans()
                : FormatHelper.formatDateTime(ownerHistories[index].giveTime,
                    pattern: "MM/yyyy"),
            style: UITextStyle.text_secondary_14_w500,
          ),
        ),
        itemExtent: 120.h,
        contentsBuilder: (context, index) => Container(
          margin: EdgeInsets.only(left: 15.w, right: 15.w),
          child: GestureDetector(
            onTap: () {
              Get.to(() => UserProfile(user: ownerHistories[index].owner));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MWAvatar(
                  avatarUrl: ownerHistories[index].owner.avatarUrl,
                  borderRadius: 10.r,
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ownerHistories[index].owner.name ?? "",
                        style: UITextStyle.text_header_14_w600,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      if (ownerHistories[index].createdAt != null)
                        Flexible(
                          child: Text(
                            time_ago
                                .format(
                                  ownerHistories[index].createdAt!,
                                  clock: ownerHistories[index].giveTime,
                                  locale: 'vi',
                                )
                                .replaceAll('ago', ''),
                            style: UITextStyle.text_secondary_12_w500,
                            maxLines: 1,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        connectorBuilder: (_, index, connectorType) {
          return SolidLineConnector(
            indent: connectorType == ConnectorType.start ? 0 : 2.0,
            endIndent: connectorType == ConnectorType.end ? 0 : 2.0,
            color: UIColor.primary,
          );
        },
        indicatorBuilder: (context, index) {
          return OutlinedDotIndicator(
            color: UIColor.primary,
            borderWidth: 6,
            size: 18.w,
          );
        },
      ),
    );
  }
}
