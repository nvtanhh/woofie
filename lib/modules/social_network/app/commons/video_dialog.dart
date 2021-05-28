import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoDialog extends StatelessWidget {
  final File? video;
  final String? videoUrl;
  final bool? autoPlay;

  const VideoDialog({
    Key? key,
    this.video,
    this.videoUrl,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          Container(color: Colors.black87.withOpacity(.6), child: video != null ? BetterPlayer.file(video!.path) : BetterPlayer.network(videoUrl!)),
    );
  }
}
