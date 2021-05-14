import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/theme/ui_color.dart';

enum MFIconSize { small, medium, large, extraLarge }

@immutable
class MFIconData {
  final AssetGenImage? assetImageFile;
  final IconData? nativeIcon;

  const MFIconData({this.nativeIcon, this.assetImageFile});

  bool get isNativaIcon => nativeIcon != null;
}

class MFIcon extends StatelessWidget {
  final MFIconData iconData;
  final MFIconSize? size;
  final double? customSize;
  final Color? color;

  static const double EXTRA_LARGE = 48.0;
  static const double LARGE_SIZE = 36.0;
  static const double MEDIUM_SIZE = 24.0;
  static const double SMALL_SIZE = 18.0;

  const MFIcon(
    this.iconData, {
    Key? key,
    this.size,
    this.customSize,
    this.color = UIColor.text_secondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? iconSize;

    if (customSize != null) {
      iconSize = customSize;
    } else {
      final finalSize = size ?? MFIconSize.medium;
      switch (finalSize) {
        case MFIconSize.extraLarge:
          iconSize = EXTRA_LARGE;
          break;
        case MFIconSize.large:
          iconSize = LARGE_SIZE;
          break;
        case MFIconSize.medium:
          iconSize = MEDIUM_SIZE;
          break;
        case MFIconSize.small:
          iconSize = SMALL_SIZE;
          break;
        default:
          throw 'Unsupported OBIconSize';
      }
    }

    if (iconData.isNativaIcon) {
      return Icon(
        iconData.nativeIcon,
        size: iconSize,
        color: color,
      );
    } else {
      return Assets.resources.icons.icAddPost.image(height: iconSize, width: iconSize, fit: BoxFit.cover);
    }
  }
}

// ignore: avoid_classes_with_only_static_members
class MFIcons {
  static const home = MFIconData(nativeIcon: Icons.home_filled);
  static const search = MFIconData(nativeIcon: CupertinoIcons.search);
  static const notificaiton = MFIconData(nativeIcon: Icons.notifications);
  static const profile = MFIconData(nativeIcon: Icons.person_rounded);
  static const mail = MFIconData(nativeIcon: Icons.mail_outline);
  static const lock = MFIconData(nativeIcon: Icons.lock_outline_rounded);
  static const visibility = MFIconData(nativeIcon: Icons.visibility);
  static const invisibility = MFIconData(nativeIcon: Icons.visibility_off);
  static const person = MFIconData(nativeIcon: Icons.person_outline);
  static const back = MFIconData(nativeIcon: Icons.arrow_back_ios_rounded);
  static const close = MFIconData(nativeIcon: Icons.close_rounded);
  static const comment = MFIconData(nativeIcon: Icons.comment_rounded);
  static const send = MFIconData(nativeIcon: Icons.send);
  static const bookmark = MFIconData(nativeIcon: Icons.bookmark);
  static const addImage = MFIconData(nativeIcon: Icons.add_photo_alternate);
  static const location = MFIconData(nativeIcon: Icons.location_on_rounded);
  static const notificaitonImportant = MFIconData(nativeIcon: Icons.notification_important_rounded);
  static const save = MFIconData(nativeIcon: Icons.security_rounded);
  static const moreVerical = MFIconData(nativeIcon: Icons.more_vert_rounded);
  static const moreHoriz = MFIconData(nativeIcon: Icons.more_horiz_rounded);
  static const language = MFIconData(nativeIcon: Icons.language);
  static const feedback = MFIconData(nativeIcon: Icons.feedback_rounded);
  static const logout = MFIconData(nativeIcon: Icons.logout);

  // Icon with asset image
  static final add = MFIconData(assetImageFile: Assets.resources.icons.icAddPost);
  static final message = MFIconData(assetImageFile: Assets.resources.icons.icMessage);
  static final react = MFIconData(assetImageFile: Assets.resources.icons.icReact);
}
