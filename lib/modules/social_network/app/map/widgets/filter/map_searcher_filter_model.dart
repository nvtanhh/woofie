import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_breeds_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_types_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class MapSearcherFilterModel extends BaseViewModel {
  final GetPetTypesUsecase _getPetTypesUsecase;
  final GetPetBreedUsecase _getPetBreedUsecase;

  final RxList<PetType> _petTypes = RxList([]);
  final RxInt _indexPetTypeSelected = RxInt(-1);
  PetType? selectedPetType;

  final RxList<PetBreed> _petBreeds = RxList([]);
  final RxList<PetBreed> _selectedPetBreeds = RxList([]);

  MapSearcherFilterModel(
    this._getPetTypesUsecase,
    this._getPetBreedUsecase,
  );

  @override
  void initState() {
    loadPetTypes();
    super.initState();
  }

  Future<Unit> loadPetTypes() async {
    return call(
      () async => petTypes = await _getPetTypesUsecase.call(),
      showLoading: false,
    );
  }

  Future<Unit> loadPetBreeds(int idPetType) async {
    return call(
      () async => petBreeds = await _getPetBreedUsecase.call(idPetType),
      onSuccess: () {},
      showLoading: false,
    );
  }

  void onPetTypeSelectedIndex(int index) {
    final petType = petTypes[index];
    if (petType != selectedPetType) {
      indexPetTypeSelected = index;
      selectedPetType = petTypes[index];
      if (index != petTypes.length - 1) {
        loadPetBreeds(selectedPetType!.id);
      } else {
        petBreeds = [];
      }
    }
  }

  List<PetType> get petTypes => _petTypes.toList();

  set petTypes(List<PetType> value) {
    _petTypes.assignAll(value);
  }

  List<PetBreed> get petBreeds => _petBreeds.toList();

  set petBreeds(List<PetBreed> value) {
    _petBreeds.assignAll(value);
  }

  List<PetBreed> get selectedPetBreeds => _selectedPetBreeds.toList();

  set selectedPetBreeds(List<PetBreed> value) {
    _selectedPetBreeds.assignAll(value);
  }

  int get indexPetTypeSelected => _indexPetTypeSelected.value;

  set indexPetTypeSelected(int value) {
    _indexPetTypeSelected.value = value;
  }

  void onPetBreedSelected(PetBreed petBreed) {
    if (selectedPetBreeds.contains(petBreed)) {
      _selectedPetBreeds.remove(petBreed);
    } else {
      _selectedPetBreeds.add(petBreed);
    }
  }
}
