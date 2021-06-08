import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_detail_info_pet_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class DetailInfoPetWidgetModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  late Function onAddWeightClick;
  late Function onAddWormFlushedClick;
  late Function onAddVaccinatedClick;
  late Function(Pet) updatePet;
  final RxBool _isLoaded = RxBool(false);
  final GetDetailInfoPetUsecase _getDetailInfoPetUsecase;

  DetailInfoPetWidgetModel(this._getDetailInfoPetUsecase);

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
        updatePet(pet);
      },
      onFailure: (err) {
        _isLoaded.value = false;
      },
      showLoading: false,
    );
  }

  void onTabWeightChart() {
    Get.to(
      () => Weight(
        pet: pet,
        isMyPet: isMyPet,
        onAddWeight: onAddWeight,
      ),
    );
  }

  void onTabWormFlushed() {
    Get.to(
      () => WormFlushedWidget(
        petId: pet.id,
        isMyPet: isMyPet,
        onAddWormFlushed: onAddWormFlush,
      ),
    );
  }

  void onTabVaccinated() {
    Get.to(
      () => VaccinatedWidget(
        petId: pet.id,
        isMyPet: isMyPet,onAddVaccinated: onAddVaccinated,
      ),
    );
  }

  void onAddWeight(PetWeight petWeight) {
    pet.petWeights?.insert(0, petWeight);
    if ((pet.petWeights?.length ?? 0) > 2) pet.petWeights?.removeLast();
    updatePet(pet);
  }

  void onAddWormFlush(PetWormFlushed petWormFlushed) {
    pet.petWormFlushes?.insert(0, petWormFlushed);
    if ((pet.petWormFlushes?.length ?? 0) > 2) pet.petWormFlushes?.removeLast();
    updatePet(pet);
  }

  void onAddVaccinated(PetVaccinated petVaccinated) {
    pet.petVaccinates?.insert(0, petVaccinated);
    if ((pet.petVaccinates?.length ?? 0) > 2) pet.petVaccinates?.removeLast();
    updatePet(pet);
  }

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }
}
