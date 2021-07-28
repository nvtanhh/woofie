import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/gender.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet_breed.dart';
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_breeds_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_presigned_avatar_pet_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_infomation_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';
import 'package:uuid/uuid.dart';

@injectable
class EditPetProfileWidgetModel extends BaseViewModel {
  late Pet pet;
  final Rx<File?> _avatarFile = Rx<File?>(null);
  late TextEditingController introduceEditingController, nameEditingController;
  final Rx<Gender> _genderSelected = Rx<Gender>(Gender.male);
  final Rx<DateTime?> _datePicker = Rx<DateTime?>(null);
  final RxList<PetBreed> _petBreads = RxList<PetBreed>();
  PetBreed? _petBreed;
  final GetPetBreedUsecase _getPetBreedUsecase;
  final ToastService _toastService;
  final GetPresignedAvatarPetUrlUsecase _getPresignedAvatarPetUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final UpdatePetInformationUsecase _updatePetInformationUsecase;
  String? newAvatarUrl;

  EditPetProfileWidgetModel(
    this._getPetBreedUsecase,
    this._toastService,
    this._getPresignedAvatarPetUrlUsecase,
    this._uploadMediaUsecase,
    this._updatePetInformationUsecase,
  );

  @override
  void initState() {
    genderSelected = pet.gender ?? Gender.male;
    petBreads = [pet.petBreed!];
    introduceEditingController = TextEditingController(text: pet.bio ?? "");
    nameEditingController = TextEditingController(text: pet.name ?? "");
    datePicker = pet.dob;
    getPetBreads();
    super.initState();
  }

  bool validateData() {
    if (nameEditingController.text.isEmpty) {
      _toastService.error(message: "Name not empty", context: Get.context!);
      return false;
    }
    if (datePicker == null) {
      _toastService.error(message: "Birthday not empty", context: Get.context!);
      return false;
    }
    return true;
  }

  Future onSaveClick() async {
    try {
      if (!validateData()) {
        return;
      }
      if (avatarFile != null) {
        newAvatarUrl = await _uploadMediaItem(avatarFile!);
      }
      final nPet = await _updatePetInformationUsecase.run(
        pet.id,
        name: nameEditingController.text,
        avatarUrl: newAvatarUrl,
        bio: introduceEditingController.text,
        gender: genderSelected,
        dob: datePicker,
        breed: _petBreed?.id,
        uuid: pet.uuid,
      );
      pet.updateFromJson(nPet);
      pet.notifyUpdate();
      _toastService.success(message: "Update success", context: Get.context!);
    } catch (e) {
      _toastService.error(message: "Update fail", context: Get.context!);
      return;
    }
  }

  Future onUpdateAvatarClick() async {
    List<File>? files;
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ["jpg","png","JPG","PNG"]);
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      _toastService.warning(message: "Cancel", context: Get.context!);
    }
    if (files != null) {
      avatarFile = files[0];
      _avatarFile.refresh();
    }
  }

  Future<String?> _uploadMediaItem(File mediaFile) async {
    final String fileName = basename(mediaFile.path);
    // get presigned URL
    final String? preSignedUrl = await _getPresignedAvatarPetUrlUsecase.run(fileName, pet.uuid ??= const Uuid().v4());
    // upload media to s3
    if (preSignedUrl != null) {
      printInfo(info: 'Uploading media to s3');
      return _uploadMediaUsecase.call(preSignedUrl, mediaFile);
    }
    return null;
  }

  void genderChange(Gender gender) {
    _genderSelected.value = gender;
    return;
  }

  void getPetBreads() {
    call(() async => petBreads = await _getPetBreedUsecase.call(pet.petTypeId!), onSuccess: () {
      _petBreads.refresh();
    });
  }

  Future onCalendarPress() async {
    final dob = await showDatePicker(
      context: Get.context!,
      initialDate: datePicker ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (dob == null) {
      return;
    } else {
      datePicker = dob;
    }
  }

  void onPetBreadChange(PetBreed petBreed) {
    _petBreed = petBreed;
    return;
  }

  File? get avatarFile => _avatarFile.value;

  set avatarFile(File? value) {
    _avatarFile.value = value;
  }

  Gender get genderSelected => _genderSelected.value;

  set genderSelected(Gender value) {
    _genderSelected.value = value;
  }

  DateTime? get datePicker => _datePicker.value;

  set datePicker(DateTime? value) {
    _datePicker.value = value;
  }

  List<PetBreed> get petBreads => _petBreads.toList();

  set petBreads(List<PetBreed> value) {
    _petBreads.assignAll(value);
  }

  @override
  void disposeState() {
    introduceEditingController.dispose();
    nameEditingController.dispose();
    _avatarFile.close();
    _genderSelected.close();
    _datePicker.close();
    _petBreads.close();
    super.disposeState();
  }
}
