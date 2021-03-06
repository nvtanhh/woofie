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
    await call(() async => reactions = await _getFunctionalPostReactions.call(postId: post.id), showLoading: false, onFailure: (err) {
      print(err.toString());
    });
    // remove myself
    reactions.removeWhere((element) => element.reactor.id == _loggedInUser.user!.id);
    if (post.type == PostType.mating) {
      reactions.removeWhere((element) => element.matingPet == null);
    }
    return reactions;
  }

  String getAppbarTitle() {
    if (post.type == PostType.adop) return 'X??c nh???n cho th?? c??ng';
    if (post.type == PostType.mating) return 'X??c nh???n gh??p ????i';
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
        title: 'X??c nh???n cho th?? c??ng',
        content:
            'B???n c?? ch???c ch???n mu???n cho ${pet.name} l???i cho ${user.name}.\nKhi ch???n "C??" b??i vi???t c???a b???n s??? ???????c ????ng l???i v?? ${user.name} s??? tr??? th??nh ch??? m???i c???a ${pet.name}.',
        confirmText: 'C??',
        cancelText: 'H???y',
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
        title: 'X??c nh???n gh??p ????i th?? c??ng',
        content:
            'B???n c?? ch???c ch???n mu???n gh??p ????i ${myPet.name} v???i ${pet.name}.\nKhi ch???n "C??" b??i vi???t c???a b???n s??? ???????c ????ng l???i v?? ????nh d???u l?? ???? gh??p ????i th??nh c??ng.',
        confirmText: 'C??',
        cancelText: 'H???y',
        onConfirm: () => _matingWith(pet, myPet),
      ),
    );
  }

  Future _givePet(User user, Pet pet) async {
    await call(
      () async {
        await _changePetOwnerUsecase.call(user, pet);
        await _closePostUsecase.run(post, additionalData: user.toJsonString().replaceAll("\"", "'"));
      },
      onSuccess: () {
        _refreshUser(_loggedInUser.user!);
        Get.back();
        Get.snackbar(
          'Th??nh c??ng ????',
          'B???n ???? cho th?? c??ng c???a b???n cho ${user.name}}',
          backgroundColor: UIColor.primary,
          colorText: UIColor.white,
        );
      },
      onFailure: (error) {
        print(error.toString());
      },
    );
  }

  Future _matingWith(Pet pet, Pet myPet) async {
    await call(
      () async {
        await _closePostUsecase.run(post, additionalData: pet.toJsonString().replaceAll("\"", "'"));
      },
      onSuccess: () {
        Get.back();
        Get.snackbar(
          'Th??nh c??ng ????',
          'X??c nh???n gh??p ????i ${myPet.name} v???i ${pet.name}',
          backgroundColor: UIColor.accent2,
          colorText: UIColor.white,
        );
      },
      onFailure: (error) {
        print(error.toString());
      },
    );
  }
}
