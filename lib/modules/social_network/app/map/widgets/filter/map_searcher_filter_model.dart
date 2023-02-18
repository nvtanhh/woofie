import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/app/map/widgets/filter/models/filter_option.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_breeds_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_types_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class MapSearcherFilterModel extends BaseViewModel {
  final GetPetTypesUsecase _getPetTypesUsecase;
  final GetPetBreedUsecase _getPetBreedUsecase;

  final RxList<PetType> _petTypes = RxList([]);
  final RxList<PetBreed> _petBreeds = RxList([]);

  final RxList<PostType> _selectedPostTypes = RxList([]);
  final Rxn<PetType> _selectedPetType = Rxn();
  final RxList<PetBreed> _selectedPetBreeds = RxList([]);

  FilterOptions? currentFilter;

  MapSearcherFilterModel(
    this._getPetTypesUsecase,
    this._getPetBreedUsecase,
  );

  @override
  void initState() {
    if (currentFilter != null) {
      selectedPostTypes = currentFilter!.selectedPostTypes ?? [];
    }
    loadPetTypes();
    super.initState();
  }

  Future<void> loadPetTypes() async {
    await run(
      () async {
        petTypes = await _getPetTypesUsecase.call();
      },
      onSuccess: () {
        if (currentFilter != null && currentFilter!.selectedPetType != null) {
          selectedPetType = currentFilter!.selectedPetType;
          loadPetBreeds(currentFilter!.selectedPetType!.id);
        }
      },
      showLoading: false,
    );
  }

  Future<void> loadPetBreeds(int idPetType) async {
    await run(
      () async => petBreeds = await _getPetBreedUsecase.call(idPetType),
      onSuccess: () {
        if (currentFilter != null && currentFilter!.selectedPetBreeds != null) {
          selectedPetBreeds = currentFilter!.selectedPetBreeds ?? [];
        }
      },
      showLoading: false,
    );
  }

  PetType? get selectedPetType => _selectedPetType.value;

  set selectedPetType(PetType? value) {
    _selectedPetType.value = value;
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

  List<PostType> get selectedPostTypes => _selectedPostTypes.toList();

  set selectedPostTypes(List<PostType> value) {
    _selectedPostTypes.assignAll(value);
  }

  void onPetBreedSelected(PetBreed petBreed) {
    if (selectedPetBreeds.contains(petBreed)) {
      _selectedPetBreeds.remove(petBreed);
    } else {
      _selectedPetBreeds.add(petBreed);
    }
  }

  void onApplyFilter() {
    FilterOptions? filterOptions;
    if (selectedPostTypes.isNotEmpty ||
        selectedPetBreeds.isNotEmpty ||
        selectedPetType != null) {
      filterOptions = FilterOptions(
        selectedPostTypes: selectedPostTypes,
        selectedPetBreeds: selectedPetBreeds,
        selectedPetType: selectedPetType,
      );
    } else {
      filterOptions = FilterOptions(isClearFilter: true);
    }
    Get.back(result: filterOptions);
  }

  void onClearFilter() {
    Get.back(result: FilterOptions(isClearFilter: true));
  }

  void onPostTypeSelected(PostType postType) {
    if (selectedPostTypes.contains(postType)) {
      _selectedPostTypes.remove(postType);
    } else {
      _selectedPostTypes.add(postType);
    }
  }

  void onPetTypeSelected(PetType petType) {
    final index = petTypes.indexOf(petType);
    if (petType != selectedPetType) {
      selectedPetType = petType;
      if (index != petTypes.length - 1) {
        loadPetBreeds(selectedPetType!.id);
      } else {
        petBreeds = [];
      }
    }
  }
}
