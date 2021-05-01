import 'dart:io';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/add_pet/domain/models/gender.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_breed.dart';
import 'package:meowoof/modules/add_pet/domain/models/pet_type.dart';
import 'package:meowoof/modules/add_pet/domain/usecases/get_pet_breeds_usecase.dart';
import 'package:meowoof/modules/add_pet/domain/usecases/get_pet_types_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AddPetWidgetModel extends BaseViewModel {
  final GetPetTypesUsecase _getPetTypesUsecase;
  final GetPetBreedUsecase _getPetBreedUsecase;
  final RxList<PetType> _petTypes = RxList([]);
  final RxList<PetBreed> _petBreeds = RxList([]);
  final RxInt _currentStepAddPet = RxInt(1);
  final RxInt _indexPetTypeSelected = RxInt(-1);
  final RxInt _indexPetBreedSelected = RxInt(-1);
  PetType petTypeSelected;
  PetBreed petBreedSelected;
  Pet pet;

  AddPetWidgetModel(this._getPetTypesUsecase, this._getPetBreedUsecase);

  @override
  void initState() {
    pet = Pet();
    loadPetTypes();
    super.initState();
  }

  Future<Unit> loadPetTypes() async {
    return call(() async => petTypes = await _getPetTypesUsecase.call());
  }

  Future<Unit> loadPetBreeds(int idPetType) async {
    return call(
      () async => petBreeds = await _getPetBreedUsecase.call(idPetType),
      onSuccess: () {
        currentStepAddPet++;
      },
    );
  }

  void onPetTypeSelectedIndex(int index) {
    indexPetTypeSelected = index;
    petTypeSelected = petTypes[index];
    loadPetBreeds(petTypeSelected.id);
    pet.petTypeId = petTypeSelected.id;
  }

  void onPetBreedSelectedIndex(int index) {
    indexPetBreedSelected = index;
    petBreedSelected = petBreeds[index];
    pet.petBreedId = petBreedSelected.id;
  }

  void doNotHavePet() {}

  void unknownBreed() {
    if (currentStepAddPet == 2) currentStepAddPet++;
  }

  void continues() {
    if (petBreedSelected != null) {
      if (currentStepAddPet == 2) currentStepAddPet++;
    }
  }

  void onDone() {}

  void onNameChange(String name) {
    pet.name = name;
    return;
  }

  void onAgeChange(String age) {}

  void onAvatarChange(File avatar) {}

  void onGenderChange(Gender gender) {
    pet.gender = gender;
    return;
  }

  List<PetType> get petTypes => _petTypes.toList();

  set petTypes(List<PetType> value) {
    _petTypes.assignAll(value);
  }

  int get currentStepAddPet => _currentStepAddPet.value;

  set currentStepAddPet(int value) {
    _currentStepAddPet.value = value;
  }

  int get indexPetTypeSelected => _indexPetTypeSelected.value;

  set indexPetTypeSelected(int value) {
    _indexPetTypeSelected.value = value;
  }

  List<PetBreed> get petBreeds => _petBreeds.toList();

  set petBreeds(List<PetBreed> value) {
    _petBreeds.assignAll(value);
  }

  int get indexPetBreedSelected => _indexPetBreedSelected.value;

  set indexPetBreedSelected(int value) {
    _indexPetBreedSelected.value = value;
  }
}
