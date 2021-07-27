import 'package:flutter/material.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_image_previewer.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_video_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

class MediaPreviewer extends StatelessWidget {
  final Media? postMedia;
  final MediaFile? mediaFile;
  final Function()? onRemove;
  final double? width;
  final double? height;

  final ValueChanged<MediaFile>? onImageEidted;

  final bool allowEditMedia;

  const MediaPreviewer({
    Key? key,
    this.postMedia,
    this.mediaFile,
    this.onRemove,
    this.onImageEidted,
    this.allowEditMedia = true,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaFile != null && mediaFile!.isImage) {
      return PostImagePreviewer(
        postImageFile: mediaFile!.file,
        onRemove: onRemove,
        onPostImageEdited: onImageEidted,
        allowEditImage: allowEditMedia,
        width: width,
        height: height,
      );
    } else if (mediaFile != null && mediaFile!.isVideo) {
      return PostVideoPreviewer(
        postVideoFile: mediaFile!.file,
        onRemove: onRemove,
        width: width,
        height: height,
      );
    }

    if (postMedia != null && postMedia!.isImage) {
      return PostImagePreviewer(
        postMedia: postMedia,
        onRemove: onRemove,
      );
    } else if (postMedia != null && mediaFile!.isVideo) {
      return PostVideoPreviewer(postVideo: postMedia, onRemove: onRemove);
    }
    return const SizedBox();
  }
}
