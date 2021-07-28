import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/app/widgets/message/media_sender.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/media_button.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class MessageSender extends StatelessWidget {
  final TextEditingController textController;

  final Function(List<MediaFile>) onMediaPicked;
  final Function(MediaFile)? onRemoveSeedingMedia;

  final List<MediaFile> previewMediaMessage;

  final VoidCallback onSendMessage;

  final bool isCanSendMessage;

  final VoidCallback? onTap;

  const MessageSender({
    Key? key,
    required this.textController,
    required this.onMediaPicked,
    required this.previewMediaMessage,
    required this.onSendMessage,
    this.onRemoveSeedingMedia,
    this.isCanSendMessage = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 170.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: UIColor.holder.withOpacity(.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (previewMediaMessage.isNotEmpty)
              SizedBox(
                height: 110.h,
                child: MediasSenderWidget(medias: previewMediaMessage, onRemoveMedia: onRemoveSeedingMedia),
              ),
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
                  decoration: const InputDecoration(
                    hintText: 'Soạn tin nhắn...',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onTap: onTap,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: isCanSendMessage ? UIColor.primary : UIColor.textBody,
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
    if (previewMediaMessage.isNotEmpty) {
      Get.snackbar('Sorry', 'Currently, You can only send at most 1 image each time.',
          backgroundColor: UIColor.accent2.withOpacity(.8), colorText: UIColor.white, duration: const Duration(seconds: 2));
      return;
    }
    final List<MediaFile> medias = await injector<MediaService>().pickMedias(allowMultiple: false);
    if (medias.isNotEmpty) {
      onMediaPicked(medias);
    }
  }
}
