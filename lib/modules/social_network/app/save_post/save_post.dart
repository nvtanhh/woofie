import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/widgets/post_locatior.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post_model.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/jumping_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/media_button.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/post_type_choose.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class CreatePost extends StatefulWidget {
  final Post? post;

  const CreatePost({super.key, this.post});

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends BaseViewState<CreatePost, SavePostModel> {
  @override
  SavePostModel createViewModel() => injector<SavePostModel>();

  @override
  void loadArguments() {
    viewModel.post = widget.post;
    viewModel.isPostEditing = widget.post != null;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                _buildPostIdentifier(),
                Expanded(
                  child: TextField(
                    controller: viewModel.contentController,
                    scrollPhysics: const BouncingScrollPhysics(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 20.h, top: 10.h),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText:
                          LocaleKeys.save_post_content_placeholder.trans(),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: UITextStyle.body_15_reg,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              bottom: 300.h - MediaQuery.of(context).viewInsets.bottom,),
          child: _mediaWrapper(),
        ),
      ],
    );
  }

  Widget _mediaWrapper() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: 1.sw,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MediaButton(onMediasPicked: viewModel.onMediasPicked),
            Obx(
              () => viewModel.addedMediaFiles.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: viewModel.addedMediaFiles
                          .map(
                            (file) => MediaButton(
                              key: ObjectKey(file),
                              mediaFile: file,
                              onRemove: () => viewModel.onRemoveMedia(file),
                              onImageEdited: (editedFile) =>
                                  viewModel.onImageEdited(file, editedFile),
                            ),
                          )
                          .toList(),
                    ),
            ),
            Obx(
              () => viewModel.postMedias.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: viewModel.postMedias
                          .map(
                            (media) => MediaButton(
                              key: ObjectKey(media),
                              postMedia: media,
                              onRemove: () =>
                                  viewModel.onRemovePostMedia(media),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: InkWell(
        onTap: () => Get.back(),
        child: const MWIcon(
          MWIcons.back,
          color: UIColor.textHeader,
        ),
      ),
      title: Text(
        widget.post == null
            ? LocaleKeys.save_post_create_post.trans()
            : LocaleKeys.save_post_edit_post.trans(),
        style: UITextStyle.heading_18_semiBold,
      ),
      centerTitle: true,
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 16),
          alignment: Alignment.center,
          child: Center(
            child: Obx(
              () => MWButton(
                minWidth: 35.w,
                // padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                onPressed: viewModel.onWantsToContinue,
                isDisabled: viewModel.isDisable,
                borderRadius: BorderRadius.circular(5.r),
                textStyle: UITextStyle.heading_16_medium.apply(
                    color:
                        viewModel.isDisable ? UIColor.textBody : UIColor.white,),
                child: Text(
                  widget.post == null
                      ? LocaleKeys.save_post_post_action.trans()
                      : LocaleKeys.save_post_update_action.trans(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostIdentifier() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MWAvatar(
            avatarUrl: viewModel.user?.avatarUrl,
            borderRadius: 10.r,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Row(
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            text: viewModel.user?.name ?? "",
                            children: _buildPetTags(),
                            style: UITextStyle.heading_16_semiBold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (viewModel.taggedPets.isEmpty)
                        GestureDetector(
                          onTap: viewModel.onTagPet,
                          child: Row(
                            children: [
                              MWIcon(MWIcons.petTag, customSize: 20),
                              SizedBox(width: 5.w),
                              Text(
                                  LocaleKeys.save_post_tag_your_pet_text
                                      .trans(),
                                  style: UITextStyle.second_14_medium,),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Obx(
                    () => Row(
                      children: [
                        if (!viewModel.isPostEditing)
                          PostTypeChoseWidget(
                            onPostTypeChosen: viewModel.onPostTypeChosen,
                            chosenPostType: viewModel.postType,
                          )
                        else
                          _buildPostTypeWidget(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildLocater(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildPetTags() {
    if (viewModel.taggedPets.isEmpty) return [];
    final List<InlineSpan> inLineSpan = [];
    inLineSpan.add(
      TextSpan(
          text: " ${LocaleKeys.new_feed_with.trans()} ",
          style: UITextStyle.heading_16_reg,),
    );
    for (var i = 0; i < viewModel.taggedPets.length; i++) {
      inLineSpan.add(
        TextSpan(
          text:
              "${viewModel.taggedPets[i].name}${i != viewModel.taggedPets.length - 1 ? ", " : " "}",
          style: UITextStyle.heading_16_semiBold,
          recognizer: TapGestureRecognizer()..onTap = viewModel.onTagPet,
        ),
      );
    }
    return inLineSpan;
  }

  Widget _buildLocater() {
    if (viewModel.postType == PostType.activity) return const SizedBox();

    return viewModel.isLoadingAddress.value
        ? _buildLoadingAddressWidget()
        : PostLocator(
            location: viewModel.currentAddress.value,
            maxLines: 2,
          );
  }

  Widget _buildLoadingAddressWidget() {
    return Row(children: [
      Transform.translate(
        offset: const Offset(0, 5),
        child: const JumpingWidget(
          child: MWIcon(
            MWIcons.location,
            themeColor: MWIconThemeColor.primary,
            customSize: 20,
          ),
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: Text(
          LocaleKeys.save_post_location_loading.trans(),
          style: UITextStyle.body_10_medium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],);
  }

  Widget _buildPostTypeWidget() {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
        border: Border.all(
          width: 0.5,
          color: PostTypeChoseWidget.getBoderColorByType(viewModel.postType),
        ),
        color: PostTypeChoseWidget.getBackgroundColorByType(viewModel.postType),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        child: Text(
          PostTypeChoseWidget.getPostTypeTile(viewModel.postType),
          style: UITextStyle.body_12_medium.apply(
            color: PostTypeChoseWidget.getTextColorByType(viewModel.postType),
          ),
        ),
      ),
    );
  }
}
