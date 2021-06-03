import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/search_bar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/search_widget_model.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/widgets/pets_widget.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/widgets/services_widget.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class SearchWidget extends StatefulWidget {
  final String? textSearch;

  const SearchWidget({Key? key, this.textSearch}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends BaseViewState<SearchWidget, SearchWidgetModel> with TickerProviderStateMixin {
  @override
  void loadArguments() {
    viewModel.tabController = TabController(
      length: 2,
      vsync: this,
    );
    viewModel.keyWord = widget.textSearch;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MWSearchBar(
                textInit: widget.textSearch,
                onSearch: viewModel.onSearch,
              ),
              TabBar(
                tabs: [
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
                child: TabBarView(
                  controller: viewModel.tabController,
                  children: [
                    PetsWidget(
                      pagingController: viewModel.petPagingController,
                      follow: viewModel.followPet,
                    ),
                    ServicesWidget(pagingController: viewModel.servicePagingController),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  SearchWidgetModel createViewModel() => injector<SearchWidgetModel>();
}
