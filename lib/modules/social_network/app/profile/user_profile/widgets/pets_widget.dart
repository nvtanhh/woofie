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
  final RxList<Pet> _list = RxList();

  PetsWidget({
    Key? key,
    required this.user,
    this.onFollow,
    required this.isMyPets,
  }) : super(key: key) {
    if (user.currentPets == null) {
      user.currentPets = [];
      user.notifyUpdate();
    } else {
      _list.assignAll(user.currentPets!);
    }
    injector<EventBus>().on<PetDeletedEvent>().listen(
      (event) {
        _list.removeWhere((element) => element.id == event.pet.id);
        _list.refresh();
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
      _list.add(petNew as Pet);
      _list.refresh();
      user.currentPets?.add(petNew);
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
          height: 180.h,
          child: user.currentPets?.isEmpty == true
              ? isMyPets
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160.w,
                          height: 180.h,
                          margin: EdgeInsets.all(5.w),
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
                              Text(LocaleKeys.add_pet_do_not_have_pet.trans()),
                              IconButton(
                                onPressed: () => onPressAddPet(),
                                icon: const Icon(
                                  Icons.add_box_outlined,
                                  color: UIColor.textBody,
                                ),
                              ),
                              Text(
                                LocaleKeys.profile_add_pet.trans(),
                                style: UITextStyle.text_body_12_w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(LocaleKeys.add_pet_do_not_have_pet.trans()))
              : Obx(
                  () => ListView.builder(
                    padding: EdgeInsets.only(left: 16.w),
                    itemBuilder: (context, index) {
                      if (isMyPets && index == _list.length) {
                        return InkWell(
                          onTap: () => onPressAddPet(),
                          child: Container(
                            width: 115.w,
                            height: 180.h,
                            margin: EdgeInsets.all(5.w),
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
                                const MWIcon(
                                  MWIcons.addOutlined,
                                  color: UIColor.textBody,
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
                      return PreviewFollowPet(
                        pet: _list[index],
                        onFollow: onFollow,
                        margin: EdgeInsets.only(right: 12.w),
                        isMyPet: isMyPets,
                      );
                    },
                    itemCount: isMyPets ? _list.length + 1 : _list.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
        ),
      ],
    );
  }
}
