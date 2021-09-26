import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/core/ui/search_bar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/search_widget_model.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/widgets/pets_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/widgets/services_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/widgets/users_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class SearchWidget extends StatefulWidget {
  final String? textSearch;
  final UserLocation userLocation;
  const SearchWidget({Key? key, this.textSearch,required this.userLocation}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends BaseViewState<SearchWidget, SearchWidgetModel> with TickerProviderStateMixin {
  @override
  void loadArguments() {
    viewModel.tabController = TabController(
      length: 3,
      vsync: this,
    );
    viewModel.keyWord = widget.textSearch;
    viewModel.userLocation= widget.userLocation;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const MWIcon(MWIcons.back),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: MWSearchBar(
                      textInit: widget.textSearch,
                      onSearch: viewModel.onSearch,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: UIColor.primary,
                      tabs: [
                        Tab(
                          child: Text(
                            LocaleKeys.explore_user.trans(),
                            style: UITextStyle.text_header_14_w600,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        Tab(
                          child: Text(
                            LocaleKeys.explore_pet.trans(),
                            style: UITextStyle.text_header_14_w600,
                          ),
                        ),
                        Tab(
                          child: Text(
                            LocaleKeys.explore_service.trans(),
                            style: UITextStyle.text_header_14_w600,
                          ),
                        ),
                      ],
                      controller: viewModel.tabController,
                      onTap: (index) => viewModel.onTab(index),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
                        child: TabBarView(
                          controller: viewModel.tabController,
                          children: [
                            UsersWidget(pagingController: viewModel.userPagingController),
                            PetsWidget(
                              pagingController: viewModel.petPagingController,
                              follow: viewModel.followPet,
                            ),
                            ServicesWidget(
                              pagingController: viewModel.servicePagingController,
                              userLocation: viewModel.userLocation,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  SearchWidgetModel createViewModel() => injector<SearchWidgetModel>();
}
