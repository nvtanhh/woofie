import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/widgets/pet_item_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/pet_card_item.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MessageBodyPostPreviewerMating extends StatelessWidget {
  final Message message;
  final Post? post;

  const MessageBodyPostPreviewerMating(this.message, {Key? key, this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = json.decode(message.content);
    final Post finalPost =
        post ?? Post.fromJsonFromChat(data['post'] as Map<String, dynamic>);
    Pet? matingPet;
    if (data['additional_data'] != null) {
      matingPet =
          Pet.fromJsonPure(data['additional_data'] as Map<String, dynamic>);
    }

    return Column(
      crossAxisAlignment: message.isSentByMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200.h),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
              bottomLeft:
                  message.isSentByMe ? Radius.circular(15.r) : Radius.zero,
            ),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AdoptionPetDetailWidget(post: finalPost));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: PetItemWidget(
                          post: finalPost.updateSubjectValue,
                          pet: finalPost.updateSubjectValue.taggegPets![0],
                          postType: finalPost.type,
                          showDistance: false,
                          isConstraintsSize: false,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: const Text('❤️'),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => PetProfile(pet: matingPet!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: PetCardItem(
                          pet: matingPet!,
                        ),
                      ),
                    ),
                  ),
                ],
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
