import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';

enum MWAvatarSize { extraSmall, small, medium, large, extraLarge }

class MWAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? avatarFile;
  final MWAvatarSize size;
  final VoidCallback? onPressed;
  final double? borderWidth;
  final bool isZoomable;
  final double? borderRadius;
  final double? customSize;

  static const double AVATAR_SIZE_EXTRA_SMALL = 20.0;
  static const double AVATAR_SIZE_SMALL = 30.0;
  static const double AVATAR_SIZE_MEDIUM = 45.0;
  static const double AVATAR_SIZE_LARGE = 70.0;
  static const double AVATAR_SIZE_EXTRA_LARGE = 100;
  static final AssetGenImage DEFAULT_AVATAR_ASSET = Assets.resources.images.fallbacks.avatarFallback;
  static const double avatarBorderRadius = 60;

  static double getAvatarSize(MWAvatarSize size) {
    double avatarSize;

    switch (size) {
      case MWAvatarSize.extraSmall:
        avatarSize = AVATAR_SIZE_EXTRA_SMALL;
        break;
      case MWAvatarSize.small:
        avatarSize = AVATAR_SIZE_SMALL;
        break;
      case MWAvatarSize.medium:
        avatarSize = AVATAR_SIZE_MEDIUM;
        break;
      case MWAvatarSize.large:
        avatarSize = AVATAR_SIZE_LARGE;
        break;
      case MWAvatarSize.extraLarge:
        avatarSize = AVATAR_SIZE_EXTRA_LARGE;
        break;
    }

    return avatarSize;
  }

  const MWAvatar(
      {this.avatarUrl,
      this.size = MWAvatarSize.medium,
      this.onPressed,
      this.avatarFile,
      this.borderWidth,
      this.isZoomable = false,
      this.borderRadius,
      this.customSize});

  @override
  Widget build(BuildContext context) {
    final finalSize = size;
    final avatarSize = customSize ?? getAvatarSize(finalSize);

    Widget finalAvatarImage;

    if (avatarFile != null) {
      finalAvatarImage = FadeInImage(
        fit: BoxFit.cover,
        height: avatarSize.w,
        width: avatarSize.w,
        placeholder: DEFAULT_AVATAR_ASSET,
        image: FileImage(avatarFile!),
      );
    } else if (avatarUrl != null) {
      finalAvatarImage = ExtendedImage.network(
        avatarUrl!,
        height: avatarSize.w,
        width: avatarSize.w,
        fit: BoxFit.cover,
        retries: 0,
      );

      if (isZoomable) {
        finalAvatarImage = GestureDetector(
          onTap: () {},
          child: finalAvatarImage,
        );
      }
    } else {
      finalAvatarImage = _getAvatarPlaceholder(avatarSize);
    }

    Widget avatar = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? avatarBorderRadius),
      child: finalAvatarImage,
    );

    if (onPressed == null) return avatar;

    return GestureDetector(
      onTap: onPressed,
      child: avatar,
    );
  }

  Widget _getAvatarPlaceholder(double avatarSize) {
    return DEFAULT_AVATAR_ASSET.image(
      height: avatarSize.w,
      width: avatarSize.w,
    );
  }
}