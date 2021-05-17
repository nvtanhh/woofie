import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/modules/social_network/app/new_feed/newfeed_widget.dart';
import 'package:suga_core/suga_core.dart';

class HomeMenuWidgetModel extends BaseViewModel {
  List<Widget> listScreen = [
    NewFeedWidget(),
  ];
  late TabController tabController;
  final RxInt _currentTab = RxInt(0);

  void onTabChange(int index) {
    if (currentTab == index) return;
    currentTab = index;
    tabController.index = index;
  }

  int get currentTab => _currentTab.value;

  set currentTab(int value) {
    _currentTab.value = value;
  }
}
