import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/widgets/pet_item_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MessageBodyPostPreviewer extends StatelessWidget {
  final Message message;

  const MessageBodyPostPreviewer(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Post post = Post.fromJsonFromChat(
        json.decode(message.content) as Map<String, dynamic>);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _mediaDescriptionWidget(message),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
              bottomLeft: Radius.circular(15.r),
            ),
            child: PetItemWidget(
              post: post,
              pet: post.taggegPets![0],
              postType: post.type,
              showDistance: false,
              isConstraintsSize: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mediaDescriptionWidget(Message message) {
    if (message.description != null && message.description!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: message.isSentByMe ? UIColor.primary : UIColor.holder,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              bottomLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 18.w,
              right: 18.w,
              top: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.description!,
                  style: message.isSentByMe
                      ? UITextStyle.body_14_medium.apply(color: Colors.white)
                      : UITextStyle.body_14_medium,
                ),
                const SizedBox(height: 10),
                if (message.type == MessageType.video)
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    endIndent: 0,
                    color: message.isSentByMe ? Colors.white : UIColor.textBody,
                  )
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
