import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';

enum OBAvatarSize { extraSmall, small, medium, large, extraLarge }

enum OBAvatarType { user, community }

class OBAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? avatarFile;
  final OBAvatarSize size;
  final VoidCallback? onPressed;
  final double? borderWidth;
  final bool isZoomable;
  final double? borderRadius;
  final double? customSize;

  static const double AVATAR_SIZE_EXTRA_SMALL = 20.0;
  static const double AVATAR_SIZE_SMALL = 30.0;
  static const double AVATAR_SIZE_MEDIUM = 50.0;
  static const double AVATAR_SIZE_LARGE = 80.0;
  static const double AVATAR_SIZE_EXTRA_LARGE = 120;
  static final AssetGenImage DEFAULT_AVATAR_ASSET = Assets.resources.images.fallbacks.avatarFallback;
  static const double avatarBorderRadius = 60;

  static double getAvatarSize(OBAvatarSize size) {
    double avatarSize;

    switch (size) {
      case OBAvatarSize.extraSmall:
        avatarSize = AVATAR_SIZE_EXTRA_SMALL;
        break;
      case OBAvatarSize.small:
        avatarSize = AVATAR_SIZE_SMALL;
        break;
      case OBAvatarSize.medium:
        avatarSize = AVATAR_SIZE_MEDIUM;
        break;
      case OBAvatarSize.large:
        avatarSize = AVATAR_SIZE_LARGE;
        break;
      case OBAvatarSize.extraLarge:
        avatarSize = AVATAR_SIZE_EXTRA_LARGE;
        break;
    }

    return avatarSize;
  }

  const OBAvatar(
      {this.avatarUrl,
      this.size = OBAvatarSize.small,
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
