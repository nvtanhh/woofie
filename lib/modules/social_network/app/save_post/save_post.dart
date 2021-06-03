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
import 'package:meowoof/modules/social_network/app/save_post/widgets/media_button.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

import 'save_post_model.dart';
import 'widgets/jumping_widget.dart';
import 'widgets/post_type_choose.dart';

class CreatePost extends StatefulWidget {
  final Post? post;

  const CreatePost({Key? key, this.post}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends BaseViewState<CreatePost, SavePostModel> {
  @override
  SavePostModel createViewModel() => injector<SavePostModel>();

  @override
  void loadArguments() {
    viewModel.post = widget.post;
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
                _buildPostIdentifer(),
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
                      hintText: "What's on your mind...",
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: UITextStyle.body_14_reg,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 300.h - MediaQuery.of(context).viewInsets.bottom),
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
              () => viewModel.files.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: viewModel.files
                          .map((file) => MediaButton(
                                key: ObjectKey(file),
                                mediaFile: file,
                                onRemove: () => viewModel.onRemoveMedia(file),
                                onImageEdited: (editedFile) => viewModel.onImageEdited(file, editedFile),
                              ))
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
        widget.post == null ? "Create Post" : 'Edit Post',
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
                onPressed: () {},
                isDisabled: viewModel.isDisable,
                borderRadius: BorderRadius.circular(5.r),
                textStyle: UITextStyle.heading_16_medium.apply(color: viewModel.isDisable ? UIColor.textBody : UIColor.white),
                child: Text(
                  widget.post == null ? 'Post' : 'Update',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostIdentifer() {
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
                      Text.rich(
                        TextSpan(
                          text: viewModel.user?.name ?? "",
                          children: _buildPetTags(),
                          style: UITextStyle.heading_16_semiBold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 10),
                      if (viewModel.taggedPets.isEmpty)
                        GestureDetector(
                          onTap: viewModel.onTagPet,
                          child: Row(
                            children: [
                              MWIcon(MWIcons.petTag, customSize: 20),
                              SizedBox(width: 5.w),
                              Text('Tag your pet', style: UITextStyle.second_14_medium),
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
                        PostTypeChoseWidget(
                          onPostTypeChosen: viewModel.onPostTypeChosen,
                          chosenPostType: viewModel.postType,
                        ),
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
      TextSpan(text: " ${LocaleKeys.new_feed_with.trans()} ", style: UITextStyle.heading_16_reg),
    );
    for (var i = 0; i < viewModel.taggedPets.length; i++) {
      inLineSpan.add(
        TextSpan(
          text: "${viewModel.taggedPets[i].name}${i != viewModel.taggedPets.length - 1 ? ", " : " "}",
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
        : viewModel.currentAdress.value.isNotEmpty
            ? Row(children: [
                const MWIcon(
                  MWIcons.location,
                  themeColor: MWIconThemeColor.primary,
                  customSize: 20,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    viewModel.currentAdress.value,
                    style: UITextStyle.body_10_medium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ])
            : const SizedBox();
  }

  Widget _buildLoadingAddressWidget() {
    return Row(children: [
      const JumpingWidget(
        child: MWIcon(
          MWIcons.location,
          themeColor: MWIconThemeColor.primary,
          customSize: 20,
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: Text(
          'Loading your address...',
          style: UITextStyle.body_10_medium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}
