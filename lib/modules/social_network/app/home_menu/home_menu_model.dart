import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/explore/explore_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/newfeed_widget.dart';
import 'package:meowoof/modules/social_network/app/notification/notification_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/usecases/notification/count_notification_unread_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/notification/read_all_notification_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class HomeMenuWidgetModel extends BaseViewModel {
  List<Widget> listScreen = [
    NewFeedWidget(),
    ExploreWidget(),
    NotificationWidget(),
    UserProfile(),
  ];
  late TabController tabController;
  final RxInt _currentTab = RxInt(0);
  final RxInt _countUnreadNotify = RxInt(0);
  final CountNotificationUnreadUsecase _countNotificationUnreadUsecase;
  final ReadAllNotificationUsecase _allNotificationUsecase;
  final ToastService toastService;
  DateTime? currentBackPressTime;
  DateTime? now;

  HomeMenuWidgetModel(
    this._countNotificationUnreadUsecase,
    this._allNotificationUsecase,
    this.toastService,
  );

  late Timer _timer;

  @override
  void initState() {
    getNumberNotificationUnread();
    _timer = Timer.periodic(
        const Duration(seconds: 10), (_) => getNumberNotificationUnread());
    super.initState();
  }

  Future<bool> onWillPop() {
    now = DateTime.now();
    if (currentBackPressTime == null ||
        now!.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastService.error(
          message: LocaleKeys.system_press_to_exit.trans(),
          context: Get.context!);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future getNumberNotificationUnread() async {
    if (currentTab == 2) return;
    try {
      countUnreadNotify = await _countNotificationUnreadUsecase.run();
    } catch (er) {
      printError(info: er.toString());
    }
  }

  void readAllNotify() {
    call(
      () async => countUnreadNotify = await _allNotificationUsecase.run() ?? 0,
      showLoading: false,
    );
  }

  void onTabChange(int index) {
    if (currentTab == index) return;
    currentTab = index;
    tabController.index = index;
    if (index == 2) {
      readAllNotify();
    }
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
    listScreen.clear();
    super.disposeState();
  }
}
