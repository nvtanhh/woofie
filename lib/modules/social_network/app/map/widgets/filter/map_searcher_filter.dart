import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/ios_indicator.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/add_pet/widgets/select_pet_type_widget.dart';
import 'package:meowoof/modules/social_network/app/map/widgets/filter/map_searcher_filter_model.dart';
import 'package:meowoof/modules/social_network/app/map/widgets/filter/widgets/select_pet_breed.dart';
import 'package:meowoof/modules/social_network/app/map/widgets/filter/widgets/select_pet_type_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapSearcherFilter extends StatefulWidget {
  const MapSearcherFilter({Key? key}) : super(key: key);

  @override
  _MapSearcherFilterState createState() => _MapSearcherFilterState();
}

class _MapSearcherFilterState
    extends BaseViewState<MapSearcherFilter, MapSearcherFilterModel> {
  @override
  MapSearcherFilterModel createViewModel() =>
      injector<MapSearcherFilterModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 600.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        color: UIColor.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: IOSIndicatorWidget()),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: _selectPostTypeSection(),
                    ),
                    _selectPetTypeSection(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: _selectPetBreedSection(),
                    ),
                  ],
                ),
              ),
            ),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _selectPostTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Post type', style: UITextStyle.heading_18_semiBold),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MWIcon(
              defineIcon(PostType.adop),
              customSize: 48.w,
            ),
            SizedBox(width: 15.w),
            MWIcon(
              defineIcon(PostType.mating),
              customSize: 48.w,
            ),
            SizedBox(width: 15.w),
            MWIcon(
              defineIcon(PostType.lose),
              customSize: 48.w,
            ),
          ],
        ),
      ],
    );
  }

  Widget _selectPetTypeSection() {
    return Obx(
      () => viewModel.petTypes.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pet type', style: UITextStyle.heading_18_semiBold),
                SizedBox(height: 15.h),
                MapSeacherFilterSelectPetTypeWidget(
                  petTypes: viewModel.petTypes,
                  selectedIndex: viewModel.indexPetTypeSelected,
                  onSelectedIndex: viewModel.onPetTypeSelectedIndex,
                )
              ],
            )
          : const SizedBox(),
    );
  }

  Widget _selectPetBreedSection() {
    return Obx(
      () => viewModel.petBreeds.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pet breed', style: UITextStyle.heading_18_semiBold),
                SizedBox(height: 15.h),
                MapSeacherFilterSelectPetBreedWidget(
                  petBreeds: viewModel.petBreeds,
                  onPetBreedSelected: viewModel.onPetBreedSelected,
                  selectedPetBreeds: viewModel.selectedPetBreeds,
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  MWIconData defineIcon(PostType postType) {
    switch (postType) {
      case PostType.mating:
        return MWIcons.icMatting;
      case PostType.adop:
        return MWIcons.icAdoption;
      case PostType.lose:
        return MWIcons.icLose;
      default:
        return MWIcons.icAdoption;
    }
  }

  Widget _actionButtons() {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Clear',
            style: UITextStyle.body_16_medium,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ButtonWidget(
            height: 45.h,
            borderRadius: 10.r,
            title: 'Show results',
            titleStyle: UITextStyle.white_16_w600,
          ),
        ),
      ],
    );
  }
}
