import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_worm_flushed.dart';
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

  void onTabWeightChart() {
    Get.to(
      () => WeightWidget(
        pet: pet,
        isMyPet: isMyPet,
      ),
    );
  }

  void onTabWormFlushed() {
    Get.to(
      () => WormFlushedWidget(
        pet: pet,
        isMyPet: isMyPet,
      ),
    );
  }

  void onTabVaccinated() {
    Get.to(
      () => VaccinatedWidget(
        pet: pet,
        isMyPet: isMyPet,
      ),
    );
  }

  bool get isLoaded => _isLoaded.value;

  set isLoaded(bool value) {
    _isLoaded.value = value;
  }
}
