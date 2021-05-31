import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart ';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/widgets/pets_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/widgets/user_menu_action_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class InfoUserWidget extends StatelessWidget {
  final User user;
  final Function(Pet)? onFollowPet;
  final bool isMe;

  final Function(User)? onUserBlock;
  final Function(User)? onUserReport;

  const InfoUserWidget({
    Key? key,
    required this.user,
    required this.onFollowPet,
    required this.isMe,
    this.onUserBlock,
    this.onUserReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonWidget(
              onPress: () => null,
              backgroundColor: UIColor.white,
              width: 40.w,
              height: 40.h,
              borderRadius: 10.r,
              contentWidget: IconButton(
                icon: const MWIcon(MWIcons.moreHoriz),
                onPressed: () => null,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        MWAvatar(
          avatarUrl: user.avatarUrl,
          customSize: 80.w,
          borderRadius: 15.r,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          user.name ?? "Unknown",
          style: UITextStyle.text_header_24_w600,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          user.bio ?? "Unknown",
          style: UITextStyle.text_body_14_w500,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            Expanded(
              child: ButtonWidget(
                onPress: () => isMe ? null : null,
                height: 40.h,
                title: isMe ? LocaleKeys.profile_edit_profile.trans() : LocaleKeys.profile_contact.trans(),
                borderRadius: 10.r,
              ),
            ),
            if (!isMe)
              UserMenuActionWidget(
                user: user,
                onUserReport: onUserReport!,
                onUserBlock: onUserBlock!,
              )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        PetsWidget(
          pets: user.pets ?? [],
          onFollow: isMe ? null : onFollowPet,
          isMyPets: isMe,
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
