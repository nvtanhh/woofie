import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';

class MessageBodyMedia extends StatelessWidget {
  final Message message;

  final User? partner;

  const MessageBodyMedia(this.message, {Key? key, required this.partner})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: message.isSentByMe ? UIColor.primary : UIColor.holder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _mediaDescriptionWidget(message),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300.h),
            child: _mediaWidget(message, partner),
          ),
        ],
      ),
    );
  }

  // MediaType _getMediaType(message) {
  //   switch (message.type) {
  //     case MessageType.image:
  //       return MediaType.image;
  //     case MessageType.video:
  //       return MediaType.video;
  //     default:
  //       throw Exception('Unsupported message type: ${message.type}');
  //   }
  // }

  Widget _mediaWidget(Message message, User? partner) {
    if (message.type == MessageType.image) {
      return ImageWithPlaceHolderWidget(
        imageUrl: message.content,
        placeHolderImage: 'resources/images/fallbacks/media-fallback.png',
        isConstraintsSize: false,
      );
    } else if (message.type == MessageType.video) {
      // final Media media =
      //     Media(id: -1, url: message.content, type: MediaType.video);
      // return PostVideoPreviewer(
      //   key: Key(message.objectId),
      //   postVideo: media,
      //   isConstraintsSize: false,
      //   playIconSize: 30,
      //   playIconMargin: 10,
      // );
      return _videoMessage(message, partner);
    }
    return const SizedBox();
  }

  Widget _mediaDescriptionWidget(Message message) {
    if (message.description != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        child: Text(
          message.description!,
          style: message.isSentByMe
              ? UITextStyle.body_14_medium.apply(color: Colors.white)
              : UITextStyle.body_14_medium,
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
      height: 80,
      padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
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
