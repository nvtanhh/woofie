import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/logged_user.dart';
import 'package:meowoof/core/ui/confirm_dialog.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post_reaction.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/change_pet_owner.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_functional_post_react.dart';
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/close_post_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_user_profile_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class ConfirmGivePetModel extends BaseViewModel {
  final GetUseProfileUseacse _getUseProfileUseacse;
  final GetFunctionalPostReactions _getFunctionalPostReactions;
  final ChangePetOwnerUsecase _changePetOwnerUsecase;
  final LoggedInUser _loggedInUser;
  final ClosePostUsecase _closePostUsecase;

  late Post post;
  late PagingController<int, User> pagingController;

  static const int _pageSize = 10;

  ConfirmGivePetModel(
    this._loggedInUser,
    this._getUseProfileUseacse,
    this._getFunctionalPostReactions,
    this._changePetOwnerUsecase,
    this._closePostUsecase,
  );

  Future<List<PostReaction>> getAllUserInPost() async {
    List<PostReaction> reactions = [];
    await call(
      () async =>
          reactions = await _getFunctionalPostReactions.call(postId: post.id),
      showLoading: false,
    );
    // remove myself
    reactions
        .removeWhere((element) => element.reactor.id == _loggedInUser.user!.id);
    if (post.type == PostType.mating) {
      reactions.removeWhere((element) => element.matingPet == null);
    }
    return reactions;
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

  void openPetProfile(Pet pet) {
    Get.to(
      () => PetProfile(
        pet: pet,
      ),
    );
  }

  void onWantsToGivePetForThisUser(User user) {
    final pet = post.taggegPets![0];
    Get.dialog(
      ConfirmDialog(
        title: 'Xác nhận cho thú cưng',
        content:
            'Bạn có chắc chắn muốn cho ${pet.name} lại cho ${user.name}.\nKhi chọn "Có" bài viết của bạn sẽ được đóng lại và ${user.name} sẽ trở thành chủ mới của ${pet.name}.',
        confirmText: 'Có',
        cancelText: 'Hủy',
        onConfirm: () => _givePet(user, pet),
      ),
    );
  }

  void onTapUser(User user) {
    if (post.type == PostType.adop) onWantsToGivePetForThisUser(user);
  }

  void onTapMatingPetIteam(Pet pet) {
    _onPetChosen(pet);
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
            'Bạn có chắc chắn muốn ghép đôi ${myPet.name} với ${pet.name}.\nKhi chọn "Có" bài viết của bạn sẽ được đóng lại và đánh dấu là đã ghép đôi thành công.',
        confirmText: 'Có',
        cancelText: 'Hủy',
        onConfirm: () => _matingWith(pet, myPet),
      ),
    );
  }

  Future _givePet(User user, Pet pet) async {
    await call(
      () async {
        await _changePetOwnerUsecase.call(user, pet);
        await _closePostUsecase.run(post,
            additionalData: user.toJsonString().replaceAll("\"", "'"));
      },
      onSuccess: () {
        _refreshUser(_loggedInUser.user!);
        Get.back();
        Get.snackbar(
          'Thành công 🎉',
          'Bạn đã cho thú cưng của bạn cho ${user.name}}',
          backgroundColor: UIColor.primary,
          colorText: UIColor.white,
        );
      },
      onFailure: (error) {},
    );
  }

  Future _matingWith(Pet pet, Pet myPet) async {
    await call(
      () async {
        await _closePostUsecase.run(post,
            additionalData: pet.toJsonString().replaceAll("\"", "'"));
      },
      onSuccess: () {
        Get.back();
        Get.snackbar(
          'Thành công 🎉',
          'Xác nhận ghép đôi ${myPet.name} với ${pet.name}',
          backgroundColor: UIColor.accent2,
          colorText: UIColor.white,
        );
      },
      onFailure: (error) {},
    );
  }
}
