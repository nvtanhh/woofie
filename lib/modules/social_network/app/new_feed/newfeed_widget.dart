import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/app_logo.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/newfeed_widget_model.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/icon.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class NewFeedWidget extends StatefulWidget {
  @override
  _NewFeedWidgetState createState() => _NewFeedWidgetState();
}

class _NewFeedWidgetState
    extends BaseViewState<NewFeedWidget, NewFeedWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // padding: EdgeInsets.only(
      //   top: 10.h,
      //   left: 16.w,
      //   right: 16.w,
      // ),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            // child: Obx(
            //   () => ListView.builder(
            //     padding: EdgeInsets.only(top: 15.h),
            //     itemCount: viewModel.posts.length,
            //     itemBuilder: (context, index) {
            //       return PostItemInListView(
            //         post: viewModel.posts[index],
            //         onCommentClick: viewModel.onCommentClick,
            //         onLikeClick: viewModel.onLikeClick,
            //         onPostClick: viewModel.onPostClick,
            //       );
            //     },
            //   ),
            // ),
            child: PagedListView<int, Post>(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                itemBuilder: (context, item, index) => PostItem(
                  post: item,
                  onCommentClick: viewModel.onCommentClick,
                  onLikeClick: viewModel.onLikeClick,
                  onPostClick: viewModel.onPostClick,
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
      preferredSize: Size.fromHeight(46.h),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(width: 45.w, height: 45.h, child: const MWLogo()),
            SizedBox(
              width: 10.w,
            ),
            Text(
              LocaleKeys.app_name.trans(),
              style: GoogleFonts.montserrat(
                  textStyle: UITextStyle.text_header_24_w700),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            InkWell(
              onTap: () {},
              child: MWIcon(MWIcons.add),
            ),
            SizedBox(
              width: 16.w,
            ),
            InkWell(
              onTap: () {},
              child: const MWIcon(
                MWIcons.message,
                customSize: 28,
                color: UIColor.text_header,
              ),
            )
          ],
        ),
      ),
    );
  }
}
