import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_weight.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_weights_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_weights_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class WeightModel extends BaseViewModel {
  late Pet pet;
  late bool isMyPet;
  PagingController<int, PetWeight> pagingController = PagingController(firstPageKey: 0);
  final AddWeightUsecase _addWeightUsecase;
  final GetWeightsUsecase _getWeightsUsecase;

  WeightModel(this._addWeightUsecase, this._getWeightsUsecase);

  @override
  void initState() {
    pet.dob = DateTime(2020, 1, 20);
    pagingController.appendLastPage(
      [
        PetWeight(id: 0, createdAt: DateTime(2021, 6), weight: 5, description: ""),
        PetWeight(id: 0, createdAt: DateTime(2021, 5), weight: 4, description: ""),
        PetWeight(id: 0, createdAt: DateTime(2021, 4), weight: 5, description: ""),
        PetWeight(id: 1, createdAt: DateTime(2021, 3), weight: 2, description: ""),
      ],
    );
    super.initState();
  }

  void onAddClick() {}

  void addWeight() {}
}
