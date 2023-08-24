import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/modules/chat/app/widgets/active_status_avatar.dart';
import 'package:meowoof/modules/chat/app/widgets/message/jumping_dots.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';

class TypingWidget extends StatelessWidget {
  final bool isTyping;
  final User? chatPartner;

  const TypingWidget(
      {super.key, required this.isTyping, required this.chatPartner,});

  @override
  Widget build(BuildContext context) {
    if (!isTyping) {
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(
        right: 0.15.sw,
        top: 10,
        left: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ActiveStatusAvatar(
                avatarUrl: chatPartner?.avatarUrl ?? '',
                isSmallSize: true,
                borderRadius: 8,
                isActive: false,
              ),),
          Container(
            height: 30.h,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: UIColor.holder,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const JumpingDots(
              color: UIColor.textBody,
              radius: 6,
              jumpHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
