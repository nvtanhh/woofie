import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/widgets/card_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_detail_info_pet_usecase.dart';
import 'package:meowoof/theme/ui_text_style.dart';

class DetailInfoPetWidget extends StatelessWidget {
  Pet pet;
  final RxBool _isLoaded = RxBool(false);
  final GetDetailInfoPetUsecase _getDetailInfoPetUsecase = injector<GetDetailInfoPetUsecase>();

  DetailInfoPetWidget({Key? key, required this.pet}) : super(key: key) {
    _loadPetDetailInfo();
  }

  Future _loadPetDetailInfo() async {
    try {
      pet = await _getDetailInfoPetUsecase.call(pet.id!);
      _isLoaded.value =true;
    } catch (e) {
      _isLoaded.value =false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardDetailWidget(
              title: LocaleKeys.explore_gender.trans(),
              value: pet.gender?.toString() ?? "",
            ),
            CardDetailWidget(
              title: LocaleKeys.explore_age.trans(),
              value: DateTimeHelper.calcAge(pet.dob),
            ),
            CardDetailWidget(
              title: LocaleKeys.explore_breed.trans(),
              value: pet.petBreed?.name ?? "",
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          LocaleKeys.explore_age.trans(),
          style: UITextStyle.text_header_18_w600,
        ),
      ],
    );
  }
}
