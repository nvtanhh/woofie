import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/dialog/add_caccinated_dialog.dart';
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
  final ToastService _toastService;
  List<PetVaccinated> receivePetVaccinated = [];
  bool isLastPage = false;
  int pageSize = 10, pageKey = 0;
  PetVaccinated? vaccinated;
  Function(PetVaccinated)? onAddVaccinated;
  VaccinatedWidgetModel(
    this._getVaccinatesUsecase,
    this._addVaccinatedUsecase,
    this._toastService,
  );

  @override
  void initState() {
    getVaccinates();
    super.initState();
  }

  Future showDialogAddWeight() async {
    vaccinated = null;
    vaccinated = await Get.dialog(
      AddVaccinatedDialog(),
    );
    if (vaccinated == null) {
      return;
    }
    vaccinated?.petId = petId;
    await call(
      () async {
        final data = await _addVaccinatedUsecase.call(vaccinated!);
        vaccinated!.id = data.id;
      },
      onSuccess: () {
        onAddVaccinated?.call(vaccinated!);
        _vaccinates.insert(0, vaccinated!);
        _vaccinates.refresh();
      },
      onFailure: (err) {
        printError(info: err.toString());
        _toastService.error(message: LocaleKeys.error.trans(), context: Get.context!);
      },
    );
  }

  Future getVaccinates() async {
    if (isLastPage) return;
    await call(
      () async {
        receivePetVaccinated = await _getVaccinatesUsecase.call(
          petId,
          offset: _vaccinates.length,
        );

        if (receivePetVaccinated.length < pageSize) {
          isLastPage = true;
        }
      },
      showLoading: false,
      onSuccess: () {
        _vaccinates.addAll(receivePetVaccinated);
      },
      onFailure: (err) {
        _toastService.error(message: LocaleKeys.error.trans(), context: Get.context!);
        printError(info: err.toString());
      },
    );
  }

  List<PetVaccinated> get vaccinates => _vaccinates.toList();
}
