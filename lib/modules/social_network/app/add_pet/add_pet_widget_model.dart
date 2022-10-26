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
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_presigned_avatar_pet_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';
import 'package:uuid/uuid.dart';

@injectable
class AddPetWidgetModel extends BaseViewModel {
  final GetPetTypesUsecase _getPetTypesUsecase;
  final GetPetBreedUsecase _getPetBreedUsecase;
  final GetPresignedAvatarPetUrlUsecase _getPresignedAvatarPetUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
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
  File? avatarFile;

  late bool isBackToHome;

  AddPetWidgetModel(
    this._getPetTypesUsecase,
    this._getPetBreedUsecase,
    this._addPetUsecase,
    this._toastService,
    this._uploadMediaUsecase,
    this._getPresignedAvatarPetUrlUsecase,
  );

  @override
  void initState() {
    pet = Pet(id: 0);
    loadPetTypes();
    super.initState();
  }

  void loadPetTypes() {
    run(() async => petTypes = await _getPetTypesUsecase.call());
  }

  void loadPetBreeds(int idPetType) {
    run(
      () async => petBreeds = await _getPetBreedUsecase.call(idPetType),
      onSuccess: () {
        if (petBreeds.isEmpty == true) {
          currentStepAddPet = 3;
          return;
        }
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

  void doNotHavePet() {
    if (!(isAddMore ?? true)) {
      Get.offAll(() => HomeMenuWidget());
    } else {
      Get.back();
    }
  }

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
      _toastService.warning(
          message: LocaleKeys.add_pet_name_invalid.trans(),
          context: Get.context!);
      return false;
    }
    if (pet.dob == null) {
      _toastService.warning(
          message: LocaleKeys.add_pet_age_invalid.trans(),
          context: Get.context!);
      return false;
    }
    return true;
  }

  Future<String?> _uploadMediaItem(File mediaFile) async {
    final String fileName = basename(mediaFile.path);
    // get presigned URL
    final String? preSignedUrl = await _getPresignedAvatarPetUrlUsecase.run(
        fileName, pet.uuid ??= const Uuid().v4());
    // upload media to s3
    if (preSignedUrl != null) {
      printInfo(info: 'Uploading media to s3');
      return _uploadMediaUsecase.call(preSignedUrl, mediaFile);
    }
    return null;
  }

  void onDone() {
    if (!validate()) return;
    pet.uuid = const Uuid().v4();
    run(
      () async {
        if (avatarFile != null) {
          pet.avatarUrl = await _uploadMediaItem(avatarFile!);
        }
        pet = await _addPetUsecase.call(pet);
      },
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

  void onAvatarChange(File avatar) {
    avatarFile = avatar;
    return;
  }

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

  void onPressBack() {
    if (currentStepAddPet == 1) {
      Get.back();
    } else {
      if (petTypes.indexOf(petTypeSelected!) == petTypes.length - 1) {
        // Unknow pet breed
        currentStepAddPet = currentStepAddPet - 2;
      } else {
        currentStepAddPet--;
      }
    }
  }
}
