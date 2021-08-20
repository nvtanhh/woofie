import 'dart:async';

import 'package:async/async.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget.dart';
import 'package:meowoof/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';
import 'package:meowoof/modules/chat/domain/usecases/request_message/update_content_request_message_usecase.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_service.dart';
import 'package:meowoof/modules/social_network/domain/events/pet/pet_deleted_event.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/follow_pet_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_posts_of_user_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_user_profile_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/request_contact_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class UserProfileModel extends BaseViewModel {
  final int pageSize = 10;
  int nextPageKey = 0;
  bool isMe = false;
  final Rxn<User> _user = Rxn<User>();
  StreamSubscription? _petDeletedStreamSubscription;
  final GetUseProfileUseacse _getUseProfileUseacse;
  final GetPostOfUserUsecase _getPostOfUserUsecase;
  final LogoutUsecase _logoutUsecase;
  final FollowPetUsecase _followPetUsecase;
  final DeletePostUsecase _deletePostUsecase;
  final ToastService _toastService;
  final RequestContactUsecase _requestContactUsecase;
  final UpdateContentRequestMessagesUsecase
      _updateContentRequestMessagesUsecase;
  late List<Post> posts;
  final RxBool _isLoaded = RxBool(false);
  final PostService postService;
  final EventBus _eventBus;
  final LoggedInUser _loggedInUser;
  CancelableOperation? _cancelableOperationLoadInit,
      _cancelableOperationLoadMorePost;
  

  UserProfileModel(
    this._getUseProfileUseacse,
    this._getPostOfUserUsecase,
    this._logoutUsecase,
    this._followPetUsecase,
    this._deletePostUsecase,
    this._toastService,
    this.postService,
    this._eventBus,
    this._loggedInUser,
    this._requestContactUsecase,
    this._updateContentRequestMessagesUsecase,
  );

  User? get user => _user.value;
  set user(User? user) {
    _user.value = user;
  }

  @override
  void initState() {
    postService.initState();
    if (user == null || user == _loggedInUser.user) {
      isMe = true;
      user = _loggedInUser.user;
    }
    _cancelableOperationLoadInit = CancelableOperation.fromFuture(initData());
    registerListenPetDeleted();
    super.initState();
  }

  void registerListenPetDeleted() {
    _petDeletedStreamSubscription = _eventBus.on<PetDeletedEvent>().listen(
      (event) {
        user?.currentPets?.removeWhere((element) => element.id == event.pet.id);
        user?.notifyUpdate();
        User.factory.addToCache(user!);
      },
    );
  }

  Future initData() async {
    await Future.wait([_getUserProfile(), _loadMorePost(nextPageKey)]);
    postService.pagingController.addPageRequestListener(
      (pageKey) {
        _cancelableOperationLoadMorePost =
            CancelableOperation.fromFuture(_loadMorePost(pageKey));
      },
    );
    isLoaded = true;
  }

  Future _getUserProfile() async {
    return call(
      () async => user?.update(await _getUseProfileUseacse.call(user!.id)),
      showLoading: false,
      onSuccess: () {
        User.factory.addToCache(user!);
        _loggedInUser.saveToLocal();
      },
    );
  }

  Future _loadMorePost(int pageKey) async {
    try {
      posts = await _getPostOfUserUsecase.call(
          userUUID: user!.uuid, offset: nextPageKey, limit: pageSize);
      if (postService.pagingController.itemList == null ||
          postService.pagingController.itemList?.isEmpty == true) {
        posts.insert(
          0,
          Post(
            id: 0,
            uuid: '',
            creator: User(id: 0, uuid: ''),
            type: PostType.activity,
          ),
        );
      }
      final isLastPage = posts.length < pageSize;
      if (isLastPage) {
        postService.pagingController.appendLastPage(posts);
      } else {
        nextPageKey = pageKey + posts.length;
        postService.pagingController.appendPage(posts, nextPageKey);
      }
    } catch (error) {
      postService.pagingController.error = error;
    }
  }

  void onFollowPet(Pet pet) {
    call(
      () => _followPetUsecase.call(pet.id),
      onSuccess: () {
        pet.isFollowing = !(pet.isFollowing ?? false);
        pet.notifyUpdate();
      },
      showLoading: false,
    );
  }

  void onPostDeleted(Post post, int index) {
    bool result = false;
    call(
      () async => result = await _deletePostUsecase.call(post.id),
      onSuccess: () {
        if (result) {
          _toastService.success(
              message: "Post deleted!", context: Get.context!);
          postService.pagingController.itemList?.removeAt(index);
          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
          postService.pagingController.notifyListeners();
        }
      },
      onFailure: (err) {
        _toastService.error(message: err.toString(), context: Get.context!);
      },
    );
  }

  void onUserBlock(User user) {}

  void onUserReport(User user) {}

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }

  Future onTabLogout() async {
    await _logoutUsecase.call();
    await Get.offAll(() => WelcomeWidget());
  }

  void onRefresh() {
    nextPageKey = 0;
    postService.onRefresh();
  }

  Future sendContentRequestMessage(RequestContact requestContact) async {
    final String? content = await injector<DialogService>()
        .showInputReport(title: "Nội dung") as String?;
    await call(
      () async => _updateContentRequestMessagesUsecase.run(
        requestContact: requestContact,
        content: content ?? "",
      ),
      showLoading: false,
      onSuccess: () {
        injector<NavigationService>().navigateToChatDashboard();
        Get.snackbar(
          "Thành công",
          "Đã yêu cầu, chờ xác nhận.",
          duration: const Duration(seconds: 1),
          backgroundColor: UIColor.accent2,
          colorText: UIColor.white,
        );
      },
    );
  }

  Future<void> onWantsToContact(User targetUser) async {
    if (user?.setting != null && user?.setting?.statusMessage == 0) {
      RequestContact? requestContact;
      await call(
        () async => requestContact =
            await _requestContactUsecase.run(toUserUUID: targetUser.uuid),
        onSuccess: () {
          if (requestContact != null) {
            switch (requestContact!.status!) {
              case RequestContactStatus.accept:
                injector<NavigationService>().navigateToChatRoom(
                    user: targetUser.uuid == requestContact?.toUser?.uuid
                        ? requestContact!.toUser
                        : requestContact!.fromUser);
                return;
              case RequestContactStatus.waiting:
                sendContentRequestMessage(requestContact!);
                return;
              case RequestContactStatus.deny:
                Get.snackbar(
                  "Xin lỗi",
                  "Bạn đã bị từ chối.",
                  duration: const Duration(seconds: 1),
                  backgroundColor: UIColor.danger,
                  colorText: UIColor.white,
                );
                return;
            }
          }
        },
        onFailure: (err) {
          Get.snackbar(
            "Sorry",
            "Unable to init chat room, please try again later.",
            duration: const Duration(seconds: 1),
            backgroundColor: UIColor.danger,
            colorText: UIColor.white,
          );
        },
      );
    } else {
      final isError =
          await injector<NavigationService>().navigateToChatRoom(user: user);
      if (isError != null && isError) {
        Get.snackbar(
          "Sorry",
          "Unable to init chat room, please try again later.",
          duration: const Duration(seconds: 1),
          backgroundColor: UIColor.danger,
          colorText: UIColor.white,
        );
      }
    }
  }

  @override
  void disposeState() {
    postService.disposeState();
    _cancelableOperationLoadInit?.cancel();
    _cancelableOperationLoadMorePost?.cancel();
    _petDeletedStreamSubscription?.cancel();
    super.disposeState();
  }
}
