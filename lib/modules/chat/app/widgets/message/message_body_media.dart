import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_image_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:path/path.dart';

class MessageBodyMedia extends StatelessWidget {
  final Message message;

  final User? partner;

  const MessageBodyMedia(this.message, {Key? key, required this.partner})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: message.isSentByMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _mediaWidget(message, partner),
          ),
        ),
        _mediaDescriptionWidget(message),
      ],
    );
  }

  Widget _mediaWidget(Message message, User? partner) {
    if (message.type == MessageType.image) {
      if (message.isSent) {
        return ImageWithPlaceHolderWidget(
          imageUrl: message.content,
          placeHolderImage: 'resources/images/fallbacks/media-fallback.png',
          isConstraintsSize: false,
        );
      } else {
        return PostImagePreviewer(
          postImageFile: File(message.content),
          allowEditImage: false,
          isConstraintsSize: false,
          noBorder: true,
        );
      }
    } else if (message.type == MessageType.video) {
      return _videoMessage(message, partner);
    }
    return const SizedBox();
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
              left: 12.w,
              right: 12.w,
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
                SizedBox(height: 10.h),
                if (message.type == MessageType.video)
                  Divider(
                    thickness: 0.5.w,
                    height: 1.h,
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

  Widget _videoMessage(Message message, User? partner) {
    const String sendVideoText = 'Đã gửi 1 video';
    final String subTitle = message.isSentByMe
        ? 'Bạn • $sendVideoText'
        : '${partner?.name ?? ""} • $sendVideoText';

    return Container(
      height: 70,
      padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
      color: message.isSentByMe ? UIColor.primary : UIColor.holder,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: message.isSentByMe
                  ? UIColor.white.withOpacity(.3)
                  : UIColor.textBody.withOpacity(.3),
              borderRadius: BorderRadius.circular(21),
            ),
            height: 42,
            width: 42,
            child: MWIcon(
              MWIcons.play,
              color: message.isSentByMe ? UIColor.white : UIColor.textBody,
            ),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getFileName(message.content),
                    maxLines: 1,
                    textWidthBasis: TextWidthBasis.longestLine,
                    overflow: TextOverflow.ellipsis,
                    style: message.isSentByMe
                        ? UITextStyle.body_14_medium.apply(color: Colors.white)
                        : UITextStyle.body_14_medium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Text(
                      subTitle,
                      style: message.isSentByMe
                          ? UITextStyle.body_12_reg.apply(color: Colors.white70)
                          : UITextStyle.body_12_reg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFileName(String path) {
    return basename(path);
  }
}
