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

  const MediaButton({Key? key, this.mediaFile, this.postMedia, this.onMediasPicked, this.onRemove, this.onImageEdited}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEmptyImage = postMedia == null && mediaFile == null;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 80.w,
      height: 80.h,
      child: !isEmptyImage
          ? MediaPreviewer(mediaFile: mediaFile, postMedia: postMedia, onRemove: onRemove, onImageEidted: onImageEdited)
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
    final List<MediaFile> medias = [];
    List<File>? files;
    final FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.media);
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
    if (files != null) {
      await Future.wait(files.map((file) async {
        final MediaFile media = await injector<MediaService>().convertToMediaFile(file);
        medias.add(media);
      }));
    }
    if (onMediasPicked != null) onMediasPicked!(medias);
  }
}
