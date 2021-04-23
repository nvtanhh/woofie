import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/theme/ui_color.dart';

class ImageWithPlaceHolderWidget extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double radius;
  final BoxFit fit;

  const ImageWithPlaceHolderWidget({
    this.width,
    this.height,
    this.imageUrl,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.radius,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (GetUtils.isNullOrBlank(imageUrl)) {
      return itemPlaceholder();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? topLeftRadius ?? 0),
          topRight: Radius.circular(radius ?? topRightRadius ?? 0),
          bottomLeft: Radius.circular(radius ?? bottomLeftRadius ?? 0),
          bottomRight: Radius.circular(radius ?? bottomRightRadius ?? 0),
        ),
        child: Image.network(
          imageUrl,
          height: height ?? 180.0.h,
          width: width ?? 180.0.w,
          errorBuilder: (context, url, error) {
            printError(info: error.toString());
            return itemPlaceholder();
          },
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
        color: UIColor.primary,
      ),
      child: Center(child: Assets.resources.icons.icItemPlaceholder.image(height: 28.0.h, width: 28.0.w)),
    );
  }
}
