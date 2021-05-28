import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/media_button.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/media_file.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/button.dart';
import 'package:meowoof/theme/icon.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

import 'save_post_model.dart';
import 'widgets/post_type_choose.dart';

class CreatePost extends StatefulWidget {
  final Post? post;
  const CreatePost({Key? key, this.post}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends BaseViewState<CreatePost, SavePostModel> {
  final TextEditingController _contentController = TextEditingController();
  late User _user;
  late final Rx<PostType> _postType = PostType.activity.obs;
  final RxList<MediaFile> _files = <MediaFile>[].obs;
  final RxBool _isDisable = true.obs;
  final RxList<Pet> _taggedPets = <Pet>[].obs;

  @override
  void initState() {
    super.initState();
    try {
      _user = widget.post != null ? widget.post!.creator : injector<LoggedInUser>().loggedInUser;
    } catch (error) {
      _user = User(
        id: 7,
        name: 'Tanh Nguyen',
        avatarUrl:
            'https://scontent.fhan2-3.fna.fbcdn.net/v/t1.6435-9/162354720_1147808662336518_1297648803267744126_n.jpg?_nc_cat=108&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=P68qZDEZZXIAX826eFN&_nc_ht=scontent.fhan2-3.fna&oh=e10ef4fe2b17089b3f9071aa6d611366&oe=60CEC5D6',
        pets: [
          Pet(name: "Vàng", avatar: 'https://p0.pikist.com/photos/657/191/cat-animal-eyes-kitten-head-cute-nature-predator-look-feline.jpg'),
          Pet(name: "Đỏ", avatar: 'https://p0.pikist.com/photos/389/595/animal-cat-cute-domestic-eyes-face-feline-fur-head.jpg'),
        ],
      );
    }
    _postType.value = widget.post != null ? widget.post!.type : PostType.activity;

    _contentController.addListener(_onTextChanged);
    _files.stream.listen(_onFilesChanged);
    _taggedPets.addAll(_user.pets ?? []);
  }

  @override
  SavePostModel createViewModel() => injector<SavePostModel>();
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
                    controller: _contentController,
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
            MediaButton(onMediasPicked: _onMediasPicked),
            Obx(
              () => _files.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: _files
                          .map((file) => MediaButton(
                                key: ObjectKey(file),
                                mediaFile: file,
                                onRemove: () => _onRemoveMedia(file),
                                onImageEdited: (editedFile) => _onImageEdited(file, editedFile),
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
          color: UIColor.text_header,
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
                isDisabled: _isDisable.value,
                borderRadius: BorderRadius.circular(5.r),
                textStyle: UITextStyle.heading_16_medium.apply(color: _isDisable.value ? UIColor.text_body : UIColor.white),
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
            avatarUrl: _user.avatarUrl,
            borderRadius: 10.r,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text.rich(
                    TextSpan(
                      text: _user.name,
                      children: _buildPetTags(),
                      style: UITextStyle.heading_16_semiBold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Row(
                    children: [
                      Obx(
                        () => PostTypeChoseWidget(
                          onPostTypeChosen: onPostTypeChosen,
                          chosenPostType: _postType.value,
                        ),
                      ),
                    ],
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
    if (_taggedPets.isEmpty) return [];
    final List<InlineSpan> inLineSpan = [];
    inLineSpan.add(
      TextSpan(text: " ${LocaleKeys.new_feed_with.trans()} ", style: UITextStyle.heading_16_reg),
    );
    for (var i = 0; i < _taggedPets.length; i++) {
      inLineSpan.add(
        TextSpan(
          text: "${_taggedPets[i].name}${i != _taggedPets.length - 1 ? ", " : " "}",
          style: UITextStyle.heading_16_semiBold,
        ),
      );
    }
    return inLineSpan;
  }

  Future<void> onPostTypeChosen(PostType chosenType) async {
    _postType.value = chosenType;
  }

  Future _onMediasPicked(List<MediaFile> pickedFiles) async {
    _files.addAll(pickedFiles);
  }

  Future _onRemoveMedia(MediaFile file) async {
    _files.remove(file);
  }

  void _onTextChanged() {
    if (_contentController.text.isNotEmpty || _files.isNotEmpty) {
      _isDisable.value = false;
    } else {
      _isDisable.value = true;
    }
  }

  void _onFilesChanged(List<MediaFile>? event) {
    if ((event != null && event.isNotEmpty) || _contentController.text.isNotEmpty) {
      _isDisable.value = false;
    } else {
      _isDisable.value = true;
    }
  }

  void _onImageEdited(MediaFile oldFile, MediaFile editedFile) {
    final index = _files.indexOf(oldFile);
    _files.removeAt(index);
    _files.insert(index, editedFile);
  }
}
