import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/helpers/datetime_helper.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button_widget.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget_model.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/widgets/card_detail_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/images_view_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_actions_popup.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class AdoptionPetDetailWidget extends StatefulWidget {
  final Post post;

  final VoidCallback? onDeletePost;
  final VoidCallback? onEditPost;
  final VoidCallback? onReportPost;

  const AdoptionPetDetailWidget({
    Key? key,
    required this.post,
    this.onDeletePost,
    this.onEditPost,
    this.onReportPost,
  }) : super(key: key);

  @override
  _AdoptionPetDetailState createState() => _AdoptionPetDetailState();
}

class _AdoptionPetDetailState extends BaseViewState<AdoptionPetDetailWidget,
    AdoptionPetDetailWidgetModel> {
  @override
  void loadArguments() {
    viewModel.post = widget.post;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return SizedBox(
            width: Get.width,
            height: Get.height,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ImagesViewWidget(
                  medias:
                      viewModel.post.updateSubjectValue.medias?.isEmpty ?? true
                          ? [
                              Media(
                                id: 0,
                                url: viewModel.taggedPet.avatarUrl ?? "",
                                type: MediaType.image,
                              )
                            ]
                          : viewModel.post.updateSubjectValue.medias!,
                  height: Get.height / 2,
                  fit: BoxFit.cover,
                  counterPositionTop: false,
                ),
                Positioned(
                  top: 24.h,
                  child: Container(
                    width: Get.width,
                    height: 50.h,
                    margin: EdgeInsets.only(top: 10.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonWidget(
                            onPress: () => Get.back(),
                            contentPadding: EdgeInsets.zero,
                            width: 40.w,
                            height: 40.w,
                            borderRadius: 20.w,
                            backgroundColor: UIColor.white,
                            contentWidget: const MWIcon(MWIcons.back),
                          ),
                          PostActionsTrailing(
                            post: viewModel.post.updateSubjectValue,
                            onDeletePost: widget.onDeletePost,
                            onEditPost: widget.onEditPost,
                            onReportPost: widget.onReportPost,
                            child: ButtonWidget(
                              contentPadding: EdgeInsets.zero,
                              width: 40.w,
                              height: 40.w,
                              borderRadius: 20.w,
                              backgroundColor: UIColor.white,
                              contentWidget: const MWIcon(MWIcons.moreHoriz),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: Get.height / 2 + 30.h,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: UIColor.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                      border: Border.all(color: UIColor.whiteSmoke),
                    ),
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 30.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap:
                                              viewModel.onWantsToGoToPetProfile,
                                          child: Text(
                                            viewModel.taggedPet.name ?? "",
                                            style:
                                                UITextStyle.text_header_24_w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.w,
                                        ),
                                        Row(
                                          children: [
                                            const MWIcon(
                                              MWIcons.location,
                                              color: UIColor.primary,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Flexible(
                                              child: Text(
                                                "${viewModel.post.updateSubjectValue.location?.name ?? ""} ${_getDistanceToPost()}",
                                                style: UITextStyle
                                                    .text_body_14_w500,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  MWIcon(
                                    defineIcon(widget.post.type),
                                    customSize: 48.w,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CardDetailWidget(
                                    title: LocaleKeys.explore_gender.trans(),
                                    value: FormatHelper.genderPet(
                                        viewModel.taggedPet.gender),
                                  ),
                                  CardDetailWidget(
                                    title: LocaleKeys.explore_age.trans(),
                                    value: DateTimeHelper.calcAge(
                                        viewModel.taggedPet.dob),
                                  ),
                                  CardDetailWidget(
                                    title: LocaleKeys.explore_breed.trans(),
                                    value: viewModel.taggedPet.petBreed?.name ??
                                        "",
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
                                child: SingleChildScrollView(
                                  child: Text(
                                    viewModel.post.updateSubjectValue.content ??
                                        "",
                                    style: UITextStyle.text_body_14_w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (viewModel.post.updateSubjectValue.isClosed ?? false)
                          _buildClosedPostButton()
                        else if (!viewModel.post.updateSubjectValue.isMyPost)
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(),
                            leading: MWAvatar(
                              avatarUrl: viewModel.post.updateSubjectValue
                                      .creator?.avatarUrl ??
                                  '',
                              borderRadius: 10.r,
                              onPressed: () =>
                                  viewModel.onWantsToGoToUserProfile(),
                            ),
                            title: Text(
                              viewModel.post.updateSubjectValue.creator?.name ??
                                  "",
                              style: UITextStyle.text_header_16_w6002,
                            ),
                            subtitle: Text(
                              LocaleKeys.explore_owner_pet.trans(),
                              style: GoogleFonts.montserrat(
                                  textStyle: UITextStyle.text_body_14_w500),
                            ),
                            trailing: SizedBox(
                              width: 96.w,
                              height: 47.h,
                              child: ButtonWidget(
                                title: LocaleKeys.explore_contact.trans(),
                                borderRadius: 15.r,
                                onPress: viewModel.onWantsToContact,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: ButtonWidget(
                              width: double.infinity,
                              height: 47.h,
                              title: _getActionButtonTitleSelf(
                                  viewModel.post.updateSubjectValue),
                              onPress: viewModel.onConfirmFuntionalPost,
                              borderRadius: 15.r,
                              backgroundColor: _getActionButtonColor(
                                  viewModel.post.updateSubjectValue),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  @override
  AdoptionPetDetailWidgetModel createViewModel() =>
      injector<AdoptionPetDetailWidgetModel>();

  String _getActionButtonTitleSelf(Post post) {
    switch (post.type) {
      case PostType.adop:
        return 'Xác nhận cho';
      case PostType.mating:
        return 'Xác nhận ghép đôi';
      case PostType.lose:
        return 'Đã tìm thấy';
      case PostType.activity:
        throw Exception("Unsupport post type");
    }
  }

  Color _getActionButtonColor(Post post) {
    switch (post.type) {
      case PostType.adop:
        return UIColor.adoptionColor;
      case PostType.mating:
        return UIColor.matingColor;
      case PostType.lose:
        return UIColor.accent2;
      case PostType.activity:
        throw Exception("Unsupport post type");
    }
  }

  Widget _buildClosedPostButton() {
    if (viewModel.post.type == PostType.adop && viewModel.adopter != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: ButtonWidget(
          width: double.infinity,
          contentWidget: Text.rich(
            TextSpan(
              text: 'Đã được nhận nuôi bởi ',
              children: [
                TextSpan(
                  text: viewModel.adopter!.name,
                  style: UITextStyle.text_header_16_w700.apply(
                    color: _getActionButtonColor(viewModel.post),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => viewModel.openProfileAdopter(),
                )
              ],
              style: UITextStyle.white_16_w500.apply(
                color: _getActionButtonColor(viewModel.post),
              ),
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          borderRadius: 15.r,
          backgroundColor:
              _getActionButtonColor(viewModel.post).withOpacity(.3),
        ),
      );
    } else if (viewModel.post.type == PostType.mating &&
        viewModel.matedPet != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: ButtonWidget(
          width: double.infinity,
          contentWidget: Text.rich(
            TextSpan(
              text: 'Đã ghép đôi với ',
              children: [
                TextSpan(
                  text: viewModel.matedPet!.name,
                  style: UITextStyle.text_header_16_w700.apply(
                    color: _getActionButtonColor(viewModel.post),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => viewModel.openProfileMatedPet(),
                )
              ],
              style: UITextStyle.white_16_w500.apply(
                color: _getActionButtonColor(viewModel.post),
              ),
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          borderRadius: 15.r,
          backgroundColor:
              _getActionButtonColor(viewModel.post).withOpacity(.3),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: ButtonWidget(
        width: double.infinity,
        height: 47.h,
        title: 'Bài viết đã đóng',
        titleStyle: UITextStyle.white_16_w500,
        borderRadius: 15.r,
        backgroundColor: UIColor.textSecondary,
      ),
    );
  }

  String _getDistanceToPost() {
    if (viewModel.post.updateSubjectValue.distanceUserToPost == null) {
      return '';
    }
    return '(${viewModel.post.updateSubjectValue.distanceUserToPost?.toPrecision(1)} Km)';
  }
}
