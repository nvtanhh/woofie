import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_video_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBodyMedia extends StatelessWidget {
  final Message message;

  const MessageBodyMedia(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: UIColor.primary),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300.h),
              child: _mediaWidget(message),
            ),
            _mediaDescriptionWidget(message),
          ],
        ),
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

  Widget _mediaWidget(Message message) {
    if (message.type == MessageType.image) {
      return ImageWithPlaceHolderWidget(
        imageUrl: message.content,
        placeHolderImage: 'resources/images/fallbacks/media-fallback.png',
        isConstraintsSize: false,
      );
    } else if (message.type == MessageType.video) {
      final Media media =
          Media(id: -1, url: message.content, type: MediaType.video);
      return PostVideoPreviewer(
        postVideo: media,
        isConstraintsSize: false,
        playIconSize: 30,
        playIconMargin: 10,
      );
    }
    return const SizedBox();
  }

  Widget _mediaDescriptionWidget(Message message) {
    if (message.description != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          message.description!,
          style: UITextStyle.body_14_medium.apply(color: Colors.white),
        ),
      );
    }
    return const SizedBox();
  }
}
