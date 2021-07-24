import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ItemTagUserWidget extends StatelessWidget {
  final User user;

  const ItemTagUserWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        user.name ?? "",
        style: UITextStyle.text_body_18_w500,
      ),
      leading: MWAvatar(
        avatarUrl: user.avatarUrl,
        customSize: 50.w,
      ),
    );
  }
}
