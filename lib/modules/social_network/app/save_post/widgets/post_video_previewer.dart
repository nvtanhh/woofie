import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/media_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/theme/icon.dart';

class PostVideoPreviewer extends StatelessWidget {
  final File? postVideoFile;
  final Media? postVideo;
  final VoidCallback? onRemove;
  final double? playIconSize;

  const PostVideoPreviewer({Key? key, this.postVideoFile, this.postVideo, this.onRemove, this.playIconSize = 30}) : super(key: key);

  static double avatarBorderRadius = 10.0;
  static const double buttonSize = 20;

  @override
  Widget build(BuildContext context) {
    final bool isFileVideo = postVideoFile != null;

    final Widget videoPreview = isFileVideo
        ? FutureBuilder<Uint8List?>(
            future: injector<MediaService>().getVideoThumbnailFromFile(postVideoFile!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              return _wrapImageWidgetForThumbnail(
                Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            })
        : FutureBuilder<String?>(
            future: injector<MediaService>().getVideoThumbnailFromUrl(postVideo!.url),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              return _wrapImageWidgetForThumbnail(
                Image.file(
                  File(snapshot.data!),
                ),
              );
            });

    return Stack(
      children: <Widget>[
        videoPreview,
        if (onRemove != null)
          Positioned(
            top: 5.h,
            right: 5.w,
            child: _buildRemoveButton(),
          ),
        Positioned(
          left: 5,
          bottom: 5,
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
      width: buttonSize,
      height: buttonSize,
      child: FloatingActionButton(
        backgroundColor: Colors.black54,
        onPressed: () => _onWantsToPlay(context),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 16,
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

  Widget _wrapImageWidgetForThumbnail(Widget image) {
    return SizedBox(
      height: 80.h,
      width: 80.w,
      child: ClipRRect(borderRadius: BorderRadius.circular(avatarBorderRadius), child: image),
    );
  }
}
