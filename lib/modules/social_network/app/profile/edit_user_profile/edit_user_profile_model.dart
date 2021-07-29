import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/services/location_service.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/auth/data/storages/user_storage.dart';
import 'package:meowoof/modules/social_network/domain/models/location.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/create_locaction_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_presigned_avatar_url_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_location_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_user_infomation_usecase.dart';
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:path/path.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class EditUserProfileWidgetModel extends BaseViewModel {
  late User user;
  late TextEditingController nameEditingController, introduceEditingController, addressEditingController, emailEditingController;
  final Rx<File?> _avatarFile = Rx<File?>(null);
  final ToastService _toastService;
  final GetPresignedAvatarUrlUsecase _getPresignedAvatarUrlUsecase;
  final UploadMediaUsecase _uploadMediaUsecase;
  final UpdateLocationUsecase _updateLocationUsecase;
  final CreateLocationUsecase _createLocationUsecase;
  final UpdateUserInformationUsecase _updateUserInformationUsecase;
  final UserStorage _userStorage;
  Location? location;
  String? newAvatarUrl;
  Placemark? currentPlacemark;
  final focusNode = FocusNode();

  EditUserProfileWidgetModel(
    this._toastService,
    this._uploadMediaUsecase,
    this._getPresignedAvatarUrlUsecase,
    this._updateLocationUsecase,
    this._createLocationUsecase,
    this._updateUserInformationUsecase,
    this._userStorage,
  );

  @override
  void initState() {
    nameEditingController = TextEditingController(text: user.name ?? "");
    introduceEditingController = TextEditingController(text: user.bio ?? "");
    emailEditingController = TextEditingController(text: user.email ?? "");
    addressEditingController = TextEditingController(text: user.location?.name ?? "");
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        getCurrentAddress();
      }
    });
    super.initState();
  }

  bool validateDataPreSave() {
    if (nameEditingController.text.isEmpty) {
      _toastService.error(message: "Name invalid!", context: Get.context!);
      return false;
    }
    if (location == null) {
      Fluttertoast.showToast(
        msg: "Update location help you enjoy in newfeed!",
        backgroundColor: UIColor.waringColor,
        textColor: UIColor.white,
      );
      return true;
    }
    return true;
  }

  Future onSaveClick() async {
    try {
      if (!validateDataPreSave()) {
        return;
      }
      if (checkNeedUpdateOrCreateLocation()) {
        if (user.locationId == null) {
          await createLocation();
        } else {
          await updateLocation();
        }
      }
      if (avatarFile != null) {
        newAvatarUrl = await _uploadMediaItem(avatarFile!);
      }
      final map = await _updateUserInformationUsecase.run(
        user.id,
        name: nameEditingController.text,
        bio: introduceEditingController.text,
        avatarUrl: newAvatarUrl,
        locationId: location?.id,
      );
      if (checkNeedUpdateOrCreateLocation()) {
        user.locationId = location!.id;
        user.location = location;
      }
      user.updateFromJson(map);
      user.notifyUpdate();
    } catch (err) {
      printInfo(info: err.toString());
      _toastService.error(
        message: "Update error",
        context: Get.context!,
      );
      return;
    }
    _userStorage.set(user);
    _toastService.success(
      message: "Update success.",
      context: Get.context!,
      duration: const Duration(seconds: 5),
    );
  }

  Future updateLocation() async {
    await call(
      () async => location = await _updateLocationUsecase.run(
        id: user.locationId!,
        long: location!.long!,
        lat: location!.lat!,
        name: location!.name!,
      ),
      onSuccess: () {
        return;
      },
      onFailure: (err) {
        throw err as Error;
      },
      showLoading: false,
    );
    return;
  }

  Future createLocation() async {
    await call(
      () async => location = await _createLocationUsecase.run(
        long: location!.long!,
        lat: location!.lat!,
        name: location!.name!,
      ),
      showLoading: false,
      onSuccess: () {
        return;
      },
      onFailure: (err) {
        throw err as Error;
      },
    );
    return;
  }

  Future getCurrentAddress() async {
    final LocationService locationService = injector<LocationService>();
    addressEditingController.text = "Loading your location...";
    if (await locationService.isPermissionDenied()) {
      await injector<DialogService>().showPermisstionDialog();
      return;
    }
    try {
      currentPlacemark = await locationService.getCurrentPlacemark();
      final String address = (currentPlacemark!.street!.isNotEmpty ? '${currentPlacemark!.street!}, ' : '') +
          (currentPlacemark!.locality!.isNotEmpty ? '${currentPlacemark!.locality!}, ' : '') +
          (currentPlacemark!.subAdministrativeArea!.isNotEmpty ? '${currentPlacemark!.subAdministrativeArea!}, ' : '');
      addressEditingController.text = address.trim().substring(0, address.length - 2);
    } catch (error) {
      addressEditingController.text = error.toString();
    }
    final currentPosition = await locationService.determinePosition();
    location = Location(
      name: addressEditingController.text,
      long: currentPosition.longitude,
      lat: currentPosition.latitude,
    );
  }

  bool checkNeedUpdateOrCreateLocation() {
    return location != null;
  }

  void onUpdateAvatarClick() {
    pickMedia();
  }

  Future pickMedia() async {
    List<File>? files;
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["jpg", "png", "JPG", "PNG"]);
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
    printInfo(info: 'Getting presigned URL');
    final String? preSignedUrl = await _getPresignedAvatarUrlUsecase.run(fileName);
    // upload media to s3
    if (preSignedUrl != null) {
      printInfo(info: 'Uploading media to s3');
      return _uploadMediaUsecase.call(preSignedUrl, mediaFile);
    }
    return null;
  }

  File? get avatarFile => _avatarFile.value;

  set avatarFile(File? value) {
    _avatarFile.value = value;
  }

  @override
  void disposeState() {
    nameEditingController.dispose();
    emailEditingController.dispose();
    introduceEditingController.dispose();
    addressEditingController.dispose();
    _avatarFile.close();
    focusNode.dispose();
    super.disposeState();
  }
}
