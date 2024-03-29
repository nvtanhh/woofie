import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu_model.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class HomeMenuWidget extends StatefulWidget {
  @override
  _HomeMenuWidgetState createState() => _HomeMenuWidgetState();
}

class _HomeMenuWidgetState
    extends BaseViewState<HomeMenuWidget, HomeMenuWidgetModel>
    with TickerProviderStateMixin {
  @override
  void loadArguments() {
    viewModel.tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: viewModel.currentTab,
    );
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: viewModel.onWillPop,
          child: TabBarView(
            controller: viewModel.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: viewModel.listScreen,
          ),
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Obx(
          () => DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: UIColor.textSecondary,
                  blurRadius: 10,
                  offset: Offset(-2, 0),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: BottomNavigationBar(
                currentIndex: viewModel.currentTab,
                onTap: viewModel.onTabChange,
                backgroundColor: UIColor.white,
                iconSize: 28.w,
                selectedItemColor: UIColor.primary,
                unselectedItemColor: UIColor.textSecondary,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 0,
                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home_filled,
                      ),
                      label: "",),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.search_sharp,
                      ),
                      label: "",),
                  BottomNavigationBarItem(
                      icon: Obx(
                        () {
                          if (viewModel.countUnreadNotify > 0) {
                            return badgeNotification();
                          } else {
                            return const Icon(
                              Icons.notifications,
                            );
                          }
                        },
                      ),
                      label: "",),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                      ),
                      label: "",),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget badgeNotification() {
    return Stack(
      children: [
        Icon(
          Icons.notifications,
          size: 28.w,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 20.w,
            decoration: BoxDecoration(
                color: UIColor.danger,
                borderRadius: BorderRadius.circular(10.r),),
            child: Center(
              child: Text(
                "${viewModel.countUnreadNotify}",
                style: UITextStyle.white_16_w500,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  HomeMenuWidgetModel createViewModel() => injector<HomeMenuWidgetModel>();
}
