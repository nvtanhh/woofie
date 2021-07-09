import 'package:cached_network_image/cached_network_image.dart';
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

  const ImageWithPlaceHolderWidget({
    this.width,
    this.height,
    required this.imageUrl,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.radius,
    this.fit,
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: height ?? 180.0.h,
          width: width ?? 180.0.w,
          errorWidget: (context, _, __) {
            return itemPlaceholder();
          },
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: UIColor.white,
            highlightColor: UIColor.silverSand,
            child: Container(
              width: width ?? 180.0.w,
              height: height ?? 180.0.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.r),
                  topLeft: Radius.circular(10.r),
                ),
                color: UIColor.white,
              ),
              margin: EdgeInsets.only(right: 10.w),
            ),
          ),
          fit: fit ?? BoxFit.fill,
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
        image: const DecorationImage(
          image: AssetGenImage("resources/icons/ic_person.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
