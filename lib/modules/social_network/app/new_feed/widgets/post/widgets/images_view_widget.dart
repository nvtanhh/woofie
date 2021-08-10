import 'package:better_player/better_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class ImagesViewWidget extends StatelessWidget {
  final List<Media> medias;
  final double? height;
  final BoxFit? fit;
  final bool counterPositionTop;

  ImagesViewWidget({
    Key? key,
    required this.medias,
    this.height,
    this.fit,
    this.counterPositionTop = true,
  }) : super(key: key);
  final PageController _pageController = PageController();
  final RxInt indexPage = RxInt(0);

  @override
  Widget build(BuildContext context) {
    if (medias.isNotEmpty) {
      return Container(
        height: height ?? 400.h,
        margin: EdgeInsets.only(top: 5.h, bottom: 15.h),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: PageView.builder(
                itemBuilder: (context, index) {
                  if (medias[index].type == MediaType.image || medias[index].type == MediaType.gif) {
                    return ImageWithPlaceHolderWidget(
                      imageUrl: medias[index].url ?? "",
                      radius: 20.r,
                      fit: BoxFit.cover,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9,
                          animationMinScale: 0.7,
                          maxScale: 3.0,
                          animationMaxScale: 3.5,
                        );
                      },
                      mode: ExtendedImageMode.gesture,
                    );
                  } else if (medias[index].type == MediaType.video) {
                    return BetterPlayer.network(
                      medias[index].url ?? "",
                      betterPlayerConfiguration: BetterPlayerConfiguration(
                        fit: BoxFit.scaleDown,
                        aspectRatio: 16 / 9,
                        errorBuilder: (context, string) {
                          return Text(string ?? "");
                        },
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                itemCount: medias.length,
                controller: _pageController,
                allowImplicitScrolling: true,
                onPageChanged: (index) {
                  indexPage.value = index;
                },
              ),
            ),
            Positioned(
              top: counterPositionTop ? 20 : null,
              bottom: counterPositionTop ? null : 50,
              right: 10,
              child: Container(
                width: 41.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: UIColor.eclipse,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Obx(
                  () => Text(
                    "${indexPage.value + 1}/${medias.length}",
                    style: UITextStyle.white_12_w600,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 10.h,
      );
    }
  }
}
