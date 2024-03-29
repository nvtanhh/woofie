import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/ui/confirm_dialog.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed.dart';
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/posts_of_pet_widget.dart';
import 'package:meowoof/modules/social_network/domain/events/pet/pet_deleted_event.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/follow_pet_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_detail_info_pet_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class PetProfileModel extends BaseViewModel {
  late Pet pet;
  final RxBool _isLoaded = RxBool(true);
  final Rx<bool?> _isMyPet = Rx<bool?>(null);
  late TabController tabController;
  final RxInt _tabIndex = RxInt(0);
  final GetDetailInfoPetUsecase _getDetailInfoPetUsecase;
  final FollowPetUsecase _followPetUsecase;
  final DeletePetUsecase _deletePetUsecase;
  final EventBus _eventBus;
  final PostsOfPetWidgetController postsOfPetWidgetController =
      PostsOfPetWidgetController();

  PetProfileModel(
    this._getDetailInfoPetUsecase,
    this._followPetUsecase,
    this._deletePetUsecase,
    this._eventBus,
  );

  @override
  void initState() {
    super.initState();
    _refreshPetDetail();
  }

  Future _refreshPetDetail() async {
    pet.update(await _getDetailInfoPetUsecase.call(pet.id));
  }

  void onPetBlock(Pet pet) {}

  void followPet(Pet pet) {
    run(
      () => _followPetUsecase.call(pet.id),
      onSuccess: () {
        pet.isFollowing = !(pet.isFollowing ?? false);
        pet.notifyUpdate();
      },
      showLoading: false,
      onFailure: (err) {
        printError(info: err.toString());
      },
    );
  }

  void onPetReport(Pet pet) {}

  void onTabChange(int value) {
    tabIndex = value;
    return;
  }

  void updatePet(Pet myPet) {
    pet = myPet;
    return;
  }

  void onAddVaccinatedClick() {
    Get.to(
      VaccinatedWidget(
        pet: pet,
        isMyPet: isMyPet!,
        addData: true,
      ),
    );
  }

  void onAddWeightClick() {
    Get.to(
      WeightWidget(
        pet: pet,
        isMyPet: isMyPet!,
        addData: true,
      ),
    );
  }

  void onAddWormFlushedClick() {
    Get.to(
      WormFlushedWidget(
        pet: pet,
        isMyPet: isMyPet!,
        addData: true,
      ),
    );
  }

  void onDeletePost(Pet mPet) {
    Get.dialog(
      ConfirmDialog(
        title: 'Confirm',
        content: "Are you sure you want delete ${mPet.name}?",
        confirmText: 'Xác nhận',
        cancelText: 'Hủy',
        onConfirm: () async {
          Get.back();
          deletePet(mPet);
          return;
        },
        onCancel: () {
          return;
        },
      ),
    );
  }

  void deletePet(Pet mPet) {
    run(
      () async => _deletePetUsecase.run(mPet.id),
      onSuccess: () {
        _eventBus.fire(PetDeletedEvent(mPet));
        Get.back();
      },
    );
  }

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }

  bool? get isMyPet => _isMyPet.value;

  set isMyPet(bool? value) {
    _isMyPet.value = value;
  }

  int get tabIndex => _tabIndex.value;

  set tabIndex(int value) {
    _tabIndex.value = value;
  }

  @override
  void disposeState() {
    tabController.dispose();
    super.disposeState();
  }

  Future<void> onRefresh() async {
    await _refreshPetDetail();
    if (tabController.index == 1) {
      postsOfPetWidgetController.refreshPost();
    }
  }
}
