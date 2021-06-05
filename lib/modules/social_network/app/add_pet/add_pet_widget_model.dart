import 'dart:io';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/home_menu/home_menu.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_type.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/add_pet_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_breeds_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_types_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class AddPetWidgetModel extends BaseViewModel {
  final GetPetTypesUsecase _getPetTypesUsecase;
  final GetPetBreedUsecase _getPetBreedUsecase;
  final AddPetUsecase _addPetUsecase;
  final RxList<PetType> _petTypes = RxList([]);
  final RxList<PetBreed> _petBreeds = RxList([]);
  final RxInt _currentStepAddPet = RxInt(1);
  final RxInt _indexPetTypeSelected = RxInt(-1);
  final RxInt _indexPetBreedSelected = RxInt(-1);
  final ToastService _toastService;
  PetType? petTypeSelected;
  PetBreed? petBreedSelected;
  late Pet pet;
  bool? isAddMore;

  AddPetWidgetModel(this._getPetTypesUsecase, this._getPetBreedUsecase, this._addPetUsecase, this._toastService);

  @override
  void initState() {
    pet = Pet(id: 0);
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
    loadPetBreeds(petTypeSelected!.id);
    pet.petTypeId = petTypeSelected!.id;
  }

  void onPetBreedSelectedIndex(int index) {
    indexPetBreedSelected = index;
    petBreedSelected = petBreeds[index];
    pet.petBreedId = petBreedSelected!.id;
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

  bool validate() {
    if (pet.name == null || pet.name?.isEmpty == true) {
      _toastService.warning(message: LocaleKeys.add_pet_name_invalid.trans(), context: Get.context!);
      return false;
    }
    if (pet.dob == null) {
      _toastService.warning(message: LocaleKeys.add_pet_age_invalid.trans(), context: Get.context!);
      return false;
    }
    return true;
  }

  void onDone() {
    if (!validate()) return;
    call(
      () async => pet = await _addPetUsecase.call(pet),
      onSuccess: () {
        if (isAddMore == true) {
          Get.back(result: pet);
        } else {
          Get.offAll(() => HomeMenuWidget());
        }
      },
      onFailure: (err) {
        printInfo(info: err.toString());
      },
    );
  }

  void onNameChange(String name) {
    pet.name = name;
    return;
  }

  void onAgeChange(DateTime? age) {
    pet.dob = age;
    return;
  }

  void onAvatarChange(File avatar) {}

  void onGenderChange(Gender gender) {
    pet.gender = gender;
    return;
  }
  void onBioChange(String bio) {
    pet.bio = bio;
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
