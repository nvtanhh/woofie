import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:shimmer/shimmer.dart';

class ImageWithPlaceHolderWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String imageUrl;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double? radius;
  final BoxFit? fit;
  final GestureConfig Function(ExtendedImageState)? initGestureConfigHandler;
  final ExtendedImageMode? mode;
  final Image? placeHolderImage;
  final String? placeHolderImagePath;
  final bool isConstraintsSize;
  final bool clickable;

  const ImageWithPlaceHolderWidget({
    required this.imageUrl,
    this.width,
    this.height,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.radius,
    this.fit,
    this.initGestureConfigHandler,
    this.mode,
    this.placeHolderImage,
    this.placeHolderImagePath,
    this.isConstraintsSize = true,
    this.clickable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (GetUtils.isBlank(imageUrl) == true) {
      return itemPlaceholder();
    } else {
      return GestureDetector(
        onTap: clickable
            ? () => injector<DialogService>().showZoomablePhotoBoxView(
                  imageUrl: imageUrl,
                  context: context,
                )
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius ?? topLeftRadius),
            topRight: Radius.circular(radius ?? topRightRadius),
            bottomLeft: Radius.circular(radius ?? bottomLeftRadius),
            bottomRight: Radius.circular(radius ?? bottomRightRadius),
          ),
          child: ExtendedImage.network(
            imageUrl,
            height: isConstraintsSize ? height ?? 180.0.h : null,
            width: isConstraintsSize ? width ?? 180.0.w : null,
            fit: fit ?? BoxFit.cover,
            initGestureConfigHandler: initGestureConfigHandler,
            mode: mode ?? ExtendedImageMode.none,
            timeLimit: const Duration(seconds: 3),
            retries: 0,
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
          topLeft: Radius.circular(radius ?? topLeftRadius),
          topRight: Radius.circular(radius ?? topRightRadius),
          bottomLeft: Radius.circular(radius ?? bottomLeftRadius),
          bottomRight: Radius.circular(radius ?? bottomRightRadius),
        ),
        image: placeHolderImage != null
            ? null
            : DecorationImage(
                image: AssetGenImage(
                  placeHolderImagePath ??
                      "resources/images/fallbacks/avatar-fallback.jpg",
                ),
                fit: BoxFit.cover,
              ),
      ),
      child: placeHolderImage,
    );
  }
}
