import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/commons/video_dialog.dart';
import 'package:meowoof/modules/social_network/app/commons/zoom_photo.dart';
import 'package:wakelock/wakelock.dart';

@lazySingleton
class DialogService {
  Future<void> showZoomablePhotoBoxView({required String imageUrl, required BuildContext context}) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final ThemeData theme = Theme.of(context);
        final Widget pageChild = ZoomablePhoto(imageUrl);
        return Builder(builder: (BuildContext context) {
          return Theme(data: theme, child: pageChild);
        });
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 100),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  Future<void> showVideo({String? videoUrl, File? video, bool autoPlay = true, required BuildContext context}) async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await Wakelock.enable();
    await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final ThemeData theme = Theme.of(context);
        final Widget pageChild = Material(
          child: VideoDialog(
            autoPlay: autoPlay,
            video: video,
            videoUrl: videoUrl,
          ),
        );
        return Builder(builder: (BuildContext context) {
          return Theme(data: theme, child: pageChild);
        });
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 100),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
    await Wakelock.disable();
    await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  Widget _buildMaterialDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
