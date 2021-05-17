import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';

class SendCommentWidget extends StatelessWidget {
  final Rx<User?> user;
  final TextEditingController commentEditingController;
  final Function onSendComment;

  const SendCommentWidget({
    Key? key,
    required this.user,
    required this.commentEditingController,
    required this.onSendComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: UIColor.pink_swan27,
            offset: Offset(0, -2),
            blurRadius: 5,
          )
        ],
        color: UIColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          Obx(
            () {
              if (user.value == null) {
                return Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetGenImage("resources/icons/ic_person.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              } else {
                return ImageWithPlaceHolderWidget(
                  width: 45.w,
                  height: 45.w,
                  fit: BoxFit.fill,
                  imageUrl: user.value?.avatar?.url ?? "",
                  radius: 10.r,
                );
              }
            },
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: LocaleKeys.new_feed_write_a_comment.trans(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                fillColor: UIColor.holder,
                focusColor: UIColor.black,
                filled: true,
              ),
              controller: commentEditingController,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: UIColor.primary,
              size: 30.w,
            ),
            onPressed: () => onSendComment(),
            constraints: const BoxConstraints(),
          )
        ],
      ),
    );
  }
}
