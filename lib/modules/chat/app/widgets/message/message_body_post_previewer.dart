import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_body_post_previewer_mating.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/widgets/pet_item_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MessageBodyPostPreviewer extends StatelessWidget {
  final Message message;

  const MessageBodyPostPreviewer(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Post post;
    try {
      final content = json.decode(message.content);
      post = Post.fromJsonFromChat(content['post'] as Map<String, dynamic>);
    } catch (e) {
      return const SizedBox();
    }

    if (post.type == PostType.mating) {
      return MessageBodyPostPreviewerMating(message, post: post);
    }

    return Column(
      crossAxisAlignment: message.isSentByMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
              bottomLeft:
                  message.isSentByMe ? Radius.circular(15.r) : Radius.zero,
            ),
            child: GestureDetector(
              onTap: () {
                Get.to(() => AdoptionPetDetailWidget(post: post));
              },
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: PetItemWidget(
                  post: post,
                  pet: post.taggegPets![0],
                  postType: post.type,
                  showDistance: false,
                  isConstraintsSize: false,
                ),
              ),
            ),
          ),
        ),
        _mediaDescriptionWidget(message),
      ],
    );
  }

  Widget _mediaDescriptionWidget(Message message) {
    if (message.description != null && message.description!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (message.isSentByMe ? UIColor.primary : UIColor.holder)
                .withOpacity(.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
              bottomLeft:
                  message.isSentByMe ? Radius.circular(15.r) : Radius.zero,
              bottomRight:
                  !message.isSentByMe ? Radius.circular(15.r) : Radius.zero,
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
