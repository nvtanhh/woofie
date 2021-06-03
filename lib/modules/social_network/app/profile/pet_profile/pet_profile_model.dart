import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
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
  }

  void onAddVaccinatedClick() {}

  void onAddWeightClick() {}

  void onAddWormFlushedClick() {}

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
