import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/adoption_widget_model.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/widgets/pet_item_shimmer_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/widgets/pet_item_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class AdoptionWidget extends StatefulWidget {
  @override
  _AdoptionWidgetState createState() => _AdoptionWidgetState();
}

class _AdoptionWidgetState extends BaseViewState<AdoptionWidget, AdoptionWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: UIColor.white,
          elevation: 0,
          title: Text(
            LocaleKeys.explore_adoption.trans(),
            style: UITextStyle.text_header_18_w600,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: UIColor.textHeader,
              size: 20.w,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PagedGridView<int, Post>(
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Post>(
                  itemBuilder: (context, item, index) {
                    return PetItemWidget(
                      pet: item.pets![0],
                      onClick: () => viewModel.onItemClick(item),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PetItemShimmerWidget(),
                      PetItemShimmerWidget(),
                    ],
                  ),
                  newPageProgressIndicatorBuilder: (_) => PetItemShimmerWidget(),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 165.w / 213.h,
                ),
                padding: EdgeInsets.only(
                  top: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AdoptionWidgetModel createViewModel() => injector<AdoptionWidgetModel>();
}
