import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';

class PetAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? avatarFile;
  final MWAvatarSize size;
  final VoidCallback? onPressed;
  final double? borderWidth;
  final bool isZoomable;
  final double? borderRadius;
  final double? customSize;
  final BoxFit? fit;

  const PetAvatar({
    this.avatarUrl,
    this.size = MWAvatarSize.medium,
    this.onPressed,
    this.avatarFile,
    this.borderWidth,
    this.isZoomable = false,
    this.borderRadius,
    this.customSize,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return MWAvatar(
      avatarFile: avatarFile,
      avatarUrl: avatarUrl,
      size: size,
      borderWidth: borderWidth,
      isZoomable: isZoomable,
      borderRadius: borderRadius,
      customSize: customSize,
      onPressed: onPressed,
      fit: fit,
      placeHolderImage: Assets.resources.images.fallbacks.petAvatarFallback.image(),
    );
  }
}
