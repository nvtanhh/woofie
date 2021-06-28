import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/widgets/dialog/add_weight_dialog.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_weights_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_weights_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WeightModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  final int pageSize = 5;
  PagingController<int, PetWeight> pagingController = PagingController(firstPageKey: 0);
  final AddWeightUsecase _addWeightUsecase;
  final GetWeightsUsecase _getWeightsUsecase;
  late List<PetWeight> petWeights;
  int nextPageKey = 0;
  final RxList<PetWeight> _listWeightChart = <PetWeight>[].obs;
  PetWeight? petWeightNew;
  final gloalKey = GlobalKey();
  Function(PetWeight)? onAddWeight;

  WeightModel(
    this._addWeightUsecase,
    this._getWeightsUsecase,
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
        onAddWeight?.call(petWeightNew!);
        pagingController.itemList?.insert.call(0, petWeightNew!);
        if ((pagingController.itemList?.length ?? 0) > 6) {
          petWeights = pagingController.itemList?.sublist(0, 6) ?? [];
          listWeightChart = petWeights;
        } else {
          listWeightChart = pagingController.itemList ?? [];
        }
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        pagingController.notifyListeners();
      },
      onFailure: (err) {},
    );
  }

  List<PetWeight> get listWeightChart => _listWeightChart.toList();

  set listWeightChart(List<PetWeight> value) {
    _listWeightChart.assignAll(value);
  }
}
