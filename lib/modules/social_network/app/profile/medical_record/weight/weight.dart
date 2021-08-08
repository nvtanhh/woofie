import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight_model.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/medical_actions_popup.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/weight_chart_preview_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class WeightWidget extends StatefulWidget {
  final Pet pet;
  final bool isMyPet;
  final bool? addData;

  const WeightWidget({
    Key? key,
    required this.pet,
    required this.isMyPet,
    this.addData,
  }) : super(key: key);

  @override
  _WeightWidgetState createState() => _WeightWidgetState();
}

class _WeightWidgetState extends BaseViewState<WeightWidget, WeightWidgetModel> {
  @override
  void loadArguments() {
    viewModel.pet = widget.pet;
    viewModel.isMyPet = widget.isMyPet;
    viewModel.listWeightChart = widget.pet.petWeights ?? [];
    if (widget.addData == true) {
      SchedulerBinding.instance!.addPostFrameCallback((_) => viewModel.addWeightPress());
    }
    super.loadArguments();
  }

  bool increase = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocaleKeys.profile_medical_record.trans(),
            style: UITextStyle.text_header_18_w700,
          ),
          leading: IconButton(
            icon: const MWIcon(MWIcons.back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => WeightChartPreviewWidget(
                  width: Get.width,
                  height: 180.h,
                  weights: viewModel.listWeightChart,
                  isMyPet: viewModel.isMyPet,
                  onAddClick: () => viewModel.addWeightPress(),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              if (viewModel.isMyPet)
                MWButton(
                  onPressed: () => viewModel.addWeightPress(),
                  minWidth: Get.width,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Text(
                    LocaleKeys.profile_add.trans(),
                    style: UITextStyle.white_12_w600.copyWith(fontSize: 14.sp),
                  ),
                ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: PagedListView<int, PetWeight>(
                  key: viewModel.gloalKey,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, petWeight, index) {
                      if ((viewModel.pagingController.itemList?.length ?? 0) - 1 >= index + 1) {
                        increase = (petWeight.weight ?? 0) >= (viewModel.pagingController.itemList?[index + 1].weight ?? 0);
                      }
                      return ListTile(
                        title: Text(
                          "${petWeight.weight} Kg",
                          style: UITextStyle.text_header_14_w600,
                        ),
                        subtitle: Text(
                          FormatHelper.formatDateTime(petWeight.date, pattern: "dd/MM/yyyy"),
                          style: UITextStyle.text_secondary_10_w600,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: increase ? UIColor.cosmicLatte : UIColor.aquaSpring,
                          ),
                          child: RotatedBox(
                            quarterTurns: defineAngle(index, viewModel.pagingController.itemList?.length ?? 0),
                            child: index == ((viewModel.pagingController.itemList?.length ?? 0) - 1)
                                ? Assets.resources.icons.icWeight.image(
                                    fit: BoxFit.fill,
                                    width: 32.w,
                                    height: 32.h,
                                  )
                                : MWIcon(
                                    MWIcons.doubleArrow,
                                    customSize: 24.w,
                                    color: increase ? UIColor.accent2 : UIColor.danger,
                                  ),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MedicalActionsTrailing(
                              onDelete: () => viewModel.onDeleteWeight(petWeight,index),
                              onEdit: () => viewModel.onEditWeight(petWeight,index),
                            ),
                            Text(
                              calcAgeFromWeight(viewModel.pet.dob, petWeight.date),
                              style: UITextStyle.text_secondary_12_w500,
                            ),
                          ],
                        ),
                      );
                    },
                    noItemsFoundIndicatorBuilder: (_) => Center(
                      child: Text(
                        LocaleKeys.profile_not_have_data.trans(),
                        style: UITextStyle.text_body_14_w600,
                      ),
                    ),
                  ),
                  pagingController: viewModel.pagingController,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  int defineAngle(int index, int lenght) {
    if (index == lenght - 1) {
      return 0;
    }
    if (increase) {
      return 11;
    } else {
      return 5;
    }
  }

  String calcAgeFromWeight(DateTime? dob, DateTime? timeAddWeight) {
    if (dob == null || timeAddWeight == null) return "";
    final date = AgeCalculator.age(dob, today: timeAddWeight);
    if (date.years > 0) {
      return "${date.years} ${LocaleKeys.year.trans()} ${date.months} ${LocaleKeys.month.trans()} ${LocaleKeys.add_pet_age.trans()}";
    } else {
      return "${date.months} ${LocaleKeys.month.trans()} ${LocaleKeys.add_pet_age.trans()}";
    }
  }

  @override
  WeightWidgetModel createViewModel() => injector<WeightWidgetModel>();
}
