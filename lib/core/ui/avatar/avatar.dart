import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:shimmer/shimmer.dart';

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
  final Image? placeHolderImage;
  final BoxFit? fit;

  static const double AVATAR_SIZE_EXTRA_SMALL = 20.0;
  static const double AVATAR_SIZE_SMALL = 30.0;
  static const double AVATAR_SIZE_MEDIUM = 45.0;
  static const double AVATAR_SIZE_LARGE = 70.0;
  static const double AVATAR_SIZE_EXTRA_LARGE = 100;
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

  const MWAvatar({
    this.avatarUrl,
    this.size = MWAvatarSize.medium,
    this.onPressed,
    this.avatarFile,
    this.borderWidth,
    this.isZoomable = false,
    this.borderRadius,
    this.customSize,
    this.placeHolderImage,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final finalSize = size;
    final avatarSize = customSize ?? getAvatarSize(finalSize);

    Widget finalAvatarImage;

    if (avatarFile != null) {
      finalAvatarImage = FadeInImage(
        fit: fit ?? BoxFit.cover,
        height: avatarSize.w,
        width: avatarSize.w,
        placeholder: Assets.resources.images.fallbacks.avatarFallback,
        image: FileImage(avatarFile!),
      );
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      finalAvatarImage = ExtendedImage.network(
        avatarUrl!,
        height: avatarSize.w,
        width: avatarSize.w,
        fit: fit ?? BoxFit.cover,
        retries: 0,
        loadStateChanged: (e) {
          switch (e.extendedImageLoadState) {
            case LoadState.loading:
              return Shimmer.fromColors(
                baseColor: UIColor.white,
                highlightColor: UIColor.silverSand,
                child: Container(
                  width: avatarSize.w,
                  height: avatarSize.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.r),
                      topLeft: Radius.circular(10.r),
                    ),
                    color: UIColor.white,
                  ),
                  margin: EdgeInsets.only(right: 10.w),
                ),
              );
            case LoadState.completed:
              return null;
            case LoadState.failed:
              return _getAvatarPlaceholder(avatarSize);
          }
        },
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

    final Widget avatar = ClipRRect(
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
    return SizedBox(
      height: avatarSize.h,
      width: avatarSize.w,
      child: placeHolderImage ??
          Assets.resources.images.fallbacks.avatarFallback.image(),
    );
  }
}
