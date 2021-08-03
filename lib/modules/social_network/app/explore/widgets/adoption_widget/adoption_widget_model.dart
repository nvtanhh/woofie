import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_post_by_type_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionWidgetModel extends BaseViewModel {
  final GetPostByTypeUsecase _getPostByTypeUsecase;
  final LocationService _locationService;
  final int pageSize = 10;
  int nextPageKey = 0;
  late PagingController<int, Post> pagingController;
  final LoggedInUser _loggedInUser;

  List<Post> posts = [];
  late PostType postType;
  Location? location;

  AdoptionWidgetModel(
    this._getPostByTypeUsecase,
    this._locationService,
    this._loggedInUser,
  );

  @override
  void initState() {
    pagingController = PagingController(firstPageKey: 0);
    getCurrentAddress();
    super.initState();
  }

  void loadUserFormLocal() {
    final user = _loggedInUser.user;
    location = user?.location;
    if (location != null) {
      startLoadPage();
    } else {
      injector<ToastService>().warning(message: "message", context: Get.context!);
    }
  }

  Future getCurrentAddress() async {
    if (await _locationService.isPermissionDenied()) {
      loadUserFormLocal();
      return;
    }
    try {
      final currentPosition = await _locationService.determinePosition();
      location = Location(
        long: currentPosition.longitude,
        lat: currentPosition.latitude,
      );
    } catch (e) {
      await injector<DialogService>().showPermissionDialog();
      return;
    }
    if (location != null) {
      startLoadPage();
    }
  }

  void startLoadPage() {
    pagingController.addPageRequestListener(
      (pageKey) {
        _loadPost(pageKey);
      },
    );
    _loadPost(0);
  }

  Future _loadPost(int pageKey) async {
    await call(
        () async {
          posts = await _getPostByTypeUsecase.call(
            postType: postType,
            longUser: location!.long!,
            latUser: location!.lat!,
            offset: nextPageKey,
          );

          if (posts.length < pageSize) {
            pagingController.appendLastPage(posts);
          } else {
            nextPageKey = pageKey + (posts.length);
            pagingController.appendPage(posts, nextPageKey);
          }
        },
        showLoading: false,
        onFailure: (err) {
          pagingController.error = err;
        },
        onSuccess: () {});
  }

  void onItemClick(Post post) {
    Get.to(() => AdoptionPetDetailWidget(post: post));
  }

  Future onRefresh() async {
    pagingController.refresh();
    return;
  }
}
