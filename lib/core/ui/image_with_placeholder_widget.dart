import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:shimmer/shimmer.dart';

class ImageWithPlaceHolderWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String imageUrl;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final double? radius;
  final BoxFit? fit;
  final GestureConfig Function(ExtendedImageState)? initGestureConfigHandler;
  final ExtendedImageMode? mode;

  final String? placeHolderImage;
  final bool isConstraintsSize;

  const ImageWithPlaceHolderWidget({
    required this.imageUrl,
    this.width,
    this.height,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.radius,
    this.fit,
    this.initGestureConfigHandler,
    this.mode,
    this.placeHolderImage,
    this.isConstraintsSize = true,
  });

  @override
  Widget build(BuildContext context) {
    if (GetUtils.isBlank(imageUrl) == true) {
      return itemPlaceholder();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? topLeftRadius ?? 0),
          topRight: Radius.circular(radius ?? topRightRadius ?? 0),
          bottomLeft: Radius.circular(radius ?? bottomLeftRadius ?? 0),
          bottomRight: Radius.circular(radius ?? bottomRightRadius ?? 0),
        ),
        child: ExtendedImage.network(
          imageUrl,
          height: isConstraintsSize ? height ?? 180.0.h : null,
          width: isConstraintsSize ? width ?? 180.0.w : null,
          fit: fit ?? BoxFit.fill,
          initGestureConfigHandler: initGestureConfigHandler,
          mode: mode ?? ExtendedImageMode.none,
          loadStateChanged: (e) {
            switch (e.extendedImageLoadState) {
              case LoadState.loading:
                return Shimmer.fromColors(
                  baseColor: UIColor.white,
                  highlightColor: UIColor.silverSand,
                  child: Container(
                    width: isConstraintsSize ? width ?? 180.0.w : null,
                    height: isConstraintsSize ? height ?? 180.0.h : null,
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
                return itemPlaceholder();
            }
          },
        ),
      );
    }
  }

  Widget itemPlaceholder() {
    return Container(
      height: height ?? 180.0.h,
      width: width ?? 180.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? topLeftRadius ?? 0),
          topRight: Radius.circular(radius ?? topRightRadius ?? 0),
          bottomLeft: Radius.circular(radius ?? bottomLeftRadius ?? 0),
          bottomRight: Radius.circular(radius ?? bottomRightRadius ?? 0),
        ),
        image: DecorationImage(
          image: AssetGenImage(placeHolderImage ??
              "resources/images/fallbacks/avatar-fallback.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
