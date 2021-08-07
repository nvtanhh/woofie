import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';

class PostVideoPreviewer extends StatelessWidget {
  final File? postVideoFile;
  final Media? postVideo;
  final VoidCallback? onRemove;
  final double? playIconSize;
  final double? playIconMargin;
  final double? width;
  final double? height;

  final double? thumbnailMaxWidth;
  final bool isConstraintsSize;
  final BoxFit? fit;

  const PostVideoPreviewer({
    Key? key,
    this.postVideoFile,
    this.postVideo,
    this.onRemove,
    this.playIconSize,
    this.width,
    this.height,
    this.thumbnailMaxWidth,
    this.isConstraintsSize = true,
    this.playIconMargin,
    this.fit,
  }) : super(key: key);

  static double avatarBorderRadius = 10.0;
  static const double buttonSize = 20;

  @override
  Widget build(BuildContext context) {
    final bool isFileVideo = postVideoFile != null;

    final Widget videoPreview = SizedBox(
      width: width,
      height: height,
      child: isFileVideo
          ? FutureBuilder<Uint8List?>(
              future: injector<MediaService>().getVideoThumbnailFromFile(
                postVideoFile!,
                maxWidth: thumbnailMaxWidth,
                isConstraintsSize: isConstraintsSize,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                return _wrapImageWidgetForThumbnail(
                  Image.memory(
                    snapshot.data!,
                    fit: fit ?? BoxFit.cover,
                  ),
                  width: width,
                  height: height,
                  isConstraintsSize: isConstraintsSize,
                );
              })
          : FutureBuilder<String?>(
              future: injector<MediaService>().getVideoThumbnailFromUrl(
                postVideo?.url ?? "",
                isConstraintsSize: isConstraintsSize,
                maxWidth: thumbnailMaxWidth,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                return _wrapImageWidgetForThumbnail(
                  Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                  ),
                  width: width,
                  height: height,
                  isConstraintsSize: isConstraintsSize,
                );
              },
            ),
    );

    return Stack(
      children: <Widget>[
        videoPreview,
        if (onRemove != null)
          Positioned(
            top: 5,
            right: 5,
            child: _buildRemoveButton(),
          ),
        Positioned(
          left: playIconMargin ?? 5,
          bottom: playIconMargin ?? 5,
          child: Center(
            child: _buildPlayButton(context),
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: FloatingActionButton(
        heroTag: Key(
            'postVideoPreviewerRemoveButton${postVideoFile?.path}${postVideo?.url}'),
        onPressed: onRemove,
        backgroundColor: Colors.black54,
        child: const MWIcon(
          MWIcons.close,
          customSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return SizedBox(
      width: playIconSize ?? buttonSize,
      height: playIconSize ?? buttonSize,
      child: FloatingActionButton(
        heroTag: Key(
            'postVideoPreviewerPlayButton${postVideoFile?.path}${postVideo?.url}'),
        backgroundColor: Colors.black54,
        onPressed: () => _onWantsToPlay(context),
        child: Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: playIconSize == null
              ? 16
              : (playIconSize! - playIconSize! / 6.toInt()),
        ),
      ),
    );
  }

  void _onWantsToPlay(BuildContext context) {
    injector<DialogService>().showVideo(
      context: context,
      video: postVideoFile,
      videoUrl: postVideo?.url,
    );
  }

  Widget _wrapImageWidgetForThumbnail(Widget image,
      {double? width, double? height, bool isConstraintsSize = true}) {
    return SizedBox(
      height: isConstraintsSize ? height ?? 80.h : null,
      width: isConstraintsSize ? width ?? 80.w : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarBorderRadius),
        child: image,
      ),
    );
  }
}
