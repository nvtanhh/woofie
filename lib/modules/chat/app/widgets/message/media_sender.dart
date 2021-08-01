import 'package:flutter/material.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_media_previewer.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediasSenderWidget extends StatelessWidget {
  final List<MediaFile> medias;

  final Function(MediaFile)? onRemoveMedia;

  const MediasSenderWidget({Key? key, required this.medias, this.onRemoveMedia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        children: medias
            .map(
              (file) => MediaPreviewer(
                key: Key(file.file.path),
                height: 80.h,
                width: 80.w,
                mediaFile: file,
                onRemove: onRemoveMedia != null ? () => onRemoveMedia!(file) : null,
                allowEditMedia: false,
              ),
            )
            .toList());

    // SingleChildScrollView(
    //   physics: const BouncingScrollPhysics(),
    //   child: Padding(
    //     padding: const EdgeInsets.all(12),
    //     child: Row(
    //       children: medias
    //           .map(
    //             (file) => MediaButton(
    //               key: ObjectKey(file),
    //               mediaFile: file,
    //               onRemove:
    //                   onRemoveMedia != null ? () => onRemoveMedia!(file) : null,
    //               allowEditMedia: false,
    //             ),
    //           )
    //           .toList(),
    //     ),
    //   ),
    // );
  }
}
