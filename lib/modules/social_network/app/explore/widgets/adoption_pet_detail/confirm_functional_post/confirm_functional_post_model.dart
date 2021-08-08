import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/services/bottom_sheet_service.dart';
import 'package:meowoof/core/ui/confirm_dialog.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_all_user_in_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_user_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ConfirmGivePetModel extends BaseViewModel {
  final GetAllUserInPostUsecase _getAllUserInPostUsecase;
  final GetUseProfileUseacse _getUseProfileUseacse;

  final LoggedInUser _loggedInUser;

  late Post post;
  late PagingController<int, User> pagingController;

  static const int _pageSize = 10;

  ConfirmGivePetModel(
    this._getAllUserInPostUsecase,
    this._loggedInUser,
    this._getUseProfileUseacse,
  );

  @override
  void initState() {
    super.initState();
    // final List<User> reactors = post.reactors ?? [];
    // pagingController = PagingController(firstPageKey: reactors.length);
    // pagingController.appendPage(reactors, reactors.length);
    // pagingController
    //     .addPageRequestListener((pageKey) => _loadMoreReactors(pageKey));
  }

  Future<List<User>> getAllUserInPost() async {
    List<User> users = [];
    await call(
      () async => users = await _getAllUserInPostUsecase.run(post.id),
      showLoading: false,
    );
    // remove myself
    // users.removeWhere((element) => element.id == _loggedInUser.user!.id);
    return users;
  }

  String getAppbarTitle() {
    if (post.type == PostType.adop) return 'Xác nhận cho thú cưng';
    if (post.type == PostType.mating) return 'Xác nhận ghép đôi';
    return '';
  }

  void openUserProfile(User user) {
    Get.to(
      () => UserProfile(
        user: user,
      ),
    );
  }

  void onWantsToGivePetForThisUser(User user) {
    final pet = post.taggegPets![0];
    Get.dialog(
      ConfirmDialog(
        title: 'Xác nhận cho thú cưng',
        content: 'Bạn có chắc chắn muốn cho ${pet.name} lại cho ${user.name}.',
        confirmText: 'Có',
        cancelText: 'Hủy',
      ),
    );
  }

  void onTapUser(User user) {
    if (post.type == PostType.adop) onWantsToGivePetForThisUser(user);
    if (post.type == PostType.mating) onWantsMatingPetWithThisUser(user);
  }

  Future<void> onWantsMatingPetWithThisUser(User user) async {
    await _refreshUser(user);
    await injector<BottomSheetService>().showTagPetBottomSheet(
      title: 'Chọn thú cưng muốn ghép đôi',
      userPets: user.currentPets ?? [],
      onPetChosen: (pet) {
        Get.back();
        _onPetChosen(pet);
      },
    );
  }

  Future _refreshUser(User user) async {
    await call(
      () async => user.update(await _getUseProfileUseacse.call(user.id)),
    );
  }

  void _onPetChosen(Pet pet) {
    final myPet = post.taggegPets![0];
    Get.dialog(
      ConfirmDialog(
        title: 'Xác nhận ghép đôi thú cưng',
        content:
            'Bạn có chắc chắn muốn ghép đôi ${myPet.name} với ${pet.name}.',
        confirmText: 'Có',
        cancelText: 'Hủy',
      ),
    );
  }
}
