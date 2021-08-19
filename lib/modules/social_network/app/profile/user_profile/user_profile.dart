import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/commons/shimmer_page.dart';
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

class _UserProfileState extends BaseViewState<UserProfile, UserProfileModel>
    with AutomaticKeepAliveClientMixin {
  @override
  void loadArguments() {
    viewModel.user = widget.user;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                    children: viewModel.postService.prependedWidgets.toList()),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => viewModel.onRefresh(),
                  child: PagedListView<int, Post>(
                    pagingController: viewModel.postService.pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, post, index) {
                        if (index == 0) {
                          return InfoUserWidget(
                            user: viewModel.user!,
                            onFollowPet: viewModel.onFollowPet,
                            isMe: viewModel.isMe,
                            onUserBlock: viewModel.onUserBlock,
                            onUserReport: viewModel.onUserReport,
                            onWantsToContact: viewModel.onWantsToContact,
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: PostItem(
                            post: post,
                            onLikeClick: viewModel.postService.onLikeClick,
                            onEditPost: () =>
                                viewModel.postService.onWantsToEditPost(post),
                            onDeletePost: () => viewModel.postService
                                .onWantsToDeletePost(post, index),
                            onCommentClick:
                                viewModel.postService.onCommentClick,
                            onPostClick: viewModel.postService.onPostClick,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        endDrawer: Setting(),
      ),
    );
  }

  @override
  UserProfileModel createViewModel() => injector<UserProfileModel>();

  @override
  bool get wantKeepAlive => true;
}
