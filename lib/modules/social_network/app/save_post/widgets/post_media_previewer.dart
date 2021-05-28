import 'package:flutter/material.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_image_previewer.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_video_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

class MediaPreviewer extends StatelessWidget {
  final Media? postMedia;
  final MediaFile? mediaFile;
  final Function()? onRemove;

  final ValueChanged<MediaFile>? onImageEidted;

  const MediaPreviewer({Key? key, this.postMedia, this.mediaFile, this.onRemove, this.onImageEidted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaFile != null && mediaFile!.isImage) {
      return PostImagePreviewer(
        postImageFile: mediaFile!.file,
        onRemove: onRemove,
        onPostImageEdited: onImageEidted,
      );
    } else if (mediaFile!.isVideo) {
      return PostVideoPreviewer(
        postVideoFile: mediaFile!.file,
        onRemove: onRemove,
      );
    }

    if (postMedia != null && postMedia!.isImage) {
      return PostImagePreviewer(
        postMedia: postMedia,
        onRemove: onRemove,
      );
    } else if (mediaFile!.isVideo) {
      return PostVideoPreviewer(postVideo: postMedia, onRemove: onRemove);
    }
    return const SizedBox();
  }
}
