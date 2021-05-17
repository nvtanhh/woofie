import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/newfeed_widget_model.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post_item_in_listview.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class NewFeedWidget extends StatefulWidget {
  @override
  _NewFeedWidgetState createState() => _NewFeedWidgetState();
}

class _NewFeedWidgetState extends BaseViewState<NewFeedWidget, NewFeedWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 45.h,
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: UIColor.primary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  LocaleKeys.app_name.trans(),
                  style: UITextStyle.text_header_18_w700,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                InkWell(
                  onTap: () => null,
                  child: Assets.resources.icons.icAddPost.image(
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                InkWell(
                  onTap: () => null,
                  child: Assets.resources.icons.icMessage.image(
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.fill,
                  ),
                )
              ],
            ),
          ),
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
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Post>(
                itemBuilder: (context, item, index) => PostItemInListView(
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
}
