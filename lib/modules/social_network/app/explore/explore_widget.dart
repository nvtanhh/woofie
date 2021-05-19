import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/search_bar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/explore_widget_model.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adop_widget/adop_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/service_widget.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class ExploreWidget extends StatefulWidget {
  @override
  _ExploreWidgetState createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends BaseViewState<ExploreWidget, ExploreWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MWSearchBar(
                  onSearch: viewModel.onSearchBar,
                  action: IconButton(
                    padding: EdgeInsets.only(left: 10.w),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.location_on_rounded,
                      color: UIColor.primary,
                      size: 30.w,
                    ),
                    onPressed: () => viewModel.onLocationClick(),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  LocaleKeys.explore_more.trans(),
                  style: UITextStyle.text_header_18_w700,
                ),
                InkWell(
                  onTap: () => Get.to(AdoptionWidget()),
                  child: SizedBox(
                    height: 120.h,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 95.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: UIColor.pattens_blue,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                              ),
                              SizedBox(
                                width: (Get.width * 0.6).w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocaleKeys.explore_adoption.trans(),
                                      style: UITextStyle.allports_18_w600,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      "Có đến 250 thú cưng đang chờ bạn nhận nuôi",
                                      style: UITextStyle.text_body_10_w500,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 10.w,
                          bottom: 10.h,
                          child: Assets.resources.images.explore.adop.image(
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 120.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 95.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: UIColor.lavender_blush,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: (Get.width * 0.75).w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.explore_matting.trans(),
                                    style: UITextStyle.charm_18_w600,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "Ngày tháng đẹp biết bao nhiêu. ",
                                    style: UITextStyle.text_body_10_w500,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Hẹn nhau 1 tách trà chiều mew mew!!!",
                                    style: UITextStyle.text_body_10_w500,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 10.w,
                        bottom: 10.h,
                        child: Assets.resources.images.explore.matting.image(
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 120.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 95.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: UIColor.white_smoke,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),
                            SizedBox(
                              width: (Get.width * 0.6).w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.explore_lost_pet.trans(),
                                    style: UITextStyle.persian_red_18_w600,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "Bé đi đâu rồi",
                                    style: UITextStyle.text_body_10_w500,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 10.w,
                        bottom: 10.h,
                        child: Assets.resources.images.explore.lostPet.image(
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  LocaleKeys.explore_service_pet.trans(),
                  style: UITextStyle.text_header_18_w700,
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: Get.width,
                  height: 120.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ServiceWidget(
                        title: "Animal Emergency",
                        distance: 0.3,
                        widget: Assets.resources.images.explore.emergency.image(
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ServiceWidget(
                        title: "Pety",
                        distance: 0.3,
                        widget: Assets.resources.images.explore.pety.image(
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  ExploreWidgetModel createViewModel() => injector<ExploreWidgetModel>();
}
