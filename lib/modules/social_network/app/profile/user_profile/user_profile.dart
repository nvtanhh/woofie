import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post_item.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile_model.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/widgets/info_user_widget.dart';
import 'package:meowoof/modules/social_network/app/setting/setting.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

class UserProfile extends StatefulWidget {
  final User? user;

  final UserProfileController? controller;

  const UserProfile({super.key, this.user, this.controller});

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends BaseViewState<UserProfile, UserProfileModel>
    with AutomaticKeepAliveClientMixin {
  late bool _isFirstRoute;

  @override
  void loadArguments() {
    viewModel.user = widget.user;
    widget.controller?.attach(context: context, state: this);
    super.loadArguments();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _isFirstRoute = Navigator.canPop(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        appBar: AppBar(
          leading: _isFirstRoute
              ? IconButton(
                  onPressed: () => Get.back(),
                  icon: const MWIcon(MWIcons.back),
                )
              : const SizedBox(),
          actions: [
            if (!_isFirstRoute)
              Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: MWIcon(
                    MWIcons.drawer,
                    customSize: 28.h,
                    color: UIColor.textHeader,
                  ),
                ),
              )
            else
              const SizedBox(),
          ],
        ),
        body: Obx(
          () => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: viewModel.postService.prependedWidgets.toList(),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => viewModel.onRefresh(),
                  child: PagedListView<int, Post>(
                    pagingController: viewModel.postService.pagingController,
                    scrollController: viewModel.scrollController,
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

  void scrollToTop() {
    viewModel.scrollToTop();
  }
}

class UserProfileController {
  late UserProfileState _state;
  void attach(
      {required BuildContext context, required UserProfileState state,}) {
    _state = state;
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
