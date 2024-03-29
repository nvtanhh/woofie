import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile_model.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/detail_info_pet/detail_info_pet_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/pet_info_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/posts_of_pet_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class PetProfile extends StatefulWidget {
  final Pet pet;
  final bool? isMyPet;

  const PetProfile({super.key, required this.pet, this.isMyPet});

  @override
  _PetProfileState createState() => _PetProfileState();
}

class _PetProfileState extends BaseViewState<PetProfile, PetProfileModel>
    with TickerProviderStateMixin {
  @override
  void loadArguments() {
    viewModel.pet = widget.pet;
    viewModel.isMyPet = widget.isMyPet;
    viewModel.tabController = TabController(length: 2, vsync: this);
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const MWIcon(MWIcons.back),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: viewModel.onRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PetInfoWidget(
                    pet: viewModel.pet.updateSubjectValue,
                    isMyPet: viewModel.isMyPet ?? false,
                    onPetBlock: viewModel.onPetBlock,
                    followPet: viewModel.followPet,
                    onPetReport: viewModel.onPetReport,
                    onDeletePost: viewModel.onDeletePost,
                  ),
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          LocaleKeys.profile_information.trans(),
                          style: UITextStyle.text_body_14_w600,
                        ),
                      ),
                      Tab(
                        child: Text(
                          LocaleKeys.profile_post.trans(),
                          style: UITextStyle.text_body_14_w600,
                        ),
                      )
                    ],
                    indicatorColor: UIColor.primary,
                    controller: viewModel.tabController,
                    onTap: viewModel.onTabChange,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: Get.height * 0.8,
                    child: TabBarView(
                      controller: viewModel.tabController,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        DetailInfoPetWidget(
                          pet: viewModel.pet.updateSubjectValue,
                          isMyPet: viewModel.isMyPet ?? false,
                          onAddVaccinatedClick: viewModel.onAddVaccinatedClick,
                          onAddWeightClick: viewModel.onAddWeightClick,
                          onAddWormFlushedClick:
                              viewModel.onAddWormFlushedClick,
                        ),
                        PostsOfPetWidget(
                          idPet: viewModel.pet.updateSubjectValue.id,
                          controller: viewModel.postsOfPetWidgetController,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  PetProfileModel createViewModel() => injector<PetProfileModel>();
}
