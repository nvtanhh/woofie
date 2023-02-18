import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoDialog extends StatelessWidget {
  final File? video;
  final String? videoUrl;
  final bool? autoPlay;

  const VideoDialog({
    super.key,
    this.video,
    this.videoUrl,
    this.autoPlay = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87.withOpacity(.6),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black87.withOpacity(.6),
        ),
        child: video != null
            ? BetterPlayer.file(video!.path)
            : BetterPlayer.network(videoUrl!,
                betterPlayerConfiguration: const BetterPlayerConfiguration(),),
      ),
    );
  }
}
