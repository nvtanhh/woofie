import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
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

  PetProfileModel(
    this._getDetailInfoPetUsecase,
    this._followPetUsecase,
  );

  @override
  void initState() {
    _loadPetDetailInfo();
    super.initState();
  }

  Future _loadPetDetailInfo() async {
    await call(
      () async {
        pet = await _getDetailInfoPetUsecase.call(pet.id);
      },
      onSuccess: () {
        _isLoaded.value = true;
      },
      onFailure: (err) {
        _isLoaded.value = false;
      },
      showLoading: false,
    );
  }

  void onPetBlock(Pet pet) {}

  void followPet(Pet pet) {
    call(
      () => _followPetUsecase.call(pet.id),
      onSuccess: () {},
      onFailure: (err){
        printError(info: err.toString());
      }
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
