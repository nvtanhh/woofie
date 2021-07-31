import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/theme/ui_color.dart';

enum MWIconSize { small, medium, large, extraLarge }

@immutable
class MWIconData {
  final AssetGenImage? assetImageFile;
  final IconData? nativeIcon;

  const MWIconData({this.nativeIcon, this.assetImageFile});

  bool get isNativaIcon => nativeIcon != null;
}

class MWIcon extends StatelessWidget {
  final MWIconData iconData;
  final MWIconSize? size;
  final double? customSize;
  final Color? color;
  final MWIconThemeColor? themeColor;

  static const double EXTRA_LARGE = 48.0;
  static const double LARGE_SIZE = 36.0;
  static const double MEDIUM_SIZE = 24.0;
  static const double SMALL_SIZE = 18.0;

  const MWIcon(
    this.iconData, {
    Key? key,
    this.size,
    this.customSize,
    this.color,
    this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? iconSize;

    if (customSize != null) {
      iconSize = customSize;
    } else {
      final finalSize = size ?? MWIconSize.medium;
      switch (finalSize) {
        case MWIconSize.extraLarge:
          iconSize = EXTRA_LARGE;
          break;
        case MWIconSize.large:
          iconSize = LARGE_SIZE;
          break;
        case MWIconSize.medium:
          iconSize = MEDIUM_SIZE;
          break;
        case MWIconSize.small:
          iconSize = SMALL_SIZE;
          break;
        default:
          throw 'Unsupported OBIconSize';
      }
    }

    if (iconData.isNativaIcon) {
      Color iconColor;
      if (color != null) {
        iconColor = color!;
      } else {
        switch (themeColor) {
          case MWIconThemeColor.primary:
            iconColor = UIColor.primary;
            break;
          case MWIconThemeColor.success:
            iconColor = UIColor.accent2;
            break;
          case MWIconThemeColor.primaryText:
            iconColor = UIColor.textBody;
            break;
          case MWIconThemeColor.secondaryText:
            iconColor = UIColor.textSecondary;
            break;
          case MWIconThemeColor.primaryAccent:
            iconColor = UIColor.accent;
            break;
          case MWIconThemeColor.danger:
            iconColor = UIColor.danger;
            break;
          default:
            iconColor = UIColor.textBody;
        }
      }

      return Icon(
        iconData.nativeIcon,
        size: iconSize,
        color: iconColor,
      );
    } else {
      return iconData.assetImageFile!.image(height: iconSize, width: iconSize, fit: BoxFit.cover);
    }
  }
}

// ignore: avoid_classes_with_only_static_members
class MWIcons {
  static const home = MWIconData(nativeIcon: Icons.home_filled);
  static const search = MWIconData(nativeIcon: CupertinoIcons.search);
  static const notificaiton = MWIconData(nativeIcon: Icons.notifications);
  static const profile = MWIconData(nativeIcon: Icons.person_rounded);
  static const mail = MWIconData(nativeIcon: Icons.mail_outline);
  static const lock = MWIconData(nativeIcon: Icons.lock_outline_rounded);
  static const visibility = MWIconData(nativeIcon: Icons.visibility);
  static const invisibility = MWIconData(nativeIcon: Icons.visibility_off);
  static const person = MWIconData(nativeIcon: Icons.person_outline);
  static const back = MWIconData(nativeIcon: Icons.arrow_back_ios_rounded);
  static const close = MWIconData(nativeIcon: Icons.close_rounded);
  static const send = MWIconData(nativeIcon: Icons.send_rounded);
  static const bookmark = MWIconData(nativeIcon: Icons.bookmark);
  static const addImage = MWIconData(nativeIcon: Icons.add_photo_alternate);
  static const location = MWIconData(nativeIcon: Icons.location_on_rounded);
  static const notificaitonImportant = MWIconData(nativeIcon: Icons.notification_important_rounded);
  static const save = MWIconData(nativeIcon: Icons.security_rounded);
  static const moreVerical = MWIconData(nativeIcon: Icons.more_vert_rounded);
  static const moreHoriz = MWIconData(nativeIcon: Icons.more_horiz_rounded);
  static const language = MWIconData(nativeIcon: Icons.language);
  static const feedback = MWIconData(nativeIcon: Icons.feedback_rounded);
  static const logout = MWIconData(nativeIcon: Icons.logout);
  static const sad = MWIconData(nativeIcon: Icons.sentiment_dissatisfied);
  static const refresh = MWIconData(nativeIcon: Icons.refresh);
  static const checkCircleSelected = MWIconData(nativeIcon: Icons.check_circle);
  static const checkCircle = MWIconData(nativeIcon: Icons.radio_button_unchecked);
  static const delete = MWIconData(nativeIcon: Icons.delete_rounded);
  static const edit = MWIconData(nativeIcon: Icons.edit);
  static const report = MWIconData(nativeIcon: Icons.report);
  static const arrowDown = MWIconData(nativeIcon: Icons.keyboard_arrow_down_rounded);
  static const warning = MWIconData(nativeIcon: Icons.warning_amber_outlined);
  static const block = MWIconData(nativeIcon: Icons.person_remove_alt_1_outlined);
  static const doubleArrow = MWIconData(nativeIcon: Icons.double_arrow_outlined);
  static const calendar = MWIconData(nativeIcon: Icons.calendar_today_outlined);
  static const cancel = MWIconData(nativeIcon: Icons.close);
  static const retry = MWIconData(nativeIcon: Icons.refresh);
  static const camera = MWIconData(nativeIcon: Icons.camera_alt_outlined);
  static const info = MWIconData(nativeIcon: Icons.info_rounded);
  static const play = MWIconData(nativeIcon: Icons.play_arrow_rounded);

  static const addOutlined = MWIconData(nativeIcon: Icons.my_library_add_outlined);
  // Icon with asset image
  static final add = MWIconData(assetImageFile: Assets.resources.icons.icAddPost);
  static final message = MWIconData(assetImageFile: Assets.resources.icons.icMessage);
  static final react = MWIconData(assetImageFile: Assets.resources.icons.icReact);
  static final unReact = MWIconData(assetImageFile: Assets.resources.icons.icUnreact);
  static final comment = MWIconData(assetImageFile: Assets.resources.icons.icComment);
  static final petTag = MWIconData(assetImageFile: Assets.resources.icons.icTagPet);
  static final otherInformation = MWIconData(assetImageFile: Assets.resources.icons.icOtherInfomation);
  static final petOwners = MWIconData(assetImageFile: Assets.resources.icons.icPetOwners);
  static final icAdoption = MWIconData(assetImageFile: Assets.resources.images.explore.icAdoption);
  static final icMatting = MWIconData(assetImageFile: Assets.resources.images.explore.icMatting);
  static final icLose = MWIconData(assetImageFile: Assets.resources.images.explore.icLose);
  static final icReact = MWIconData(assetImageFile: Assets.resources.images.explore.icReact);
  static final createChat = MWIconData(assetImageFile: Assets.resources.icons.icCreateChat);
}

enum MWIconThemeColor { primary, primaryText, primaryAccent, danger, success, secondaryText }
