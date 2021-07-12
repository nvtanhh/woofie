import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post_item.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile_model.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/widgets/info_user_widget.dart';
import 'package:meowoof/modules/social_network/app/setting/setting.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

class UserProfile extends StatefulWidget {
  final User? user;

  const UserProfile({Key? key, this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends BaseViewState<UserProfile, UserProfileModel> {
  @override
  void loadArguments() {
    viewModel.user = widget.user;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            InfoUserWidget(
              user: viewModel.user!,
              onFollowPet: viewModel.onFollowPet,
              isMe: viewModel.isMe,
              onUserBlock: viewModel.onUserBlock,
              onUserReport: viewModel.onUserReport,
            ),
            Obx(
              () => (viewModel.isLoaded)
                  ? PagedListView<int, Post>(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      pagingController: viewModel.pagingController,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, post, index) {
                          return PostItem(
                            post: post.updateSubjectValue,
                            onLikeClick: viewModel.onLikeClick,
                            onEditPost: () => viewModel.onPostEdited(post),
                            onDeletePost: () =>
                                viewModel.onPostDeleted(post, index),
                            onCommentClick: viewModel.onCommentClick,
                            onPostClick: viewModel.onPostClick,
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Setting(),
      ),
    );
  }

  @override
  UserProfileModel createViewModel() => injector<UserProfileModel>();
}
