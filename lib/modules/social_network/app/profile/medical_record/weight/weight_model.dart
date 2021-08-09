import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/dialog/add_weight_dialog.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_weights_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_weight_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_weights_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_weight_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WeightWidgetModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  final int pageSize = 5;
  PagingController<int, PetWeight> pagingController = PagingController(firstPageKey: 0);
  final AddWeightUsecase _addWeightUsecase;
  final GetWeightsUsecase _getWeightsUsecase;
  final DialogService _dialogService;
  final DeletePetWeightUsecase _deletePetWeightUsecase;
  final UpdatePetWeightUsecase _updatePetWeightUsecase;
  final ToastService _toastService;
  late List<PetWeight> petWeights;
  int nextPageKey = 0;
  final RxList<PetWeight> _listWeightChart = <PetWeight>[].obs;
  PetWeight? petWeightNew;
  final gloalKey = GlobalKey();

  WeightWidgetModel(
    this._addWeightUsecase,
    this._getWeightsUsecase,
    this._dialogService,
    this._deletePetWeightUsecase,
    this._updatePetWeightUsecase,
    this._toastService,
  );

  @override
  void initState() {
    pagingController.addPageRequestListener(
      (pageKey) {
        _loadMorePost(pageKey);
      },
    );
    super.initState();
  }

  Future _loadMorePost(int pageKey) async {
    try {
      petWeights = await _getWeightsUsecase.call(pet.id, offset: pageKey);
      final isLastPage = petWeights.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(petWeights);
      } else {
        nextPageKey = pageKey + petWeights.length;
        pagingController.appendPage(petWeights, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future addWeightPress() async {
    petWeightNew = null;
    petWeightNew = await Get.dialog(
      AddWeightDialog(),
    ) as PetWeight?;
    if (petWeightNew == null) {
      return;
    }
    petWeightNew?.petId = pet.id;
    await call(
      () async {
        final pet = await _addWeightUsecase.call(petWeightNew!);
        petWeightNew?.id = pet.id;
      },
      onSuccess: () {
        pagingController.itemList?.insert.call(0, petWeightNew!);
        sortByDate();
        onAddWeightAndRebuildChart();
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      onFailure: (err) {},
    );
  }

  void sortByDate() {
    pagingController.itemList?.sort(
      (a, b) {
        return a.date!.compareTo(b.date!)>=0?-1:1;
      },
    );
  }



  void onAddWeightAndRebuildChart() {
    if((pagingController.itemList?.length??0)>6){
      petWeights = pagingController.itemList?.sublist(0, 6) ?? [];
      listWeightChart = petWeights;

      pet.petWeights = petWeights.toList();
    }else{
      listWeightChart = pagingController.itemList?.toList() ?? [];

      pet.petWeights = listWeightChart.toList();
    }
    pet.notifyUpdate();
  }

  List<PetWeight> get listWeightChart => _listWeightChart.toList();

  set listWeightChart(List<PetWeight> value) {
    _listWeightChart.assignAll(value);
  }

  void onDeleteWeight(PetWeight petWeight, int index) {
    _dialogService.showDialogConfirmDelete(() => deletePetWeight(petWeight, index));
  }

  Future onEditWeight(PetWeight petWeight, int index) async {
    petWeightNew = null;
    petWeightNew = await Get.dialog(
      AddWeightDialog(
        petWeight: petWeight,
      ),
    ) as PetWeight?;
    if (petWeightNew == null) {
      return;
    }
    await call(
      () async => petWeightNew = await _updatePetWeightUsecase.run(petWeight),
      onSuccess: () {
        pagingController.itemList?[index] = petWeightNew!;
        sortByDate();
        onAddWeightAndRebuildChart();
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
    );
  }

  void deletePetWeight(PetWeight petWeight, int index) {
    call(() async => _deletePetWeightUsecase.run(petWeight.id), onSuccess: () {
      _toastService.success(message: "Delete success!", context: Get.context!);
      pagingController.itemList?.removeAt(index);
      sortByDate();
      onAddWeightAndRebuildChart();
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      pagingController.notifyListeners();
    });
  }

  @override
  void disposeState() {
    pagingController.dispose();
    _listWeightChart.close();
    super.disposeState();
  }
}
