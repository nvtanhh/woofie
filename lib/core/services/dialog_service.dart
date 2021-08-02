import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/modules/social_network/app/commons/video_dialog.dart';
import 'package:meowoof/modules/social_network/app/commons/zoom_photo.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/report_dialog_widget.dart';
import 'package:meowoof/theme/ui_text_style.dart';
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

  Future showPermissionDialog() async {
    await Get.defaultDialog(
      title: '',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'You need to provide your location if wanted to use this function',
              style: UITextStyle.body_14_medium,
            ),
            const SizedBox(height: 20),
            MWButton(
              onPressed: () => Get.back(),
              borderRadius: BorderRadius.circular(10),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future showInputReport() async {
    return Get.dialog(ReportDialogWidget(), barrierDismissible: true);
  }
}
