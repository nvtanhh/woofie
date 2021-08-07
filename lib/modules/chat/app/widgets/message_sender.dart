import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/chat/app/widgets/message/media_sender.dart';
import 'package:meowoof/modules/chat/app/widgets/message/sender_post_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';

class MessageSender extends StatelessWidget {
  final TextEditingController textController;

  final Function(List<MediaFile>) onMediaPicked;
  final Function(MediaFile)? onRemoveSeedingMedia;
  final VoidCallback? onRemoveAttachmentPost;
  final List<MediaFile> previewMediaMessage;
  final VoidCallback onSendMessage;
  final bool isCanSendMessage;
  final VoidCallback? onTap;
  final Post? attachmentPost;

  const MessageSender({
    Key? key,
    required this.textController,
    required this.onMediaPicked,
    required this.previewMediaMessage,
    required this.onSendMessage,
    this.onRemoveSeedingMedia,
    this.isCanSendMessage = false,
    this.onTap,
    this.attachmentPost,
    this.onRemoveAttachmentPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 220.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: UIColor.holder.withOpacity(.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _attachmentPreviewer(),
            DecoratedBox(
              decoration: BoxDecoration(
                color: UIColor.holder,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  onPressed: _pickImage,
                  icon: const MWIcon(MWIcons.camera),
                ),
                title: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.chat_sender_placeholder.trans(),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  maxLines: 4,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onTap: onTap,
                ),
                trailing: IconButton(
                  icon: MWIcon(
                    MWIcons.send,
                    color:
                        isCanSendMessage ? UIColor.primary : UIColor.textBody,
                  ),
                  onPressed: isCanSendMessage ? onSendMessage : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _pickImage() async {
    if (attachmentPost != null || previewMediaMessage.isNotEmpty) {
      Get.snackbar(LocaleKeys.chat_sender_pick_media_error_tile.trans(),
          LocaleKeys.chat_sender_pick_media_error_description.trans(),
          backgroundColor: UIColor.accent.withOpacity(.8),
          colorText: UIColor.white,
          duration: const Duration(seconds: 2));
      return;
    }
    final List<MediaFile> medias =
        await injector<MediaService>().pickMedias(allowMultiple: false);
    if (medias.isNotEmpty) {
      onMediaPicked(medias);
    }
  }

  Widget _attachmentPreviewer() {
    if (attachmentPost != null) {
      return Container(
        height: 150.h,
        width: 150.w,
        padding: const EdgeInsets.all(12),
        child: ChatSenderPostPreviewer(
          attachmentPost!,
          onRemovePost: onRemoveAttachmentPost,
        ),
      );
    }
    if (previewMediaMessage.isNotEmpty) {
      return SizedBox(
        height: 120.h,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: MediasSenderWidget(
            medias: previewMediaMessage,
            onRemoveMedia: onRemoveSeedingMedia,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
