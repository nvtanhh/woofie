import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/add_pet/add_pet_widget.dart';
import 'package:meowoof/modules/social_network/app/commons/preview_follow_pet.dart';
import 'package:meowoof/modules/social_network/domain/events/pet/pet_deleted_event.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';

// ignore: must_be_immutable
class PetsWidget extends StatelessWidget {
  final User user;
  final Function(Pet)? onFollow;
  final bool isMyPets;

  PetsWidget({
    Key? key,
    required this.user,
    this.onFollow,
    required this.isMyPets,
  }) : super(key: key) {
    if (user.currentPets == null) {
      user.currentPets = [];
      user.notifyUpdate();
    }
    injector<EventBus>().on<PetDeletedEvent>().listen(
      (event) {
        user.currentPets?.removeWhere((element) => element.id == event.pet.id);
        user.notifyUpdate();
      },
    );
  }

  Future onPressAddPet() async {
    final petNew = await Get.to(
      () => const AddPetWidget(
        isAddMore: true,
      ),
    );
    if (petNew != null) {
      user.currentPets?.add(petNew as Pet);
      user.notifyUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            LocaleKeys.profile_pet.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
          height: 190.h,
          child: Obx(
            () {
              return user.updateSubjectValue.currentPets?.isEmpty ?? true
                  ? isMyPets
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCardAddPet(showTitle: true),
                          ],
                        )
                      : Center(
                          child:
                              Text(LocaleKeys.add_pet_do_not_have_pet.trans()))
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        left: 15.w,
                        top: 5.h,
                        bottom: 5.h,
                        right: 16.w,
                      ),
                      itemBuilder: (context, index) {
                        if (isMyPets && index == user.currentPets!.length) {
                          return buildCardAddPet();
                        }
                        return PreviewFollowPet(
                          pet: user.currentPets![index].updateSubjectValue,
                          onFollow: onFollow,
                          margin: EdgeInsets.only(right: 12.w),
                          isMyPet: isMyPets,
                        );
                      },
                      itemCount: isMyPets
                          ? user.currentPets!.length + 1
                          : user.currentPets!.length,
                      scrollDirection: Axis.horizontal,
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCardAddPet({bool showTitle = false}) {
    return GestureDetector(
      onTap: () => onPressAddPet(),
      child: Container(
        width: showTitle ? 150.w : 120.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(
              color: UIColor.dimGray,
              blurRadius: 5,
              offset: Offset(2, 0),
              spreadRadius: 2,
            ),
          ],
          color: UIColor.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showTitle)
              Text(
                LocaleKeys.add_pet_you_do_not_have_pet.trans(),
                textAlign: TextAlign.center,
              ),
            SizedBox(
              height: 5.h,
            ),
            const MWIcon(
              MWIcons.addOutlined,
              color: UIColor.textBody,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              LocaleKeys.profile_add_pet.trans(),
              style: UITextStyle.text_body_12_w600,
            ),
          ],
        ),
      ),
    );
  }
}
