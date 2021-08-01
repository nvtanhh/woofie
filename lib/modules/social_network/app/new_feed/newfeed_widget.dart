import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/app_logo.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/newfeed_widget_model.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post_item.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class NewFeedWidget extends StatefulWidget {
  @override
  _NewFeedWidgetState createState() => _NewFeedWidgetState();
}

class _NewFeedWidgetState
    extends BaseViewState<NewFeedWidget, NewFeedWidgetModel>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Obx(
            () =>
                Column(children: viewModel.postService.prependedWidgets.value),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: viewModel.onRefresh,
              child: PagedListView<int, Post>(
                scrollController: viewModel.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                pagingController: viewModel.postService.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Post>(
                  itemBuilder: (context, item, index) => Obx(
                    () => PostItem(
                      post: item.updateSubjectValue,
                      onCommentClick: viewModel.postService.onCommentClick,
                      onLikeClick: viewModel.postService.onLikeClick,
                      onPostClick: viewModel.postService.onPostClick,
                      onDeletePost: () =>
                          viewModel.postService.onPostDeleted(index),
                      onEditPost: () =>
                          viewModel.postService.onWantsToEditPost(item),
                      onReportPost: () =>
                          viewModel.postService.onReportPost(item),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  NewFeedWidgetModel createViewModel() => injector<NewFeedWidgetModel>();

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: viewModel.onRefresh,
              child: Row(
                children: [
                  SizedBox(width: 45.w, height: 46.h, child: const MWLogo()),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    LocaleKeys.app_name.trans(),
                    style: GoogleFonts.montserrat(
                        textStyle: UITextStyle.text_header_24_w700),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            InkWell(
              onTap: viewModel.postService.onWantsToCreateNewPost,
              child: MWIcon(MWIcons.add),
            ),
            SizedBox(
              width: 16.w,
            ),
            GestureDetector(
              onTap: viewModel.onWantsToGoToChat,
              child: MWIcon(
                MWIcons.message,
                customSize: 28,
                color: UIColor.textHeader,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
