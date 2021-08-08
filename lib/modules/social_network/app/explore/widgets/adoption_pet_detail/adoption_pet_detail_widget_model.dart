import 'dart:convert';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/navigation_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/confirm_functional_post/confirm_functional_post.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile.dart';
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_detail_post_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AdoptionPetDetailWidgetModel extends BaseViewModel {
  final Rxn<Post> _post = Rxn<Post>();
  final GetDetailPostUsecase _getDetailPostUsecase;
  final RxBool _isLoaded = RxBool(false);
  Pet? matedPet;
  User? adopter;

  AdoptionPetDetailWidgetModel(this._getDetailPostUsecase);

  @override
  void initState() {
    getPostDetail();
    super.initState();
  }

  Future getPostDetail() async {
    await call(
      () async {
        post.update(await _getDetailPostUsecase.call(post.id));
        if (post.isClosed ?? false) {
          _handleClosedPost();
        }
      },
      showLoading: false,
    );
  }

  Pet get taggedPet => post.taggegPets![0].updateSubjectValue;

  Post get post => _post.value!;

  set post(Post post) {
    _post.value = post;
  }

  @override
  void disposeState() {
    _isLoaded.close();
    super.disposeState();
  }

  Future onWantsToContact() async {
    if (post.isMyPost) {
    } else {
      final error = await injector<NavigationService>()
          .navigateToChatRoom(user: post.creator, attachmentPost: post);
      if (error != null && error) {
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

  Future onConfirmFuntionalPost() async {
    switch (post.type) {
      case PostType.adop:
        await Get.to(() => ConfirmGivePet(post: post));
        break;
      case PostType.mating:
        await Get.to(() => ConfirmGivePet(post: post));
        break;
      case PostType.lose:
        break;
      default:
    }
  }

  void onWantsToGoToPetProfile() {
    Get.to(() => PetProfile(pet: taggedPet));
  }

  void onWantsToGoToUserProfile() {
    Get.to(() => UserProfile(user: post.creator));
  }

  void _handleClosedPost() {
    switch (post.type) {
      case PostType.adop:
        if (post.additionalData != null) {
          adopter = User.fromJsonPure(
              json.decode(post.additionalData!.replaceAll("'", "\""))
                  as Map<String, dynamic>);
        }
        break;
      case PostType.mating:
        if (post.additionalData != null) {
          matedPet = Pet.fromJsonPure(
              json.decode(post.additionalData!.replaceAll("'", "\""))
                  as Map<String, dynamic>);
        }
        break;
      default:
    }
  }

  void openProfileMatedPet() {
    if (matedPet != null) {
      Get.to(() => PetProfile(pet: matedPet!));
    }
  }

  void openProfileAdopter() {
    if (adopter != null) {
      Get.to(() => UserProfile(user: adopter));
    }
  }
}
