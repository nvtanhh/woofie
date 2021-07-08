import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/explore/explore_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/newfeed_widget.dart';
import 'package:meowoof/modules/social_network/app/notification/notification_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/usecases/notification/count_notification_unread_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class HomeMenuWidgetModel extends BaseViewModel {
  List<Widget> listScreen = [NewFeedWidget(), ExploreWidget(), NotificationWidget(), const UserProfile()];
  late TabController tabController;
  final RxInt _currentTab = RxInt(0);
  final RxInt _countUnreadNotify = RxInt(0);
  final CountNotificationUnreadUsecase _countNotificationUnreadUsecase;

  HomeMenuWidgetModel(this._countNotificationUnreadUsecase);

  late Timer _timer;

  @override
  void initState() {
    getNumberNotificationUnread();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => getNumberNotificationUnread());
    super.initState();
  }

  Future getNumberNotificationUnread() async {
    try {
      countUnreadNotify = await _countNotificationUnreadUsecase.run();
    } catch (er) {
      printError(info: er.toString());
    }
  }

  void onTabChange(int index) {
    if (currentTab == index) return;
    currentTab = index;
    tabController.index = index;
  }

  int get currentTab => _currentTab.value;

  set currentTab(int value) {
    _currentTab.value = value;
  }

  int get countUnreadNotify => _countUnreadNotify.value;

  set countUnreadNotify(int value) {
    _countUnreadNotify.value = value;
  }

  @override
  void disposeState() {
    _timer.cancel();
    super.disposeState();
  }
}
