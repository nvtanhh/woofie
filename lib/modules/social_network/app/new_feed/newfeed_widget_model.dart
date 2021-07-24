import 'dart:async';

import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/post_service.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class NewFeedWidgetModel extends BaseViewModel {
  final BottomSheetService bottomSheetService = injector<BottomSheetService>();
  final GetPostsUsecase _getPostsUsecase;
  final PostService postService;

  List<Post> posts = [];
  final int pageSize = 10;
  int nextPageKey = 0;
  DateTime? dateTimeValueLast;
  CancelableOperation? cancelableOperation;

  late DateTime _lastRefeshTime;

  static const int _refreshIntervalLimitSecond = 3;

  NewFeedWidgetModel(
    this._getPostsUsecase,
    this.postService,
  );

  @override
  void disposeState() {
    cancelableOperation?.cancel();
    postService.disposeState();
    super.disposeState();
  }

  void getPosts() {
    call(
      () async => posts = await _getPostsUsecase.call(),
    );
  }

  @override
  void initState() {
    postService.initState();
    super.initState();
    postService.pagingController.addPageRequestListener(
      (pageKey) {
        cancelableOperation = CancelableOperation.fromFuture(_loadMorePost(pageKey));
      },
    );
    _lastRefeshTime = DateTime.now();
  }

  Future _loadMorePost(int pageKey) async {
    try {
      final newItems = await _getPostsUsecase.call(offset: nextPageKey, lastValue: dateTimeValueLast);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        postService.pagingController.appendLastPage(newItems);
      } else {
        nextPageKey = pageKey + newItems.length;
        dateTimeValueLast = newItems.last.createdAt;
        postService.pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      postService.pagingController.error = error;
    }
  }

  void onWantsToGoToChat() {
    injector<NavigationService>().navigateToChatDashboard();
  }

  Future<void> onRefresh() async {
    if (_isCanRefesh()) {
      final newItems = await _getPostsUsecase.call(limit: pageSize);
      postService.pagingController.itemList = newItems;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      postService.pagingController.notifyListeners();
    } else {
      printInfo(info: 'Please wait $_refreshIntervalLimitSecond seconds');
    }
  }

  bool _isCanRefesh() {
    return DateTime.now().difference(_lastRefeshTime).inSeconds > _refreshIntervalLimitSecond;
  }
}
