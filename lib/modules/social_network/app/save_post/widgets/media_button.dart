import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_media_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

class MediaButton extends StatelessWidget {
  final Media? postMedia;
  final MediaFile? mediaFile;
  final ValueChanged<List<MediaFile>>? onMediasPicked;
  final Function()? onRemove;
  final ValueChanged<MediaFile>? onImageEdited;

  final bool allowEditMedia;

  const MediaButton({
    Key? key,
    this.mediaFile,
    this.postMedia,
    this.onMediasPicked,
    this.onRemove,
    this.onImageEdited,
    this.allowEditMedia = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEmptyImage = postMedia == null && mediaFile == null;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 80.w,
      height: 80.h,
      child: !isEmptyImage
          ? MediaPreviewer(
              mediaFile: mediaFile,
              postMedia: postMedia,
              onRemove: onRemove,
              onImageEidted: onImageEdited,
              allowEditMedia: allowEditMedia,
            )
          : GestureDetector(
              onTap: _pickMedia,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const MWIcon(MWIcons.addImage),
              ),
            ),
    );
  }

  Future _pickMedia() async {
    final List<MediaFile> medias = await injector<MediaService>().pickMedias();
    if (medias.isNotEmpty && onMediasPicked != null) onMediasPicked!(medias);
  }
}
