import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu_model.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

class HomeMenuWidget extends StatefulWidget {
  @override
  _HomeMenuWidgetState createState() => _HomeMenuWidgetState();
}

class _HomeMenuWidgetState extends BaseViewState<HomeMenuWidget, HomeMenuWidgetModel> with TickerProviderStateMixin {
  @override
  void loadArguments() {
    viewModel.tabController = TabController(
      length: viewModel.listScreen.length,
      vsync: this,
      initialIndex: viewModel.currentTab,
    );
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          controller: viewModel.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: viewModel.listScreen,
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: viewModel.currentTab,
            onTap: viewModel.onTabChange,
            backgroundColor: UIColor.white,
            iconSize: 30.w,
            selectedItemColor: UIColor.primary,
            unselectedItemColor: UIColor.text_secondary,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_filled,
                    size: 30.w,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_sharp,
                    size: 30.w,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications,
                    size: 30.w,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 30.w,
                  ),
                  label: ""),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeMenuWidgetModel createViewModel() => HomeMenuWidgetModel();
}
