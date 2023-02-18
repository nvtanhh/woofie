import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';

class PostImagePreviewer extends StatelessWidget {
  final Media? postMedia;
  final File? postImageFile;
  final VoidCallback? onRemove;
  final VoidCallback? onWillEditImage;
  final ValueChanged<MediaFile>? onPostImageEdited;

  static const double buttonSize = 20;

  final bool allowEditImage;
  final double? width;
  final double? height;
  final bool isConstraintsSize;
  final bool noBorder;
  final BoxFit? fit;

  const PostImagePreviewer({
    super.key,
    this.postMedia,
    this.postImageFile,
    this.onRemove,
    this.onWillEditImage,
    this.onPostImageEdited,
    this.allowEditImage = true,
    this.width,
    this.height,
    this.isConstraintsSize = true,
    this.noBorder = false,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarBorderRadius = 10.0;
    final bool isFileImage = postImageFile != null;

    final imagePreview = SizedBox(
      width: isConstraintsSize ? width ?? 200 : null,
      height: isConstraintsSize ? height ?? 200 : null,
      child: ClipRRect(
        borderRadius: !noBorder
            ? BorderRadius.circular(avatarBorderRadius)
            : BorderRadius.zero,
        child: isFileImage
            ? Image.file(
                postImageFile!,
                fit: fit ?? BoxFit.cover,
              )
            : ExtendedImage.network(
                postMedia!.url ?? "",
                fit: fit ?? BoxFit.cover,
                retries: 0,
              ),
      ),
    );

    if (onRemove == null) return imagePreview;

    return Stack(
      children: <Widget>[
        imagePreview,
        Positioned(
          top: 5,
          right: 5,
          child: _buildRemoveButton(),
        ),
        if (isFileImage && allowEditImage)
          Positioned(
            bottom: 5,
            left: 5,
            child: _buildEditButton(context),
          )
      ],
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: onRemove,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: FloatingActionButton(
          heroTag: Key(
              'postImagePreviewerRemoveButton${postImageFile?.path}${postMedia?.url}',),
          onPressed: onRemove,
          backgroundColor: Colors.black54,
          child: const MWIcon(
            MWIcons.close,
            customSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: FloatingActionButton(
        heroTag: Key(
            'postImagePreviewerEditButton${postImageFile?.path}${postMedia?.url}',),
        onPressed: () => _onWantsToEditImage(context),
        backgroundColor: Colors.black54,
        child: const MWIcon(
          MWIcons.edit,
          color: Colors.white,
          customSize: 12,
        ),
      ),
    );
  }

  Future _onWantsToEditImage(BuildContext context) async {
    if (onWillEditImage != null) onWillEditImage!();
    final mediaService = injector<MediaService>();

    final File? croppedFile = await mediaService.cropImage(postImageFile!);
    if (croppedFile != null && onPostImageEdited != null) {
      final MediaFile media =
          await mediaService.convertToMediaFile(croppedFile);
      onPostImageEdited!(media);
    }
  }
}
