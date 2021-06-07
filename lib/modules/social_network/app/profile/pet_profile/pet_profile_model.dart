import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class PetProfileModel extends BaseViewModel {
  late Pet pet;
  final RxBool _isLoaded = RxBool(true);
  final Rx<bool?> _isMyPet = Rx<bool?>(null);
  late TabController tabController;
  final RxInt _tabIndex = RxInt(0);
  void onPetBlock(Pet pet) {}

  void followPet(Pet pet) {}

  void onPetReport(Pet pet) {}

  void onTabChange(int value) {
    tabIndex = value;
    return;
  }

  void updatePet(Pet mypet) {
    pet = mypet;
    return;
  }

  void onAddVaccinatedClick() {
    Get.to(
      VaccinatedWidget(
        petId: pet.id,
        isMyPet: isMyPet!,
        addData: true,
      ),
    );
  }

  void onAddWeightClick() {
    Get.to(
      Weight(
        pet: pet,
        isMyPet: isMyPet!,
        addData: true,
      ),
    );
  }

  void onAddWormFlushedClick() {
    Get.to(
      WormFlushedWidget(
        petId: pet.id,
        isMyPet: isMyPet!,
        addData: true,
      ),
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
}
