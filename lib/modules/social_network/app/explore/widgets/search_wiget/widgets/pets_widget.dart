import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class PetsWidget extends StatelessWidget {
  final PagingController<int, Pet> pagingController;
  final Function(int) follow;

  const PetsWidget({
    Key? key,
    required this.pagingController,
    required this.follow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Pet>(
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, pet, index) {
          return InkWell(
            onTap: () => Get.to(() => PetProfile(pet: pet)),
            child: Container(
              padding: EdgeInsets.all(10.w),
              height: 165.h,
              child: Row(
                children: [
                  ImageWithPlaceHolderWidget(
                      imageUrl: pet.avatarUrl ?? "",
                      width: 117.w,
                      height: 152.h,
                      radius: 10.r,
                      fit: BoxFit.cover,
                      placeHolderImage: "resources/images/fallbacks/pet-avatar-fallback.jpg"),
                  SizedBox(
                    width: 25.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          pet.name ?? "",
                          style: UITextStyle.text_header_16_w700,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          pet.bio ?? "",
                          style: UITextStyle.text_body_14_w500,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(
                          () => ButtonWidget(
                            onPress: () {
                              if (pet.isFollowing == true) {
                                pet.unFollowPet();
                              } else {
                                pet.followPet();
                              }
                              follow(pet.id);
                            },
                            height: 30.h,
                            width: 65.w,
                            title: (pet.updateSubjectValue.isFollowing ?? false)
                                ? LocaleKeys.profile_un_follow.trans()
                                : LocaleKeys.profile_follow.trans(),
                            titleStyle: UITextStyle.white_12_w600,
                            borderRadius: 10.r,
                            backgroundColor: (pet.updateSubjectValue.isFollowing ?? false) ? UIColor.textSecondary : UIColor.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
        firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
      ),
      pagingController: pagingController,
    );
  }
}
