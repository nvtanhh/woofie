import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget_model.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/widgets/card_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class AdoptionPetDetailWidget extends StatefulWidget {
  final Post post;

  const AdoptionPetDetailWidget({Key? key, required this.post}) : super(key: key);

  @override
  _AdoptionPetDetailState createState() => _AdoptionPetDetailState();
}

class _AdoptionPetDetailState extends BaseViewState<AdoptionPetDetailWidget, AdoptionPetDetailWidgetModel> {
  @override
  void loadArguments() {
    viewModel.post = widget.post;
    viewModel.pet = widget.post.pets?[0];
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ImageWithPlaceHolderWidget(
                imageUrl: viewModel.post.medias?[0].url ?? viewModel.pet?.avatar?.url ?? "",
                height: Get.height / 2,
                width: Get.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: Get.height / 2 + 50.h,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: UIColor.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    top: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.pet?.name ?? "",
                                  style: UITextStyle.text_header_24_w700,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      color: UIColor.primary,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      viewModel.post.pets?[0].name ?? "",
                                      style: UITextStyle.text_header_18_w600,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CardDetailWidget(
                            title: LocaleKeys.explore_gender.trans(),
                            value: viewModel.pet?.gender.toString() ?? "",
                          ),
                          CardDetailWidget(
                            title: LocaleKeys.explore_age.trans(),
                            value: DateTimeHelper.calcAge(viewModel.pet?.dob),
                          ),
                          CardDetailWidget(
                            title: LocaleKeys.explore_breed.trans(),
                            value: viewModel.post.pets?[0].gender.toString() ?? "",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        LocaleKeys.explore_detail.trans(),
                        style: UITextStyle.text_header_18_w700,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Expanded(
                        child: Text(
                          viewModel.post.content ?? "",
                          style: UITextStyle.text_body_14_w500,
                        ),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(),
                        leading: MWAvatar(
                          avatarUrl: viewModel.post.creator.avatar?.url,
                          borderRadius: 10.r,
                        ),
                        title: Text(
                          viewModel.post.creator.name ?? "",
                          style: UITextStyle.text_header_16_w6002,
                        ),
                        subtitle: Text(
                          LocaleKeys.explore_owner_pet.trans(),
                          style: GoogleFonts.montserrat(textStyle: UITextStyle.text_body_14_w500),
                        ),
                        trailing: ButtonWidget(
                          width: 96.w,
                          height: 47.h,
                          title: LocaleKeys.explore_contact.trans(),
                          onPress: () => null,
                          borderRadius: 15.r,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: Get.width,
                  height: 50.h,
                  margin: EdgeInsets.only(top: 10.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          onPress: () => Get.back(),
                          width: 40.w,
                          height: 40.w,
                          borderRadius: 20.w,
                          backgroundColor: UIColor.white,
                          contentWidget: const Icon(
                            Icons.arrow_back_ios_outlined,
                            color: UIColor.textHeader,
                          ),
                        ),
                        ButtonWidget(
                          onPress: () => null,
                          width: 40.w,
                          height: 40.w,
                          borderRadius: 20.w,
                          backgroundColor: UIColor.white,
                          contentWidget: const Icon(
                            Icons.more_horiz_outlined,
                            color: UIColor.textHeader,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  AdoptionPetDetailWidgetModel createViewModel() => injector<AdoptionPetDetailWidgetModel>();
}
