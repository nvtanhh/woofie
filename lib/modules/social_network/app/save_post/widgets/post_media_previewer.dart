import 'package:flutter/material.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_image_previewer.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_video_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

class MediaPreviewer extends StatelessWidget {
  final Media? media;
  final MediaFile? mediaFile;
  final Function()? onRemove;
  final double? width;
  final double? height;

  final ValueChanged<MediaFile>? onImageEidted;
  final bool allowEditMedia;
  final BoxFit? fit;
  final bool isConstraintsSize;

  const MediaPreviewer({
    super.key,
    this.media,
    this.mediaFile,
    this.onRemove,
    this.onImageEidted,
    this.allowEditMedia = true,
    this.width,
    this.height,
    this.fit,
    this.isConstraintsSize = true,
  });

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
        fit: fit,
        isConstraintsSize: isConstraintsSize,
      );
    } else if (mediaFile != null && mediaFile!.isVideo) {
      return PostVideoPreviewer(
        postVideoFile: mediaFile!.file,
        onRemove: onRemove,
        width: width,
        height: height,
        isConstraintsSize: isConstraintsSize,
      );
    }

    if (media != null && media!.isImage) {
      return PostImagePreviewer(
        postMedia: media,
        onRemove: onRemove,
        fit: fit,
        isConstraintsSize: isConstraintsSize,
      );
    } else if (media != null && media!.isVideo) {
      return PostVideoPreviewer(
        postVideo: media,
        onRemove: onRemove,
        isConstraintsSize: isConstraintsSize,
      );
    }
    return const SizedBox();
  }
}
