import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_widget.dart';
import 'package:meowoof/modules/social_network/app/save_post/save_post.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/follow_pet_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_posts_of_user_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_user_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class UserProfileModel extends BaseViewModel {
  final int pageSize = 10;
  int nextPageKey = 0;
  bool isMe = false;
  User? user;
  PagingController<int, Post> pagingController = PagingController(firstPageKey: 0);
  final GetUseProfileUseacse _getUseProfileUseacse;
  final GetPostOfUserUsecase _getPostOfUserUsecase;
  final BottomSheetService _bottomSheetService;
  final LikePostUsecase _likePostUsecase;
  final LogoutUsecase _logoutUsecase;
  final FollowPetUsecase _followPetUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final ToastService _toastService;
  late List<Post> posts;
  final RxBool _isLoaded = RxBool(false);
  CancelableOperation? _cancelableOperationLoadInit, _cancelableOperationLoadMorePost;

  UserProfileModel(
    this._getUseProfileUseacse,
    this._getPostOfUserUsecase,
    this._bottomSheetService,
    this._likePostUsecase,
    this._logoutUsecase,
    this._followPetUsecase,
    this._deletePostUsecase,
    this._toastService,
  );

  @override
  void initState() {
    if (user == null) {
      isMe = true;
      user = injector<LoggedInUser>().loggedInUser;
    }
    _cancelableOperationLoadInit = CancelableOperation.fromFuture(initData());
    super.initState();
  }

  Future initData() async {
    await Future.wait([_getUserProfile(), _loadMorePost(nextPageKey)]);
    pagingController.addPageRequestListener(
      (pageKey) {
        _cancelableOperationLoadMorePost = CancelableOperation.fromFuture(_loadMorePost(pageKey));
      },
    );
    isLoaded = true;
  }

  Future _getUserProfile() async {
    return call(() async => user = await _getUseProfileUseacse.call(user!.id), showLoading: false, onSuccess: () {});
  }

  Future _loadMorePost(int pageKey) async {
    try {
      posts = await _getPostOfUserUsecase.call(user!.uuid!, offset: nextPageKey, limit: pageSize);
      if (pagingController.itemList == null) {
        posts.insert(0, Post(id: 0, creator: User(id: 0), type: PostType.activity));
      }
      final isLastPage = posts.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(posts);
      } else {
        nextPageKey = pageKey + posts.length;
        pagingController.appendPage(posts, nextPageKey);
      }
    } catch (error) {
      printInfo(info: "post: ${error.toString()}");
      pagingController.error = error;
    }
  }

  void onFollowPet(Pet pet) {
    call(
      () => _followPetUsecase.call(pet.id),
      onSuccess: () {},
    );
  }

  void onLikeClick(int idPost) {
    _likePostUsecase.call(idPost);
  }

  void onPostEdited(Post post) {
    Get.to(
      () => CreatePost(
        post: post,
      ),
    );
  }

  void onPostDeleted(Post post) {
    bool result = false;
    call(() async => result = await _deletePostUsecase.call(post.id), onSuccess: () {
      if (result) {
        _toastService.success(message: "Success", context: Get.context!);
      }
    }, onFailure: (err) {
      _toastService.success(message: err.toString(), context: Get.context!);
    });
  }

  void onCommentClick(int idPost) {
    _bottomSheetService.showComments(idPost);
  }

  void onUserBlock(User user) {}

  void onUserReport(User user) {}

  void onPostClick(Post post) {
    Get.to(
      () => PostDetail(post: post),
    );
  }

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }

  @override
  void disposeState() {
    _cancelableOperationLoadInit?.cancel();
    _cancelableOperationLoadMorePost?.cancel();
    pagingController.dispose();
    super.disposeState();
  }

  Future onTabLogout() async {
    await _logoutUsecase.call();
    await Get.offAll(() => WelcomeWidget());
  }
}
