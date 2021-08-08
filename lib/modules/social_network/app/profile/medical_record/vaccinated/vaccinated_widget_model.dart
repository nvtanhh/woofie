import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/dialog/add_caccinated_dialog.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_vaccinated.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_vaccinated_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_vaccinated_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_vaccinates_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_vaccinated_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class VaccinatedWidgetModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  final RxList<PetVaccinated> _vaccinates = RxList<PetVaccinated>();
  final GetVaccinatesUsecase _getVaccinatesUsecase;
  final AddVaccinatedUsecase _addVaccinatedUsecase;
  final DialogService _dialogService;
  final DeletePetVaccinatedUsecase _deletePetVaccinatedUsecase;
  final UpdatePetVaccinatedUsecase _updatePetVaccinatedUsecase;
  final ToastService _toastService;
  List<PetVaccinated> receivePetVaccinated = [];
  bool isLastPage = false;
  int pageSize = 10, pageKey = 0;
  PetVaccinated? vaccinated;

  VaccinatedWidgetModel(
    this._getVaccinatesUsecase,
    this._addVaccinatedUsecase,
    this._toastService,
    this._dialogService,
    this._deletePetVaccinatedUsecase,
    this._updatePetVaccinatedUsecase,
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
    vaccinated?.petId = pet.id;
    await call(
      () async {
        final data = await _addVaccinatedUsecase.call(vaccinated!);
        vaccinated!.id = data.id;
      },
      onSuccess: () {
        _vaccinates.insert(0, vaccinated!);
        updatePreviewVaccinated();
        _vaccinates.refresh();
      },
      onFailure: (err) {
        printError(info: err.toString());
        _toastService.error(message: LocaleKeys.error.trans(), context: Get.context!);
      },
    );
  }

  void updatePreviewVaccinated() {
    sortByDate();
    if (_vaccinates.length > 2) {
      pet.petVaccinates = _vaccinates.sublist(0, 2);
    } else {
      pet.petVaccinates = _vaccinates.toList();
    }
    pet.notifyUpdate();
  }

  Future getVaccinates() async {
    if (isLastPage) return;
    await call(
      () async {
        receivePetVaccinated = await _getVaccinatesUsecase.call(
          pet.id,
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

  Future onEdit(PetVaccinated vaccinate, int index) async {
    vaccinated = null;
    vaccinated = await Get.dialog(
      AddVaccinatedDialog(
        petVaccinated: vaccinate,
      ),
    );
    if (vaccinated == null) {
      return;
    }
    await call(() async => vaccinated = await _updatePetVaccinatedUsecase.run(vaccinated!), onSuccess: () {
      _vaccinates[index] = vaccinated!;
      updatePreviewVaccinated();
      _vaccinates.refresh();
    });
  }

  void onDelete(PetVaccinated vaccinate, int index) {
    _dialogService.showDialogConfirmDelete(() => deletePetWormFlushed(vaccinate, index));
  }

  void deletePetWormFlushed(PetVaccinated vaccinate, int index) {
    call(
      () async => _deletePetVaccinatedUsecase.run(vaccinate.id),
      onSuccess: () {
        _vaccinates.removeAt(index);
        updatePreviewVaccinated();
        _vaccinates.refresh();
      },
    );
  }

  void sortByDate() {
    _vaccinates.sort((a, b) {
      return a.date!.compareTo(b.date!);
    });
  }

  @override
  void disposeState() {
    _vaccinates.close();
    super.disposeState();
  }
}
