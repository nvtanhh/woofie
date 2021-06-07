import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_vaccinated_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_vaccinates_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class VaccinatedWidgetModel extends BaseViewModel {
  late int petId;
  late bool isMyPet;
  final RxList<PetVaccinated> _vaccinates = RxList<PetVaccinated>();
  final GetVaccinatesUsecase _getVaccinatesUsecase;
  final AddVaccinatedUsecase _addVaccinatedUsecase;

  VaccinatedWidgetModel(this._getVaccinatesUsecase, this._addVaccinatedUsecase);

  @override
  void initState() {
    getVaccinates();
    super.initState();
  }

  void showDialogAddWeight() {}

  Future getVaccinates() async {
    printInfo(info: _vaccinates.length.toString());
    _vaccinates.addAll(
      await _getVaccinatesUsecase.call(
        petId,
        offset: _vaccinates.length,
      ),
    );
  }

  List<PetVaccinated> get vaccinates => _vaccinates.toList();
}
