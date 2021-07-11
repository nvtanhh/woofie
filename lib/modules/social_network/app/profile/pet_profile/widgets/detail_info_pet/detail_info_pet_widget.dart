import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/widgets/card_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/vaccinated_preview_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/weight_chart_preview_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/worm_flushed_preview_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/detail_info_pet/detail_info_pet_widget_model.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class DetailInfoPetWidget extends StatefulWidget {
  final Pet pet;
  final bool isMyPet;
  final Function onAddWeightClick;
  final Function onAddWormFlushedClick;
  final Function onAddVaccinatedClick;

  const DetailInfoPetWidget({
    Key? key,
    required this.pet,
    required this.isMyPet,
    required this.onAddWeightClick,
    required this.onAddWormFlushedClick,
    required this.onAddVaccinatedClick,
  }) : super(key: key);

  @override
  _DetailInfoPetWidgetState createState() => _DetailInfoPetWidgetState();
}

class _DetailInfoPetWidgetState extends BaseViewState<DetailInfoPetWidget, DetailInfoPetWidgetModel> with AutomaticKeepAliveClientMixin {
  @override
  void loadArguments() {
    viewModel.pet = widget.pet;
    viewModel.isMyPet = widget.isMyPet;
    viewModel.onAddWeightClick = widget.onAddWeightClick;
    viewModel.onAddVaccinatedClick = widget.onAddVaccinatedClick;
    viewModel.onAddWormFlushedClick = widget.onAddWormFlushedClick;
    super.loadArguments();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardDetailWidget(
              title: LocaleKeys.explore_gender.trans(),
              value: FormatHelper.genderPet(viewModel.pet.gender),
            ),
            CardDetailWidget(
              title: LocaleKeys.explore_age.trans(),
              value: DateTimeHelper.calcAge(viewModel.pet.dob),
            ),
            CardDetailWidget(
              title: LocaleKeys.explore_breed.trans(),
              value: viewModel.pet.petBreed?.name ?? "",
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          LocaleKeys.profile_medical_record.trans(),
          style: UITextStyle.text_header_18_w600,
        ),
        SizedBox(
          height: 10.h,
        ),
        InkWell(
          onTap: () => viewModel.onTabWeightChart(),
          child: Obx(
            () => WeightChartPreviewWidget(
              width: Get.width,
              height: 175.h,
              isMyPet: viewModel.isMyPet,
              onAddClick: viewModel.isMyPet ? viewModel.onAddWeightClick : () => null,
              weights: viewModel.pet.updateSubject.petWeights ?? [],
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => viewModel.onTabWormFlushed(),
                child: Obx(
                  () => WormFlushedPreviewWidget(
                    width: 160.w,
                    height: 188.h,
                    wormFlushed: viewModel.pet.updateSubject.petWormFlushes ?? [],
                    isMyPet: viewModel.isMyPet,
                    onAddClick: viewModel.isMyPet ? viewModel.onAddWormFlushedClick : () => null,
                  ),
                ),
              ),
              InkWell(
                onTap: () => viewModel.onTabVaccinated(),
                child: Obx(
                  () => VaccinatedPreviewWidget(
                    width: 160.w,
                    height: 188.h,
                    vaccinates: viewModel.pet.updateSubject.petVaccinates ?? [],
                    isMyPet: viewModel.isMyPet,
                    onAddClick: viewModel.isMyPet ? viewModel.onAddVaccinatedClick : () => null,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  DetailInfoPetWidgetModel createViewModel() => injector<DetailInfoPetWidgetModel>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
