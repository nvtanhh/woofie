import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_detail_info_pet_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class DetailInfoPetWidgetModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  late Function onAddWeightClick;
  late Function onAddWormFlushedClick;
  late Function onAddVaccinatedClick;
  final RxBool _isLoaded = RxBool(false);
  final GetDetailInfoPetUsecase _getDetailInfoPetUsecase;

  DetailInfoPetWidgetModel(this._getDetailInfoPetUsecase);

  @override
  void initState() {
    _loadPetDetailInfo();
    super.initState();
  }

  Future _loadPetDetailInfo() async {
    try {
      pet = await _getDetailInfoPetUsecase.call(pet.id);
      _isLoaded.value = true;
    } catch (e) {
      printError(info: e.toString());
      _isLoaded.value = false;
    }
  }

  void onTabWeightChart() {
    Get.to(
      () => Weight(
        pet: pet,
        isMyPet: isMyPet,
      ),
    );
  }

  void onTabWormFlushed() {
    Get.to(
      () => WormFlushedWidget(
        petId: pet.id,
        isMyPet: isMyPet,
      ),
    );
  }

  void onTabVaccinated() {
    Get.to(
      () => VaccinatedWidget(
        petId: pet.id,
        isMyPet: isMyPet,
      ),
    );
  }

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }
}
